use std::sync::{mpsc, Arc};

use async_trait::async_trait;
use beyondtranslate_core::{
    ChatMessage, ChatRequest, ChatResponse, ChatRole, DetectLanguageRequest,
    DetectLanguageResponse, DictionaryError, DictionaryService, LlmError, LlmService,
    LlmStreamReceiver, LookUpRequest, LookUpResponse, Provider, ProviderCapability, StreamChunk,
    TextDetection, TextTranslation, TranslateRequest, TranslateResponse, TranslationError,
    TranslationService, WordDefinition, WordEtymology, WordPhrase, WordPronunciation, WordSynonym,
};
use serde::{Deserialize, Serialize};
use serde_json::Value;

use super::prompt;

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
    translation_service: OpenAiTranslationService,
    dictionary_service: OpenAiDictionaryService,
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
            translation_service: OpenAiTranslationService {
                llm: llm_service.clone(),
                default_model: default_model.clone(),
            },
            dictionary_service: OpenAiDictionaryService {
                llm: llm_service,
                default_model,
            },
        })
    }
}

impl Provider for OpenAiProvider {
    fn name(&self) -> &'static str {
        "openai"
    }

    fn capabilities(&self) -> Vec<ProviderCapability> {
        vec![
            ProviderCapability::Translation,
            ProviderCapability::Dictionary,
        ]
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

// ── Translation Service (delegates to LLM) ────────────────────────────────────

pub struct OpenAiTranslationService {
    llm: Arc<OpenAiLlmService>,
    default_model: String,
}

impl OpenAiTranslationService {
    fn llm(&self) -> &OpenAiLlmService {
        self.llm.as_ref()
    }
}

#[async_trait(?Send)]
impl TranslationService for OpenAiTranslationService {
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

pub struct OpenAiDictionaryService {
    llm: Arc<OpenAiLlmService>,
    default_model: String,
}

impl OpenAiDictionaryService {
    fn llm(&self) -> &OpenAiLlmService {
        self.llm.as_ref()
    }
}

#[async_trait(?Send)]
impl DictionaryService for OpenAiDictionaryService {
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
