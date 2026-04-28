use std::sync::Arc;

use beyondtranslate_core::Provider;
use beyondtranslate_runtime::{from_yaml_str, ProviderRegistry, RuntimeError};
use worker::Env;

use crate::ApiError;

const CONFIG_YAML: &str = include_str!("../config.yaml");

pub fn load_provider(env: &Env, name: &str) -> Result<Arc<dyn Provider>, ApiError> {
    let registry = load_registry(env)?;

    registry
        .require(name)
        .cloned()
        .map_err(runtime_error_to_api_error)
}

fn load_registry(env: &Env) -> Result<ProviderRegistry, ApiError> {
    let rendered = render_runtime_config(CONFIG_YAML, |key| {
        env.var(key).ok().map(|value| value.to_string())
    });

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

fn render_runtime_config<F>(template: &str, lookup: F) -> String
where
    F: Fn(&str) -> Option<String>,
{
    let mut rendered = String::with_capacity(template.len());
    let mut chars = template.chars().peekable();

    while let Some(ch) = chars.next() {
        if ch == '$' && chars.peek() == Some(&'{') {
            chars.next();

            let mut key = String::new();
            while let Some(&next) = chars.peek() {
                chars.next();
                if next == '}' {
                    break;
                }
                key.push(next);
            }

            if key.is_empty() {
                rendered.push_str("null");
            } else if let Some(value) = lookup(&key) {
                rendered.push_str(&value);
            } else {
                rendered.push_str("null");
            }

            continue;
        }

        rendered.push(ch);
    }

    rendered
}

#[cfg(test)]
mod tests;
