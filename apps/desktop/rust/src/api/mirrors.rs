pub use beyondtranslate_core::{
    LookUpRequest, LookUpResponse, ProviderCapability, TextTranslation, TranslateRequest,
    TranslateResponse, WordDefinition, WordImage, WordPhrase, WordPronunciation, WordSentence,
    WordTag, WordTense,
};
pub use beyondtranslate_engine::{
    BaiduProviderConfig, CaiyunProviderConfig, DeepLProviderConfig, GoogleProviderConfig,
    IcibaProviderConfig, ProviderType, TencentProviderConfig, YoudaoProviderConfig,
};
use flutter_rust_bridge::frb;

#[frb(mirror(ProviderCapability))]
#[frb(unignore)]
pub enum _ProviderCapability {
    Dictionary,
    Translation,
}

#[frb(mirror(ProviderType))]
#[frb(unignore)]
pub enum _ProviderType {
    Baidu,
    Caiyun,
    DeepL,
    Google,
    Iciba,
    Tencent,
    Youdao,
}

#[frb(mirror(BaiduProviderConfig))]
#[frb(unignore)]
pub struct _BaiduProviderConfig {
    pub app_id: String,
    pub app_key: String,
    pub base_url: Option<String>,
}

#[frb(mirror(CaiyunProviderConfig))]
#[frb(unignore)]
pub struct _CaiyunProviderConfig {
    pub token: String,
    pub request_id: String,
    pub base_url: Option<String>,
}

#[frb(mirror(DeepLProviderConfig))]
#[frb(unignore)]
pub struct _DeepLProviderConfig {
    pub api_key: String,
    pub base_url: Option<String>,
}

#[frb(mirror(GoogleProviderConfig))]
#[frb(unignore)]
pub struct _GoogleProviderConfig {
    pub api_key: String,
    pub base_url: Option<String>,
}

#[frb(mirror(IcibaProviderConfig))]
#[frb(unignore)]
pub struct _IcibaProviderConfig {
    pub api_key: String,
    pub base_url: Option<String>,
}

#[frb(mirror(TencentProviderConfig))]
#[frb(unignore)]
pub struct _TencentProviderConfig {
    pub secret_id: String,
    pub secret_key: String,
    pub base_url: Option<String>,
}

#[frb(mirror(YoudaoProviderConfig))]
#[frb(unignore)]
pub struct _YoudaoProviderConfig {
    pub app_key: String,
    pub app_secret: String,
    pub base_url: Option<String>,
    pub picture_base_url: Option<String>,
}

#[frb(mirror(TextTranslation))]
pub struct _TextTranslation {
    pub detected_source_language: Option<String>,
    pub text: String,
    pub audio_url: Option<String>,
}

#[frb(mirror(WordDefinition))]
pub struct _WordDefinition {
    pub r#type: Option<String>,
    pub name: Option<String>,
    pub values: Option<Vec<String>>,
}

#[frb(mirror(WordPronunciation))]
pub struct _WordPronunciation {
    pub r#type: Option<String>,
    pub phonetic_symbol: Option<String>,
    pub audio_url: Option<String>,
}

#[frb(mirror(WordTense))]
pub struct _WordTense {
    pub r#type: Option<String>,
    pub name: Option<String>,
    pub values: Option<Vec<String>>,
}

#[frb(mirror(WordTag))]
pub struct _WordTag {
    pub name: String,
}

#[frb(mirror(WordImage))]
pub struct _WordImage {
    pub url: String,
}

#[frb(mirror(WordPhrase))]
pub struct _WordPhrase {
    pub text: String,
    pub translations: Vec<String>,
}

#[frb(mirror(WordSentence))]
pub struct _WordSentence {
    pub text: String,
    pub translations: Vec<String>,
}

#[frb(mirror(TranslateRequest))]
pub struct _TranslateRequest {
    pub source_language: Option<String>,
    pub target_language: Option<String>,
    pub text: String,
}

#[frb(mirror(TranslateResponse))]
pub struct _TranslateResponse {
    pub translations: Vec<TextTranslation>,
}

#[frb(mirror(LookUpRequest))]
pub struct _LookUpRequest {
    pub source_language: String,
    pub target_language: String,
    pub word: String,
}

#[frb(mirror(LookUpResponse))]
pub struct _LookUpResponse {
    pub translations: Vec<TextTranslation>,
    pub word: Option<String>,
    pub tip: Option<String>,
    pub tags: Option<Vec<WordTag>>,
    pub definitions: Option<Vec<WordDefinition>>,
    pub pronunciations: Option<Vec<WordPronunciation>>,
    pub images: Option<Vec<WordImage>>,
    pub phrases: Option<Vec<WordPhrase>>,
    pub tenses: Option<Vec<WordTense>>,
    pub sentences: Option<Vec<WordSentence>>,
}
