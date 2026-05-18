use std::io::{Read, Write};
use std::net::{TcpListener, TcpStream};
use std::sync::{
    atomic::{AtomicBool, Ordering},
    Arc, Mutex,
};
use std::thread::{self, JoinHandle};
use std::time::Duration;

use beyondtranslate_api_core::{error_envelope, success_envelope, ApiError};
use beyondtranslate_core::{DetectLanguageRequest, LookUpRequest, TranslateRequest};
use serde::Serialize;

use crate::runtime::{Runtime, RuntimeError};

#[derive(Clone, Debug, uniffi::Record)]
pub struct ApiServerInfo {
    pub host: String,
    pub port: u16,
    pub base_url: String,
}

struct ServerState {
    info: ApiServerInfo,
    stopped: AtomicBool,
    handle: Mutex<Option<JoinHandle<()>>>,
}

#[derive(uniffi::Object)]
pub struct RuntimeApiServer {
    state: Arc<ServerState>,
}

impl RuntimeApiServer {
    pub(crate) fn start(
        runtime: Runtime,
        host: String,
        port: u16,
    ) -> Result<Arc<Self>, RuntimeError> {
        let host = normalize_host(host)?;
        let listener = TcpListener::bind((host.as_str(), port)).map_err(|error| {
            RuntimeError::from(format!(
                "failed to bind API server on {host}:{port}: {error}"
            ))
        })?;
        let addr = listener.local_addr().map_err(|error| {
            RuntimeError::from(format!("failed to read API server addr: {error}"))
        })?;
        let info = ApiServerInfo {
            host: addr.ip().to_string(),
            port: addr.port(),
            base_url: format!("http://{}:{}", addr.ip(), addr.port()),
        };
        let state = Arc::new(ServerState {
            info,
            stopped: AtomicBool::new(false),
            handle: Mutex::new(None),
        });

        let thread_state = state.clone();
        let handle = thread::Builder::new()
            .name("beyondtranslate-api-server".to_owned())
            .spawn(move || serve(listener, runtime, thread_state))
            .map_err(|error| RuntimeError::from(format!("failed to spawn API server: {error}")))?;

        *state
            .handle
            .lock()
            .map_err(|error| RuntimeError::from(format!("API server mutex poisoned: {error}")))? =
            Some(handle);

        Ok(Arc::new(Self { state }))
    }

    fn stop_impl(&self) {
        if self.state.stopped.swap(true, Ordering::SeqCst) {
            return;
        }

        let _ = TcpStream::connect((self.state.info.host.as_str(), self.state.info.port));
        if let Ok(mut handle) = self.state.handle.lock() {
            if let Some(handle) = handle.take() {
                let _ = handle.join();
            }
        }
    }
}

#[uniffi::export]
impl RuntimeApiServer {
    pub fn info(&self) -> ApiServerInfo {
        self.state.info.clone()
    }

    pub fn stop(&self) {
        self.stop_impl();
    }
}

impl Drop for RuntimeApiServer {
    fn drop(&mut self) {
        self.stop_impl();
    }
}

fn normalize_host(host: String) -> Result<String, RuntimeError> {
    let host = host.trim();
    let host = if host.is_empty() { "127.0.0.1" } else { host };
    if host != "127.0.0.1" && host != "localhost" {
        return Err(RuntimeError::from(
            "API server can only bind to 127.0.0.1".to_owned(),
        ));
    }
    Ok("127.0.0.1".to_owned())
}

fn serve(listener: TcpListener, runtime: Runtime, state: Arc<ServerState>) {
    for stream in listener.incoming() {
        if state.stopped.load(Ordering::SeqCst) {
            break;
        }

        let Ok(stream) = stream else {
            continue;
        };
        let runtime = runtime.clone();
        thread::Builder::new()
            .name("beyondtranslate-api-request".to_owned())
            .spawn(move || {
                let _ = handle_stream(stream, runtime);
            })
            .ok();
    }
}

fn handle_stream(mut stream: TcpStream, runtime: Runtime) -> std::io::Result<()> {
    stream.set_read_timeout(Some(Duration::from_secs(10))).ok();
    let request = match read_request(&mut stream) {
        Ok(request) => request,
        Err(error) => {
            write_response(
                &mut stream,
                400,
                "application/json",
                &serde_json::to_vec(&error_envelope(ApiError::bad_request(
                    "INVALID_REQUEST",
                    error,
                )))
                .unwrap_or_default(),
            )?;
            return Ok(());
        }
    };

    let response = dispatch(request, runtime);
    write_response(
        &mut stream,
        response.status,
        response.content_type,
        response.body.as_slice(),
    )
}

