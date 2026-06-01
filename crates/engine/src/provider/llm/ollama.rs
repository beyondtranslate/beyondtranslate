use std::sync::{mpsc, Arc};

use async_trait::async_trait;
use beyondtranslate_core::{
    ChatChoice, ChatMessage, ChatRequest, ChatResponse, ChatRole, LlmError, LlmService,
    LlmStreamReceiver, Provider, StreamChunk,
};
use serde::{Deserialize, Serialize};
use serde_json::Value;

// ── Config ────────────────────────────────────────────────────────────────────

#[derive(Debug, Clone, Deserialize, PartialEq, Serialize)]
pub struct OllamaProviderConfig {
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

pub struct OllamaProvider {
    #[allow(dead_code)]
    config: OllamaProviderConfig,
    llm_service: Arc<OllamaLlmService>,
}

impl OllamaProvider {
    pub fn new(config: OllamaProviderConfig) -> Result<Self, String> {
        let base_url = config
            .base_url
            .clone()
            .unwrap_or_else(|| "http://localhost:11434".to_string());

        let http = HttpClient::new(&base_url);
        let default_model = configured_default_model(&config.default_model)?;

        let llm_service = Arc::new(OllamaLlmService {
            base_url,
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
impl Provider for OllamaProvider {
    fn name(&self) -> &'static str {
        "ollama"
    }

    fn llm(&self) -> Option<&dyn LlmService> {
        Some(self.llm_service.as_ref())
    }

    async fn list_models(&self) -> Result<Vec<String>, LlmError> {
        self.llm_service.list_models().await
    }
}

// ── HTTP Client ───────────────────────────────────────────────────────────────

#[derive(Clone)]
struct HttpClient {
    base_url: String,
    client: reqwest::Client,
}

impl HttpClient {
    fn new(base_url: &str) -> Self {
        Self {
            base_url: base_url.to_string(),
            client: reqwest::Client::new(),
        }
    }

    fn join_url(&self, path: &str) -> String {
        format!("{}{}", self.base_url.trim_end_matches('/'), path)
    }
}

// ── LLM Service (core) ────────────────────────────────────────────────────────

pub struct OllamaLlmService {
    base_url: String,
    default_model: String,
    http: HttpClient,
}

impl OllamaLlmService {
    fn build_ollama_body(&self, request: &ChatRequest, stream: bool) -> Value {
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

        // Ollama puts generation parameters inside "options"
        let mut options = serde_json::Map::new();
        if let Some(temp) = request.temperature {
            options.insert("temperature".to_string(), serde_json::json!(temp));
        }
        if let Some(max_tokens) = request.max_tokens {
            options.insert("num_predict".to_string(), serde_json::json!(max_tokens));
        }
        if !options.is_empty() {
            body["options"] = serde_json::Value::Object(options);
        }

        body
    }

    fn parse_chat_response(&self, json: &Value) -> Result<ChatResponse, LlmError> {
        let model = json["model"].as_str().unwrap_or("").to_string();

        let content = json["message"]["content"]
            .as_str()
            .unwrap_or("")
            .to_string();

        let role_str = json["message"]["role"].as_str().unwrap_or("assistant");

        let role = match role_str {
            "system" => ChatRole::System,
            "user" => ChatRole::User,
            _ => ChatRole::Assistant,
        };

        let finish_reason = if json["done"].as_bool().unwrap_or(false) {
            json["done_reason"].as_str().map(|s| s.to_string())
        } else {
            None
        };

        Ok(ChatResponse {
            id: None,
            model,
            choices: vec![ChatChoice {
                index: 0,
                message: ChatMessage { role, content },
                finish_reason,
            }],
            // Ollama doesn't always return token counts
            usage: None,
        })
    }
}

impl OllamaLlmService {
    async fn list_models(&self) -> Result<Vec<String>, LlmError> {
        let response = self
            .http
            .client
            .get(self.http.join_url("/api/tags"))
            .header("Content-Type", "application/json")
            .send()
            .await
            .map_err(|e| LlmError::NetworkError(e.to_string()))?;

        if !response.status().is_success() {
            let status = response.status();
            let body = response.text().await.unwrap_or_default();
            return Err(LlmError::NetworkError(format!("HTTP {status}: {body}")));
        }

        let json: serde_json::Value = response
            .json()
            .await
            .map_err(|e| LlmError::SerializationError(e.to_string()))?;

        // Ollama API returns { "models": [{ "name": "...", ... }] }
        let models = json["models"]
            .as_array()
            .map(|arr| {
                arr.iter()
                    .filter_map(|m| m["name"].as_str().map(String::from))
                    .collect::<Vec<_>>()
            })
            .unwrap_or_default();

        Ok(models)
    }
}

#[async_trait]
impl LlmService for OllamaLlmService {
    fn provider_name(&self) -> &'static str {
        "ollama"
    }

    fn available_models(&self) -> Vec<String> {
        vec![self.default_model.clone()]
    }

    async fn chat(&self, request: ChatRequest) -> Result<ChatResponse, LlmError> {
        let body = self.build_ollama_body(&request, false);

        let response = self
            .http
            .client
            .post(self.http.join_url("/api/chat"))
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

        let json: Value = response
            .json()
            .await
            .map_err(|e| LlmError::SerializationError(e.to_string()))?;

        self.parse_chat_response(&json)
    }

    async fn chat_stream(&self, request: ChatRequest) -> Result<LlmStreamReceiver, LlmError> {
        let body = self.build_ollama_body(&request, true);

        let response = self
            .http
            .client
            .post(self.http.join_url("/api/chat"))
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

                            if line.is_empty() {
                                continue;
                            }

                            match serde_json::from_str::<Value>(&line) {
                                Ok(parsed) => {
                                    let content = parsed["message"]["content"]
                                        .as_str()
                                        .unwrap_or("")
                                        .to_string();

                                    let done = parsed["done"].as_bool().unwrap_or(false);
                                    let finish_reason = if done {
                                        parsed["done_reason"]
                                            .as_str()
                                            .map(|s| s.to_string())
                                            .or(Some("stop".to_string()))
                                    } else {
                                        None
                                    };

                                    if !content.is_empty() || finish_reason.is_some() {
                                        let _ = tx.send(StreamChunk {
                                            content,
                                            index: 0,
                                            finish_reason,
                                        });
                                    }

                                    if done {
                                        return;
                                    }
                                }
                                Err(_) => {
                                    // Skip unparseable lines
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
