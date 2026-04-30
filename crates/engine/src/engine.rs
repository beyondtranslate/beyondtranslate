use std::{
    collections::{BTreeMap, HashMap},
    fs,
    path::Path,
    sync::Arc,
};

use beyondtranslate_core::{DictionaryService, Provider, TranslationService};
use serde::{Deserialize, Serialize};
use serde_yaml::Value;
use thiserror::Error;

#[cfg(feature = "baidu")]
use crate::provider::{BaiduProvider, BaiduProviderConfig};
#[cfg(feature = "caiyun")]
use crate::provider::{CaiyunProvider, CaiyunProviderConfig};
#[cfg(feature = "deepl")]
use crate::provider::{DeepLProvider, DeepLProviderConfig};
#[cfg(feature = "google")]
use crate::provider::{GoogleProvider, GoogleProviderConfig};
#[cfg(feature = "iciba")]
use crate::provider::{IcibaProvider, IcibaProviderConfig};
#[cfg(feature = "tencent")]
use crate::provider::{TencentProvider, TencentProviderConfig};
#[cfg(feature = "youdao")]
use crate::provider::{YoudaoProvider, YoudaoProviderConfig};

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

    pub(crate) fn insert(&mut self, name: String, provider: Arc<dyn Provider>) {
        self.providers.insert(name, provider);
    }
}

// ── Builder ───────────────────────────────────────────────────────────────────

macro_rules! build_provider_fn {
    ($fn_name:ident, $feature:literal, $Provider:ty, $Config:ty) => {
        #[cfg(feature = $feature)]
        fn $fn_name(name: &str, value: Value) -> Result<Arc<dyn Provider>, EngineError> {
            let config = serde_yaml::from_value::<$Config>(value).map_err(|source| {
                EngineError::InvalidProviderConfig {
                    provider: name.to_owned(),
                    source,
                }
            })?;
            let provider =
                <$Provider>::new(config).map_err(|reason| EngineError::ConfigValidationFailed {
                    provider: name.to_owned(),
                    reason,
                })?;
            Ok(Arc::new(provider))
        }

        #[cfg(not(feature = $feature))]
        fn $fn_name(name: &str, _value: Value) -> Result<Arc<dyn Provider>, EngineError> {
            Err(EngineError::ProviderNotEnabled(name.to_owned()))
        }
    };
}

fn build_provider(name: &str, value: Value) -> Result<Arc<dyn Provider>, EngineError> {
    match name {
        "baidu" => build_baidu_provider(name, value),
        "caiyun" => build_caiyun_provider(name, value),
        "deepl" => build_deepl_provider(name, value),
        "google" => build_google_provider(name, value),
        "iciba" => build_iciba_provider(name, value),
        "tencent" => build_tencent_provider(name, value),
        "youdao" => build_youdao_provider(name, value),
        _ => Err(EngineError::UnknownProvider(name.to_owned())),
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
    pub providers: BTreeMap<String, Value>,
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

    for (name, value) in config.providers {
        let provider = build_provider(&name, value)?;
        registry.insert(name, provider);
    }

    Ok(registry)
}
