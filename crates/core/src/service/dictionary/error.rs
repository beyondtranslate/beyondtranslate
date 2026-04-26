use reqwest::{Response, StatusCode};
use thiserror::Error;

pub type DictionaryResult<T> = Result<T, DictionaryError>;
pub type DictionaryServiceResult<T> = Result<T, DictionaryServiceError>;

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
    #[error("provider error ({provider}): {message}")]
    ProviderError {
        provider: &'static str,
        message: String,
    },
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
    ) -> DictionaryResult<Response> {
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
            _ => Self::ProviderError { provider, message },
        };

        Err(error)
    }
}

#[derive(Debug, Error, Clone)]
pub enum DictionaryServiceError {
    #[error("no dictionary providers configured")]
    NoProvidersConfigured,
    #[error(transparent)]
    Dictionary(#[from] DictionaryError),
}
