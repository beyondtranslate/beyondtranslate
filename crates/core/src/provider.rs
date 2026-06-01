use async_trait::async_trait;

use crate::{DictionaryService, LlmError, LlmService, OcrService, TranslationService};

#[async_trait]
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

    /// Fetches the list of available models from this provider's API.
    async fn list_models(&self) -> Result<Vec<String>, LlmError> {
        Err(LlmError::UnsupportedOperation("list_models".to_string()))
    }
}
