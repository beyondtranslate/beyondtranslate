use std::collections::BTreeMap;

use beyondtranslate_engine::{Engine, EngineConfig};
use serde_yaml::{Mapping, Value};

use crate::domain::settings::Settings;

pub fn build_from_settings(settings: &Settings) -> Result<Engine, String> {
    build_from_engine_config(&settings.engine)
}

pub fn build_from_engine_config(config: &EngineConfig) -> Result<Engine, String> {
    let config_yaml = serde_yaml::to_string(config)
        .map_err(|error| format!("failed to encode engine config yaml: {error}"))?;
    beyondtranslate_engine::from_yaml_str(&config_yaml).map_err(|error| error.to_string())
}

pub fn build_from_provider_config(
    provider_type: &str,
    provider_config_yaml: &str,
) -> Result<Engine, String> {
    let provider_type = provider_type.trim();
    if provider_type.is_empty() {
        return Err("provider_type is required".to_owned());
    }

    let provider_config = parse_provider_config(provider_config_yaml)?;
    let mut providers = Mapping::new();
    providers.insert(Value::String(provider_type.to_owned()), provider_config);

    let mut root = BTreeMap::new();
    root.insert("providers", Value::Mapping(providers));

    let config_yaml = serde_yaml::to_string(&root)
        .map_err(|error| format!("failed to encode runtime config yaml: {error}"))?;

    beyondtranslate_engine::from_yaml_str(&config_yaml).map_err(|error| error.to_string())
}

fn parse_provider_config(input: &str) -> Result<Value, String> {
    let value = serde_yaml::from_str::<Value>(input)
        .map_err(|error| format!("invalid provider config yaml: {error}"))?;

    match value {
        Value::Mapping(_) => Ok(value),
        _ => Err("provider config yaml must decode to a mapping/object".to_owned()),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parse_provider_config_requires_mapping() {
        let error = parse_provider_config("- just\n- a\n- list").unwrap_err();
        assert_eq!(
            error,
            "provider config yaml must decode to a mapping/object"
        );
    }

    #[test]
    fn build_from_provider_config_registers_provider() {
        let engine = build_from_provider_config("deepl", "api_key: test-key").unwrap();
        assert_eq!(engine.names(), vec!["deepl"]);
    }
}
