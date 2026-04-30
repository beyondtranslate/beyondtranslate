use crate::{DictionaryService, TranslationService};

pub trait Provider: Send + Sync {
    fn name(&self) -> &'static str;

    fn translation(&self) -> Option<&dyn TranslationService> {
        None
    }

    fn dictionary(&self) -> Option<&dyn DictionaryService> {
        None
    }
}
