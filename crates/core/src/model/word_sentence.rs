use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct WordSentence {
    pub text: String,
    pub translations: Vec<String>,
}
