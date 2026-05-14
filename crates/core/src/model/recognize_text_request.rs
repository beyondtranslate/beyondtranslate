use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct RecognizeTextRequest {
    pub image_path: Option<String>,
    pub base64_image: Option<String>,
}