struct HttpRequest {
    method: String,
    path: String,
    body: Vec<u8>,
}

struct HttpResponse {
    status: u16,
    content_type: &'static str,
    body: Vec<u8>,
}

fn read_request(stream: &mut TcpStream) -> Result<HttpRequest, String> {
    let mut buffer = Vec::new();
    let mut chunk = [0_u8; 4096];
    let header_end = loop {
        let read = stream
            .read(&mut chunk)
            .map_err(|error| format!("failed to read request: {error}"))?;
        if read == 0 {
            return Err("empty request".to_owned());
        }
        buffer.extend_from_slice(&chunk[..read]);
        if let Some(index) = find_header_end(&buffer) {
            break index;
        }
        if buffer.len() > 1024 * 1024 {
            return Err("request headers are too large".to_owned());
        }
    };

    let headers = String::from_utf8_lossy(&buffer[..header_end]);
    let mut lines = headers.lines();
    let request_line = lines
        .next()
        .ok_or_else(|| "missing request line".to_owned())?;
    let mut request_parts = request_line.split_whitespace();
    let method = request_parts
        .next()
        .ok_or_else(|| "missing request method".to_owned())?
        .to_owned();
    let raw_path = request_parts
        .next()
        .ok_or_else(|| "missing request path".to_owned())?;
    let path = raw_path.split('?').next().unwrap_or(raw_path).to_owned();

    let mut content_length = 0_usize;
    for line in lines {
        if let Some((name, value)) = line.split_once(':') {
            if name.eq_ignore_ascii_case("content-length") {
                content_length = value
                    .trim()
                    .parse::<usize>()
                    .map_err(|_| "invalid content-length".to_owned())?;
            }
        }
    }

    let body_start = header_end + 4;
    while buffer.len() < body_start + content_length {
        let read = stream
            .read(&mut chunk)
            .map_err(|error| format!("failed to read request body: {error}"))?;
        if read == 0 {
            break;
        }
        buffer.extend_from_slice(&chunk[..read]);
    }

    let body_end = body_start.saturating_add(content_length).min(buffer.len());
    Ok(HttpRequest {
        method,
        path,
        body: buffer[body_start..body_end].to_vec(),
    })
}

fn find_header_end(buffer: &[u8]) -> Option<usize> {
    buffer.windows(4).position(|window| window == b"\r\n\r\n")
}

fn dispatch(request: HttpRequest, runtime: Runtime) -> HttpResponse {
    if request.method == "OPTIONS" {
        return empty_response(204);
    }

    match (request.method.as_str(), request.path.as_str()) {
        ("GET", "/") => json_ok(beyondtranslate_api_core::index("/")),
        ("GET", "/health") => json_ok(beyondtranslate_api_core::health()),
        ("GET", "/openapi.json") => match beyondtranslate_api_core::openapi_document() {
            Ok(document) => json_ok(document),
            Err(error) => json_error(error),
        },
        ("GET", "/reference") => HttpResponse {
            status: 200,
            content_type: "text/html; charset=utf-8",
            body: beyondtranslate_api_core::reference_html().into_bytes(),
        },
        _ => dispatch_provider_route(request, runtime),
    }
}

fn dispatch_provider_route(request: HttpRequest, runtime: Runtime) -> HttpResponse {
    if request.method == "POST" {
        if let Some(provider) = route_provider(&request.path, "/translations/", "/translate") {
            return with_json_body::<TranslateRequest, _, _>(&request.body, |body| {
                block_on_api(runtime.api_translate(provider, body))
            });
        }
        if let Some(provider) = route_provider(&request.path, "/translations/", "/detect-language")
        {
            return with_json_body::<DetectLanguageRequest, _, _>(&request.body, |body| {
                block_on_api(runtime.api_detect_language(provider, body))
            });
        }
        if let Some(provider) = route_provider(&request.path, "/dictionaries/", "/lookup") {
            return with_json_body::<LookUpRequest, _, _>(&request.body, |body| {
                block_on_api(runtime.api_lookup(provider, body))
            });
        }
    }

    if request.method == "GET" {
        if let Some(provider) =
            route_provider(&request.path, "/translations/", "/supported-language-pairs")
        {
            return match block_on_api(runtime.api_supported_language_pairs(provider)) {
                Ok(pairs) => json_ok(beyondtranslate_api_core::supported_language_pairs(pairs)),
                Err(error) => json_error(error),
            };
        }
    }

    let error = match request.method.as_str() {
        "GET" | "POST" | "OPTIONS" => ApiError::not_found("Route not found"),
        _ => ApiError::method_not_allowed("Method not allowed"),
    };
    json_error(error)
}

