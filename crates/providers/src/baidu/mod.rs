use async_trait::async_trait;
use beyondtranslate_core::{
    DetectLanguageRequest, DetectLanguageResponse, HttpClient, TextDetection, TextTranslation,
    TranslateRequest, TranslateResponse, TranslationError, TranslationProvider, TranslationResult,
};
use rand::random;
use reqwest::Client;
use serde_json::Value;

pub struct BaiduProvider {
    app_id: String,
    app_key: String,
    http: HttpClient,
}

pub struct BaiduProviderBuilder {
    app_id: Option<String>,
    app_key: Option<String>,
    base_url: Option<String>,
    client: Option<Client>,
}

impl BaiduProvider {
    pub fn builder() -> BaiduProviderBuilder {
        BaiduProviderBuilder {
            app_id: None,
            app_key: None,
            base_url: None,
            client: None,
        }
    }
}

impl BaiduProviderBuilder {
    pub fn app_id(mut self, app_id: impl Into<String>) -> Self {
        self.app_id = Some(app_id.into());
        self
    }

    pub fn app_key(mut self, app_key: impl Into<String>) -> Self {
        self.app_key = Some(app_key.into());
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

    pub fn build(self) -> TranslationResult<BaiduProvider> {
        Ok(BaiduProvider {
            app_id: self.app_id.ok_or_else(|| {
                TranslationError::ConfigError("Baidu app_id is required".to_owned())
            })?,
            app_key: self.app_key.ok_or_else(|| {
                TranslationError::ConfigError("Baidu app_key is required".to_owned())
            })?,
            http: HttpClient::new(
                self.base_url
                    .unwrap_or_else(|| "https://fanyi-api.baidu.com".to_owned()),
                self.client.unwrap_or_default(),
            ),
        })
    }
}

#[async_trait(?Send)]
impl TranslationProvider for BaiduProvider {
    async fn detect_language(
        &self,
        request: DetectLanguageRequest,
    ) -> TranslationResult<DetectLanguageResponse> {
        let text = request
            .texts
            .into_iter()
            .next()
            .ok_or_else(|| TranslationError::InvalidRequest("texts is required".to_owned()))?;
        let salt = (random::<u32>() % 999_999).to_string();
        let sign = format!(
            "{:x}",
            md5::compute(format!("{}{}{}{}", self.app_id, text, salt, self.app_key))
        );

        let response = self.http.post("/api/trans/vip/language").query(&[
            ("q", text.as_str()),
            ("appid", self.app_id.as_str()),
            ("salt", salt.as_str()),
            ("sign", sign.as_str()),
        ]);
        let response = self
            .http
            .execute(response)
            .await
            .map_err(TranslationError::from_network_error)?;
        let response = TranslationError::from_response("baidu", response).await?;
        let data: Value = response
            .json()
            .await
            .map_err(|error| TranslationError::SerializationError(error.to_string()))?;

        ensure_baidu_success(&data)?;
        let detected = data["data"]["src"].as_str().ok_or_else(|| {
            TranslationError::SerializationError("missing data.src in Baidu response".to_owned())
        })?;

        Ok(DetectLanguageResponse {
            detections: Some(vec![TextDetection {
                detected_language: detected.to_owned(),
                text,
            }]),
        })
    }

    async fn translate(&self, request: TranslateRequest) -> TranslationResult<TranslateResponse> {
        let salt = (random::<u32>() % 999_999).to_string();
        let sign = format!(
            "{:x}",
            md5::compute(format!(
                "{}{}{}{}",
                self.app_id, request.text, salt, self.app_key
            ))
        );
        let from = baidu_language_code(request.source_language.as_deref()).unwrap_or("auto");
        let to = baidu_language_code(request.target_language.as_deref()).ok_or_else(|| {
            TranslationError::InvalidRequest("target_language is required".to_owned())
        })?;

        let response = self.http.post("/api/trans/vip/translate").query(&[
            ("q", request.text.as_str()),
            ("from", from),
            ("to", to),
            ("appid", self.app_id.as_str()),
            ("salt", salt.as_str()),
            ("sign", sign.as_str()),
            ("dict", "0"),
        ]);
        let response = self
            .http
            .execute(response)
            .await
            .map_err(TranslationError::from_network_error)?;
        let response = TranslationError::from_response("baidu", response).await?;
        let data: Value = response
            .json()
            .await
            .map_err(|error| TranslationError::SerializationError(error.to_string()))?;

        ensure_baidu_success(&data)?;
        let translations = data["trans_result"]
            .as_array()
            .ok_or_else(|| {
                TranslationError::SerializationError(
                    "missing trans_result in Baidu response".to_owned(),
                )
            })?
            .iter()
            .filter_map(|item| item["dst"].as_str())
            .map(|text| TextTranslation {
                detected_source_language: None,
                text: text.to_owned(),
                audio_url: None,
            })
            .collect();

        Ok(TranslateResponse { translations })
    }
}

fn baidu_language_code(language: Option<&str>) -> Option<&str> {
    match language {
        Some("es") => Some("spa"),
        Some("fr") => Some("fra"),
        Some("ja") => Some("jp"),
        Some("ko") => Some("kor"),
        Some(other) => Some(other),
        None => None,
    }
}

fn ensure_baidu_success(data: &Value) -> TranslationResult<()> {
    if let Some(code) = data["error_code"].as_i64() {
        if code != 0 {
            let message = data["error_msg"].as_str().unwrap_or("unknown error");
            return Err(TranslationError::ProviderError {
                provider: "baidu",
                message: format!("{code}: {message}"),
            });
        }
    }

    if let Some(code) = data["error_code"].as_str() {
        if code != "0" {
            let message = data["error_msg"].as_str().unwrap_or("unknown error");
            return Err(TranslationError::ProviderError {
                provider: "baidu",
                message: format!("{code}: {message}"),
            });
        }
    }

    Ok(())
}
