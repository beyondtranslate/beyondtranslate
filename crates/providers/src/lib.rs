#[cfg(feature = "baidu")]
pub mod baidu;
#[cfg(feature = "caiyun")]
pub mod caiyun;
#[cfg(feature = "deepl")]
pub mod deepl;
#[cfg(feature = "google")]
pub mod google;
#[cfg(feature = "iciba")]
pub mod iciba;
#[cfg(feature = "tencent")]
pub mod tencent;
#[cfg(feature = "youdao")]
pub mod youdao;

#[cfg(feature = "baidu")]
pub use baidu::{BaiduProvider, BaiduProviderConfig};
#[cfg(feature = "caiyun")]
pub use caiyun::{CaiyunProvider, CaiyunProviderConfig};
#[cfg(feature = "deepl")]
pub use deepl::{DeepLProvider, DeepLProviderConfig};
#[cfg(feature = "google")]
pub use google::{GoogleProvider, GoogleProviderConfig};
#[cfg(feature = "iciba")]
pub use iciba::{IcibaProvider, IcibaProviderConfig};
#[cfg(feature = "tencent")]
pub use tencent::{TencentProvider, TencentProviderConfig};
#[cfg(feature = "youdao")]
pub use youdao::{YoudaoProvider, YoudaoProviderConfig};