fn route_provider(path: &str, prefix: &str, suffix: &str) -> Option<String> {
    let provider = path.strip_prefix(prefix)?.strip_suffix(suffix)?;
    if provider.is_empty() || provider.contains('/') {
        return None;
    }
    Some(provider.to_owned())
}

fn with_json_body<T, R, F>(body: &[u8], handler: F) -> HttpResponse
where
    T: for<'de> serde::Deserialize<'de>,
    R: Serialize,
    F: FnOnce(T) -> Result<R, ApiError>,
{
    match serde_json::from_slice::<T>(body) {
        Ok(body) => match handler(body) {
            Ok(response) => json_ok(response),
            Err(error) => json_error(error),
        },
        Err(error) => json_error(ApiError::bad_request("INVALID_JSON", error.to_string())),
    }
}

fn block_on_api<F, T>(future: F) -> Result<T, ApiError>
where
    F: std::future::Future<Output = Result<T, ApiError>>,
{
    tokio::runtime::Builder::new_current_thread()
        .enable_all()
        .build()
        .map_err(|error| {
            ApiError::internal(
                "INTERNAL_RUNTIME_ERROR",
                format!("failed to build request runtime: {error}"),
            )
        })?
        .block_on(future)
}

fn json_ok<T: Serialize>(data: T) -> HttpResponse {
    HttpResponse {
        status: 200,
        content_type: "application/json",
        body: serde_json::to_vec(&success_envelope(data)).unwrap_or_default(),
    }
}

fn json_error(error: ApiError) -> HttpResponse {
    let status = error.status;
    HttpResponse {
        status,
        content_type: "application/json",
        body: serde_json::to_vec(&error_envelope(error)).unwrap_or_default(),
    }
}

fn empty_response(status: u16) -> HttpResponse {
    HttpResponse {
        status,
        content_type: "text/plain; charset=utf-8",
        body: Vec::new(),
    }
}

fn write_response(
    stream: &mut TcpStream,
    status: u16,
    content_type: &str,
    body: &[u8],
) -> std::io::Result<()> {
    let reason = match status {
        200 => "OK",
        204 => "No Content",
        400 => "Bad Request",
        401 => "Unauthorized",
        404 => "Not Found",
        405 => "Method Not Allowed",
        429 => "Too Many Requests",
        500 => "Internal Server Error",
        502 => "Bad Gateway",
        _ => "OK",
    };
    write!(
        stream,
        "HTTP/1.1 {status} {reason}\r\n\
         Content-Type: {content_type}\r\n\
         Content-Length: {}\r\n\
         Access-Control-Allow-Origin: *\r\n\
         Access-Control-Allow-Methods: GET, POST, OPTIONS\r\n\
         Access-Control-Allow-Headers: content-type\r\n\
         Connection: close\r\n\
         \r\n",
        body.len()
    )?;
    stream.write_all(body)
}

#[cfg(test)]
mod tests {
    use std::path::PathBuf;
    use std::time::{SystemTime, UNIX_EPOCH};

    use super::*;

    fn unique_data_dir() -> PathBuf {
        std::env::temp_dir().join(format!(
            "beyondtranslate-api-server-{}",
            SystemTime::now()
                .duration_since(UNIX_EPOCH)
                .expect("time went backwards")
                .as_nanos()
        ))
    }

    #[test]
    fn serves_health_on_loopback() {
        let runtime = Runtime::new(unique_data_dir().display().to_string())
            .expect("failed to create runtime");
        let server = runtime
            .start_api_server("127.0.0.1".to_owned(), 0)
            .expect("failed to start server");
        let info = server.info();
        let mut stream =
            TcpStream::connect((info.host.as_str(), info.port)).expect("failed to connect");
        stream
            .write_all(b"GET /health HTTP/1.1\r\nHost: 127.0.0.1\r\n\r\n")
            .expect("failed to write request");

        let mut response = String::new();
        stream
            .read_to_string(&mut response)
            .expect("failed to read response");

        assert!(response.starts_with("HTTP/1.1 200 OK"));
        assert!(response.contains(r#""success":true"#));
        assert!(response.contains(r#""ok":true"#));

        server.stop();
    }
}
