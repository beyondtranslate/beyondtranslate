use serde::{Deserialize, Serialize};

use super::TextTranslation;

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct TranslateResponse {
    pub translations: Vec<TextTranslation>,
}
