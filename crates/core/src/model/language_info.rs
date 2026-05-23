use serde::{Deserialize, Serialize};

/// A language known to the translation system.
///
/// The language list is generated from the curated engine language list.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct LanguageInfo {
    /// Language code, e.g. "zh-CN", "en", "ja"
    pub code: String,
    /// Human-readable language name.
    pub local_name: String,
}
