mod common;
mod model;
mod service;

pub use common::http_client::HttpClient;
pub use model::{
    DetectLanguageRequest, DetectLanguageResponse, LanguagePair, LookUpRequest, LookUpResponse,
    TextDetection, TextTranslation, TranslateRequest, TranslateResponse, WordDefinition, WordImage,
    WordPhrase, WordPronunciation, WordSentence, WordTag, WordTense,
};
pub use service::translation::{
    ProviderErrorKind, TranslationError, TranslationProvider, TranslationResult,
    TranslationService, TranslationServiceError, TranslationServiceResult,
};
