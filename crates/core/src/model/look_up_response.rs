use serde::{Deserialize, Serialize};

use super::{
    TextTranslation, WordDefinition, WordEtymology, WordImage, WordPhrase, WordPronunciation,
    WordSentence, WordSynonym, WordTag, WordTense,
};

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
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
