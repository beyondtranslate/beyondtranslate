#![cfg_attr(not(feature = "google"), allow(dead_code))]

use async_trait::async_trait;
use beyondtranslate_core::{
    DetectLanguageRequest, DetectLanguageResponse, Provider, TextDetection, TextTranslation,
    TranslateRequest, TranslateResponse, TranslationError, TranslationService,
};

use crate::common::http_client::HttpClient;
use serde::{Deserialize, Serialize};
use serde_json::{json, Value};

#[derive(Debug, Clone, Deserialize, PartialEq, Serialize)]
pub struct GoogleProviderConfig {
    #[serde(rename = "appKey", alias = "apiKey", alias = "api_key")]
    pub api_key: String,
    #[serde(rename = "baseUrl", alias = "base_url")]
    pub base_url: Option<String>,
}

pub struct GoogleProvider {
    #[allow(dead_code)]
    config: GoogleProviderConfig,
    translation_service: GoogleTranslationService,
}

struct GoogleTranslationService {
    api_key: String,
    http: HttpClient,
}

impl GoogleProvider {
    pub fn new(config: GoogleProviderConfig) -> Result<Self, String> {
        if config.api_key.trim().is_empty() {
            return Err("api_key must not be empty".to_owned());
        }
        Ok(Self {
            config: config.clone(),
            translation_service: GoogleTranslationService {
                api_key: config.api_key,
                http: HttpClient::new(
                    config
                        .base_url
                        .unwrap_or_else(|| "https://translation.googleapis.com".to_owned()),
                    Default::default(),
                ),
            },
        })
    }
}

#[async_trait(?Send)]
impl TranslationService for GoogleTranslationService {
    async fn detect_language(
        &self,
        request: DetectLanguageRequest,
    ) -> Result<DetectLanguageResponse, TranslationError> {
        let text = request
            .texts
            .into_iter()
            .next()
            .ok_or_else(|| TranslationError::InvalidRequest("texts is required".to_owned()))?;

        let response = self
            .http
            .post("/language/translate/v2/detect")
            .query(&[("key", self.api_key.as_str())])
            .json(&json!({ "q": text }));
        let response = self
            .http
            .execute(response)
            .await
            .map_err(TranslationError::from_network_error)?;
        let response = TranslationError::from_response("google", response).await?;
        let data: Value = response
            .json()
            .await
            .map_err(|error| TranslationError::SerializationError(error.to_string()))?;

        let detections = data["data"]["detections"][0]
            .as_array()
            .ok_or_else(|| {
                TranslationError::SerializationError(
                    "missing detections in Google response".to_owned(),
                )
            })?
            .iter()
            .filter_map(|item| item["language"].as_str())
            .map(|language| TextDetection {
                detected_language: language.to_owned(),
                text: text.clone(),
            })
            .collect();

        Ok(DetectLanguageResponse {
            detections: Some(detections),
        })
    }

    async fn translate(
        &self,
        request: TranslateRequest,
    ) -> Result<TranslateResponse, TranslationError> {
        let target_language = request.target_language.ok_or_else(|| {
            TranslationError::InvalidRequest("target_language is required".to_owned())
        })?;
        let response = self
            .http
            .post("/language/translate/v2")
            .query(&[("key", self.api_key.as_str())])
            .json(&json!({
                "q": request.text,
                "source": request.source_language,
                "target": target_language,
                "format": "text",
            }));
        let response = self
            .http
            .execute(response)
            .await
            .map_err(TranslationError::from_network_error)?;
        let response = TranslationError::from_response("google", response).await?;
        let data: Value = response
            .json()
            .await
            .map_err(|error| TranslationError::SerializationError(error.to_string()))?;

        let translations = data["data"]["translations"]
            .as_array()
            .ok_or_else(|| {
                TranslationError::SerializationError(
                    "missing translations in Google response".to_owned(),
                )
            })?
            .iter()
            .filter_map(|item| item["translatedText"].as_str())
            .map(|text| TextTranslation {
                detected_source_language: None,
                text: text.to_owned(),
                audio_url: None,
            })
            .collect();

        Ok(TranslateResponse { translations })
    }
}

impl Provider for GoogleProvider {
    fn name(&self) -> &'static str {
        "google"
    }

    fn translation(&self) -> Option<&dyn TranslationService> {
        Some(&self.translation_service)
    }
}
