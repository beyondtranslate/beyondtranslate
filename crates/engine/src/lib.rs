mod common;
mod engine;
mod languages;
mod provider;

pub use provider::llm::prompt;

pub use beyondtranslate_core::{
    DictionaryError, DictionaryService, OcrError, OcrService, Provider, ProviderCapability,
    TranslationError, TranslationService,
};
pub use engine::{
    from_yaml_str, load_from_file, Engine, EngineConfig, EngineError, ProviderConfig, ProviderType,
};
pub use languages::{all_languages, app_languages};
#[cfg(feature = "baidu")]
pub use provider::BaiduProvider;
#[cfg(feature = "caiyun")]
pub use provider::CaiyunProvider;
pub use provider::DeepLProvider;
#[cfg(feature = "google")]
pub use provider::GoogleProvider;
#[cfg(feature = "iciba")]
pub use provider::IcibaProvider;
pub use provider::SystemProvider;
pub use provider::SystemTranslationService;
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
