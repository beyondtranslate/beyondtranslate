use async_trait::async_trait;

use crate::{
    DetectLanguageRequest, DetectLanguageResponse, LanguagePair, LookUpRequest, LookUpResponse,
    TranslateRequest, TranslateResponse,
};

use super::error::TranslationResult;

#[async_trait]
pub trait TranslationProvider: Send + Sync {
    async fn get_supported_language_pairs(&self) -> TranslationResult<Vec<LanguagePair>> {
        Err(super::error::TranslationError::UnsupportedMethod(
            "get_supported_language_pairs",
        ))
    }

    async fn detect_language(
        &self,
        _request: DetectLanguageRequest,
    ) -> TranslationResult<DetectLanguageResponse> {
        Err(super::error::TranslationError::UnsupportedMethod(
            "detect_language",
        ))
    }

    async fn look_up(&self, _request: LookUpRequest) -> TranslationResult<LookUpResponse> {
        Err(super::error::TranslationError::UnsupportedMethod("look_up"))
    }

    async fn translate(&self, request: TranslateRequest) -> TranslationResult<TranslateResponse>;
}
