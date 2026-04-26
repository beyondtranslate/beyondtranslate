use serde::Serialize;
use worker::{Request, Response};

use crate::ApiError;

#[derive(Debug, Serialize)]
struct IndexResponse {
    message: &'static str,
    references: Vec<String>,
}

pub async fn handle(req: Request) -> Result<Response, ApiError> {
    let path = req.path();
    let prefix = normalized_prefix(path.as_str());

    Response::from_json(&IndexResponse {
        message: "Welcome to BeyondTranslate API",
        references: vec![format!("{prefix}/reference")],
    })
    .map_err(ApiError::from_worker_error)
}

fn normalized_prefix(path: &str) -> &str {
    match path.trim_end_matches('/') {
        "" => "",
        "/" => "",
        prefix => prefix,
    }
}

#[cfg(test)]
mod tests {
    use super::normalized_prefix;

    #[test]
    fn normalizes_root_prefix() {
        assert_eq!(normalized_prefix("/"), "");
        assert_eq!(normalized_prefix(""), "");
    }

    #[test]
    fn trims_trailing_slash() {
        assert_eq!(normalized_prefix("/auth/"), "/auth");
        assert_eq!(normalized_prefix("/admin"), "/admin");
    }
}
