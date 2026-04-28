use beyondtranslate_core::{DictionaryError, LookUpRequest};
use worker::{Env, Request, Response};

use crate::{
    error::{json_ok, ApiError},
    services::provider_registry,
    utils,
};

pub async fn lookup(mut req: Request, env: Env, provider: &str) -> Result<Response, ApiError> {
    let request: LookUpRequest = req
        .json()
        .await
        .map_err(|error| ApiError::bad_request("INVALID_JSON", error.to_string()))?;
    let request = validate_lookup_request(request)?;

    let provider = provider_registry::load_provider(&env, provider)?;
    let service = provider
        .dictionary()
        .ok_or_else(|| ApiError::from(DictionaryError::UnsupportedMethod("look_up")))?;
    let response = service.look_up(request).await.map_err(ApiError::from)?;

    json_ok(&response).map_err(ApiError::from_worker_error)
}

fn validate_lookup_request(request: LookUpRequest) -> Result<LookUpRequest, ApiError> {
    let source_language = utils::normalize_required_language(request.source_language);
    let target_language = utils::normalize_required_language(request.target_language);
    let word = utils::trim_required_text(request.word);

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

    use super::validate_lookup_request;

    #[test]
    fn validates_lookup_request() {
        let request = LookUpRequest {
            source_language: "en".to_owned(),
            target_language: "zh".to_owned(),
            word: "hello".to_owned(),
        };
        let request = validate_lookup_request(request).expect("valid lookup request");

        assert_eq!(request.word, "hello");
    }
}
