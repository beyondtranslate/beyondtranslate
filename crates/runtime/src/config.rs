use std::{collections::BTreeMap, fs, path::Path};

use serde::Deserialize;
use serde_yaml::Value;

use crate::{builder::build_provider, ProviderRegistry, RuntimeError};

#[derive(Debug, Deserialize)]
struct RuntimeConfig {
    #[serde(default)]
    providers: BTreeMap<String, Value>,
}

pub fn load_from_file(path: impl AsRef<Path>) -> Result<ProviderRegistry, RuntimeError> {
    let path = path.as_ref();
    let content = fs::read_to_string(path).map_err(|source| RuntimeError::ReadConfigFile {
        path: path.display().to_string(),
        source,
    })?;

    from_yaml_str(&content)
}

pub fn from_yaml_str(content: &str) -> Result<ProviderRegistry, RuntimeError> {
    let config: RuntimeConfig = serde_yaml::from_str(content)?;
    from_config(config)
}

fn from_config(config: RuntimeConfig) -> Result<ProviderRegistry, RuntimeError> {
    let mut registry = ProviderRegistry::new();

    for (name, value) in config.providers {
        let provider = build_provider(&name, value)?;
        registry.insert(name, provider);
    }

    Ok(registry)
}
