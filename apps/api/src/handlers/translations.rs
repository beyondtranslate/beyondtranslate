use beyondtranslate_core::{TranslateRequest, TranslateResponse, TranslationServiceError};
use worker::{Env, Request, Response};

use crate::ApiError;

pub async fn handle(mut req: Request, env: Env, provider: &str) -> Result<Response, ApiError> {
    let request: TranslateRequest = req
        .json()
        .await
        .map_err(|error| ApiError::bad_request("INVALID_JSON", error.to_string()))?;
    let request = validate_request(request)?;

    let service = TranslationHandlerService::from_env(&env, provider)?;
    let response = service.translate(request).await.map_err(ApiError::from)?;

    crate::json_ok(&response).map_err(ApiError::from_worker_error)
}

struct TranslationHandlerService;

impl TranslationHandlerService {
    fn from_env(_env: &Env, provider: &str) -> Result<Self, ApiError> {
        match provider {
            "iciba" => Ok(Self),
            _ => Err(ApiError::bad_request(
                "INVALID_PROVIDER",
                format!("Unsupported translation provider: {provider}"),
            )),
        }
    }

    async fn translate(
        &self,
        _request: TranslateRequest,
    ) -> Result<TranslateResponse, TranslationServiceError> {
        Err(TranslationServiceError::NoProvidersConfigured)
    }
}

fn validate_request(request: TranslateRequest) -> Result<TranslateRequest, ApiError> {
    let text = request.text.trim().to_owned();
    if text.is_empty() {
        return Err(ApiError::bad_request("INVALID_REQUEST", "`text` is required"));
    }

    Ok(TranslateRequest {
        source_language: request
            .source_language
            .map(|value| value.trim().to_ascii_lowercase())
            .filter(|value| !value.is_empty()),
        target_language: request
            .target_language
            .map(|value| value.trim().to_ascii_lowercase())
            .filter(|value| !value.is_empty()),
        text,
    })
}

#[cfg(test)]
mod tests {
    use beyondtranslate_core::TranslateRequest;

    use super::validate_request;

    #[test]
    fn validates_translate_request() {
        let request = TranslateRequest {
            source_language: Some("EN".to_owned()),
            target_language: Some("ZH".to_owned()),
            text: "  hello  ".to_owned(),
        };
        let request = validate_request(request).expect("valid translate request");

        assert_eq!(request.text, "hello");
        assert_eq!(request.source_language.as_deref(), Some("en"));
    }
}
