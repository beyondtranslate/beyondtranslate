#![cfg_attr(not(feature = "youdao"), allow(dead_code))]

use crate::common::http_client::HttpClient;
use async_trait::async_trait;
use beyondtranslate_core::{
    DictionaryError, DictionaryService, LookUpRequest, LookUpResponse, Provider, TextTranslation,
    WordDefinition, WordImage, WordPronunciation, WordTag, WordTense,
};
use serde::{Deserialize, Serialize};
use serde_json::Value;
use sha2::{Digest, Sha256};
use std::time::{SystemTime, UNIX_EPOCH};

#[derive(Debug, Clone, Deserialize, PartialEq, Serialize)]
pub struct YoudaoProviderConfig {
    #[serde(rename = "appKey", alias = "app_key")]
    pub app_key: String,
    #[serde(rename = "appSecret", alias = "app_secret")]
    pub app_secret: String,
    #[serde(rename = "baseUrl", alias = "base_url")]
    pub base_url: Option<String>,
    #[serde(rename = "pictureBaseUrl", alias = "picture_base_url")]
    pub picture_base_url: Option<String>,
}

pub struct YoudaoProvider {
    config: YoudaoProviderConfig,
    dictionary_service: YoudaoDictionaryService,
}

struct YoudaoDictionaryService {
    app_key: String,
    app_secret: String,
    http: HttpClient,
    picture_http: HttpClient,
}

impl YoudaoProvider {
    pub fn new(config: YoudaoProviderConfig) -> Result<Self, String> {
        if config.app_key.trim().is_empty() {
            return Err("app_key must not be empty".to_owned());
        }
        if config.app_secret.trim().is_empty() {
            return Err("app_secret must not be empty".to_owned());
        }
        let client = reqwest::Client::default();

        Ok(Self {
            config: config.clone(),
            dictionary_service: YoudaoDictionaryService {
                app_key: config.app_key,
                app_secret: config.app_secret,
                http: HttpClient::new(
                    config
                        .base_url
                        .unwrap_or_else(|| "https://openapi.youdao.com".to_owned()),
                    client.clone(),
                ),
                picture_http: HttpClient::new(
                    config
                        .picture_base_url
                        .unwrap_or_else(|| "https://picdict.youdao.com".to_owned()),
                    client,
                ),
            },
        })
    }
}

#[async_trait(?Send)]
impl DictionaryService for YoudaoDictionaryService {
    async fn look_up(&self, request: LookUpRequest) -> Result<LookUpResponse, DictionaryError> {
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
            return Err(DictionaryError::NetworkError(format!(
                "youdao: {}",
                youdao_error_message(error_code)
            )));
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

impl Provider for YoudaoProvider {
    fn name(&self) -> &'static str {
        "youdao"
    }

    fn dictionary(&self) -> Option<&dyn DictionaryService> {
        Some(&self.dictionary_service)
    }
}

impl YoudaoDictionaryService {
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
