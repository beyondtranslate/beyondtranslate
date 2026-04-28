use std::sync::Arc;

use beyondtranslate_core::Provider;
use beyondtranslate_runtime::{from_yaml_str, ProviderRegistry, RuntimeError};
use worker::Env;

use crate::{config::ApiConfig, error::ApiError};

pub fn load_provider(env: &Env, name: &str) -> Result<Arc<dyn Provider>, ApiError> {
    let registry = load_registry(env)?;

    registry
        .require(name)
        .cloned()
        .map_err(runtime_error_to_api_error)
}

fn load_registry(env: &Env) -> Result<ProviderRegistry, ApiError> {
    let rendered = ApiConfig::default().render_runtime_config(env);
    from_yaml_str(&rendered).map_err(runtime_error_to_api_error)
}

fn runtime_error_to_api_error(error: RuntimeError) -> ApiError {
    match error {
        RuntimeError::UnknownProvider(name) | RuntimeError::ProviderNotEnabled(name) => {
            ApiError::bad_request("INVALID_PROVIDER", format!("Unsupported provider: {name}"))
        }
        RuntimeError::ReadConfigFile { .. }
        | RuntimeError::ParseConfig(_)
        | RuntimeError::InvalidProviderConfig { .. } => ApiError::internal(
            "INTERNAL_CONFIG_ERROR",
            format!("Failed to load provider config: {error}"),
        ),
    }
}
