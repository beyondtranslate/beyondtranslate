use std::collections::BTreeMap;

use beyondtranslate_engine::{Engine, EngineConfig, ProviderConfig};

use crate::domain::settings::{provider_config_from_settings, Settings};

pub fn build_from_settings(settings: &Settings) -> Result<Engine, String> {
    let mut providers = BTreeMap::new();
    for (provider_id, provider) in &settings.providers {
        let provider_id = provider_id.trim();
        if provider_id.is_empty() {
            return Err("provider id is required".to_owned());
        }

        providers.insert(
            provider_id.to_owned(),
            provider_config_from_settings(provider)?,
        );
    }

    build_from_engine_config(&EngineConfig { providers })
}

pub fn build_from_engine_config(config: &EngineConfig) -> Result<Engine, String> {
    let config_text = serde_yaml::to_string(config)
        .map_err(|error| format!("failed to encode engine config yaml: {error}"))?;
    beyondtranslate_engine::from_yaml_str(&config_text).map_err(|error| error.to_string())
}

pub fn build_from_provider_config(
    provider_id: &str,
    provider_config_text: &str,
) -> Result<Engine, String> {
    let provider_id = provider_id.trim();
    if provider_id.is_empty() {
        return Err("provider_id is required".to_owned());
    }

    let provider_config = parse_provider_config(provider_config_text)?;
    let mut providers = BTreeMap::new();
    providers.insert(provider_id.to_owned(), provider_config);

    build_from_engine_config(&EngineConfig { providers })
}

pub fn parse_provider_config(input: &str) -> Result<ProviderConfig, String> {
    serde_yaml::from_str::<ProviderConfig>(input)
        .map_err(|error| format!("invalid provider config: {error}"))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parse_provider_config_requires_type_tag() {
        let error = parse_provider_config("api_key: test-key").unwrap_err();
        assert!(error.contains("type"));
    }

    #[test]
    fn build_from_provider_config_registers_provider() {
        let engine =
            build_from_provider_config("deepl-main", "type: deepl\napi_key: test-key").unwrap();
        assert_eq!(engine.names(), vec!["deepl-main"]);
    }
}
