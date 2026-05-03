mod common;
mod engine;
mod provider;

pub use beyondtranslate_core::{
    DictionaryError, DictionaryService, Provider, ProviderCapability, TranslationError,
    TranslationService,
};
pub use engine::{
    from_yaml_str, load_from_file, Engine, EngineConfig, EngineError, ProviderConfig, ProviderType,
};
#[cfg(feature = "baidu")]
pub use provider::BaiduProvider;
#[cfg(feature = "caiyun")]
pub use provider::CaiyunProvider;
pub use provider::DeepLProvider;
#[cfg(feature = "google")]
pub use provider::GoogleProvider;
#[cfg(feature = "iciba")]
pub use provider::IcibaProvider;
#[cfg(feature = "tencent")]
pub use provider::TencentProvider;
#[cfg(feature = "youdao")]
pub use provider::YoudaoProvider;
pub use provider::{
    BaiduProviderConfig, CaiyunProviderConfig, DeepLProviderConfig, GoogleProviderConfig,
    IcibaProviderConfig, TencentProviderConfig, YoudaoProviderConfig,
};

#[cfg(test)]
mod tests;
