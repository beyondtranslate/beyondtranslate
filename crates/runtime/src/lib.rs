mod config;
mod factory;

use beyondtranslate_core::{DictionaryResult, TranslationResult};

pub use config::{DictionaryProviderConfig, TranslationProviderConfig};
pub use factory::{create_dictionary, create_translator};
pub type RuntimeResult<T> = TranslationResult<T>;
pub type DictionaryRuntimeResult<T> = DictionaryResult<T>;
