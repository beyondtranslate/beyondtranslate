use std::sync::Arc;

use beyondtranslate_core::{
    DetectLanguageRequest, DetectLanguageResponse, LanguagePair, Provider, TranslateRequest,
    TranslateResponse, TranslationError, TranslationService,
};
use worker::{Env, Request, Response};

use crate::ApiError;

pub async fn handle_translate(
    mut req: Request,
    env: Env,
    provider: &str,
) -> Result<Response, ApiError> {
    let request: TranslateRequest = req
        .json()
        .await
        .map_err(|error| ApiError::bad_request("INVALID_JSON", error.to_string()))?;
    let request = validate_request(request)?;

    let service = TranslationHandlerService::from_env(&env, provider)?;
    let response = service.translate(request).await.map_err(ApiError::from)?;

    crate::json_ok(&response).map_err(ApiError::from_worker_error)
}

pub async fn handle_detect_language(
    mut req: Request,
    env: Env,
    provider: &str,
) -> Result<Response, ApiError> {
    let request: DetectLanguageRequest = req
        .json()
        .await
        .map_err(|error| ApiError::bad_request("INVALID_JSON", error.to_string()))?;
    let request = validate_detect_language_request(request)?;

    let service = TranslationHandlerService::from_env(&env, provider)?;
    let response = service
        .detect_language(request)
        .await
        .map_err(ApiError::from)?;

    crate::json_ok(&response).map_err(ApiError::from_worker_error)
}

pub async fn handle_supported_language_pairs(
    env: Env,
    provider: &str,
) -> Result<Response, ApiError> {
    let service = TranslationHandlerService::from_env(&env, provider)?;
    let response = service
        .supported_language_pairs()
        .await
        .map_err(ApiError::from)?;

    crate::json_ok(&response).map_err(ApiError::from_worker_error)
}

struct TranslationHandlerService {
    inner: Arc<dyn Provider>,
}

impl TranslationHandlerService {
    fn from_env(env: &Env, provider: &str) -> Result<Self, ApiError> {
        let inner = crate::provider_registry::load_provider(env, provider)?;
        Ok(Self { inner })
    }

    async fn translate(
        &self,
        request: TranslateRequest,
    ) -> Result<TranslateResponse, TranslationError> {
        self.translation_service("translate")?
            .translate(request)
            .await
    }

    async fn detect_language(
        &self,
        request: DetectLanguageRequest,
    ) -> Result<DetectLanguageResponse, TranslationError> {
        self.translation_service("detect_language")?
            .detect_language(request)
            .await
    }

    async fn supported_language_pairs(&self) -> Result<Vec<LanguagePair>, TranslationError> {
        self.translation_service("get_supported_language_pairs")?
            .get_supported_language_pairs()
            .await
    }

    fn translation_service(
        &self,
        method: &'static str,
    ) -> Result<&dyn TranslationService, TranslationError> {
        self.inner
            .translation()
            .ok_or(TranslationError::UnsupportedMethod(method))
    }
}

fn validate_request(request: TranslateRequest) -> Result<TranslateRequest, ApiError> {
    let text = request.text.trim().to_owned();
    if text.is_empty() {
        return Err(ApiError::bad_request(
            "INVALID_REQUEST",
            "`text` is required",
        ));
    }

    Ok(TranslateRequest {
        source_language: request
            .source_language
            .map(|value| value.trim().to_ascii_lowercase())
            .filter(|value| !value.is_empty()),
        target_language: request
            .target_language
            .map(|value| value.trim().to_ascii_lowercase())
            .filter(|value| !value.is_empty()),
        text,
    })
}

fn validate_detect_language_request(
    request: DetectLanguageRequest,
) -> Result<DetectLanguageRequest, ApiError> {
    let texts = request
        .texts
        .into_iter()
        .map(|value| value.trim().to_owned())
        .filter(|value| !value.is_empty())
        .collect::<Vec<_>>();

    if texts.is_empty() {
        return Err(ApiError::bad_request(
            "INVALID_REQUEST",
            "`texts` must contain at least one non-empty item",
        ));
    }

    Ok(DetectLanguageRequest { texts })
}

#[cfg(test)]
mod tests {
    use beyondtranslate_core::{DetectLanguageRequest, TranslateRequest};

    use super::{validate_detect_language_request, validate_request};

    #[test]
    fn validates_translate_request() {
        let request = TranslateRequest {
            source_language: Some("EN".to_owned()),
            target_language: Some("ZH".to_owned()),
            text: "  hello  ".to_owned(),
        };
        let request = validate_request(request).expect("valid translate request");

        assert_eq!(request.text, "hello");
        assert_eq!(request.source_language.as_deref(), Some("en"));
    }

    #[test]
    fn validates_detect_language_request() {
        let request = DetectLanguageRequest {
            texts: vec!["  hello  ".to_owned(), "".to_owned(), " world ".to_owned()],
        };
        let request = validate_detect_language_request(request).expect("valid detect request");

        assert_eq!(request.texts, vec!["hello".to_owned(), "world".to_owned()]);
    }
}
