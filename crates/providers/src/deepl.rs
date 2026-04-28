use async_trait::async_trait;
use beyondtranslate_core::{
    HttpClient, Provider, ProviderConfig, TextTranslation, TranslateRequest, TranslateResponse,
    TranslationError, TranslationService,
};
use serde::Deserialize;

#[derive(Debug, Clone, Deserialize)]
pub struct DeepLProviderConfig {
    pub api_key: String,
    pub base_url: Option<String>,
}

impl ProviderConfig for DeepLProviderConfig {}

pub struct DeepLProvider {
    config: DeepLProviderConfig,
    translation_service: DeepLTranslationService,
}

struct DeepLTranslationService {
    api_key: String,
    http: HttpClient,
}

impl DeepLProvider {
    pub fn new(config: DeepLProviderConfig) -> Self {
        Self {
            config: config.clone(),
            translation_service: DeepLTranslationService {
                api_key: config.api_key,
                http: HttpClient::new(
                    config
                        .base_url
                        .unwrap_or_else(|| "https://api.deepl.com".to_owned()),
                    Default::default(),
                ),
            },
        }
    }
}

#[async_trait(?Send)]
impl TranslationService for DeepLTranslationService {
    async fn translate(
        &self,
        request: TranslateRequest,
    ) -> Result<TranslateResponse, TranslationError> {
        let mut form_fields = vec![
            ("text".to_owned(), request.text),
            (
                "target_lang".to_owned(),
                request.target_language.ok_or_else(|| {
                    TranslationError::InvalidRequest("target_language is required".to_owned())
                })?,
            ),
        ];

        if let Some(source_language) = request.source_language {
            form_fields.push(("source_lang".to_owned(), source_language.to_uppercase()));
        }

        let response = self
            .http
            .post("/v2/translate")
            .header("Authorization", format!("DeepL-Auth-Key {}", self.api_key))
            .form(&form_fields);

        let response = self
            .http
            .execute(response)
            .await
            .map_err(TranslationError::from_network_error)?;
        let response = TranslationError::from_response("deepl", response).await?;
        let payload: DeepLTranslateResponse = response
            .json()
            .await
            .map_err(|error| TranslationError::SerializationError(error.to_string()))?;

        let translations = payload
            .translations
            .into_iter()
            .map(|item| TextTranslation {
                detected_source_language: item.detected_source_language,
                text: item.text,
                audio_url: None,
            })
            .collect();

        Ok(TranslateResponse { translations })
    }
}

impl Provider for DeepLProvider {
    fn name(&self) -> &'static str {
        "deepl"
    }

    fn config(&self) -> &dyn ProviderConfig {
        &self.config
    }

    fn translation(&self) -> Option<&dyn TranslationService> {
        Some(&self.translation_service)
    }
}

#[derive(Debug, Deserialize)]
struct DeepLTranslateResponse {
    translations: Vec<DeepLTranslation>,
}

#[derive(Debug, Deserialize)]
struct DeepLTranslation {
    detected_source_language: Option<String>,
    text: String,
}
