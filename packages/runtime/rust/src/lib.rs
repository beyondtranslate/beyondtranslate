pub mod domain;
mod remote;
pub mod runtime;
pub use runtime::{Runtime, RuntimeDictionary, RuntimeError, RuntimeSettings, RuntimeTranslation};

use beyondtranslate_core::{
    DetectLanguageRequest, DetectLanguageResponse, LanguagePair, LookUpRequest, LookUpResponse,
    TextDetection, TextTranslation, TranslateRequest, TranslateResponse, WordDefinition, WordImage,
    WordPhrase, WordPronunciation, WordSentence, WordTag, WordTense,
};

#[uniffi::export]
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

#[uniffi::export]
pub fn greet(name: String) -> String {
    format!("Hello, {name}!")
}

#[uniffi::export]
pub fn version() -> String {
    env!("CARGO_PKG_VERSION").to_string()
}

#[uniffi::export]
pub fn echo_detect_language_request(request: DetectLanguageRequest) -> DetectLanguageRequest {
    request
}

#[uniffi::export]
pub fn echo_detect_language_response(response: DetectLanguageResponse) -> DetectLanguageResponse {
    response
}

#[uniffi::export]
pub fn echo_language_pair(language_pair: LanguagePair) -> LanguagePair {
    language_pair
}

#[uniffi::export]
pub fn echo_look_up_request(request: LookUpRequest) -> LookUpRequest {
    request
}

#[uniffi::export]
pub fn echo_look_up_response(response: LookUpResponse) -> LookUpResponse {
    response
}

#[uniffi::export]
pub fn echo_text_detection(text_detection: TextDetection) -> TextDetection {
    text_detection
}

#[uniffi::export]
pub fn echo_text_translation(text_translation: TextTranslation) -> TextTranslation {
    text_translation
}

#[uniffi::export]
pub fn echo_translate_request(request: TranslateRequest) -> TranslateRequest {
    request
}

#[uniffi::export]
pub fn echo_translate_response(response: TranslateResponse) -> TranslateResponse {
    response
}

#[uniffi::export]
pub fn echo_word_definition(word_definition: WordDefinition) -> WordDefinition {
    word_definition
}

#[uniffi::export]
pub fn echo_word_image(word_image: WordImage) -> WordImage {
    word_image
}

#[uniffi::export]
pub fn echo_word_phrase(word_phrase: WordPhrase) -> WordPhrase {
    word_phrase
}

#[uniffi::export]
pub fn echo_word_pronunciation(word_pronunciation: WordPronunciation) -> WordPronunciation {
    word_pronunciation
}

#[uniffi::export]
pub fn echo_word_sentence(word_sentence: WordSentence) -> WordSentence {
    word_sentence
}

#[uniffi::export]
pub fn echo_word_tag(word_tag: WordTag) -> WordTag {
    word_tag
}

#[uniffi::export]
pub fn echo_word_tense(word_tense: WordTense) -> WordTense {
    word_tense
}

uniffi::include_scaffolding!("api");
