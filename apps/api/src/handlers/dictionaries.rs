use beyondtranslate_core::LookUpRequest;
use worker::{Env, Request, Response};

use crate::{
    error::{json_ok, ApiError, WorkerApiErrorExt},
    services::engine,
};

pub async fn lookup(mut req: Request, env: Env, provider: &str) -> Result<Response, ApiError> {
    let request: LookUpRequest = req
        .json()
        .await
        .map_err(|error| ApiError::bad_request("INVALID_JSON", error.to_string()))?;
    let request = beyondtranslate_api_core::lookup_request(request)?;

    let engine = engine::load_engine(&env)?;
    let service = engine
        .dictionary(provider)
        .map_err(ApiError::from_engine_error)?;
    let response = service.look_up(request).await.map_err(ApiError::from)?;

    json_ok(response).map_err(ApiError::from_worker_error)
}
