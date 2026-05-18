use worker::Response;

use crate::error::{ApiError, WorkerApiErrorExt};

pub async fn handle() -> Result<Response, ApiError> {
    Response::from_html(beyondtranslate_api_core::reference_html())
        .map_err(ApiError::from_worker_error)
}
