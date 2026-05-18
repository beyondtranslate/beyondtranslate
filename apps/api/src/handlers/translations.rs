use beyondtranslate_core::{DetectLanguageRequest, TranslateRequest};
use worker::{Env, Request, Response};

use crate::{
    error::{json_ok, ApiError, WorkerApiErrorExt},
    services::engine,
};

pub async fn translate(mut req: Request, env: Env, provider: &str) -> Result<Response, ApiError> {
    let request: TranslateRequest = req
        .json()
        .await
        .map_err(|error| ApiError::bad_request("INVALID_JSON", error.to_string()))?;
    let request = beyondtranslate_api_core::translate_request(request)?;

    let eng = engine::load_engine(&env)?;
    let service = eng
        .translation(provider)
        .map_err(ApiError::from_engine_error)?;
    let response = service.translate(request).await.map_err(ApiError::from)?;

    json_ok(response).map_err(ApiError::from_worker_error)
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
    let request = beyondtranslate_api_core::detect_language_request(request)?;

    let eng = engine::load_engine(&env)?;
    let service = eng
        .translation(provider)
        .map_err(ApiError::from_engine_error)?;
    let response = service
        .detect_language(request)
        .await
        .map_err(ApiError::from)?;

    json_ok(response).map_err(ApiError::from_worker_error)
}

pub async fn supported_language_pairs(env: Env, provider: &str) -> Result<Response, ApiError> {
    let eng = engine::load_engine(&env)?;
    let service = eng
        .translation(provider)
        .map_err(ApiError::from_engine_error)?;
    let response = service
        .get_supported_language_pairs()
        .await
        .map_err(ApiError::from)?;

    json_ok(beyondtranslate_api_core::supported_language_pairs(response))
        .map_err(ApiError::from_worker_error)
}
