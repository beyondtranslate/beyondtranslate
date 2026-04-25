use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct WordDefinition {
    pub r#type: Option<String>,
    pub name: Option<String>,
    pub values: Option<Vec<String>>,
}
