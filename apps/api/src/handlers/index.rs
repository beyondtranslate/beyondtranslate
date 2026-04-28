use serde::Serialize;
use worker::{Request, Response};

use crate::{error::ApiError, utils::normalized_prefix};

#[derive(Debug, Serialize)]
struct IndexResponse {
    message: &'static str,
    references: Vec<String>,
}

pub async fn handle(req: Request) -> Result<Response, ApiError> {
    let path = req.path();
    let prefix = normalized_prefix(path.as_str());

    Response::from_json(&IndexResponse {
        message: "Welcome to BeyondTranslate API",
        references: vec![format!("{prefix}/reference")],
    })
    .map_err(ApiError::from_worker_error)
}
