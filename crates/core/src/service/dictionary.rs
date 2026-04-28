use async_trait::async_trait;
use reqwest::{Response, StatusCode};
use thiserror::Error;

use crate::{LookUpRequest, LookUpResponse};

#[derive(Debug, Error, Clone)]
pub enum DictionaryError {
    #[error("unsupported method: {0}")]
    UnsupportedMethod(&'static str),
    #[error("configuration error: {0}")]
    ConfigError(String),
    #[error("authentication failed: {0}")]
    AuthError(String),
    #[error("rate limited: {0}")]
    RateLimitError(String),
    #[error("invalid request: {0}")]
    InvalidRequest(String),
    #[error("network error: {0}")]
    NetworkError(String),
    #[error("serialization error: {0}")]
    SerializationError(String),
}

impl DictionaryError {
    pub fn from_network_error(error: reqwest::Error) -> Self {
        Self::NetworkError(error.to_string())
    }

    pub async fn from_response(
        provider: &'static str,
        response: Response,
    ) -> Result<Response, DictionaryError> {
        let status = response.status();
        if status.is_success() {
            return Ok(response);
        }

        let body = response.text().await.unwrap_or_default();
        let message = if body.is_empty() {
            status.to_string()
        } else {
            body
        };

        let error = match status {
            StatusCode::UNAUTHORIZED | StatusCode::FORBIDDEN => Self::AuthError(message),
            StatusCode::TOO_MANY_REQUESTS => Self::RateLimitError(message),
            status if status.is_client_error() => Self::InvalidRequest(message),
            _ => Self::NetworkError(format!("{provider}: {message}")),
        };

        Err(error)
    }
}

#[async_trait(?Send)]
pub trait DictionaryService: Send + Sync {
    async fn look_up(&self, request: LookUpRequest) -> Result<LookUpResponse, DictionaryError>;
}
