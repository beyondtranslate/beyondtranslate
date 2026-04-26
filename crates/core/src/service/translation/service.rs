use std::sync::Arc;

use crate::{
    DetectLanguageRequest, DetectLanguageResponse, LanguagePair, TranslateRequest,
    TranslateResponse,
};

use super::error::{TranslationError, TranslationServiceError, TranslationServiceResult};
use super::provider::TranslationProvider;

pub struct TranslationService {
    primary: Arc<dyn TranslationProvider>,
    fallbacks: Vec<Arc<dyn TranslationProvider>>,
}

impl TranslationService {
    pub fn new(
        primary: Arc<dyn TranslationProvider>,
        fallbacks: Vec<Arc<dyn TranslationProvider>>,
    ) -> Self {
        Self { primary, fallbacks }
    }

    pub async fn get_supported_language_pairs(
        &self,
    ) -> TranslationServiceResult<Vec<LanguagePair>> {
        let mut last_error = None;

        for provider in std::iter::once(&self.primary).chain(self.fallbacks.iter()) {
            match provider.get_supported_language_pairs().await {
                Ok(result) => return Ok(result),
                Err(error) => last_error = Some(error),
            }
        }

        Err(map_last_error(last_error))
    }

    pub async fn detect_language(
        &self,
        request: DetectLanguageRequest,
    ) -> TranslationServiceResult<DetectLanguageResponse> {
        let mut last_error = None;

        for provider in std::iter::once(&self.primary).chain(self.fallbacks.iter()) {
            match provider.detect_language(request.clone()).await {
                Ok(result) => return Ok(result),
                Err(error) => last_error = Some(error),
            }
        }

        Err(map_last_error(last_error))
    }

    pub async fn translate(
        &self,
        request: TranslateRequest,
    ) -> TranslationServiceResult<TranslateResponse> {
        let mut last_error = None;

        for provider in std::iter::once(&self.primary).chain(self.fallbacks.iter()) {
            match provider.translate(request.clone()).await {
                Ok(result) => return Ok(result),
                Err(error) => last_error = Some(error),
            }
        }

        Err(map_last_error(last_error))
    }
}

fn map_last_error(last_error: Option<TranslationError>) -> TranslationServiceError {
    last_error
        .map(TranslationServiceError::from)
        .unwrap_or(TranslationServiceError::NoProvidersConfigured)
}
