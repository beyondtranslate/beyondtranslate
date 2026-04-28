use crate::{DictionaryService, TranslationService};

pub trait ProviderConfig: Send + Sync {}

pub trait Provider: Send + Sync {
    fn name(&self) -> &'static str;

    fn config(&self) -> &dyn ProviderConfig;

    fn translation(&self) -> Option<&dyn TranslationService> {
        None
    }

    fn dictionary(&self) -> Option<&dyn DictionaryService> {
        None
    }
}
