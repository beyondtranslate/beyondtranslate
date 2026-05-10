use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct WordPronunciation {
    pub r#type: Option<String>,
    pub phonetic_symbol: Option<String>,
    pub audio_url: Option<String>,
}
