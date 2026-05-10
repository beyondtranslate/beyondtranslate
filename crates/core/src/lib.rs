mod model;
mod provider;
mod service;

#[cfg(feature = "uniffi")]
uniffi::setup_scaffolding!();

pub use model::{
    DetectLanguageRequest, DetectLanguageResponse, LanguagePair, LookUpRequest, LookUpResponse,
    TextDetection, TextTranslation, TranslateRequest, TranslateResponse, WordDefinition, WordImage,
    WordPhrase, WordPronunciation, WordSentence, WordTag, WordTense,
};
pub use provider::{Provider, ProviderCapability};
pub use service::{DictionaryError, DictionaryService, TranslationError, TranslationService};
