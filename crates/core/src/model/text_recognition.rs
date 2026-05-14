use serde::{Deserialize, Serialize};

use super::RecognizedRect;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TextRecognition {
    pub text: String,
    pub recognized_rect: Option<RecognizedRect>,
}
