use std::sync::{mpsc, Arc};

use async_trait::async_trait;
use beyondtranslate_core::{
    ChatMessage, ChatRequest, ChatResponse, ChatRole, DetectLanguageRequest,
    DetectLanguageResponse, DictionaryError, DictionaryService, LlmError, LlmService,
    LlmStreamReceiver, LookUpRequest, LookUpResponse, Provider, StreamChunk, TextDetection,
    TextTranslation, TranslateRequest, TranslateResponse, TranslationError, TranslationService,
    WordDefinition, WordEtymology, WordPhrase, WordPronunciation, WordSynonym,
};
use serde::{Deserialize, Serialize};
use serde_json::Value;

use super::prompt;

// ── Config ────────────────────────────────────────────────────────────────────

#[derive(Debug, Clone, Deserialize, PartialEq, Serialize)]
pub struct AnthropicProviderConfig {
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

pub struct AnthropicProvider {
    #[allow(dead_code)]
    config: AnthropicProviderConfig,
    llm_service: Arc<AnthropicLlmService>,
    translation_service: AnthropicTranslationService,
    dictionary_service: AnthropicDictionaryService,
}

impl AnthropicProvider {
    pub fn new(config: AnthropicProviderConfig) -> Result<Self, String> {
        if config.api_key.trim().is_empty() {
            return Err("api_key must not be empty".to_owned());
        }
        let base_url = config
            .base_url
            .clone()
            .unwrap_or_else(|| "https://api.anthropic.com".to_string());

        let http = HttpClient::new(&base_url, &config.api_key);
        let default_model = configured_default_model(&config.default_model)?;

        let llm_service = Arc::new(AnthropicLlmService {
            base_url,
            api_key: config.api_key.clone(),
            default_model: default_model.clone(),
            http: http.clone(),
        });

        Ok(Self {
            config: config.clone(),
            llm_service: llm_service.clone(),
            translation_service: AnthropicTranslationService {
                llm: llm_service.clone(),
                default_model: default_model.clone(),
            },
            dictionary_service: AnthropicDictionaryService {
                llm: llm_service,
                default_model,
            },
        })
    }
}

impl Provider for AnthropicProvider {
    fn name(&self) -> &'static str {
        "anthropic"
    }

    fn translation(&self) -> Option<&dyn TranslationService> {
        Some(&self.translation_service)
    }

    fn dictionary(&self) -> Option<&dyn DictionaryService> {
        Some(&self.dictionary_service)
    }

