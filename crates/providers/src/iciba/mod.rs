use async_trait::async_trait;
use beyondtranslate_core::{
    DictionaryError, DictionaryProvider, DictionaryResult, HttpClient, LookUpRequest,
    LookUpResponse, TextTranslation, TranslateRequest, TranslateResponse, TranslationError,
    TranslationProvider, TranslationResult, WordDefinition, WordPronunciation, WordTense,
};
use reqwest::Client;
use serde_json::Value;

pub struct IcibaProvider {
    api_key: String,
    http: HttpClient,
}

pub struct IcibaProviderBuilder {
    api_key: Option<String>,
    base_url: Option<String>,
    client: Option<Client>,
}

impl IcibaProvider {
    pub fn builder() -> IcibaProviderBuilder {
        IcibaProviderBuilder {
            api_key: None,
            base_url: None,
            client: None,
        }
    }
}

impl IcibaProviderBuilder {
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

    pub fn build(self) -> DictionaryResult<IcibaProvider> {
        Ok(IcibaProvider {
            api_key: self.api_key.ok_or_else(|| {
                DictionaryError::ConfigError("Iciba api_key is required".to_owned())
            })?,
            http: HttpClient::new(
                self.base_url
                    .unwrap_or_else(|| "http://dict-co.iciba.com".to_owned()),
                self.client.unwrap_or_default(),
            ),
        })
    }
}

#[async_trait]
impl DictionaryProvider for IcibaProvider {
    async fn look_up(&self, request: LookUpRequest) -> DictionaryResult<LookUpResponse> {
        if !(request.source_language == "en" && request.target_language == "zh") {
            return Err(DictionaryError::InvalidRequest(
                "Iciba only supports en -> zh lookup".to_owned(),
            ));
        }

        let response = self.http.get("/api/dictionary.php").query(&[
            ("w", request.word.to_lowercase()),
            ("key", self.api_key.clone()),
            ("type", "json".to_owned()),
        ]);
        let response = self
            .http
            .execute(response)
            .await
            .map_err(DictionaryError::from_network_error)?;
        let content_type = response
            .headers()
            .get("content-type")
            .and_then(|value| value.to_str().ok())
            .unwrap_or("")
            .to_owned();
        let response = DictionaryError::from_response("iciba", response).await?;

        if content_type.contains("text/xml") {
            return Err(DictionaryError::AuthError(
                "Please check your key".to_owned(),
            ));
        }

        let data: Value = response
            .json()
            .await
            .map_err(|error| DictionaryError::SerializationError(error.to_string()))?;

        let word = data["word_name"].as_str().map(ToOwned::to_owned);
        let symbol = data["symbols"].as_array().and_then(|items| items.first());

        let definitions = symbol
            .and_then(|value| value["parts"].as_array())
            .map(|parts| {
                parts
                    .iter()
                    .map(|part| WordDefinition {
                        r#type: None,
                        name: part["part"].as_str().map(ToOwned::to_owned),
                        values: part["means"].as_array().map(|means| {
                            means
                                .iter()
                                .filter_map(|value| value.as_str().map(ToOwned::to_owned))
                                .collect()
                        }),
                    })
                    .collect::<Vec<_>>()
            })
            .filter(|items| !items.is_empty());

        let pronunciations = symbol
            .map(|value| {
                vec![
                    WordPronunciation {
                        r#type: Some("uk".to_owned()),
                        phonetic_symbol: value["ph_en"].as_str().map(ToOwned::to_owned),
                        audio_url: value["ph_en_mp3"].as_str().map(ToOwned::to_owned),
                    },
                    WordPronunciation {
                        r#type: Some("us".to_owned()),
                        phonetic_symbol: value["ph_am"].as_str().map(ToOwned::to_owned),
                        audio_url: value["ph_am_mp3"].as_str().map(ToOwned::to_owned),
                    },
                ]
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

        let tenses = data["exchange"]
            .as_object()
            .map(|exchange| {
                exchange
                    .iter()
                    .filter_map(|(key, value)| {
                        let values = value.as_array().map(|items| {
                            items
                                .iter()
                                .filter_map(|item| item.as_str().map(ToOwned::to_owned))
                                .collect::<Vec<_>>()
                        })?;
                        if values.is_empty() {
                            return None;
                        }

                        Some(WordTense {
                            r#type: None,
                            name: Some(iciba_tense_name(key).to_owned()),
                            values: Some(values),
                        })
                    })
                    .collect::<Vec<_>>()
            })
            .filter(|items| !items.is_empty());

        if pronunciations.is_none() && definitions.is_none() {
            return Err(DictionaryError::ProviderError {
                provider: "iciba",
                message: "Resource not found.".to_owned(),
            });
        }

        Ok(LookUpResponse {
            translations: Vec::<TextTranslation>::new(),
            word,
            tip: None,
            tags: None,
            definitions,
            pronunciations,
            images: None,
            phrases: None,
            tenses,
            sentences: None,
        })
    }
}

#[async_trait]
impl TranslationProvider for IcibaProvider {
    async fn translate(&self, _request: TranslateRequest) -> TranslationResult<TranslateResponse> {
        Err(TranslationError::UnsupportedMethod("translate"))
    }
}

fn iciba_tense_name(key: &str) -> &str {
    match key {
        "word_pl" => "复数",
        "word_third" => "第三人称单数",
        "word_past" => "过去式",
        "word_done" => "过去分词",
        "word_ing" => "现在分词",
        "word_er" => "word_er",
        "word_est" => "word_est",
        _ => key,
    }
}
