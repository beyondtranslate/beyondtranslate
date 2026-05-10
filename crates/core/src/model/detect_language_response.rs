use serde::{Deserialize, Serialize};

use super::TextDetection;

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[cfg_attr(feature = "uniffi", derive(uniffi::Record))]
pub struct DetectLanguageResponse {
    pub detections: Option<Vec<TextDetection>>,
}
