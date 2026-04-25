use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct LanguagePair {
    pub source_language: Option<String>,
    pub source_language_id: Option<String>,
    pub target_language: Option<String>,
    pub target_language_id: Option<String>,
}
