use std::{
    collections::{BTreeMap, HashMap},
    fs,
    path::Path,
    sync::Arc,
};

use beyondtranslate_core::{DictionaryService, Provider, TranslationService};
use serde::{Deserialize, Serialize};
use serde_yaml::{Mapping, Value};
use thiserror::Error;

#[cfg(feature = "baidu")]
use crate::provider::BaiduProvider;
use crate::provider::BaiduProviderConfig;
#[cfg(feature = "caiyun")]
use crate::provider::CaiyunProvider;
use crate::provider::CaiyunProviderConfig;
use crate::provider::DeepLProvider;
use crate::provider::DeepLProviderConfig;
#[cfg(feature = "google")]
use crate::provider::GoogleProvider;
use crate::provider::GoogleProviderConfig;
#[cfg(feature = "iciba")]
use crate::provider::IcibaProvider;
use crate::provider::IcibaProviderConfig;
#[cfg(feature = "tencent")]
use crate::provider::TencentProvider;
use crate::provider::TencentProviderConfig;
#[cfg(feature = "youdao")]
use crate::provider::YoudaoProvider;
use crate::provider::YoudaoProviderConfig;

// ── Error ─────────────────────────────────────────────────────────────────────

#[derive(Debug, Error)]
pub enum EngineError {
    #[error("failed to read config file `{path}`: {source}")]
    ReadConfigFile {
        path: String,
        #[source]
        source: std::io::Error,
    },
    #[error("failed to parse config yaml: {0}")]
    ParseConfig(#[from] serde_yaml::Error),
    #[error("provider `{0}` is not supported")]
    UnknownProvider(String),
    #[error("provider `{0}` is not enabled in this build")]
    ProviderNotEnabled(String),
    #[error("provider `{provider}` config is invalid: {source}")]
    InvalidProviderConfig {
        provider: String,
        #[source]
        source: serde_yaml::Error,
    },
    #[error("provider `{provider}` config validation failed: {reason}")]
    ConfigValidationFailed { provider: String, reason: String },
    #[error("provider `{0}` does not support translation")]
    TranslationNotSupported(String),
    #[error("provider `{0}` does not support dictionary lookup")]
    DictionaryNotSupported(String),
}

// ── Registry ──────────────────────────────────────────────────────────────────

#[derive(Default)]
pub struct Engine {
    providers: HashMap<String, Arc<dyn Provider>>,
}

impl std::fmt::Debug for Engine {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Engine")
            .field("names", &self.names())
            .finish()
    }
}

impl Engine {
    pub fn new() -> Self {
        Self::default()
    }

    /// Returns the translation service for the named provider.
    pub fn translation(&self, name: &str) -> Result<&dyn TranslationService, EngineError> {
        self.require(name)?
            .translation()
            .ok_or_else(|| EngineError::TranslationNotSupported(name.to_owned()))
    }

    /// Returns the dictionary service for the named provider.
    pub fn dictionary(&self, name: &str) -> Result<&dyn DictionaryService, EngineError> {
        self.require(name)?
            .dictionary()
            .ok_or_else(|| EngineError::DictionaryNotSupported(name.to_owned()))
    }

    /// Returns the raw provider by name. Prefer [`translation`] or [`dictionary`] for normal use.
    pub fn require(&self, name: &str) -> Result<&Arc<dyn Provider>, EngineError> {
        self.providers
            .get(name)
            .ok_or_else(|| EngineError::UnknownProvider(name.to_owned()))
    }

    /// Lists all registered provider names in alphabetical order.
    pub fn names(&self) -> Vec<&str> {
        let mut names = self
            .providers
            .keys()
            .map(String::as_str)
            .collect::<Vec<_>>();
        names.sort_unstable();
        names
    }

    pub(crate) fn insert(&mut self, provider_id: String, provider: Arc<dyn Provider>) {
        self.providers.insert(provider_id, provider);
    }
}

// ── Builder ───────────────────────────────────────────────────────────────────

#[derive(Clone, Copy, Debug, Deserialize, Eq, PartialEq, Serialize)]
pub enum ProviderType {
    #[serde(rename = "baidu")]
    Baidu,
    #[serde(rename = "caiyun")]
    Caiyun,
    #[serde(rename = "deepl")]
    DeepL,
    #[serde(rename = "google")]
    Google,
    #[serde(rename = "iciba")]
    Iciba,
    #[serde(rename = "tencent")]
    Tencent,
    #[serde(rename = "youdao")]
    Youdao,
}

