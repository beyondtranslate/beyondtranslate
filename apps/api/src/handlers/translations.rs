use beyondtranslate_core::{
    DetectLanguageRequest, DetectLanguageResponse, LanguagePair, TranslateRequest,
    TranslateResponse, TranslationService, TranslationServiceError,
};
use beyondtranslate_runtime::{create_translator, TranslationProviderConfig};
use worker::{Env, Request, Response};

use crate::ApiError;

pub async fn handle_translate(
    mut req: Request,
    env: Env,
    provider: &str,
) -> Result<Response, ApiError> {
    let request: TranslateRequest = req
        .json()
        .await
        .map_err(|error| ApiError::bad_request("INVALID_JSON", error.to_string()))?;
    let request = validate_request(request)?;

    let service = TranslationHandlerService::from_env(&env, provider)?;
    let response = service.translate(request).await.map_err(ApiError::from)?;

    crate::json_ok(&response).map_err(ApiError::from_worker_error)
}

pub async fn handle_detect_language(
    mut req: Request,
    env: Env,
    provider: &str,
) -> Result<Response, ApiError> {
    let request: DetectLanguageRequest = req
        .json()
        .await
        .map_err(|error| ApiError::bad_request("INVALID_JSON", error.to_string()))?;
    let request = validate_detect_language_request(request)?;

    let service = TranslationHandlerService::from_env(&env, provider)?;
    let response = service
        .detect_language(request)
        .await
        .map_err(ApiError::from)?;

    crate::json_ok(&response).map_err(ApiError::from_worker_error)
}

pub async fn handle_supported_language_pairs(
    env: Env,
    provider: &str,
) -> Result<Response, ApiError> {
    let service = TranslationHandlerService::from_env(&env, provider)?;
    let response = service
        .supported_language_pairs()
        .await
        .map_err(ApiError::from)?;

    crate::json_ok(&response).map_err(ApiError::from_worker_error)
}

struct TranslationHandlerService {
    inner: TranslationService,
}

impl TranslationHandlerService {
    fn from_env(_env: &Env, provider: &str) -> Result<Self, ApiError> {
        match provider {
            "iciba" => Self::from_iciba_env(_env),
            _ => Err(ApiError::bad_request(
                "INVALID_PROVIDER",
                format!("Unsupported translation provider: {provider}"),
            )),
        }
    }

    fn from_iciba_env(env: &Env) -> Result<Self, ApiError> {
        let api_key = env
            .var("ICIBA_API_KEY")
            .map(|value| value.to_string())
            .map_err(|_| {
                ApiError::internal(
                    "INTERNAL_CONFIG_ERROR",
                    "Missing required environment variable: ICIBA_API_KEY",
                )
            })?;

        let base_url = env.var("ICIBA_BASE_URL").ok().map(|value| value.to_string());

        let inner = create_translator(TranslationProviderConfig::Iciba { api_key, base_url })
            .map_err(ApiError::from)?;

        Ok(Self { inner })
    }

    async fn translate(
        &self,
        request: TranslateRequest,
    ) -> Result<TranslateResponse, TranslationServiceError> {
        self.inner.translate(request).await
    }

    async fn detect_language(
        &self,
        request: DetectLanguageRequest,
    ) -> Result<DetectLanguageResponse, TranslationServiceError> {
        self.inner.detect_language(request).await
    }

    async fn supported_language_pairs(
        &self,
    ) -> Result<Vec<LanguagePair>, TranslationServiceError> {
        self.inner.get_supported_language_pairs().await
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

fn validate_detect_language_request(
    request: DetectLanguageRequest,
) -> Result<DetectLanguageRequest, ApiError> {
    let texts = request
        .texts
        .into_iter()
        .map(|value| value.trim().to_owned())
        .filter(|value| !value.is_empty())
        .collect::<Vec<_>>();

    if texts.is_empty() {
        return Err(ApiError::bad_request(
            "INVALID_REQUEST",
            "`texts` must contain at least one non-empty item",
        ));
    }

    Ok(DetectLanguageRequest { texts })
}

#[cfg(test)]
mod tests {
    use beyondtranslate_core::{DetectLanguageRequest, TranslateRequest};

    use super::{validate_detect_language_request, validate_request};

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

    #[test]
    fn validates_detect_language_request() {
        let request = DetectLanguageRequest {
            texts: vec!["  hello  ".to_owned(), "".to_owned(), " world ".to_owned()],
        };
        let request = validate_detect_language_request(request).expect("valid detect request");

        assert_eq!(request.texts, vec!["hello".to_owned(), "world".to_owned()]);
    }
}
