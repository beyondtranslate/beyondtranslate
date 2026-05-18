use worker::Response;

use crate::error::{ApiError, WorkerApiErrorExt};

pub async fn handle() -> Result<Response, ApiError> {
    let document = beyondtranslate_api_core::openapi_document()?;
    Response::from_json(&document).map_err(ApiError::from_worker_error)
}
