use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[cfg_attr(feature = "uniffi", derive(uniffi::Record))]
pub struct TextTranslation {
    pub detected_source_language: Option<String>,
    pub text: String,
    pub audio_url: Option<String>,
}