    fn llm(&self) -> Option<&dyn LlmService> {
        Some(self.llm_service.as_ref())
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

pub struct AnthropicLlmService {
    base_url: String,
    api_key: String,
    default_model: String,
    http: HttpClient,
}

impl AnthropicLlmService {
    fn build_anthropic_body(&self, request: &ChatRequest, stream: bool) -> Value {
        // Anthropic does NOT support system role as a message — it's a top-level field.
        let mut system_prompts: Vec<String> = Vec::new();
        let messages: Vec<Value> = request
            .messages
            .iter()
            .filter_map(|m| match m.role {
                ChatRole::System => {
                    system_prompts.push(m.content.clone());
                    None
                }
                ChatRole::User => Some(serde_json::json!({
                    "role": "user",
                    "content": m.content,
                })),
                ChatRole::Assistant => Some(serde_json::json!({
                    "role": "assistant",
                    "content": m.content,
                })),
            })
            .collect();

        let model = if request.model.is_empty() {
            &self.default_model
        } else {
            &request.model
        };

        let max_tokens = request.max_tokens.unwrap_or(4096);

        let mut body = serde_json::json!({
            "model": model,
            "max_tokens": max_tokens,
            "messages": messages,
            "stream": stream,
        });

        if !system_prompts.is_empty() {
            let system = system_prompts.join("\n\n");
            body["system"] = serde_json::json!(system);
        }

        if let Some(temp) = request.temperature {
            body["temperature"] = serde_json::json!(temp);
        }

        body
    }
}

#[async_trait]
impl LlmService for AnthropicLlmService {
    fn provider_name(&self) -> &'static str {
        "anthropic"
    }

    fn available_models(&self) -> Vec<String> {
        vec![self.default_model.clone()]
    }

    async fn list_models(&self) -> Result<Vec<String>, LlmError> {
        let response = self
            .http
            .client
            .get(self.http.join_url("/v1/models"))
            .header("x-api-key", &self.api_key)
            .header("anthropic-version", "2023-06-01")
            .header("Content-Type", "application/json")
            .send()
            .await
            .map_err(|e| LlmError::NetworkError(e.to_string()))?;

        if !response.status().is_success() {
            let status = response.status();
            let body = response.text().await.unwrap_or_default();
            return Err(match status.as_u16() {
                401 | 403 => LlmError::AuthError(body),
                429 => LlmError::RateLimitError(body),
                400..=499 => LlmError::InvalidRequest(body),
                _ => LlmError::NetworkError(format!("HTTP {status}: {body}")),
            });
        }

        let json: serde_json::Value = response
            .json()
            .await
            .map_err(|e| LlmError::SerializationError(e.to_string()))?;

        // Anthropic API returns { "data": [{ "id": "...", ... }] }
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

    async fn chat(&self, request: ChatRequest) -> Result<ChatResponse, LlmError> {
        let body = self.build_anthropic_body(&request, false);

        let response = self
            .http
            .client
            .post(self.http.join_url("/v1/messages"))
            .header("x-api-key", &self.api_key)
            .header("anthropic-version", "2023-06-01")
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

        let raw: Value = response
            .json()
            .await
            .map_err(|e| LlmError::SerializationError(e.to_string()))?;

        let chat_response = parse_anthropic_response(&raw);
        Ok(chat_response)
    }

    async fn chat_stream(&self, request: ChatRequest) -> Result<LlmStreamReceiver, LlmError> {
        let body = self.build_anthropic_body(&request, true);

        let response = self
            .http
            .client
            .post(self.http.join_url("/v1/messages"))
            .header("x-api-key", &self.api_key)
            .header("anthropic-version", "2023-06-01")
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
            let mut current_event: Option<String> = None;

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

                            if let Some(event) = line.strip_prefix("event: ") {
                                current_event = Some(event.to_string());
                                continue;
                            }

                            if let Some(data) = line.strip_prefix("data: ") {
                                let event_type = current_event
                                    .take()
                                    .unwrap_or_else(|| "message".to_string());

                                match event_type.as_str() {
                                    "content_block_delta" => {
                                        if let Ok(parsed) = serde_json::from_str::<Value>(data) {
                                            if let Some(delta) = parsed["delta"].as_object() {
                                                if delta["type"] == "text_delta" {
                                                    let text = delta["text"]
                                                        .as_str()
                                                        .unwrap_or("")
                                                        .to_string();
                                                    if !text.is_empty() {
                                                        let index =
                                                            parsed["index"].as_u64().unwrap_or(0)
                                                                as u32;
                                                        let _ = tx.send(StreamChunk {
                                                            content: text,
                                                            index,
                                                            finish_reason: None,
                                                        });
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    "message_stop" => {
                                        let _ = tx.send(StreamChunk {
                                            content: String::new(),
                                            index: 0,
                                            finish_reason: Some("stop".to_string()),
                                        });
                                        return;
                                    }
                                    "error" => {
                                        if let Ok(parsed) = serde_json::from_str::<Value>(data) {
                                            let error_msg = parsed["error"]["message"]
                                                .as_str()
                                                .unwrap_or("Unknown stream error");
                                            let _ = tx.send(StreamChunk {
                                                content: error_msg.to_string(),
                                                index: 0,
                                                finish_reason: Some("error".to_string()),
                                            });
                                        }
                                        return;
                                    }
                                    _ => {}
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

/// Parse Anthropic's non-streaming JSON response into a `ChatResponse`.
fn parse_anthropic_response(raw: &Value) -> ChatResponse {
    let id = raw["id"].as_str().map(|s| s.to_string());
    let model = raw["model"].as_str().unwrap_or("unknown").to_string();

    let content_text = raw["content"]
        .as_array()
        .and_then(|blocks| {
            blocks.iter().find_map(|block| {
                if block["type"] == "text" {
                    block["text"].as_str().map(|s| s.to_string())
                } else {
                    None
                }
            })
        })
        .unwrap_or_default();

    let stop_reason = raw["stop_reason"].as_str().map(|s| s.to_string());

    let message = ChatMessage::assistant(content_text);
    let choice = beyondtranslate_core::ChatChoice {
        index: 0,
        message,
        finish_reason: stop_reason,
    };

    let usage = raw.get("usage").map(|u| {
        let input = u["input_tokens"].as_u64().unwrap_or(0) as u32;
        let output = u["output_tokens"].as_u64().unwrap_or(0) as u32;
        beyondtranslate_core::ChatUsage {
            prompt_tokens: input,
            completion_tokens: output,
            total_tokens: input + output,
        }
    });

    ChatResponse {
        id,
        model,
        choices: vec![choice],
        usage,
    }
}

// ── Translation Service (delegates to LLM) ────────────────────────────────────

pub struct AnthropicTranslationService {
    llm: Arc<AnthropicLlmService>,
    default_model: String,
}

impl AnthropicTranslationService {
    fn llm(&self) -> &AnthropicLlmService {
        self.llm.as_ref()
    }
}

#[async_trait(?Send)]
impl TranslationService for AnthropicTranslationService {
    async fn translate(
        &self,
        request: TranslateRequest,
    ) -> Result<TranslateResponse, TranslationError> {
        let source_lang = request.source_language.as_deref().unwrap_or("auto");
        let target_lang = request.target_language.as_deref().unwrap_or("English");

        let system_prompt = prompt::translate_text_system_prompt(source_lang, target_lang, None);
        let user_prompt = prompt::translate_text_user_prompt(&request.text);

        let chat_req = ChatRequest {
            model: self.default_model.clone(),
            messages: vec![
                ChatMessage::system(system_prompt),
                ChatMessage::user(user_prompt),
            ],
            temperature: Some(0.3),
            max_tokens: Some(4096),
            stream: None,
        };

        let chat_response = self
            .llm()
            .chat(chat_req)
            .await
            .map_err(|e| TranslationError::NetworkError(e.to_string()))?;

        let content = chat_response
            .choices
            .first()
            .map(|c| c.message.content.clone())
            .unwrap_or_default();

        let translations = parse_translation_json(&content).unwrap_or_else(|| {
            vec![TextTranslation {
                text: content,
                detected_source_language: None,
                audio_url: None,
            }]
        });

        Ok(TranslateResponse { translations })
    }

    async fn detect_language(
        &self,
        request: DetectLanguageRequest,
    ) -> Result<DetectLanguageResponse, TranslationError> {
        // Take the first text for detection
        let text = request.texts.first().cloned().unwrap_or_default();

        let chat_req = ChatRequest {
            model: self.default_model.clone(),
            messages: vec![
                ChatMessage::system(
                    "You are a language detection expert. Identify the language of the given text. \
                     Return ONLY a JSON object: {\"language\": \"<language name in English>\", \"confidence\": 0.0-1.0}",
                ),
                ChatMessage::user(format!("Detect the language: \"{}\"", text)),
            ],
            temperature: Some(0.0),
            max_tokens: Some(256),
            stream: None,
        };

        let chat_response = self
            .llm()
            .chat(chat_req)
            .await
            .map_err(|e| TranslationError::NetworkError(e.to_string()))?;

        let content = chat_response
            .choices
            .first()
            .map(|c| c.message.content.clone())
            .unwrap_or_default();

        let detected: Value = serde_json::from_str(&content).unwrap_or_default();
        let language = detected["language"]
            .as_str()
            .unwrap_or("unknown")
            .to_string();

        Ok(DetectLanguageResponse {
            detections: Some(vec![TextDetection {
                detected_language: language,
                text,
            }]),
        })
    }
}

fn parse_translation_json(content: &str) -> Option<Vec<TextTranslation>> {
    let json_str = content
        .strip_prefix("```json")
        .and_then(|s| s.strip_suffix("```"))
        .map(|s| s.trim())
        .unwrap_or(content.trim());

    serde_json::from_str::<Value>(json_str).ok().and_then(|v| {
        v["translations"].as_array().map(|arr| {
            arr.iter()
                .map(|item: &Value| TextTranslation {
                    text: item["text"].as_str().unwrap_or("").to_string(),
                    detected_source_language: None,
                    audio_url: None,
                })
                .collect()
        })
    })
}

// ── Dictionary Service (delegates to LLM) ─────────────────────────────────────

pub struct AnthropicDictionaryService {
    llm: Arc<AnthropicLlmService>,
    default_model: String,
}

impl AnthropicDictionaryService {
    fn llm(&self) -> &AnthropicLlmService {
        self.llm.as_ref()
    }
}

#[async_trait(?Send)]
impl DictionaryService for AnthropicDictionaryService {
    async fn look_up(&self, request: LookUpRequest) -> Result<LookUpResponse, DictionaryError> {
        let chat_req = ChatRequest {
            model: self.default_model.clone(),
            messages: vec![
                ChatMessage::system(prompt::dictionary_lookup_system_prompt(
                    &request.source_language,
                    &request.target_language,
                )),
                ChatMessage::user(prompt::dictionary_lookup_user_prompt(&request.word)),
            ],
            temperature: Some(0.3),
            max_tokens: Some(2048),
            stream: None,
        };

        let chat_response = self
            .llm()
            .chat(chat_req)
            .await
            .map_err(|e| DictionaryError::NetworkError(e.to_string()))?;

        let content = chat_response
            .choices
            .first()
            .map(|c| c.message.content.clone())
            .unwrap_or_default();

        parse_dictionary_json(&content, &request.word)
    }
}

fn parse_dictionary_json(
    content: &str,
    fallback_word: &str,
) -> Result<LookUpResponse, DictionaryError> {
    let json_str = content
        .strip_prefix("```json")
        .and_then(|s| s.strip_suffix("```"))
        .map(|s| s.trim())
        .unwrap_or(content.trim());

    let v: Value = serde_json::from_str(json_str)
        .map_err(|e| DictionaryError::SerializationError(e.to_string()))?;

    let word = v["word"]
        .as_str()
        .map(|s| s.to_string())
        .or(Some(fallback_word.to_string()));

    let pronunciations: Option<Vec<WordPronunciation>> =
        v["pronunciations"].as_array().map(|arr: &Vec<Value>| {
            arr.iter()
                .map(|p: &Value| WordPronunciation {
                    r#type: p["type"].as_str().map(|s| s.to_string()),
                    phonetic_symbol: p["phonetic"].as_str().map(|s| s.to_string()),
                    audio_url: p["audio_url"].as_str().map(|s| s.to_string()),
                })
                .collect()
        });

    let definitions: Option<Vec<WordDefinition>> =
        v["definitions"].as_array().map(|arr: &Vec<Value>| {
            arr.iter()
                .map(|d: &Value| WordDefinition {
                    r#type: d["type"].as_str().map(|s| s.to_string()),
                    name: d["meaning"].as_str().map(|s| s.to_string()),
                    values: d["examples"].as_array().map(|exs: &Vec<Value>| {
                        exs.iter()
                            .filter_map(|e: &Value| e.as_str().map(|s: &str| s.to_string()))
                            .collect()
                    }),
                })
                .collect()
        });

    let translations: Vec<TextTranslation> = v["translations"]
        .as_array()
        .map(|arr: &Vec<Value>| {
            arr.iter()
                .filter_map(|t: &Value| {
                    t.as_str().map(|s: &str| TextTranslation {
                        text: s.to_string(),
                        detected_source_language: None,
                        audio_url: None,
                    })
                })
                .collect()
        })
        .unwrap_or_default();

    let synonyms: Option<Vec<WordSynonym>> = v["synonyms"].as_array().map(|arr: &Vec<Value>| {
        arr.iter()
            .filter_map(|s: &Value| s.as_str())
            .map(|syn: &str| WordSynonym {
                r#type: None,
                word: syn.to_string(),
                definitions: None,
            })
            .collect()
    });

    let phrases: Option<Vec<WordPhrase>> = v["phrases"].as_array().map(|arr: &Vec<Value>| {
        arr.iter()
            .map(|p: &Value| WordPhrase {
                text: p["text"].as_str().unwrap_or("").to_string(),
                translations: p["translation"]
                    .as_str()
                    .map(|t: &str| vec![t.to_string()])
                    .unwrap_or_default(),
            })
            .collect()
    });

    let etymology: Option<Vec<WordEtymology>> = v["etymology"].as_str().map(|s: &str| {
        vec![WordEtymology {
            origin: Some(s.to_string()),
            root: None,
        }]
    });

    Ok(LookUpResponse {
        translations,
        word,
        tip: v["usage_notes"].as_str().map(|s: &str| s.to_string()),
        tags: None,
        pronunciations,
        definitions,
        images: None,
        phrases,
        tenses: None,
        sentences: None,
        etymology,
        synonyms,
    })
}
