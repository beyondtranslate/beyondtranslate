use std::sync::{mpsc, Arc};

use async_trait::async_trait;
use beyondtranslate_core::{
    ChatRequest, ChatResponse, ChatRole, LlmError, LlmService, LlmStreamReceiver, Provider,
    StreamChunk,
};
use serde::{Deserialize, Serialize};
use serde_json::Value;

// ── Config ────────────────────────────────────────────────────────────────────

#[derive(Debug, Clone, Deserialize, PartialEq, Serialize)]
pub struct OpenAiProviderConfig {
    #[serde(rename = "apiKey", alias = "api_key")]
    pub api_key: String,
    #[serde(rename = "baseUrl", alias = "base_url")]
    pub base_url: Option<String>,
    #[serde(rename = "defaultModel", alias = "default_model", default)]
    pub default_model: String,
}

fn configured_default_model(default_model: &str) -> Result<String, String> {
    let default_model = default_model.trim().to_string();
    if default_model.is_empty() {
        return Err("default_model must be configured".to_owned());
    }
    Ok(default_model)
}

// ── Provider ──────────────────────────────────────────────────────────────────

pub struct OpenAiProvider {
    #[allow(dead_code)]
    config: OpenAiProviderConfig,
    llm_service: Arc<OpenAiLlmService>,
}

impl OpenAiProvider {
    pub fn new(config: OpenAiProviderConfig) -> Result<Self, String> {
        if config.api_key.trim().is_empty() {
            return Err("api_key must not be empty".to_owned());
        }
        let base_url = config
            .base_url
            .clone()
            .unwrap_or_else(|| "https://api.openai.com".to_string());

        let http = HttpClient::new(&base_url, &config.api_key);
        let default_model = configured_default_model(&config.default_model)?;

        let llm_service = Arc::new(OpenAiLlmService {
            base_url,
            api_key: config.api_key.clone(),
            default_model: default_model.clone(),
            http: http.clone(),
        });

        Ok(Self {
            config: config.clone(),
            llm_service: llm_service.clone(),
        })
    }
}

#[async_trait]
impl Provider for OpenAiProvider {
    fn name(&self) -> &'static str {
        "openai"
    }

    fn llm(&self) -> Option<&dyn LlmService> {
        Some(self.llm_service.as_ref())
    }

    async fn list_models(&self) -> Result<Vec<String>, LlmError> {
        self.llm_service.list_models().await
    }
}

// ── LLM Service (core) ────────────────────────────────────────────────────────

#[derive(Clone)]
struct HttpClient {
    base_url: String,
    api_key: String,
    client: reqwest::Client,
}

impl HttpClient {
    fn new(base_url: &str, api_key: &str) -> Self {
        Self {
            base_url: base_url.to_string(),
            api_key: api_key.to_string(),
            client: reqwest::Client::new(),
        }
    }

    fn join_url(&self, path: &str) -> String {
        format!("{}{}", self.base_url.trim_end_matches('/'), path)
    }
}

pub struct OpenAiLlmService {
    base_url: String,
    api_key: String,
    default_model: String,
    http: HttpClient,
}

impl OpenAiLlmService {
    fn build_openai_body(&self, request: &ChatRequest, stream: bool) -> Value {
        let messages: Vec<Value> = request
            .messages
            .iter()
            .map(|m| {
                let role = match m.role {
                    ChatRole::System => "system",
                    ChatRole::User => "user",
                    ChatRole::Assistant => "assistant",
                };
                serde_json::json!({
                    "role": role,
                    "content": m.content,
                })
            })
            .collect();

        let model = if request.model.is_empty() {
            &self.default_model
        } else {
            &request.model
        };

        let mut body = serde_json::json!({
            "model": model,
            "messages": messages,
            "stream": stream,
        });

        if let Some(temp) = request.temperature {
            body["temperature"] = serde_json::json!(temp);
        }
        if let Some(max_tokens) = request.max_tokens {
            body["max_tokens"] = serde_json::json!(max_tokens);
        }

        body
    }

    async fn send_chat(&self, request: &ChatRequest) -> Result<reqwest::Response, LlmError> {
        let body = self.build_openai_body(request, false);
        self.http
            .client
            .post(self.http.join_url("/v1/chat/completions"))
            .header("Authorization", format!("Bearer {}", self.api_key))
            .header("Content-Type", "application/json")
            .json(&body)
            .send()
            .await
            .map_err(|e| LlmError::NetworkError(e.to_string()))
    }
}

