use worker::Response;

use crate::{
    error::{json_ok, ApiError},
    models::health_response::HealthResponse,
};

pub async fn handle() -> Result<Response, ApiError> {
    json_ok(&HealthResponse { ok: true }).map_err(ApiError::from_worker_error)
}
