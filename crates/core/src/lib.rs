mod common;
mod model;
mod provider;
mod service;

pub use common::http_client::HttpClient;
pub use model::{
    DetectLanguageRequest, DetectLanguageResponse, LanguagePair, LookUpRequest, LookUpResponse,
    TextDetection, TextTranslation, TranslateRequest, TranslateResponse, WordDefinition, WordImage,
    WordPhrase, WordPronunciation, WordSentence, WordTag, WordTense,
};
pub use provider::{Provider, ProviderConfig};
pub use service::{DictionaryError, DictionaryService, TranslationError, TranslationService};
