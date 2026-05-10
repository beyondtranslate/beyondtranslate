use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[cfg_attr(feature = "uniffi", derive(uniffi::Record))]
pub struct TranslateRequest {
    pub source_language: Option<String>,
    pub target_language: Option<String>,
    pub text: String,
}
