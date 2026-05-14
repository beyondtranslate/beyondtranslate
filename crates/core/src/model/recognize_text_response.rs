use serde::{Deserialize, Serialize};

use super::TextRecognition;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct RecognizeTextResponse {
    pub text: String,
    pub recognitions: Option<Vec<TextRecognition>>,
}
