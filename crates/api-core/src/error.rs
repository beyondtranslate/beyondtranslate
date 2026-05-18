use beyondtranslate_core::{DictionaryError, TranslationError};
use beyondtranslate_engine::EngineError;
use serde::Serialize;

#[derive(Debug, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct ErrorBody {
    pub code: String,
    pub message: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub provider: Option<String>,
}

#[derive(Debug, Serialize)]
pub struct SuccessResponse<T: Serialize> {
    pub success: bool,
    pub data: T,
}

#[derive(Debug, Serialize)]
pub struct ErrorResponse {
    pub success: bool,
    pub error: ErrorBody,
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

    pub fn from_engine_error(error: EngineError) -> Self {
        match error {
            EngineError::UnknownProvider(name) | EngineError::ProviderNotEnabled(name) => {
                Self::bad_request("INVALID_PROVIDER", format!("Unsupported provider: {name}"))
            }
            EngineError::TranslationNotSupported(name)
            | EngineError::DictionaryNotSupported(name)
            | EngineError::OcrNotSupported(name) => Self::bad_request(
                "SERVICE_NOT_SUPPORTED",
                format!("Provider `{name}` does not support this service"),
            ),
            EngineError::ReadConfigFile { .. }
            | EngineError::ParseConfig(_)
            | EngineError::InvalidProviderConfig { .. }
            | EngineError::ConfigValidationFailed { .. } => Self::internal(
                "INTERNAL_CONFIG_ERROR",
                format!("Failed to load provider config: {error}"),
            ),
        }
    }
}

pub fn success_envelope<T: Serialize>(data: T) -> SuccessResponse<T> {
    SuccessResponse {
        success: true,
        data,
    }
}

pub fn error_envelope(error: ApiError) -> ErrorResponse {
    ErrorResponse {
        success: false,
        error: error.body,
    }
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
    fn maps_network_error_without_provider_name() {
        let error = ApiError::from(TranslationError::NetworkError("broken".to_owned()));

        assert_eq!(error.status, 502);
        assert_eq!(error.body.code, "NETWORK_ERROR");
        assert_eq!(error.body.provider.as_deref(), None);
    }
}
