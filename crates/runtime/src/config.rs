#[derive(Debug, Clone)]
pub enum TranslationProviderConfig {
    Baidu {
        app_id: String,
        app_key: String,
        base_url: Option<String>,
    },
    Caiyun {
        token: String,
        request_id: String,
        base_url: Option<String>,
    },
    DeepL {
        api_key: String,
        base_url: Option<String>,
    },
    Google {
        api_key: String,
        base_url: Option<String>,
    },
    Iciba {
        api_key: String,
        base_url: Option<String>,
    },
    Tencent {
        secret_id: String,
        secret_key: String,
        base_url: Option<String>,
    },
    Youdao {
        app_key: String,
        app_secret: String,
        base_url: Option<String>,
        picture_base_url: Option<String>,
    },
    Chain {
        primary: Box<TranslationProviderConfig>,
        fallbacks: Vec<TranslationProviderConfig>,
    },
}

#[derive(Debug, Clone)]
pub enum DictionaryProviderConfig {
    Iciba {
        api_key: String,
        base_url: Option<String>,
    },
    Youdao {
        app_key: String,
        app_secret: String,
        base_url: Option<String>,
        picture_base_url: Option<String>,
    },
    Chain {
        primary: Box<DictionaryProviderConfig>,
        fallbacks: Vec<DictionaryProviderConfig>,
    },
}
