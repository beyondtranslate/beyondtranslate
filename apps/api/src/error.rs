use worker::{Response, Result};

pub use beyondtranslate_api_core::ApiError;

pub trait WorkerApiErrorExt {
    fn from_worker_error(error: worker::Error) -> Self;
    fn into_response(self) -> Result<Response>;
}

impl WorkerApiErrorExt for ApiError {
    fn from_worker_error(error: worker::Error) -> Self {
        Self::internal("INTERNAL_ERROR", error.to_string())
    }

    fn into_response(self) -> Result<Response> {
        let status = self.status;
        Ok(
            Response::from_json(&beyondtranslate_api_core::error_envelope(self))?
                .with_status(status),
        )
    }
}

pub fn json_ok<T: serde::Serialize>(data: T) -> Result<Response> {
    Response::from_json(&beyondtranslate_api_core::success_envelope(data))
}
