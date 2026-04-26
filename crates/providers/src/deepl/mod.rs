use async_trait::async_trait;
use beyondtranslate_core::{
    HttpClient, TextTranslation, TranslateRequest, TranslateResponse, TranslationError,
    TranslationProvider, TranslationResult,
};
use reqwest::Client;
use serde::Deserialize;

pub struct DeepLProvider {
    api_key: String,
    http: HttpClient,
}

pub struct DeepLProviderBuilder {
    api_key: Option<String>,
    base_url: Option<String>,
    client: Option<Client>,
}

impl DeepLProvider {
    pub fn builder() -> DeepLProviderBuilder {
        DeepLProviderBuilder {
            api_key: None,
            base_url: None,
            client: None,
        }
    }
}

impl DeepLProviderBuilder {
    pub fn api_key(mut self, api_key: impl Into<String>) -> Self {
        self.api_key = Some(api_key.into());
        self
    }

    pub fn base_url(mut self, base_url: impl Into<String>) -> Self {
        self.base_url = Some(base_url.into());
        self
    }

    pub fn client(mut self, client: Client) -> Self {
        self.client = Some(client);
        self
    }

    pub fn build(self) -> TranslationResult<DeepLProvider> {
        Ok(DeepLProvider {
            api_key: self.api_key.ok_or_else(|| {
                TranslationError::ConfigError("DeepL api_key is required".to_owned())
            })?,
            http: HttpClient::new(
                self.base_url
                    .unwrap_or_else(|| "https://api.deepl.com".to_owned()),
                self.client.unwrap_or_default(),
            ),
        })
    }
}

#[async_trait]
impl TranslationProvider for DeepLProvider {
    async fn translate(&self, request: TranslateRequest) -> TranslationResult<TranslateResponse> {
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

#[derive(Debug, Deserialize)]
struct DeepLTranslateResponse {
    translations: Vec<DeepLTranslation>,
}

#[derive(Debug, Deserialize)]
struct DeepLTranslation {
    detected_source_language: Option<String>,
    text: String,
}
