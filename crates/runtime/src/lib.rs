mod builder;
mod config;
mod error;
mod registry;

#[cfg(feature = "baidu")]
pub use beyondtranslate_providers::{BaiduProvider, BaiduProviderConfig};
#[cfg(feature = "caiyun")]
pub use beyondtranslate_providers::{CaiyunProvider, CaiyunProviderConfig};
#[cfg(feature = "deepl")]
pub use beyondtranslate_providers::{DeepLProvider, DeepLProviderConfig};
#[cfg(feature = "google")]
pub use beyondtranslate_providers::{GoogleProvider, GoogleProviderConfig};
#[cfg(feature = "iciba")]
pub use beyondtranslate_providers::{IcibaProvider, IcibaProviderConfig};
#[cfg(feature = "tencent")]
pub use beyondtranslate_providers::{TencentProvider, TencentProviderConfig};
#[cfg(feature = "youdao")]
pub use beyondtranslate_providers::{YoudaoProvider, YoudaoProviderConfig};
pub use config::{from_yaml_str, load_from_file};
pub use error::RuntimeError;
pub use registry::ProviderRegistry;

#[cfg(test)]
mod tests;
