use async_trait::async_trait;
use beyondtranslate_core::{
    DetectLanguageRequest, DetectLanguageResponse, HttpClient, TextDetection, TextTranslation,
    TranslateRequest, TranslateResponse, TranslationError, TranslationProvider, TranslationResult,
};
use reqwest::Client;
use serde_json::{json, Value};

pub struct GoogleProvider {
    api_key: String,
    http: HttpClient,
}

pub struct GoogleProviderBuilder {
    api_key: Option<String>,
    base_url: Option<String>,
    client: Option<Client>,
}

impl GoogleProvider {
    pub fn builder() -> GoogleProviderBuilder {
        GoogleProviderBuilder {
            api_key: None,
            base_url: None,
            client: None,
        }
    }
}

impl GoogleProviderBuilder {
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

    pub fn build(self) -> TranslationResult<GoogleProvider> {
        Ok(GoogleProvider {
            api_key: self.api_key.ok_or_else(|| {
                TranslationError::ConfigError("Google api_key is required".to_owned())
            })?,
            http: HttpClient::new(
                self.base_url
                    .unwrap_or_else(|| "https://translation.googleapis.com".to_owned()),
                self.client.unwrap_or_default(),
            ),
        })
    }
}

#[async_trait(?Send)]
impl TranslationProvider for GoogleProvider {
    async fn detect_language(
        &self,
        request: DetectLanguageRequest,
    ) -> TranslationResult<DetectLanguageResponse> {
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

    async fn translate(&self, request: TranslateRequest) -> TranslationResult<TranslateResponse> {
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
