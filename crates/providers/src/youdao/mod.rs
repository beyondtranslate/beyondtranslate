use async_trait::async_trait;
use beyondtranslate_core::{
    DictionaryError, DictionaryProvider, DictionaryResult, HttpClient, LookUpRequest,
    LookUpResponse, TextTranslation, TranslateRequest, TranslateResponse, TranslationError,
    TranslationProvider, TranslationResult, WordDefinition, WordImage, WordPronunciation, WordTag,
    WordTense,
};
use reqwest::Client;
use serde_json::Value;
use sha2::{Digest, Sha256};
use std::time::{SystemTime, UNIX_EPOCH};

pub struct YoudaoProvider {
    app_key: String,
    app_secret: String,
    http: HttpClient,
    picture_http: HttpClient,
}

pub struct YoudaoProviderBuilder {
    app_key: Option<String>,
    app_secret: Option<String>,
    base_url: Option<String>,
    picture_base_url: Option<String>,
    client: Option<Client>,
}

impl YoudaoProvider {
    pub fn builder() -> YoudaoProviderBuilder {
        YoudaoProviderBuilder {
            app_key: None,
            app_secret: None,
            base_url: None,
            picture_base_url: None,
            client: None,
        }
    }
}

impl YoudaoProviderBuilder {
    pub fn app_key(mut self, app_key: impl Into<String>) -> Self {
        self.app_key = Some(app_key.into());
        self
    }

    pub fn app_secret(mut self, app_secret: impl Into<String>) -> Self {
        self.app_secret = Some(app_secret.into());
        self
    }

    pub fn base_url(mut self, base_url: impl Into<String>) -> Self {
        self.base_url = Some(base_url.into());
        self
    }

    pub fn picture_base_url(mut self, picture_base_url: impl Into<String>) -> Self {
        self.picture_base_url = Some(picture_base_url.into());
        self
    }

    pub fn client(mut self, client: Client) -> Self {
        self.client = Some(client);
        self
    }

    pub fn build(self) -> DictionaryResult<YoudaoProvider> {
        let client = self.client.unwrap_or_default();

        Ok(YoudaoProvider {
            app_key: self.app_key.ok_or_else(|| {
                DictionaryError::ConfigError("Youdao app_key is required".to_owned())
            })?,
            app_secret: self.app_secret.ok_or_else(|| {
                DictionaryError::ConfigError("Youdao app_secret is required".to_owned())
            })?,
            http: HttpClient::new(
                self.base_url
                    .unwrap_or_else(|| "https://openapi.youdao.com".to_owned()),
                client.clone(),
            ),
            picture_http: HttpClient::new(
                self.picture_base_url
                    .unwrap_or_else(|| "https://picdict.youdao.com".to_owned()),
                client,
            ),
        })
    }
}

