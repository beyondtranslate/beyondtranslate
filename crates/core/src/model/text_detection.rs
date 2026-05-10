use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct TextDetection {
    pub detected_language: String,
    pub text: String,
}
