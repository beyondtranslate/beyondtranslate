use worker::{Request, Response};

use crate::error::{ApiError, WorkerApiErrorExt};

pub async fn handle(req: Request) -> Result<Response, ApiError> {
    Response::from_json(&beyondtranslate_api_core::index(req.path().as_str()))
        .map_err(ApiError::from_worker_error)
}
