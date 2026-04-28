use async_trait::async_trait;
use beyondtranslate_core::{
    HttpClient, LanguagePair, Provider, ProviderConfig, TextTranslation, TranslateRequest,
    TranslateResponse, TranslationError, TranslationService,
};
use serde::Deserialize;
use serde_json::{json, Value};

#[derive(Debug, Clone, Deserialize)]
pub struct CaiyunProviderConfig {
    pub token: String,
    pub request_id: String,
    pub base_url: Option<String>,
}

impl ProviderConfig for CaiyunProviderConfig {}

pub struct CaiyunProvider {
    config: CaiyunProviderConfig,
    translation_service: CaiyunTranslationService,
}

struct CaiyunTranslationService {
    token: String,
    request_id: String,
    http: HttpClient,
}

impl CaiyunProvider {
    pub fn new(config: CaiyunProviderConfig) -> Self {
        Self {
            config: config.clone(),
            translation_service: CaiyunTranslationService {
                token: config.token,
                request_id: config.request_id,
                http: HttpClient::new(
                    config
                        .base_url
                        .unwrap_or_else(|| "http://api.interpreter.caiyunai.com".to_owned()),
                    Default::default(),
                ),
            },
        }
    }
}

#[async_trait(?Send)]
impl TranslationService for CaiyunTranslationService {
    async fn get_supported_language_pairs(&self) -> Result<Vec<LanguagePair>, TranslationError> {
        Ok(vec![
            LanguagePair {
                source_language: Some("en".to_owned()),
                source_language_id: None,
                target_language: Some("zh".to_owned()),
                target_language_id: None,
            },
            LanguagePair {
                source_language: Some("ja".to_owned()),
                source_language_id: None,
                target_language: Some("zh".to_owned()),
                target_language_id: None,
            },
            LanguagePair {
                source_language: Some("zh".to_owned()),
                source_language_id: None,
                target_language: Some("en".to_owned()),
                target_language_id: None,
            },
            LanguagePair {
                source_language: Some("zh".to_owned()),
                source_language_id: None,
                target_language: Some("ja".to_owned()),
                target_language_id: None,
            },
        ])
    }

    async fn translate(
        &self,
        request: TranslateRequest,
    ) -> Result<TranslateResponse, TranslationError> {
        let trans_type = match (
            request.source_language.as_deref(),
            request.target_language.as_deref(),
        ) {
            (Some(source), Some(target)) => format!("{source}2{target}"),
            _ => "auto".to_owned(),
        };

        let response = self
            .http
            .post("/v1/translator")
            .header("Content-Type", "application/json")
            .header("X-Authorization", format!("token {}", self.token))
            .json(&json!({
                "source": [request.text],
                "trans_type": trans_type,
                "request_id": self.request_id,
            }));

        let response = self
            .http
            .execute(response)
            .await
            .map_err(TranslationError::from_network_error)?;
        let response = TranslationError::from_response("caiyun", response).await?;
        let data: Value = response
            .json()
            .await
            .map_err(|error| TranslationError::SerializationError(error.to_string()))?;

        if let Some(message) = data["message"].as_str() {
            return Err(TranslationError::NetworkError(format!("caiyun: {message}")));
        }

        let translations = data["target"]
            .as_array()
            .ok_or_else(|| {
                TranslationError::SerializationError("missing target in Caiyun response".to_owned())
            })?
            .iter()
            .filter_map(|item| item.as_str())
            .map(|text| TextTranslation {
                detected_source_language: None,
                text: text.to_owned(),
                audio_url: None,
            })
            .collect();

        Ok(TranslateResponse { translations })
    }
}

impl Provider for CaiyunProvider {
    fn name(&self) -> &'static str {
        "caiyun"
    }

    fn config(&self) -> &dyn ProviderConfig {
        &self.config
    }

    fn translation(&self) -> Option<&dyn TranslationService> {
        Some(&self.translation_service)
    }
}
