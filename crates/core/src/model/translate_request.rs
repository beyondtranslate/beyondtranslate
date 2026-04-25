use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct TranslateRequest {
    pub source_language: Option<String>,
    pub target_language: Option<String>,
    pub text: String,
}
