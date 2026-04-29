use beyondtranslate_engine::{from_yaml_str, Engine, EngineError};
use worker::Env;

use crate::{config::ApiConfig, error::ApiError};

pub fn load_engine(env: &Env) -> Result<Engine, ApiError> {
    let rendered = ApiConfig::default().render_runtime_config(env);
    from_yaml_str(&rendered).map_err(to_api_error)
}

pub fn to_api_error(error: EngineError) -> ApiError {
    match error {
        EngineError::UnknownProvider(name) | EngineError::ProviderNotEnabled(name) => {
            ApiError::bad_request("INVALID_PROVIDER", format!("Unsupported provider: {name}"))
        }
        EngineError::TranslationNotSupported(name) | EngineError::DictionaryNotSupported(name) => {
            ApiError::bad_request(
                "SERVICE_NOT_SUPPORTED",
                format!("Provider `{name}` does not support this service"),
            )
        }
        EngineError::ReadConfigFile { .. }
        | EngineError::ParseConfig(_)
        | EngineError::InvalidProviderConfig { .. }
        | EngineError::ConfigValidationFailed { .. } => ApiError::internal(
            "INTERNAL_CONFIG_ERROR",
            format!("Failed to load provider config: {error}"),
        ),
    }
}