impl ProviderType {
    pub fn as_str(self) -> &'static str {
        match self {
            Self::Baidu => "baidu",
            Self::Caiyun => "caiyun",
            Self::DeepL => "deepl",
            Self::Google => "google",
            Self::Iciba => "iciba",
            Self::Tencent => "tencent",
            Self::Youdao => "youdao",
        }
    }
}

#[derive(Clone, Debug, Deserialize, PartialEq, Serialize)]
pub struct ProviderConfig {
    #[serde(rename = "type")]
    pub provider_type: ProviderType,
    #[serde(flatten, default)]
    pub options: BTreeMap<String, Value>,
}

impl ProviderConfig {
    pub fn decode<T>(&self, provider_id: &str) -> Result<T, EngineError>
    where
        T: for<'de> Deserialize<'de>,
    {
        serde_yaml::from_value::<T>(self.options_value()).map_err(|source| {
            EngineError::InvalidProviderConfig {
                provider: provider_id.to_owned(),
                source,
            }
        })
    }

    pub fn options_value(&self) -> Value {
        let mut mapping = Mapping::new();
        for (key, value) in &self.options {
            mapping.insert(Value::String(key.clone()), value.clone());
        }
        Value::Mapping(mapping)
    }
}

macro_rules! build_provider_fn {
    ($fn_name:ident, $feature:literal, $Provider:ty, $Config:ty) => {
        #[cfg(feature = $feature)]
        fn $fn_name(provider_id: &str, config: $Config) -> Result<Arc<dyn Provider>, EngineError> {
            let provider =
                <$Provider>::new(config).map_err(|reason| EngineError::ConfigValidationFailed {
                    provider: provider_id.to_owned(),
                    reason,
                })?;
            Ok(Arc::new(provider))
        }

        #[cfg(not(feature = $feature))]
        fn $fn_name(provider_id: &str, _config: $Config) -> Result<Arc<dyn Provider>, EngineError> {
            Err(EngineError::ProviderNotEnabled(provider_id.to_owned()))
        }
    };
}

fn build_provider(provider_id: &str, config: ProviderConfig) -> Result<Arc<dyn Provider>, EngineError> {
    match config.provider_type {
        ProviderType::Baidu => build_baidu_provider(provider_id, config.decode(provider_id)?),
        ProviderType::Caiyun => build_caiyun_provider(provider_id, config.decode(provider_id)?),
        ProviderType::DeepL => build_deepl_provider(provider_id, config.decode(provider_id)?),
        ProviderType::Google => build_google_provider(provider_id, config.decode(provider_id)?),
        ProviderType::Iciba => build_iciba_provider(provider_id, config.decode(provider_id)?),
        ProviderType::Tencent => build_tencent_provider(provider_id, config.decode(provider_id)?),
        ProviderType::Youdao => build_youdao_provider(provider_id, config.decode(provider_id)?),
    }
}

build_provider_fn!(
    build_baidu_provider,
    "baidu",
    BaiduProvider,
    BaiduProviderConfig
);
build_provider_fn!(
    build_caiyun_provider,
    "caiyun",
    CaiyunProvider,
    CaiyunProviderConfig
);
build_provider_fn!(
    build_deepl_provider,
    "deepl",
    DeepLProvider,
    DeepLProviderConfig
);
build_provider_fn!(
    build_google_provider,
    "google",
    GoogleProvider,
    GoogleProviderConfig
);
build_provider_fn!(
    build_iciba_provider,
    "iciba",
    IcibaProvider,
    IcibaProviderConfig
);
build_provider_fn!(
    build_tencent_provider,
    "tencent",
    TencentProvider,
    TencentProviderConfig
);
build_provider_fn!(
    build_youdao_provider,
    "youdao",
    YoudaoProvider,
    YoudaoProviderConfig
);

// ── Config ────────────────────────────────────────────────────────────────────

#[derive(Clone, Debug, Default, Deserialize, PartialEq, Serialize)]
pub struct EngineConfig {
    #[serde(default)]
    pub providers: BTreeMap<String, ProviderConfig>,
}

pub fn load_from_file(path: impl AsRef<Path>) -> Result<Engine, EngineError> {
    let path = path.as_ref();
    let content = fs::read_to_string(path).map_err(|source| EngineError::ReadConfigFile {
        path: path.display().to_string(),
        source,
    })?;

    from_yaml_str(&content)
}

pub fn from_yaml_str(content: &str) -> Result<Engine, EngineError> {
    let config: EngineConfig = serde_yaml::from_str(content)?;
    from_config(config)
}

fn from_config(config: EngineConfig) -> Result<Engine, EngineError> {
    let mut registry = Engine::new();

    for (provider_id, config) in config.providers {
        let provider = build_provider(&provider_id, config)?;
        registry.insert(provider_id, provider);
    }

    Ok(registry)
}