impl OpenAiLlmService {
    async fn list_models(&self) -> Result<Vec<String>, LlmError> {
        let response = self
            .http
            .client
            .get(self.http.join_url("/v1/models"))
            .header("Authorization", format!("Bearer {}", self.api_key))
            .header("Content-Type", "application/json")
            .send()
            .await
            .map_err(|e| LlmError::NetworkError(e.to_string()))?;

        if !response.status().is_success() {
            let status = response.status();
            let body = response.text().await.unwrap_or_default();
            return Err(match status.as_u16() {
                401 | 403 => LlmError::AuthError(body),
                _ => LlmError::NetworkError(format!("HTTP {status}: {body}")),
            });
        }

        let json: serde_json::Value = response
            .json()
            .await
            .map_err(|e| LlmError::SerializationError(e.to_string()))?;

        let models = json["data"]
            .as_array()
            .map(|arr| {
                arr.iter()
                    .filter_map(|m| m["id"].as_str().map(String::from))
                    .collect::<Vec<_>>()
            })
            .unwrap_or_default();

        Ok(models)
    }
}

#[async_trait]
impl LlmService for OpenAiLlmService {
    fn provider_name(&self) -> &'static str {
        "openai"
    }

    fn available_models(&self) -> Vec<String> {
        vec![self.default_model.clone()]
    }

    async fn chat(&self, request: ChatRequest) -> Result<ChatResponse, LlmError> {
        let response = self.send_chat(&request).await?;

        if !response.status().is_success() {
            let status = response.status();
            let body_text = response.text().await.unwrap_or_default();
            return Err(match status.as_u16() {
                401 | 403 => LlmError::AuthError(body_text),
                429 => LlmError::RateLimitError(body_text),
                400..=499 => LlmError::InvalidRequest(body_text),
                _ => LlmError::NetworkError(format!("HTTP {status}: {body_text}")),
            });
        }

        let chat_response: ChatResponse = response
            .json()
            .await
            .map_err(|e| LlmError::SerializationError(e.to_string()))?;

        Ok(chat_response)
    }

    async fn chat_stream(&self, request: ChatRequest) -> Result<LlmStreamReceiver, LlmError> {
        let body = self.build_openai_body(&request, true);

        let response = self
            .http
            .client
            .post(self.http.join_url("/v1/chat/completions"))
            .header("Authorization", format!("Bearer {}", self.api_key))
            .header("Content-Type", "application/json")
            .json(&body)
            .send()
            .await
            .map_err(|e| LlmError::NetworkError(e.to_string()))?;

        if !response.status().is_success() {
            let status = response.status();
            let body_text = response.text().await.unwrap_or_default();
            return Err(match status.as_u16() {
                401 | 403 => LlmError::AuthError(body_text),
                429 => LlmError::RateLimitError(body_text),
                400..=499 => LlmError::InvalidRequest(body_text),
                _ => LlmError::NetworkError(format!("HTTP {status}: {body_text}")),
            });
        }

        let (tx, rx) = mpsc::channel();

        tokio::spawn(async move {
            use futures_util::StreamExt;
            let mut byte_stream = response.bytes_stream();
            let mut buffer = String::new();

            while let Some(chunk_result) = byte_stream.next().await {
                match chunk_result {
                    Ok(bytes) => {
                        buffer.push_str(&String::from_utf8_lossy(&bytes));
                        while let Some(line_end) = buffer.find('\n') {
                            let line = buffer[..line_end].trim().to_string();
                            buffer = buffer[line_end + 1..].to_string();

                            if line.is_empty() || line.starts_with(':') {
                                continue;
                            }

                            if line == "data: [DONE]" {
                                let _ = tx.send(StreamChunk {
                                    content: String::new(),
                                    index: 0,
                                    finish_reason: Some("stop".to_string()),
                                });
                                return;
                            }

                            if let Some(data) = line.strip_prefix("data: ") {
                                if let Ok(parsed) = serde_json::from_str::<Value>(data) {
                                    if let Some(choices) = parsed["choices"].as_array() {
                                        for choice in choices {
                                            let index =
                                                choice["index"].as_u64().unwrap_or(0) as u32;
                                            let delta_content = choice["delta"]["content"]
                                                .as_str()
                                                .unwrap_or("")
                                                .to_string();
                                            let finish_reason = choice["finish_reason"]
                                                .as_str()
                                                .map(|s| s.to_string());

                                            if !delta_content.is_empty() || finish_reason.is_some()
                                            {
                                                let _ = tx.send(StreamChunk {
                                                    content: delta_content,
                                                    index,
                                                    finish_reason,
                                                });
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Err(e) => {
                        let _ = tx.send(StreamChunk {
                            content: format!("Stream error: {e}"),
                            index: 0,
                            finish_reason: Some("error".to_string()),
                        });
                        return;
                    }
                }
            }
        });

        Ok(LlmStreamReceiver { rx })
    }
}
