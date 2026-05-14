mod dictionary;
mod ocr;
mod translation;

pub use dictionary::{DictionaryError, DictionaryService};
pub use ocr::{OcrError, OcrService};
pub use translation::{TranslationError, TranslationService};
