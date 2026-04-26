use async_trait::async_trait;
use beyondtranslate_core::{
    HttpClient, LanguagePair, TextTranslation, TranslateRequest, TranslateResponse,
    TranslationError, TranslationProvider, TranslationResult,
};
use reqwest::Client;
use serde_json::{json, Value};

pub struct CaiyunProvider {
    token: String,
    request_id: String,
    http: HttpClient,
}

pub struct CaiyunProviderBuilder {
    token: Option<String>,
    request_id: Option<String>,
    base_url: Option<String>,
    client: Option<Client>,
}

impl CaiyunProvider {
    pub fn builder() -> CaiyunProviderBuilder {
        CaiyunProviderBuilder {
            token: None,
            request_id: None,
            base_url: None,
            client: None,
        }
    }
}

impl CaiyunProviderBuilder {
    pub fn token(mut self, token: impl Into<String>) -> Self {
        self.token = Some(token.into());
        self
    }

    pub fn request_id(mut self, request_id: impl Into<String>) -> Self {
        self.request_id = Some(request_id.into());
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

    pub fn build(self) -> TranslationResult<CaiyunProvider> {
        Ok(CaiyunProvider {
            token: self.token.ok_or_else(|| {
                TranslationError::ConfigError("Caiyun token is required".to_owned())
            })?,
            request_id: self.request_id.ok_or_else(|| {
                TranslationError::ConfigError("Caiyun request_id is required".to_owned())
            })?,
            http: HttpClient::new(
                self.base_url
                    .unwrap_or_else(|| "http://api.interpreter.caiyunai.com".to_owned()),
                self.client.unwrap_or_default(),
            ),
        })
    }
}

#[async_trait(?Send)]
impl TranslationProvider for CaiyunProvider {
    async fn get_supported_language_pairs(&self) -> TranslationResult<Vec<LanguagePair>> {
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

    async fn translate(&self, request: TranslateRequest) -> TranslationResult<TranslateResponse> {
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
            return Err(TranslationError::ProviderError {
                provider: "caiyun",
                message: message.to_owned(),
            });
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
