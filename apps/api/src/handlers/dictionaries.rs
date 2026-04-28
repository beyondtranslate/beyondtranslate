use std::sync::Arc;

use beyondtranslate_core::{
    DictionaryError, DictionaryService, LookUpRequest, LookUpResponse, Provider,
};
use worker::{Env, Request, Response};

use crate::ApiError;

pub async fn handle(mut req: Request, env: Env, provider: &str) -> Result<Response, ApiError> {
    let request: LookUpRequest = req
        .json()
        .await
        .map_err(|error| ApiError::bad_request("INVALID_JSON", error.to_string()))?;
    let request = validate_request(request)?;

    let service = DictionaryHandlerService::from_env(&env, provider)?;
    let result = service.lookup(request).await.map_err(ApiError::from)?;

    crate::json_ok(&result).map_err(ApiError::from_worker_error)
}

struct DictionaryHandlerService {
    inner: Arc<dyn Provider>,
}

impl DictionaryHandlerService {
    fn from_env(env: &Env, provider: &str) -> Result<Self, ApiError> {
        let inner = crate::provider_registry::load_provider(env, provider)?;
        Ok(Self { inner })
    }

    async fn lookup(&self, request: LookUpRequest) -> Result<LookUpResponse, DictionaryError> {
        self.dictionary_service()?.look_up(request).await
    }

    fn dictionary_service(&self) -> Result<&dyn DictionaryService, DictionaryError> {
        self.inner
            .dictionary()
            .ok_or(DictionaryError::UnsupportedMethod("look_up"))
    }
}

fn validate_request(request: LookUpRequest) -> Result<LookUpRequest, ApiError> {
    let source_language = request.source_language.trim().to_ascii_lowercase();
    let target_language = request.target_language.trim().to_ascii_lowercase();
    let word = request.word.trim().to_owned();

    if word.is_empty() {
        return Err(ApiError::bad_request(
            "INVALID_REQUEST",
            "`word` is required",
        ));
    }

    if source_language != "en" || target_language != "zh" {
        return Err(ApiError::bad_request(
            "INVALID_REQUEST",
            "Iciba lookup only supports sourceLanguage=en and targetLanguage=zh",
        ));
    }

    Ok(LookUpRequest {
        source_language,
        target_language,
        word,
    })
}

#[cfg(test)]
mod tests {
    use beyondtranslate_core::LookUpRequest;

    use super::validate_request;

    #[test]
    fn validates_lookup_request() {
        let request = LookUpRequest {
            source_language: "en".to_owned(),
            target_language: "zh".to_owned(),
            word: "hello".to_owned(),
        };
        let request = validate_request(request).expect("valid lookup request");

        assert_eq!(request.word, "hello");
    }
}
