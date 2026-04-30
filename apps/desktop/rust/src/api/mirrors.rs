pub use beyondtranslate_core::{
    LookUpRequest, LookUpResponse, TextTranslation, TranslateRequest, TranslateResponse,
    WordDefinition, WordImage, WordPhrase, WordPronunciation, WordSentence, WordTag, WordTense,
};
use flutter_rust_bridge::frb;

#[frb(mirror(TextTranslation))]
pub struct _TextTranslation {
    pub detected_source_language: Option<String>,
    pub text: String,
    pub audio_url: Option<String>,
}

#[frb(mirror(WordDefinition))]
pub struct _WordDefinition {
    pub r#type: Option<String>,
    pub name: Option<String>,
    pub values: Option<Vec<String>>,
}

#[frb(mirror(WordPronunciation))]
pub struct _WordPronunciation {
    pub r#type: Option<String>,
    pub phonetic_symbol: Option<String>,
    pub audio_url: Option<String>,
}

#[frb(mirror(WordTense))]
pub struct _WordTense {
    pub r#type: Option<String>,
    pub name: Option<String>,
    pub values: Option<Vec<String>>,
}

#[frb(mirror(WordTag))]
pub struct _WordTag {
    pub name: String,
}

#[frb(mirror(WordImage))]
pub struct _WordImage {
    pub url: String,
}

#[frb(mirror(WordPhrase))]
pub struct _WordPhrase {
    pub text: String,
    pub translations: Vec<String>,
}

#[frb(mirror(WordSentence))]
pub struct _WordSentence {
    pub text: String,
    pub translations: Vec<String>,
}

#[frb(mirror(TranslateRequest))]
pub struct _TranslateRequest {
    pub source_language: Option<String>,
    pub target_language: Option<String>,
    pub text: String,
}

#[frb(mirror(TranslateResponse))]
pub struct _TranslateResponse {
    pub translations: Vec<TextTranslation>,
}

#[frb(mirror(LookUpRequest))]
pub struct _LookUpRequest {
    pub source_language: String,
    pub target_language: String,
    pub word: String,
}

#[frb(mirror(LookUpResponse))]
pub struct _LookUpResponse {
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
}
