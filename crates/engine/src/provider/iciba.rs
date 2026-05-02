#![cfg_attr(not(feature = "iciba"), allow(dead_code))]

use async_trait::async_trait;
use beyondtranslate_core::{
    DictionaryError, DictionaryService, LookUpRequest, LookUpResponse, Provider, TextTranslation,
    WordDefinition, WordPronunciation, WordTense,
};

use crate::common::http_client::HttpClient;
use serde::{Deserialize, Serialize};
use serde_json::Value;

#[derive(Debug, Clone, Deserialize, PartialEq, Serialize)]
pub struct IcibaProviderConfig {
    #[serde(rename = "appKey", alias = "apiKey", alias = "api_key")]
    pub api_key: String,
    #[serde(rename = "baseUrl", alias = "base_url")]
    pub base_url: Option<String>,
}

pub struct IcibaProvider {
    #[allow(dead_code)]
    config: IcibaProviderConfig,
    dictionary_service: IcibaDictionaryService,
}

struct IcibaDictionaryService {
    api_key: String,
    http: HttpClient,
}

impl IcibaProvider {
    pub fn new(config: IcibaProviderConfig) -> Result<Self, String> {
        if config.api_key.trim().is_empty() {
            return Err("api_key must not be empty".to_owned());
        }
        Ok(Self {
            config: config.clone(),
            dictionary_service: IcibaDictionaryService {
                api_key: config.api_key,
                http: HttpClient::new(
                    config
                        .base_url
                        .unwrap_or_else(|| "http://dict-co.iciba.com".to_owned()),
                    Default::default(),
                ),
            },
        })
    }
}

#[async_trait(?Send)]
impl DictionaryService for IcibaDictionaryService {
    async fn look_up(&self, request: LookUpRequest) -> Result<LookUpResponse, DictionaryError> {
        if !(request.source_language == "en" && request.target_language == "zh") {
            return Err(DictionaryError::InvalidRequest(
                "Iciba only supports en -> zh lookup".to_owned(),
            ));
        }

        let response = self.http.get("/api/dictionary.php").query(&[
            ("w", request.word.to_lowercase()),
            ("key", self.api_key.clone()),
            ("type", "json".to_owned()),
        ]);
        let response = self
            .http
            .execute(response)
            .await
            .map_err(DictionaryError::from_network_error)?;
        let content_type = response
            .headers()
            .get("content-type")
            .and_then(|value| value.to_str().ok())
            .unwrap_or("")
            .to_owned();
        let response = DictionaryError::from_response("iciba", response).await?;

        if content_type.contains("text/xml") {
            return Err(DictionaryError::AuthError(
                "Please check your key".to_owned(),
            ));
        }

        let data: Value = response
            .json()
            .await
            .map_err(|error| DictionaryError::SerializationError(error.to_string()))?;

        let word = data["word_name"].as_str().map(ToOwned::to_owned);
        let symbol = data["symbols"].as_array().and_then(|items| items.first());

        let definitions = symbol
            .and_then(|value| value["parts"].as_array())
            .map(|parts| {
                parts
                    .iter()
                    .map(|part| WordDefinition {
                        r#type: None,
                        name: part["part"].as_str().map(ToOwned::to_owned),
                        values: part["means"].as_array().map(|means| {
                            means
                                .iter()
                                .filter_map(|value| value.as_str().map(ToOwned::to_owned))
                                .collect()
                        }),
                    })
                    .collect::<Vec<_>>()
            })
            .filter(|items| !items.is_empty());

        let pronunciations = symbol
            .map(|value| {
                vec![
                    WordPronunciation {
                        r#type: Some("uk".to_owned()),
                        phonetic_symbol: value["ph_en"].as_str().map(ToOwned::to_owned),
                        audio_url: value["ph_en_mp3"].as_str().map(ToOwned::to_owned),
                    },
                    WordPronunciation {
                        r#type: Some("us".to_owned()),
                        phonetic_symbol: value["ph_am"].as_str().map(ToOwned::to_owned),
                        audio_url: value["ph_am_mp3"].as_str().map(ToOwned::to_owned),
                    },
                ]
                .into_iter()
                .filter(|item| {
                    item.phonetic_symbol
                        .as_ref()
                        .map(|value| !value.is_empty())
                        .unwrap_or(false)
                        || item
                            .audio_url
                            .as_ref()
                            .map(|value| !value.is_empty())
                            .unwrap_or(false)
                })
                .collect::<Vec<_>>()
            })
            .filter(|items| !items.is_empty());

        let tenses = data["exchange"]
            .as_object()
            .map(|exchange| {
                exchange
                    .iter()
                    .filter_map(|(key, value)| {
                        let values = value.as_array().map(|items| {
                            items
                                .iter()
                                .filter_map(|item| item.as_str().map(ToOwned::to_owned))
                                .collect::<Vec<_>>()
                        })?;
                        if values.is_empty() {
                            return None;
                        }

                        Some(WordTense {
                            r#type: None,
                            name: Some(iciba_tense_name(key).to_owned()),
                            values: Some(values),
                        })
                    })
                    .collect::<Vec<_>>()
            })
            .filter(|items| !items.is_empty());

        if pronunciations.is_none() && definitions.is_none() {
            return Err(DictionaryError::NetworkError(
                "iciba: Resource not found.".to_owned(),
            ));
        }

        Ok(LookUpResponse {
            translations: Vec::<TextTranslation>::new(),
            word,
            tip: None,
            tags: None,
            definitions,
            pronunciations,
            images: None,
            phrases: None,
            tenses,
            sentences: None,
        })
    }
}

impl Provider for IcibaProvider {
    fn name(&self) -> &'static str {
        "iciba"
    }

    fn dictionary(&self) -> Option<&dyn DictionaryService> {
        Some(&self.dictionary_service)
    }
}

fn iciba_tense_name(key: &str) -> &str {
    match key {
        "word_pl" => "复数",
        "word_third" => "第三人称单数",
        "word_past" => "过去式",
        "word_done" => "过去分词",
        "word_ing" => "现在分词",
        "word_er" => "word_er",
        "word_est" => "word_est",
        _ => key,
    }
}
