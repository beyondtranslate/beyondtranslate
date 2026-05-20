//! UniFFI remote-type mirrors for the shared `beyondtranslate_core` crate.
//!
//! `beyondtranslate_core` is a plain Rust crate with no uniffi annotations, so
//! its records can be reused by non-uniffi consumers (e.g. the Cloudflare
//! Worker in `apps/api`). To still expose those records to Dart/Swift through
//! this crate, we register them here as
//! [remote types](https://mozilla.github.io/uniffi-rs/0.31/types/remote_ext_types.html).
//!
//! Each block below is a "shadow definition" whose body must mirror the real
//! struct field-by-field. The `#[uniffi::remote(Record)]` attribute consumes
//! that body to emit the FFI scaffolding (`FfiConverter`, metadata, ...) but
//! *does not* re-emit the struct itself, so the accompanying `type` alias is
//! what ultimately resolves the name back to `beyondtranslate_core`.
//!
//! Because all of these mirrors live in this crate they end up in this
//! crate's UniFFI namespace, which is why the generated Swift/Dart/header
//! files all collapse into a single `beyondtranslate_runtime.{dart,swift,h}`
//! pair.
//!
//! When a field is added/removed in `beyondtranslate_core::model`, the
//! matching mirror below MUST be updated to keep the FFI metadata in sync,
//! otherwise the generated bindings will silently corrupt the wire format.

use beyondtranslate_core as core;
use beyondtranslate_engine as engine;

type ProviderCapability = core::ProviderCapability;
#[uniffi::remote(Enum)]
pub enum ProviderCapability {
    Dictionary,
    Ocr,
    Translation,
}

type ProviderType = engine::ProviderType;
#[uniffi::remote(Enum)]
pub enum ProviderType {
    Baidu,
    Caiyun,
    DeepL,
    Google,
    Iciba,
    Tencent,
    Youdao,
    System,
}

type DetectLanguageRequest = core::DetectLanguageRequest;
#[uniffi::remote(Record)]
pub struct DetectLanguageRequest {
    pub texts: Vec<String>,
}

type TextDetection = core::TextDetection;
#[uniffi::remote(Record)]
pub struct TextDetection {
    pub detected_language: String,
    pub text: String,
}

type DetectLanguageResponse = core::DetectLanguageResponse;
#[uniffi::remote(Record)]
pub struct DetectLanguageResponse {
    pub detections: Option<Vec<TextDetection>>,
}

type LanguagePair = core::LanguagePair;
#[uniffi::remote(Record)]
pub struct LanguagePair {
    pub source_language: Option<String>,
    pub source_language_id: Option<String>,
    pub target_language: Option<String>,
    pub target_language_id: Option<String>,
}

type LookUpRequest = core::LookUpRequest;
#[uniffi::remote(Record)]
pub struct LookUpRequest {
    pub source_language: String,
    pub target_language: String,
    pub word: String,
}

type TextTranslation = core::TextTranslation;
#[uniffi::remote(Record)]
pub struct TextTranslation {
    pub detected_source_language: Option<String>,
    pub text: String,
    pub audio_url: Option<String>,
}

type WordDefinition = core::WordDefinition;
#[uniffi::remote(Record)]
pub struct WordDefinition {
    pub r#type: Option<String>,
    pub name: Option<String>,
    pub values: Option<Vec<String>>,
}

type WordImage = core::WordImage;
#[uniffi::remote(Record)]
pub struct WordImage {
    pub url: String,
}

type WordEtymology = core::WordEtymology;
#[uniffi::remote(Record)]
pub struct WordEtymology {
    pub origin: Option<String>,
    pub root: Option<Vec<String>>,
}

type WordPhrase = core::WordPhrase;
#[uniffi::remote(Record)]
pub struct WordPhrase {
    pub text: String,
    pub translations: Vec<String>,
}

type WordSynonym = core::WordSynonym;
#[uniffi::remote(Record)]
pub struct WordSynonym {
    pub r#type: Option<String>,
    pub word: String,
    pub definitions: Option<Vec<String>>,
}

type WordPronunciation = core::WordPronunciation;
#[uniffi::remote(Record)]
pub struct WordPronunciation {
    pub r#type: Option<String>,
    pub phonetic_symbol: Option<String>,
    pub audio_url: Option<String>,
}

type WordSentence = core::WordSentence;
#[uniffi::remote(Record)]
pub struct WordSentence {
    pub text: String,
    pub translations: Vec<String>,
}

type WordTag = core::WordTag;
#[uniffi::remote(Record)]
pub struct WordTag {
    pub name: String,
}

type WordTense = core::WordTense;
#[uniffi::remote(Record)]
pub struct WordTense {
    pub r#type: Option<String>,
    pub name: Option<String>,
    pub values: Option<Vec<String>>,
}

type LookUpResponse = core::LookUpResponse;
#[uniffi::remote(Record)]
pub struct LookUpResponse {
    pub translations: Vec<TextTranslation>,
    pub word: Option<String>,
    pub tip: Option<String>,
    pub tags: Option<Vec<WordTag>>,
    pub definitions: Option<Vec<WordDefinition>>,
    pub pronunciations: Option<Vec<WordPronunciation>>,
    pub images: Option<Vec<WordImage>>,
    pub phrases: Option<Vec<WordPhrase>>,
    pub tenses: Option<Vec<WordTense>>,
    pub sentences: Option<Vec<WordSentence>>,
    pub etymology: Option<Vec<WordEtymology>>,
    pub synonyms: Option<Vec<WordSynonym>>,
}

type TranslateRequest = core::TranslateRequest;
#[uniffi::remote(Record)]
pub struct TranslateRequest {
    pub source_language: Option<String>,
    pub target_language: Option<String>,
    pub text: String,
}

type TranslateResponse = core::TranslateResponse;
#[uniffi::remote(Record)]
pub struct TranslateResponse {
    pub translations: Vec<TextTranslation>,
}

type RecognizedRect = core::RecognizedRect;
#[uniffi::remote(Record)]
pub struct RecognizedRect {
    pub x: f64,
    pub y: f64,
    pub width: f64,
    pub height: f64,
    pub top: Option<f64>,
    pub right: Option<f64>,
    pub bottom: Option<f64>,
    pub left: Option<f64>,
}

type TextRecognition = core::TextRecognition;
#[uniffi::remote(Record)]
pub struct TextRecognition {
    pub text: String,
    pub recognized_rect: Option<RecognizedRect>,
}

type RecognizeTextRequest = core::RecognizeTextRequest;
#[uniffi::remote(Record)]
pub struct RecognizeTextRequest {
    pub image_path: Option<String>,
    pub base64_image: Option<String>,
}

type RecognizeTextResponse = core::RecognizeTextResponse;
#[uniffi::remote(Record)]
pub struct RecognizeTextResponse {
    pub text: String,
    pub recognitions: Option<Vec<TextRecognition>>,
}
