use serde::{Deserialize, Serialize};

use super::TextTranslation;

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[cfg_attr(feature = "uniffi", derive(uniffi::Record))]
pub struct TranslateResponse {
    pub translations: Vec<TextTranslation>,
}
