use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct WordSynonym {
    /// "synonym" or "antonym", or `None` if unspecified.
    pub r#type: Option<String>,
    /// The related word.
    pub word: String,
    /// Optional shared definitions to distinguish different senses.
    /// e.g. for "happy": synonyms might be grouped by meaning.
    pub definitions: Option<Vec<String>>,
}
