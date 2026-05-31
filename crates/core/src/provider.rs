use crate::{DictionaryService, LlmService, OcrService, TranslationService};

pub trait Provider: Send + Sync {
    fn name(&self) -> &'static str;

    fn translation(&self) -> Option<&dyn TranslationService> {
        None
    }

    fn dictionary(&self) -> Option<&dyn DictionaryService> {
        None
    }

    fn ocr(&self) -> Option<&dyn OcrService> {
        None
    }

    fn llm(&self) -> Option<&dyn LlmService> {
        None
    }
}
