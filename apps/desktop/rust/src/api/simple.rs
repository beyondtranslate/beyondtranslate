use std::collections::BTreeMap;
use std::future::Future;
use std::thread;

use beyondtranslate_core::{LookUpRequest, TranslateRequest};
use serde::{Deserialize, Serialize};
use serde_yaml::{Mapping, Value};
use tokio::sync::oneshot;

#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct RustTranslateDebugRequest {
    pub provider_type: String,
    pub provider_config_yaml: String,
    pub source_language: Option<String>,
    pub target_language: String,
    pub text: String,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct RustTranslateDebugResponse {
    pub provider_type: String,
    pub translations: Vec<String>,
    pub detected_source_language: Option<String>,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct RustLookupDebugRequest {
    pub provider_type: String,
    pub provider_config_yaml: String,
    pub source_language: String,
    pub target_language: String,
    pub word: String,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct RustLookupDebugResponse {
    pub provider_type: String,
    pub word: Option<String>,
    pub definitions: Vec<String>,
    pub pronunciations: Vec<String>,
    pub tenses: Vec<String>,
}

pub async fn translate_with_runtime(
    request: RustTranslateDebugRequest,
) -> Result<RustTranslateDebugResponse, String> {
    run_on_worker_thread(move || async move { translate_with_runtime_impl(request).await }).await
}

pub async fn lookup_with_runtime(
    request: RustLookupDebugRequest,
) -> Result<RustLookupDebugResponse, String> {
    run_on_worker_thread(move || async move { lookup_with_runtime_impl(request).await }).await
}

async fn translate_with_runtime_impl(
    request: RustTranslateDebugRequest,
) -> Result<RustTranslateDebugResponse, String> {
    let provider_type = request.provider_type.trim().to_owned();
    if provider_type.is_empty() {
        return Err("provider_type is required".to_owned());
    }

    let target_language = request.target_language.trim().to_owned();
    if target_language.is_empty() {
        return Err("target_language is required".to_owned());
    }

    let text = request.text.trim().to_owned();
    if text.is_empty() {
        return Err("text is required".to_owned());
    }

    let provider_config = parse_provider_config(&request.provider_config_yaml)?;
    let registry = load_runtime_registry(&provider_type, provider_config)?;
    let provider = registry
        .require(&provider_type)
        .map_err(|error| error.to_string())?;
    let translation_service = provider
        .translation()
        .ok_or_else(|| format!("provider `{provider_type}` does not support translation"))?;

    let response = translation_service
        .translate(TranslateRequest {
            source_language: request
                .source_language
                .map(|language| language.trim().to_owned())
                .filter(|language| !language.is_empty()),
            target_language: Some(target_language),
            text,
        })
        .await
        .map_err(|error| error.to_string())?;

    Ok(RustTranslateDebugResponse {
        provider_type,
        detected_source_language: response
            .translations
            .first()
            .and_then(|translation| translation.detected_source_language.clone()),
        translations: response
            .translations
            .into_iter()
            .map(|translation| translation.text)
            .collect(),
    })
}

async fn lookup_with_runtime_impl(
    request: RustLookupDebugRequest,
) -> Result<RustLookupDebugResponse, String> {
    let provider_type = request.provider_type.trim().to_owned();
    if provider_type.is_empty() {
        return Err("provider_type is required".to_owned());
    }

    let source_language = request.source_language.trim().to_owned();
    if source_language.is_empty() {
        return Err("source_language is required".to_owned());
    }

    let target_language = request.target_language.trim().to_owned();
    if target_language.is_empty() {
        return Err("target_language is required".to_owned());
    }

    let word = request.word.trim().to_owned();
    if word.is_empty() {
        return Err("word is required".to_owned());
    }

    let provider_config = parse_provider_config(&request.provider_config_yaml)?;
    let registry = load_runtime_registry(&provider_type, provider_config)?;
    let provider = registry
        .require(&provider_type)
        .map_err(|error| error.to_string())?;
    let dictionary_service = provider
        .dictionary()
        .ok_or_else(|| format!("provider `{provider_type}` does not support dictionary lookup"))?;

    let response = dictionary_service
        .look_up(LookUpRequest {
            source_language,
            target_language,
            word,
        })
        .await
        .map_err(|error| error.to_string())?;

    Ok(RustLookupDebugResponse {
        provider_type,
        word: response.word,
        definitions: response
            .definitions
            .unwrap_or_default()
            .into_iter()
            .map(|definition| {
                let name = definition.name.unwrap_or_default();
                let values = definition.values.unwrap_or_default().join(", ");
                match (name.is_empty(), values.is_empty()) {
                    (true, true) => String::new(),
                    (false, true) => name,
                    (true, false) => values,
                    (false, false) => format!("{name} {values}"),
                }
            })
            .filter(|item| !item.is_empty())
            .collect(),
        pronunciations: response
            .pronunciations
            .unwrap_or_default()
            .into_iter()
            .map(|pronunciation| {
                let kind = pronunciation.r#type.unwrap_or_default();
                let symbol = pronunciation.phonetic_symbol.unwrap_or_default();
                let audio_url = pronunciation.audio_url.unwrap_or_default();
                let mut parts = Vec::new();
                if !kind.is_empty() {
                    parts.push(kind);
                }
                if !symbol.is_empty() {
                    parts.push(symbol);
                }
                if !audio_url.is_empty() {
                    parts.push(audio_url);
                }
                parts.join(" | ")
            })
            .filter(|item| !item.is_empty())
            .collect(),
        tenses: response
            .tenses
            .unwrap_or_default()
            .into_iter()
            .map(|tense| {
                let name = tense.name.unwrap_or_default();
                let values = tense.values.unwrap_or_default().join(", ");
                match (name.is_empty(), values.is_empty()) {
                    (true, true) => String::new(),
                    (false, true) => name,
                    (true, false) => values,
                    (false, false) => format!("{name}: {values}"),
                }
            })
            .filter(|item| !item.is_empty())
            .collect(),
    })
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}

fn parse_provider_config(input: &str) -> Result<Value, String> {
    let value = serde_yaml::from_str::<Value>(input)
        .map_err(|error| format!("invalid provider config yaml: {error}"))?;

    match value {
        Value::Mapping(_) => Ok(value),
        _ => Err("provider config yaml must decode to a mapping/object".to_owned()),
    }
}

fn load_runtime_registry(
    provider_type: &str,
    provider_config: Value,
) -> Result<beyondtranslate_runtime::ProviderRegistry, String> {
    let mut providers = Mapping::new();
    providers.insert(Value::String(provider_type.to_owned()), provider_config);

    let mut root = BTreeMap::new();
    root.insert("providers", Value::Mapping(providers));

    let config_yaml = serde_yaml::to_string(&root)
        .map_err(|error| format!("failed to encode runtime config yaml: {error}"))?;

    beyondtranslate_runtime::from_yaml_str(&config_yaml).map_err(|error| error.to_string())
}

async fn run_on_worker_thread<F, Fut, T>(task: F) -> Result<T, String>
where
    F: FnOnce() -> Fut + Send + 'static,
    Fut: Future<Output = Result<T, String>> + 'static,
    T: Send + 'static,
{
    let (sender, receiver) = oneshot::channel();

    thread::Builder::new()
        .name("beyondtranslate-runtime-bridge".to_owned())
        .spawn(move || {
            let result = tokio::runtime::Builder::new_current_thread()
                .enable_all()
                .build()
                .map_err(|error| format!("failed to build tokio runtime: {error}"))
                .and_then(|runtime| runtime.block_on(task()));

            let _ = sender.send(result);
        })
        .map_err(|error| format!("failed to spawn runtime worker thread: {error}"))?;

    receiver
        .await
        .map_err(|error| format!("runtime worker thread ended unexpectedly: {error}"))?
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parse_provider_config_requires_mapping() {
        let error = parse_provider_config("- just\n- a\n- list").unwrap_err();
        assert_eq!(
            error,
            "provider config yaml must decode to a mapping/object"
        );
    }

    #[test]
    fn load_runtime_registry_registers_provider() {
        let registry =
            load_runtime_registry("deepl", parse_provider_config("api_key: test-key").unwrap())
                .unwrap();

        assert_eq!(registry.names(), vec!["deepl"]);
    }

    #[test]
    fn translate_with_runtime_requires_target_language() {
        let error = tokio::runtime::Builder::new_current_thread()
            .enable_all()
            .build()
            .unwrap()
            .block_on(translate_with_runtime(RustTranslateDebugRequest {
                provider_type: "deepl".to_owned(),
                provider_config_yaml: "api_key: test-key".to_owned(),
                source_language: Some("en".to_owned()),
                target_language: String::new(),
                text: "hello".to_owned(),
            }))
            .unwrap_err();

        assert_eq!(error, "target_language is required");
    }

    #[test]
    fn lookup_with_runtime_requires_word() {
        let error = tokio::runtime::Builder::new_current_thread()
            .enable_all()
            .build()
            .unwrap()
            .block_on(lookup_with_runtime(RustLookupDebugRequest {
                provider_type: "iciba".to_owned(),
                provider_config_yaml: "api_key: test-key".to_owned(),
                source_language: "en".to_owned(),
                target_language: "zh".to_owned(),
                word: String::new(),
            }))
            .unwrap_err();

        assert_eq!(error, "word is required");
    }
}
