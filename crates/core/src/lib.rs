mod model;
mod provider;
mod service;

pub use model::{
    ChatChoice, ChatMessage, ChatRequest, ChatResponse, ChatRole, ChatUsage, DetectLanguageRequest,
    DetectLanguageResponse, LanguageInfo, LanguagePair, LookUpRequest, LookUpResponse,
    RecognizeTextRequest, RecognizeTextResponse, RecognizedRect, StreamChunk, StreamState,
    TextDetection, TextRecognition, TextTranslation, TranslateRequest, TranslateResponse,
    TranslationTarget, WordDefinition, WordEtymology, WordImage, WordPhrase, WordPronunciation,
    WordSentence, WordSynonym, WordTag, WordTense,
};
pub use provider::Provider;
pub use service::{
    DictionaryError, DictionaryService, LlmError, LlmService, LlmStreamReceiver, OcrError,
    OcrService, TranslationError, TranslationService,
};
