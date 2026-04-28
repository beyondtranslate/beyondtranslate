use beyondtranslate_core::{DictionaryError, TranslationError};
use serde::Serialize;
use worker::{Response, Result};

#[derive(Debug, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct ErrorBody {
    pub code: String,
    pub message: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub provider: Option<String>,
}

#[derive(Debug, Serialize)]
struct SuccessResponse<'a, T: Serialize> {
    success: bool,
    data: &'a T,
}

#[derive(Debug, Serialize)]
struct ErrorResponse<'a, T: Serialize> {
    success: bool,
    error: &'a T,
}

#[derive(Debug, Clone)]
pub struct ApiError {
    pub status: u16,
    pub body: ErrorBody,
}

impl ApiError {
    pub fn bad_request(code: impl Into<String>, message: impl Into<String>) -> Self {
        Self::new(400, code, message)
    }

    pub fn internal(code: impl Into<String>, message: impl Into<String>) -> Self {
        Self::new(500, code, message)
    }

    pub fn not_found(message: impl Into<String>) -> Self {
        Self::new(404, "NOT_FOUND", message)
    }

    pub fn method_not_allowed(message: impl Into<String>) -> Self {
        Self::new(405, "METHOD_NOT_ALLOWED", message)
    }

    pub fn from_worker_error(error: worker::Error) -> Self {
        Self::internal("INTERNAL_ERROR", error.to_string())
    }

    pub fn new(status: u16, code: impl Into<String>, message: impl Into<String>) -> Self {
        Self {
            status,
            body: ErrorBody {
                code: code.into(),
                message: message.into(),
                provider: None,
            },
        }
    }

    pub fn into_response(self) -> Result<Response> {
        json_error(self.status, &self.body)
    }
}

pub fn json_ok<T: Serialize>(data: &T) -> Result<Response> {
    Response::from_json(&SuccessResponse {
        success: true,
        data,
    })
}

pub fn json_error<T: Serialize>(status: u16, error: &T) -> Result<Response> {
    Ok(Response::from_json(&ErrorResponse {
        success: false,
        error,
    })?
    .with_status(status))
}

impl From<TranslationError> for ApiError {
    fn from(error: TranslationError) -> Self {
        match error {
            TranslationError::UnsupportedMethod(method) => {
                Self::new(400, "UNSUPPORTED_OPERATION", method)
            }
            TranslationError::ConfigError(message) => {
                Self::new(500, "INTERNAL_CONFIG_ERROR", message)
            }
            TranslationError::AuthError(message) => Self::new(401, "PROVIDER_AUTH_ERROR", message),
            TranslationError::RateLimitError(message) => {
                Self::new(429, "PROVIDER_RATE_LIMIT", message)
            }
            TranslationError::InvalidRequest(message) => Self::new(400, "INVALID_REQUEST", message),
            TranslationError::NetworkError(message) => Self::new(502, "NETWORK_ERROR", message),
            TranslationError::SerializationError(message) => {
                Self::new(502, "PROVIDER_RESPONSE_INVALID", message)
            }
        }
    }
}

impl From<DictionaryError> for ApiError {
    fn from(error: DictionaryError) -> Self {
        match error {
            DictionaryError::UnsupportedMethod(method) => {
                Self::new(400, "UNSUPPORTED_OPERATION", method)
            }
            DictionaryError::ConfigError(message) => {
                Self::new(500, "INTERNAL_CONFIG_ERROR", message)
            }
            DictionaryError::AuthError(message) => Self::new(401, "PROVIDER_AUTH_ERROR", message),
            DictionaryError::RateLimitError(message) => {
                Self::new(429, "PROVIDER_RATE_LIMIT", message)
            }
            DictionaryError::InvalidRequest(message) => Self::new(400, "INVALID_REQUEST", message),
            DictionaryError::NetworkError(message) => Self::new(502, "NETWORK_ERROR", message),
            DictionaryError::SerializationError(message) => {
                Self::new(502, "PROVIDER_RESPONSE_INVALID", message)
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use beyondtranslate_core::TranslationError;

    use super::ApiError;

    #[test]
    fn maps_unsupported_method_to_client_error() {
        let error = ApiError::from(TranslationError::UnsupportedMethod("translate"));

        assert_eq!(error.status, 400);
        assert_eq!(error.body.code, "UNSUPPORTED_OPERATION");
        assert_eq!(error.body.provider.as_deref(), None);
    }

    #[test]
    fn maps_network_error_without_provider_name() {
        let error = ApiError::from(TranslationError::NetworkError("broken".to_owned()));

        assert_eq!(error.status, 502);
        assert_eq!(error.body.code, "NETWORK_ERROR");
        assert_eq!(error.body.provider.as_deref(), None);
    }
}
