use worker::Response;

use crate::error::{json_ok, ApiError, WorkerApiErrorExt};

pub async fn handle() -> Result<Response, ApiError> {
    json_ok(beyondtranslate_api_core::health()).map_err(ApiError::from_worker_error)
}
