use serde::{Deserialize, Serialize};

use super::TextDetection;

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct DetectLanguageResponse {
    pub detections: Option<Vec<TextDetection>>,
}
