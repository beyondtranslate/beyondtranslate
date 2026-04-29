use beyondtranslate_core::{DetectLanguageRequest, TranslateRequest};
use worker::{Env, Request, Response};

use crate::{
    error::{json_ok, ApiError},
    services::engine,
    utils,
};

pub async fn translate(mut req: Request, env: Env, provider: &str) -> Result<Response, ApiError> {
    let request: TranslateRequest = req
        .json()
        .await
        .map_err(|error| ApiError::bad_request("INVALID_JSON", error.to_string()))?;
    let request = validate_translate_request(request)?;

    let eng = engine::load_engine(&env)?;
    let service = eng.translation(provider).map_err(engine::to_api_error)?;
    let response = service.translate(request).await.map_err(ApiError::from)?;

    json_ok(&response).map_err(ApiError::from_worker_error)
}

pub async fn detect_language(
    mut req: Request,
    env: Env,
    provider: &str,
) -> Result<Response, ApiError> {
    let request: DetectLanguageRequest = req
        .json()
        .await
        .map_err(|error| ApiError::bad_request("INVALID_JSON", error.to_string()))?;
    let request = validate_detect_language_request(request)?;

    let eng = engine::load_engine(&env)?;
    let service = eng.translation(provider).map_err(engine::to_api_error)?;
    let response = service
        .detect_language(request)
        .await
        .map_err(ApiError::from)?;

    json_ok(&response).map_err(ApiError::from_worker_error)
}

pub async fn supported_language_pairs(env: Env, provider: &str) -> Result<Response, ApiError> {
    let eng = engine::load_engine(&env)?;
    let service = eng.translation(provider).map_err(engine::to_api_error)?;
    let response = service
        .get_supported_language_pairs()
        .await
        .map_err(ApiError::from)?;

    json_ok(&response).map_err(ApiError::from_worker_error)
}

fn validate_translate_request(request: TranslateRequest) -> Result<TranslateRequest, ApiError> {
    let text = utils::trim_required_text(request.text);
    if text.is_empty() {
        return Err(ApiError::bad_request(
            "INVALID_REQUEST",
            "`text` is required",
        ));
    }

    Ok(TranslateRequest {
        source_language: utils::normalize_optional_language(request.source_language),
        target_language: utils::normalize_optional_language(request.target_language),
        text,
    })
}

fn validate_detect_language_request(
    request: DetectLanguageRequest,
) -> Result<DetectLanguageRequest, ApiError> {
    let texts = request
        .texts
        .into_iter()
        .map(utils::trim_required_text)
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

    use super::{validate_detect_language_request, validate_translate_request};

    #[test]
    fn validates_translate_request() {
        let request = TranslateRequest {
            source_language: Some("EN".to_owned()),
            target_language: Some("ZH".to_owned()),
            text: "  hello  ".to_owned(),
        };
        let request = validate_translate_request(request).expect("valid translate request");

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
