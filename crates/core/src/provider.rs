use crate::{DictionaryService, TranslationService};
use serde::{Deserialize, Serialize};

#[derive(Clone, Debug, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub enum ProviderCapability {
    Translation,
    Dictionary,
}

pub trait Provider: Send + Sync {
    fn name(&self) -> &'static str;

    /// Returns the capabilities of this provider instance.
    /// The default implementation derives capabilities from `translation()` / `dictionary()`.
    fn capabilities(&self) -> Vec<ProviderCapability> {
        let mut caps = Vec::new();
        if self.translation().is_some() {
            caps.push(ProviderCapability::Translation);
        }
        if self.dictionary().is_some() {
            caps.push(ProviderCapability::Dictionary);
        }
        caps
    }

    fn translation(&self) -> Option<&dyn TranslationService> {
        None
    }

    fn dictionary(&self) -> Option<&dyn DictionaryService> {
        None
    }
}
