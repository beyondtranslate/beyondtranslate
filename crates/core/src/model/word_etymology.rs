use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct WordEtymology {
    /// Free-text description of the word's origin / history.
    /// e.g. "From Old English 'cild', of Germanic origin."
    pub origin: Option<String>,
    /// Word roots, e.g. ["拉丁语词根: \"dict-\"", "古希腊语: \"demos\""]
    pub root: Option<Vec<String>>,
}
