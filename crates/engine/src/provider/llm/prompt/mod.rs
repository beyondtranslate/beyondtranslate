// ── Prompt Templates ─────────────────────────────────────────────────────────
//
// Centralised prompt templates for LLM-based translation and dictionary
// operations.

/// Build a system prompt for word-level translation.
pub fn translate_word_system_prompt(source_lang: &str, target_lang: &str) -> String {
    format!(
        "You are a professional translator and lexicographer. \
         Translate the following word from {source} to {target}. \
         Provide the translation in JSON format with the following fields:\n\
         - \"translations\": array of {{ \"text\": string, \"part_of_speech\": string or null, \"explanation\": string or null }}\n\
         - \"pronunciation\": string or null\n\n\
         Only return valid JSON, no other text.",
        source = source_lang,
        target = target_lang,
    )
}

/// Build a user prompt for word translation.
pub fn translate_word_user_prompt(word: &str) -> String {
    format!("Translate the word: \"{word}\"")
}

/// Build a system prompt for sentence/paragraph translation.
pub fn translate_text_system_prompt(
    source_lang: &str,
    target_lang: &str,
    style: Option<&str>,
) -> String {
    let style_hint = match style {
        Some(s) => format!(
            " Use a {s} style. The output should feel natural and native in {target}.",
            s = s,
            target = target_lang
        ),
        None => format!(
            " The output should feel natural and native in {target}.",
            target = target_lang
        ),
    };

    format!(
        "You are a professional translator. Translate the following text from {source} to {target}. \
         Preserve the original formatting, tone, and meaning. \
         For proper nouns, technical terms, and brand names, keep them in their original form unless \
         a well-established translation exists.{style_hint}\n\n\
         Return the translation in JSON format: \
         {{ \"translations\": [{{ \"text\": string }}] }}\n\
         Only return valid JSON, no other text.",
        source = source_lang,
        target = target_lang,
        style_hint = style_hint,
    )
}

/// Build a user prompt for text translation.
pub fn translate_text_user_prompt(text: &str) -> String {
    format!("Translate the following text:\n\n{text}")
}

/// Build a system prompt for dictionary lookup with rich details.
pub fn dictionary_lookup_system_prompt(source_lang: &str, target_lang: &str) -> String {
    format!(
        "You are a comprehensive dictionary and thesaurus. \
         For the given word in {source}, provide a detailed entry in {target}. \
         Return the result in JSON format with these fields:\n\
         - \"word\": string (the original word)\n\
         - \"pronunciations\": array of {{ \"type\": string (e.g. \"UK\", \"US\"), \"phonetic\": string, \"audio_url\": string or null }}\n\
         - \"definitions\": array of {{ \"type\": string (e.g. \"noun\", \"verb\"), \"meaning\": string, \"examples\": array of strings }}\n\
         - \"synonyms\": array of strings\n\
         - \"antonyms\": array of strings\n\
         - \"phrases\": array of {{ \"text\": string, \"translation\": string }}\n\
         - \"etymology\": string or null\n\
         - \"usage_notes\": string or null\n\n\
         Only return valid JSON, no other text.",
        source = source_lang,
        target = target_lang,
    )
}

/// Build a user prompt for dictionary lookup.
pub fn dictionary_lookup_user_prompt(word: &str) -> String {
    format!("Define and explain the word: \"{word}\"")
}

/// Build a system prompt for translation polishing/rewriting.
pub fn polish_translation_system_prompt(style: &str) -> String {
    format!(
        "You are a professional editor. Rewrite the following translation to be more {style}. \
         Preserve the original meaning but improve the expression, fluency, and naturalness.\n\n\
         Return the polished text as plain text, no JSON wrapper, no explanations."
    )
}

/// Build a system prompt for explaining why a translation was chosen.
pub fn explain_translation_system_prompt() -> String {
    "You are a translation expert. Explain why the given translation was chosen for the source text. \
     Discuss: word choice, grammatical structure adaptation, cultural/localisation considerations, \
     and any trade-offs made. \
     Keep the explanation concise (2-3 paragraphs) and helpful for language learners."
    .to_string()
}

/// Build a system prompt for providing alternative translations.
pub fn alternative_translations_system_prompt(count: u32, style: Option<&str>) -> String {
    let style_hint = style
        .map(|s| format!(" in a {s} style"))
        .unwrap_or_default();
    format!(
        "You are a professional translator. Provide {count} alternative translations \
         for the given source text{style_hint}. Each alternative should be meaningfully different \
         while preserving the original meaning. Explain briefly why each alternative might be preferred.\n\n\
         Return JSON: {{ \"alternatives\": [{{ \"text\": string, \"why\": string }}] }}"
    )
}
