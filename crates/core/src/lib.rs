mod model;
mod provider;
mod service;

pub use model::{
    DetectLanguageRequest, DetectLanguageResponse, LanguageInfo, LanguagePair, LookUpRequest,
    LookUpResponse, RecognizeTextRequest, RecognizeTextResponse, RecognizedRect, TextDetection,
    TextRecognition, TextTranslation, TranslateRequest, TranslateResponse, WordDefinition,
    WordEtymology, WordImage, WordPhrase, WordPronunciation, WordSentence, WordSynonym, WordTag,
    WordTense,
};
pub use provider::{Provider, ProviderCapability};
pub use service::{
    DictionaryError, DictionaryService, OcrError, OcrService, TranslationError, TranslationService,
};