#[async_trait(?Send)]
impl DictionaryProvider for YoudaoProvider {
    async fn look_up(&self, request: LookUpRequest) -> DictionaryResult<LookUpResponse> {
        let input = truncate_input(&request.word);
        let curtime = current_timestamp().to_string();
        let salt = format!("{:x}", md5::compute("translation_engine_youdao"));
        let sign = format!(
            "{:x}",
            Sha256::digest(
                format!(
                    "{}{}{}{}{}",
                    self.app_key, input, salt, curtime, self.app_secret
                )
                .as_bytes()
            )
        );

        let response = self.http.get("/api").query(&[
            ("q", request.word.as_str()),
            ("from", request.source_language.as_str()),
            ("to", request.target_language.as_str()),
            ("appKey", self.app_key.as_str()),
            ("salt", salt.as_str()),
            ("sign", sign.as_str()),
            ("signType", "v3"),
            ("curtime", curtime.as_str()),
        ]);
        let response = self
            .http
            .execute(response)
            .await
            .map_err(DictionaryError::from_network_error)?;
        let response = DictionaryError::from_response("youdao", response).await?;
        let data: Value = response
            .json()
            .await
            .map_err(|error| DictionaryError::SerializationError(error.to_string()))?;

        let error_code = data["errorCode"].as_str().unwrap_or("0");
        if error_code != "0" {
            return Err(DictionaryError::ProviderError {
                provider: "youdao",
                message: youdao_error_message(error_code).to_owned(),
            });
        }

        let mut translations = data["translation"]
            .as_array()
            .map(|items| {
                items
                    .iter()
                    .filter_map(|item| item.as_str())
                    .map(|text| TextTranslation {
                        detected_source_language: None,
                        text: text.to_owned(),
                        audio_url: None,
                    })
                    .collect::<Vec<_>>()
            })
            .unwrap_or_default();
        if translations.len() == 1 {
            translations[0].audio_url = data["tSpeakUrl"].as_str().map(ToOwned::to_owned);
        }

        let word = data["returnPhrase"]
            .as_array()
            .and_then(|items| items.first())
            .and_then(|item| item.as_str())
            .map(ToOwned::to_owned);
        let basic = &data["basic"];

        let tags = basic["exam_type"]
            .as_array()
            .map(|items| {
                items
                    .iter()
                    .filter_map(|item| item.as_str())
                    .map(|name| WordTag {
                        name: name.to_owned(),
                    })
                    .collect::<Vec<_>>()
            })
            .filter(|items| !items.is_empty());

        let definitions = basic["explains"]
            .as_array()
            .map(|items| {
                items
                    .iter()
                    .filter_map(|item| item.as_str())
                    .map(|text| {
                        let (name, value) = text
                            .find(". ")
                            .map(|index| {
                                (
                                    Some(text[..=index].to_owned()),
                                    text[index + 2..].to_owned(),
                                )
                            })
                            .unwrap_or((None, text.to_owned()));

                        WordDefinition {
                            r#type: None,
                            name,
                            values: Some(value.split('；').map(ToOwned::to_owned).collect()),
                        }
                    })
                    .collect::<Vec<_>>()
            })
            .filter(|items| !items.is_empty());

        let pronunciations = Some(vec![
            WordPronunciation {
                r#type: Some("uk".to_owned()),
                phonetic_symbol: basic["uk-phonetic"].as_str().map(ToOwned::to_owned),
                audio_url: basic["uk-speech"].as_str().map(ToOwned::to_owned),
            },
            WordPronunciation {
                r#type: Some("us".to_owned()),
                phonetic_symbol: basic["us-phonetic"].as_str().map(ToOwned::to_owned),
                audio_url: basic["us-speech"].as_str().map(ToOwned::to_owned),
            },
        ])
        .map(|items| {
            items
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

        let tenses = basic["wfs"]
            .as_array()
            .map(|items| {
                items
                    .iter()
                    .filter_map(|item| item["wf"].as_object())
                    .map(|wf| {
                        let name = wf
                            .get("name")
                            .and_then(|value| value.as_str())
                            .unwrap_or_default();
                        let value = wf
                            .get("value")
                            .and_then(|value| value.as_str())
                            .unwrap_or_default();
                        let values = if value.contains('或') {
                            value.split('或').map(ToOwned::to_owned).collect()
                        } else {
                            vec![value.to_owned()]
                        };

                        WordTense {
                            r#type: None,
                            name: Some(name.to_owned()),
                            values: Some(values),
                        }
                    })
                    .collect::<Vec<_>>()
            })
            .filter(|items| !items.is_empty());

        let images = if definitions.is_some() || pronunciations.is_some() {
            self.fetch_images(&request.word, &request.source_language)
                .await
        } else {
            None
        };

        Ok(LookUpResponse {
            translations,
            word,
            tip: None,
            tags,
            definitions,
            pronunciations,
            images,
            phrases: None,
            tenses,
            sentences: None,
        })
    }
}

#[async_trait(?Send)]
impl TranslationProvider for YoudaoProvider {
    async fn translate(&self, _request: TranslateRequest) -> TranslationResult<TranslateResponse> {
        Err(TranslationError::UnsupportedMethod("translate"))
    }
}

impl YoudaoProvider {
    async fn fetch_images(&self, word: &str, language: &str) -> Option<Vec<WordImage>> {
        let response = self
            .picture_http
            .get("/search")
            .query(&[("q", word), ("le", language)]);
        let response = self.picture_http.execute(response).await.ok()?;
        let data: Value = response.json().await.ok()?;
        let images = data["data"]["pic"]
            .as_array()?
            .iter()
            .filter_map(|item| item["url"].as_str())
            .map(|url| WordImage {
                url: url.to_owned(),
            })
            .collect::<Vec<_>>();
        if images.is_empty() {
            None
        } else {
            Some(images)
        }
    }
}

fn truncate_input(value: &str) -> String {
    let chars: Vec<char> = value.chars().collect();
    if chars.len() <= 20 {
        return value.to_owned();
    }

    let prefix: String = chars.iter().take(10).collect();
    let suffix: String = chars.iter().rev().take(10).rev().collect();
    format!("{prefix}{}{suffix}", chars.len())
}

fn current_timestamp() -> u64 {
    SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap_or_default()
        .as_secs()
}

fn youdao_error_message(code: &str) -> &str {
    match code {
        "101" => "缺少必填的参数,首先确保必填参数齐全，然后确认参数书写是否正确。",
        "102" => "不支持的语言类型",
        "103" => "翻译文本过长",
        "108" => "应用ID无效",
        "111" => "开发者账号无效",
        "201" => "解密失败",
        "202" => "签名检验失败",
        "203" => "访问IP地址不在可访问IP列表",
        "301" => "辞典查询失败",
        "302" => "翻译查询失败",
        "303" => "服务端的其它异常",
        "401" => "账户已经欠费，请进行账户充值",
        "411" => "访问频率受限,请稍后访问",
        _ => "Youdao provider error",
    }
}
