use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct LookUpRequest {
    pub source_language: String,
    pub target_language: String,
    pub word: String,
}
