use std::{collections::HashMap, sync::Arc};

use beyondtranslate_core::Provider;

use crate::RuntimeError;

#[derive(Default)]
pub struct ProviderRegistry {
    providers: HashMap<String, Arc<dyn Provider>>,
}

impl std::fmt::Debug for ProviderRegistry {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("ProviderRegistry")
            .field("names", &self.names())
            .finish()
    }
}

impl ProviderRegistry {
    pub fn new() -> Self {
        Self::default()
    }

    pub fn get(&self, name: &str) -> Option<&Arc<dyn Provider>> {
        self.providers.get(name)
    }

    pub fn require(&self, name: &str) -> Result<&Arc<dyn Provider>, RuntimeError> {
        self.get(name)
            .ok_or_else(|| RuntimeError::UnknownProvider(name.to_owned()))
    }

    pub fn names(&self) -> Vec<&str> {
        let mut names = self
            .providers
            .keys()
            .map(String::as_str)
            .collect::<Vec<_>>();
        names.sort_unstable();
        names
    }

    pub(crate) fn insert(&mut self, name: String, provider: Arc<dyn Provider>) {
        self.providers.insert(name, provider);
    }
}
