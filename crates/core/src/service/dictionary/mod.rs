mod error;
mod provider;
mod service;

pub use error::{DictionaryError, DictionaryResult, DictionaryServiceError, DictionaryServiceResult};
pub use provider::DictionaryProvider;
pub use service::DictionaryService;
