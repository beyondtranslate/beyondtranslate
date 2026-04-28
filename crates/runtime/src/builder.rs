use std::sync::Arc;

use beyondtranslate_core::Provider;
#[cfg(feature = "baidu")]
use beyondtranslate_providers::{BaiduProvider, BaiduProviderConfig};
#[cfg(feature = "caiyun")]
use beyondtranslate_providers::{CaiyunProvider, CaiyunProviderConfig};
#[cfg(feature = "deepl")]
use beyondtranslate_providers::{DeepLProvider, DeepLProviderConfig};
#[cfg(feature = "google")]
use beyondtranslate_providers::{GoogleProvider, GoogleProviderConfig};
#[cfg(feature = "iciba")]
use beyondtranslate_providers::{IcibaProvider, IcibaProviderConfig};
#[cfg(feature = "tencent")]
use beyondtranslate_providers::{TencentProvider, TencentProviderConfig};
#[cfg(feature = "youdao")]
use beyondtranslate_providers::{YoudaoProvider, YoudaoProviderConfig};
use serde_yaml::Value;

use crate::RuntimeError;

pub(crate) fn build_provider(name: &str, value: Value) -> Result<Arc<dyn Provider>, RuntimeError> {
    match name {
        "baidu" => build_baidu_provider(name, value),
        "caiyun" => build_caiyun_provider(name, value),
        "deepl" => build_deepl_provider(name, value),
        "google" => build_google_provider(name, value),
        "iciba" => build_iciba_provider(name, value),
        "tencent" => build_tencent_provider(name, value),
        "youdao" => build_youdao_provider(name, value),
        _ => Err(RuntimeError::UnknownProvider(name.to_owned())),
    }
}

#[cfg(feature = "baidu")]
fn build_baidu_provider(name: &str, value: Value) -> Result<Arc<dyn Provider>, RuntimeError> {
    let config = serde_yaml::from_value::<BaiduProviderConfig>(value).map_err(|source| {
        RuntimeError::InvalidProviderConfig {
            provider: name.to_owned(),
            source,
        }
    })?;
    Ok(Arc::new(BaiduProvider::new(config)))
}

#[cfg(not(feature = "baidu"))]
fn build_baidu_provider(name: &str, _value: Value) -> Result<Arc<dyn Provider>, RuntimeError> {
    Err(RuntimeError::ProviderNotEnabled(name.to_owned()))
}

#[cfg(feature = "caiyun")]
fn build_caiyun_provider(name: &str, value: Value) -> Result<Arc<dyn Provider>, RuntimeError> {
    let config = serde_yaml::from_value::<CaiyunProviderConfig>(value).map_err(|source| {
        RuntimeError::InvalidProviderConfig {
            provider: name.to_owned(),
            source,
        }
    })?;
    Ok(Arc::new(CaiyunProvider::new(config)))
}

#[cfg(not(feature = "caiyun"))]
fn build_caiyun_provider(name: &str, _value: Value) -> Result<Arc<dyn Provider>, RuntimeError> {
    Err(RuntimeError::ProviderNotEnabled(name.to_owned()))
}

#[cfg(feature = "deepl")]
fn build_deepl_provider(name: &str, value: Value) -> Result<Arc<dyn Provider>, RuntimeError> {
    let config = serde_yaml::from_value::<DeepLProviderConfig>(value).map_err(|source| {
        RuntimeError::InvalidProviderConfig {
            provider: name.to_owned(),
            source,
        }
    })?;
    Ok(Arc::new(DeepLProvider::new(config)))
}

#[cfg(not(feature = "deepl"))]
fn build_deepl_provider(name: &str, _value: Value) -> Result<Arc<dyn Provider>, RuntimeError> {
    Err(RuntimeError::ProviderNotEnabled(name.to_owned()))
}

#[cfg(feature = "google")]
fn build_google_provider(name: &str, value: Value) -> Result<Arc<dyn Provider>, RuntimeError> {
    let config = serde_yaml::from_value::<GoogleProviderConfig>(value).map_err(|source| {
        RuntimeError::InvalidProviderConfig {
            provider: name.to_owned(),
            source,
        }
    })?;
    Ok(Arc::new(GoogleProvider::new(config)))
}

#[cfg(not(feature = "google"))]
fn build_google_provider(name: &str, _value: Value) -> Result<Arc<dyn Provider>, RuntimeError> {
    Err(RuntimeError::ProviderNotEnabled(name.to_owned()))
}

#[cfg(feature = "iciba")]
fn build_iciba_provider(name: &str, value: Value) -> Result<Arc<dyn Provider>, RuntimeError> {
    let config = serde_yaml::from_value::<IcibaProviderConfig>(value).map_err(|source| {
        RuntimeError::InvalidProviderConfig {
            provider: name.to_owned(),
            source,
        }
    })?;
    Ok(Arc::new(IcibaProvider::new(config)))
}

#[cfg(not(feature = "iciba"))]
fn build_iciba_provider(name: &str, _value: Value) -> Result<Arc<dyn Provider>, RuntimeError> {
    Err(RuntimeError::ProviderNotEnabled(name.to_owned()))
}

#[cfg(feature = "tencent")]
fn build_tencent_provider(name: &str, value: Value) -> Result<Arc<dyn Provider>, RuntimeError> {
    let config = serde_yaml::from_value::<TencentProviderConfig>(value).map_err(|source| {
        RuntimeError::InvalidProviderConfig {
            provider: name.to_owned(),
            source,
        }
    })?;
    Ok(Arc::new(TencentProvider::new(config)))
}

#[cfg(not(feature = "tencent"))]
fn build_tencent_provider(name: &str, _value: Value) -> Result<Arc<dyn Provider>, RuntimeError> {
    Err(RuntimeError::ProviderNotEnabled(name.to_owned()))
}

#[cfg(feature = "youdao")]
fn build_youdao_provider(name: &str, value: Value) -> Result<Arc<dyn Provider>, RuntimeError> {
    let config = serde_yaml::from_value::<YoudaoProviderConfig>(value).map_err(|source| {
        RuntimeError::InvalidProviderConfig {
            provider: name.to_owned(),
            source,
        }
    })?;
    Ok(Arc::new(YoudaoProvider::new(config)))
}

#[cfg(not(feature = "youdao"))]
fn build_youdao_provider(name: &str, _value: Value) -> Result<Arc<dyn Provider>, RuntimeError> {
    Err(RuntimeError::ProviderNotEnabled(name.to_owned()))
}
