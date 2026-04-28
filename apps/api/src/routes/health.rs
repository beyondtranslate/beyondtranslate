use worker::Response;

use crate::{schemas::HealthResponse, ApiError};

pub async fn handle() -> Result<Response, ApiError> {
    crate::json_ok(&HealthResponse { ok: true }).map_err(ApiError::from_worker_error)
}
