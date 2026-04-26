use worker::Response;

use crate::{ApiError, schemas::HealthResponse};

pub async fn handle() -> Result<Response, ApiError> {
    crate::json_ok(&HealthResponse { ok: true }).map_err(ApiError::from_worker_error)
}
