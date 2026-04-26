use beyondtranslate_core::{
    DictionaryService, DictionaryServiceError, LookUpRequest, LookUpResponse,
};
use beyondtranslate_runtime::{create_dictionary, DictionaryProviderConfig};
use worker::{Env, Request, Response};

use crate::ApiError;

pub async fn handle(mut req: Request, env: Env, provider: &str) -> Result<Response, ApiError> {
    let request: LookUpRequest = req
        .json()
        .await
        .map_err(|error| ApiError::bad_request("INVALID_JSON", error.to_string()))?;
    let request = validate_request(request)?;

    let service = DictionaryHandlerService::from_env(&env, provider)?;
    let result = service.lookup(request).await.map_err(ApiError::from)?;

    crate::json_ok(&result).map_err(ApiError::from_worker_error)
}

struct DictionaryHandlerService {
    inner: DictionaryService,
}

impl DictionaryHandlerService {
    fn from_env(env: &Env, provider: &str) -> Result<Self, ApiError> {
        match provider {
            "iciba" => Self::from_iciba_env(env),
            _ => Err(ApiError::bad_request(
                "INVALID_PROVIDER",
                format!("Unsupported dictionary provider: {provider}"),
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

        let inner = create_dictionary(DictionaryProviderConfig::Iciba { api_key, base_url })
            .map_err(ApiError::from)?;

        Ok(Self { inner })
    }

    async fn lookup(
        &self,
        request: LookUpRequest,
    ) -> Result<LookUpResponse, DictionaryServiceError> {
        self.inner.look_up(request).await
    }
}

fn validate_request(request: LookUpRequest) -> Result<LookUpRequest, ApiError> {
    let source_language = request.source_language.trim().to_ascii_lowercase();
    let target_language = request.target_language.trim().to_ascii_lowercase();
    let word = request.word.trim().to_owned();

    if word.is_empty() {
        return Err(ApiError::bad_request("INVALID_REQUEST", "`word` is required"));
    }

    if source_language != "en" || target_language != "zh" {
        return Err(ApiError::bad_request(
            "INVALID_REQUEST",
            "Iciba lookup only supports sourceLanguage=en and targetLanguage=zh",
        ));
    }

    Ok(LookUpRequest {
        source_language,
        target_language,
        word,
    })
}

#[cfg(test)]
mod tests {
    use beyondtranslate_core::LookUpRequest;

    use super::validate_request;

    #[test]
    fn validates_lookup_request() {
        let request = LookUpRequest {
            source_language: "en".to_owned(),
            target_language: "zh".to_owned(),
            word: "hello".to_owned(),
        };
        let request = validate_request(request).expect("valid lookup request");

        assert_eq!(request.word, "hello");
    }
}
