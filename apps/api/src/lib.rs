mod app;
mod handlers;
mod routes;
mod schemas;

use beyondtranslate_core::{
    DictionaryError, DictionaryServiceError, TranslationError, TranslationServiceError,
};
use serde::Serialize;
use worker::*;

#[derive(Debug, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct ErrorBody {
    pub code: String,
    pub message: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub provider: Option<String>,
}

#[derive(Debug, Clone)]
pub struct ApiError {
    pub status: u16,
    pub body: ErrorBody,
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

impl ApiError {
    pub fn bad_request(code: impl Into<String>, message: impl Into<String>) -> Self {
        Self::new(400, code, message, None)
    }

    pub fn internal(code: impl Into<String>, message: impl Into<String>) -> Self {
        Self::new(500, code, message, None)
    }

    pub fn not_found(message: impl Into<String>) -> Self {
        Self::new(404, "NOT_FOUND", message, None)
    }

    pub fn from_worker_error(error: worker::Error) -> Self {
        Self::internal("INTERNAL_ERROR", error.to_string())
    }

    pub fn new(
        status: u16,
        code: impl Into<String>,
        message: impl Into<String>,
        provider: Option<&str>,
    ) -> Self {
        Self {
            status,
            body: ErrorBody {
                code: code.into(),
                message: message.into(),
                provider: provider.map(ToOwned::to_owned),
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

impl From<TranslationServiceError> for ApiError {
    fn from(error: TranslationServiceError) -> Self {
        match error {
            TranslationServiceError::NoProvidersConfigured => Self::internal(
                "INTERNAL_CONFIG_ERROR",
                "No translation providers configured",
            ),
            TranslationServiceError::Translation(error) => error.into(),
        }
    }
}

impl From<DictionaryServiceError> for ApiError {
    fn from(error: DictionaryServiceError) -> Self {
        match error {
            DictionaryServiceError::NoProvidersConfigured => Self::internal(
                "INTERNAL_CONFIG_ERROR",
                "No dictionary providers configured",
            ),
            DictionaryServiceError::Dictionary(error) => error.into(),
        }
    }
}

impl From<TranslationError> for ApiError {
    fn from(error: TranslationError) -> Self {
        match error {
            TranslationError::UnsupportedMethod(method) => {
                Self::new(400, "UNSUPPORTED_OPERATION", method, None)
            }
            TranslationError::ConfigError(message) => {
                Self::new(500, "INTERNAL_CONFIG_ERROR", message, None)
            }
            TranslationError::AuthError(message) => {
                Self::new(401, "PROVIDER_AUTH_ERROR", message, None)
            }
            TranslationError::RateLimitError(message) => {
                Self::new(429, "PROVIDER_RATE_LIMIT", message, None)
            }
            TranslationError::InvalidRequest(message) => {
                Self::new(400, "INVALID_REQUEST", message, None)
            }
            TranslationError::ProviderError { provider, message } => {
                Self::new(502, "PROVIDER_ERROR", message, Some(provider))
            }
            TranslationError::NetworkError(message) => {
                Self::new(502, "NETWORK_ERROR", message, None)
            }
            TranslationError::SerializationError(message) => {
                Self::new(502, "PROVIDER_RESPONSE_INVALID", message, None)
            }
        }
    }
}

impl From<DictionaryError> for ApiError {
    fn from(error: DictionaryError) -> Self {
        match error {
            DictionaryError::UnsupportedMethod(method) => {
                Self::new(400, "UNSUPPORTED_OPERATION", method, None)
            }
            DictionaryError::ConfigError(message) => {
                Self::new(500, "INTERNAL_CONFIG_ERROR", message, None)
            }
            DictionaryError::AuthError(message) => {
                Self::new(401, "PROVIDER_AUTH_ERROR", message, None)
            }
            DictionaryError::RateLimitError(message) => {
                Self::new(429, "PROVIDER_RATE_LIMIT", message, None)
            }
            DictionaryError::InvalidRequest(message) => {
                Self::new(400, "INVALID_REQUEST", message, None)
            }
            DictionaryError::ProviderError { provider, message } => {
                Self::new(502, "PROVIDER_ERROR", message, Some(provider))
            }
            DictionaryError::NetworkError(message) => {
                Self::new(502, "NETWORK_ERROR", message, None)
            }
            DictionaryError::SerializationError(message) => {
                Self::new(502, "PROVIDER_RESPONSE_INVALID", message, None)
            }
        }
    }
}

#[event(fetch)]
async fn fetch(req: Request, env: Env, _ctx: Context) -> Result<Response> {
    console_error_panic_hook::set_once();

    match app::handle(req, env).await {
        Ok(response) => Ok(response),
        Err(error) => error.into_response(),
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
    fn maps_provider_error_with_original_provider_name() {
        let error = ApiError::from(TranslationError::ProviderError {
            provider: "iciba",
            message: "broken".to_owned(),
        });

        assert_eq!(error.status, 502);
        assert_eq!(error.body.code, "PROVIDER_ERROR");
        assert_eq!(error.body.provider.as_deref(), Some("iciba"));
    }
}
