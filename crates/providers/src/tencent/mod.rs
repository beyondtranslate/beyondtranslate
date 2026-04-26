use async_trait::async_trait;
use base64::{engine::general_purpose::STANDARD, Engine as _};
use beyondtranslate_core::{
    DetectLanguageRequest, DetectLanguageResponse, HttpClient, TextDetection, TextTranslation,
    TranslateRequest, TranslateResponse, TranslationError, TranslationProvider, TranslationResult,
};
use hmac::{Hmac, Mac};
use rand::random;
use reqwest::{Client, Url};
use serde_json::Value;
use sha1::Sha1;
use std::collections::BTreeMap;
use std::time::{SystemTime, UNIX_EPOCH};

type HmacSha1 = Hmac<Sha1>;

pub struct TencentProvider {
    secret_id: String,
    secret_key: String,
    http: HttpClient,
}

pub struct TencentProviderBuilder {
    secret_id: Option<String>,
    secret_key: Option<String>,
    base_url: Option<String>,
    client: Option<Client>,
}

impl TencentProvider {
    pub fn builder() -> TencentProviderBuilder {
        TencentProviderBuilder {
            secret_id: None,
            secret_key: None,
            base_url: None,
            client: None,
        }
    }
}

impl TencentProviderBuilder {
    pub fn secret_id(mut self, secret_id: impl Into<String>) -> Self {
        self.secret_id = Some(secret_id.into());
        self
    }

    pub fn secret_key(mut self, secret_key: impl Into<String>) -> Self {
        self.secret_key = Some(secret_key.into());
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

    pub fn build(self) -> TranslationResult<TencentProvider> {
        Ok(TencentProvider {
            secret_id: self.secret_id.ok_or_else(|| {
                TranslationError::ConfigError("Tencent secret_id is required".to_owned())
            })?,
            secret_key: self.secret_key.ok_or_else(|| {
                TranslationError::ConfigError("Tencent secret_key is required".to_owned())
            })?,
            http: HttpClient::new(
                self.base_url
                    .unwrap_or_else(|| "https://tmt.tencentcloudapi.com".to_owned()),
                self.client.unwrap_or_default(),
            ),
        })
    }
}

#[async_trait]
impl TranslationProvider for TencentProvider {
    async fn detect_language(
        &self,
        request: DetectLanguageRequest,
    ) -> TranslationResult<DetectLanguageResponse> {
        let text = request
            .texts
            .into_iter()
            .next()
            .ok_or_else(|| TranslationError::InvalidRequest("texts is required".to_owned()))?;

        let mut body = self.base_params("LanguageDetect");
        body.insert("Text".to_owned(), text.clone());
        let response = self.execute_signed(body).await?;
        let lang = response["Response"]["Lang"].as_str().ok_or_else(|| {
            TranslationError::SerializationError("missing Response.Lang".to_owned())
        })?;

        Ok(DetectLanguageResponse {
            detections: Some(vec![TextDetection {
                detected_language: lang.to_owned(),
                text,
            }]),
        })
    }

    async fn translate(&self, request: TranslateRequest) -> TranslationResult<TranslateResponse> {
        let mut body = self.base_params("TextTranslate");
        body.insert(
            "Source".to_owned(),
            request.source_language.unwrap_or_else(|| "auto".to_owned()),
        );
        body.insert("SourceText".to_owned(), request.text);
        body.insert(
            "Target".to_owned(),
            request.target_language.ok_or_else(|| {
                TranslationError::InvalidRequest("target_language is required".to_owned())
            })?,
        );

        let response = self.execute_signed(body).await?;
        let text = response["Response"]["TargetText"].as_str().ok_or_else(|| {
            TranslationError::SerializationError("missing Response.TargetText".to_owned())
        })?;

        Ok(TranslateResponse {
            translations: vec![TextTranslation {
                detected_source_language: None,
                text: text.to_owned(),
                audio_url: None,
            }],
        })
    }
}

impl TencentProvider {
    fn base_params(&self, action: &str) -> BTreeMap<String, String> {
        let mut body = BTreeMap::new();
        body.insert("Action".to_owned(), action.to_owned());
        body.insert("Language".to_owned(), "zh-CN".to_owned());
        body.insert("Nonce".to_owned(), (random::<u32>() % 9999).to_string());
        body.insert("ProjectId".to_owned(), "0".to_owned());
        body.insert("Region".to_owned(), "ap-guangzhou".to_owned());
        body.insert("SecretId".to_owned(), self.secret_id.clone());
        body.insert("Timestamp".to_owned(), current_timestamp().to_string());
        body.insert("Version".to_owned(), "2018-03-21".to_owned());
        body
    }

    async fn execute_signed(&self, mut body: BTreeMap<String, String>) -> TranslationResult<Value> {
        let endpoint = Url::parse(self.http.base_url())
            .ok()
            .and_then(|url| url.host_str().map(ToOwned::to_owned))
            .unwrap_or_else(|| "tmt.tencentcloudapi.com".to_owned());
        let query = body
            .iter()
            .map(|(key, value)| format!("{key}={value}"))
            .collect::<Vec<_>>()
            .join("&");
        let src = format!("POST{endpoint}/?{query}");

        let mut mac = HmacSha1::new_from_slice(self.secret_key.as_bytes())
            .map_err(|error| TranslationError::ConfigError(error.to_string()))?;
        mac.update(src.as_bytes());
        let signature = STANDARD.encode(mac.finalize().into_bytes());
        body.insert("Signature".to_owned(), signature);

        let response = self
            .http
            .client()
            .post(self.http.base_url())
            .header("Content-Type", "application/x-www-form-urlencoded")
            .header("Accept", "application/json")
            .form(&body);
        let response = self
            .http
            .execute(response)
            .await
            .map_err(TranslationError::from_network_error)?;
        let response = TranslationError::from_response("tencent", response).await?;
        let data: Value = response
            .json()
            .await
            .map_err(|error| TranslationError::SerializationError(error.to_string()))?;

        if let Some(error) = data["Response"]["Error"].as_object() {
            let code = error
                .get("Code")
                .and_then(|value| value.as_str())
                .unwrap_or("unknown");
            let message = error
                .get("Message")
                .and_then(|value| value.as_str())
                .unwrap_or("unknown error");
            return Err(TranslationError::ProviderError {
                provider: "tencent",
                message: format!("{code}: {message}"),
            });
        }

        Ok(data)
    }
}

fn current_timestamp() -> u64 {
    SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap_or_default()
        .as_secs()
}
