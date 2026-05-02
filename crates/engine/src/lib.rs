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
pub use provider::{
    BaiduProviderConfig, CaiyunProviderConfig, DeepLProviderConfig, GoogleProviderConfig,
    IcibaProviderConfig, TencentProviderConfig, YoudaoProviderConfig,
};

#[cfg(test)]
mod tests;
