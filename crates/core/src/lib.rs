mod model;
mod provider;
mod service;

pub use model::{
    DetectLanguageRequest, DetectLanguageResponse, LanguagePair, LookUpRequest, LookUpResponse,
    RecognizeTextRequest, RecognizeTextResponse, RecognizedRect, TextDetection, TextRecognition,
    TextTranslation, TranslateRequest, TranslateResponse, WordDefinition, WordImage, WordPhrase,
    WordPronunciation, WordSentence, WordTag, WordTense,
};
pub use provider::{Provider, ProviderCapability};
pub use service::{
    DictionaryError, DictionaryService, OcrError, OcrService, TranslationError, TranslationService,
};
