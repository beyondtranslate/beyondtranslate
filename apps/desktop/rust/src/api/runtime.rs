use std::future::Future;
use std::sync::Arc;
use std::thread;

use beyondtranslate_core::{LookUpRequest, TranslateRequest};
use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};
use tokio::sync::RwLock;

use crate::domain::engine;
use crate::domain::settings::{RustSettingsDto, Settings};

struct RuntimeState {
    settings: Settings,
    engine: beyondtranslate_engine::Engine,
}

impl RuntimeState {
    fn new(settings: Settings) -> Result<Self, String> {
        let engine = engine::build_from_settings(&settings)?;
        Ok(Self { settings, engine })
    }
}

struct RuntimeInner {
    storage_dir: String,
    state: RwLock<RuntimeState>,
}

#[frb(opaque)]
pub struct Runtime {
    inner: Arc<RuntimeInner>,
}

#[frb(opaque)]
pub struct RuntimeSettings {
    inner: Arc<RuntimeInner>,
}

#[frb(opaque)]
pub struct RuntimeTranslation {
    inner: Arc<RuntimeInner>,
    provider_type: String,
}

#[frb(opaque)]
pub struct RuntimeDictionary {
    inner: Arc<RuntimeInner>,
    provider_type: String,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct RustTranslateRequest {
    pub provider_config_yaml: Option<String>,
    pub source_language: Option<String>,
    pub target_language: String,
    pub text: String,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct RustTranslateResponse {
    pub provider_type: String,
    pub translations: Vec<String>,
    pub detected_source_language: Option<String>,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct RustLookupRequest {
    pub provider_config_yaml: Option<String>,
    pub source_language: String,
    pub target_language: String,
    pub word: String,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct RustLookupResponse {
    pub provider_type: String,
    pub word: Option<String>,
    pub definitions: Vec<String>,
    pub pronunciations: Vec<String>,
    pub tenses: Vec<String>,
}

impl Runtime {
    #[frb(sync)]
    pub fn new(storage_dir: String) -> Result<Self, String> {
        let settings = Settings::load(&storage_dir)?;
        let state = RuntimeState::new(settings)?;
        Ok(Self {
            inner: Arc::new(RuntimeInner {
                storage_dir,
                state: RwLock::new(state),
            }),
        })
    }

    #[frb(sync)]
    pub fn settings(&self) -> RuntimeSettings {
        RuntimeSettings {
            inner: Arc::clone(&self.inner),
        }
    }

    #[frb(sync)]
    pub fn translation(&self, provider_type: String) -> Result<RuntimeTranslation, String> {
        let provider_type = validate_provider_type(provider_type)?;
        Ok(RuntimeTranslation {
            inner: Arc::clone(&self.inner),
            provider_type,
        })
    }

    #[frb(sync)]
    pub fn dictionary(&self, provider_type: String) -> Result<RuntimeDictionary, String> {
        let provider_type = validate_provider_type(provider_type)?;
        Ok(RuntimeDictionary {
            inner: Arc::clone(&self.inner),
            provider_type,
        })
    }
}

impl RuntimeSettings {
    pub async fn get(&self) -> Result<RustSettingsDto, String> {
        let state = self.inner.state.read().await;
        state.settings.to_dto()
    }

    pub async fn get_json(&self) -> Result<String, String> {
        Ok(self.get().await?.raw_json)
    }

    pub async fn set_window_theme(&self, theme: String) -> Result<RustSettingsDto, String> {
        self.update(move |settings| settings.set_window_theme(&theme))
            .await
    }

    pub async fn set_window_language(&self, language: String) -> Result<RustSettingsDto, String> {
        self.update(move |settings| settings.set_window_language(&language))
            .await
    }

    async fn update<F>(&self, mutator: F) -> Result<RustSettingsDto, String>
    where
        F: FnOnce(&mut Settings),
    {
        let mut state = self.inner.state.write().await;
        let mut next_settings = state.settings.clone();
        mutator(&mut next_settings);

        let next_engine = engine::build_from_settings(&next_settings)?;
        next_settings.save(&self.inner.storage_dir)?;
        let dto = next_settings.to_dto()?;

        *state = RuntimeState {
            settings: next_settings,
            engine: next_engine,
        };

        Ok(dto)
    }
}

impl RuntimeTranslation {
    pub async fn translate(
        &self,
        request: RustTranslateRequest,
    ) -> Result<RustTranslateResponse, String> {
        let provider_type = self.provider_type.clone();
        let inner = Arc::clone(&self.inner);
        run_on_worker_thread(move || async move {
            let target_language = validate_required("target_language", request.target_language)?;
            let text = validate_required("text", request.text)?;

            let response = if let Some(provider_config_yaml) =
                optional_trimmed(request.provider_config_yaml)
            {
                let engine =
                    engine::build_from_provider_config(&provider_type, &provider_config_yaml)?;
                let translation_service = engine
                    .translation(&provider_type)
                    .map_err(|error| error.to_string())?;

                translation_service
                    .translate(TranslateRequest {
                        source_language: optional_trimmed(request.source_language),
                        target_language: Some(target_language),
                        text,
                    })
                    .await
                    .map_err(|error| error.to_string())?
            } else {
                let state = inner.state.read().await;
                let translation_service = state
                    .engine
                    .translation(&provider_type)
                    .map_err(|error| error.to_string())?;

                translation_service
                    .translate(TranslateRequest {
                        source_language: optional_trimmed(request.source_language),
                        target_language: Some(target_language),
                        text,
                    })
                    .await
                    .map_err(|error| error.to_string())?
            };

            Ok(RustTranslateResponse {
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
        })
        .await
    }
}

impl RuntimeDictionary {
    pub async fn lookup(&self, request: RustLookupRequest) -> Result<RustLookupResponse, String> {
        let provider_type = self.provider_type.clone();
        let inner = Arc::clone(&self.inner);
        run_on_worker_thread(move || async move {
            let source_language = validate_required("source_language", request.source_language)?;
            let target_language = validate_required("target_language", request.target_language)?;
            let word = validate_required("word", request.word)?;

            let response = if let Some(provider_config_yaml) =
                optional_trimmed(request.provider_config_yaml)
            {
                let engine =
                    engine::build_from_provider_config(&provider_type, &provider_config_yaml)?;
                let dictionary_service = engine
                    .dictionary(&provider_type)
                    .map_err(|error| error.to_string())?;

                dictionary_service
                    .look_up(LookUpRequest {
                        source_language,
                        target_language,
                        word,
                    })
                    .await
                    .map_err(|error| error.to_string())?
            } else {
                let state = inner.state.read().await;
                let dictionary_service = state
                    .engine
                    .dictionary(&provider_type)
                    .map_err(|error| error.to_string())?;

                dictionary_service
                    .look_up(LookUpRequest {
                        source_language,
                        target_language,
                        word,
                    })
                    .await
                    .map_err(|error| error.to_string())?
            };

            Ok(RustLookupResponse {
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
        })
        .await
    }
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}

fn validate_provider_type(provider_type: String) -> Result<String, String> {
    validate_required("provider_type", provider_type)
}

fn validate_required(name: &str, value: String) -> Result<String, String> {
    let value = value.trim().to_owned();
    if value.is_empty() {
        return Err(format!("{name} is required"));
    }
    Ok(value)
}

fn optional_trimmed(value: Option<String>) -> Option<String> {
    value
        .map(|value| value.trim().to_owned())
        .filter(|value| !value.is_empty())
}

async fn run_on_worker_thread<F, Fut, T>(task: F) -> Result<T, String>
where
    F: FnOnce() -> Fut + Send + 'static,
    Fut: Future<Output = Result<T, String>> + 'static,
    T: Send + 'static,
{
    let (sender, receiver) = tokio::sync::oneshot::channel();

    thread::Builder::new()
        .name("beyondtranslate-engine-bridge".to_owned())
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

    fn create_runtime() -> Runtime {
        let storage_dir = std::env::temp_dir().join(format!(
            "beyondtranslate-runtime-{}",
            std::time::SystemTime::now()
                .duration_since(std::time::UNIX_EPOCH)
                .expect("time went backwards")
                .as_nanos()
        ));

        Runtime::new(storage_dir.display().to_string()).expect("failed to create runtime")
    }

    #[test]
    fn translation_requires_target_language() {
        let runtime = create_runtime();
        let error = tokio::runtime::Builder::new_current_thread()
            .enable_all()
            .build()
            .unwrap()
            .block_on(async {
                runtime
                    .translation("deepl".to_owned())
                    .unwrap()
                    .translate(RustTranslateRequest {
                        provider_config_yaml: Some("api_key: test-key".to_owned()),
                        source_language: Some("en".to_owned()),
                        target_language: String::new(),
                        text: "hello".to_owned(),
                    })
                    .await
            })
            .unwrap_err();

        assert_eq!(error, "target_language is required");
    }

    #[test]
    fn lookup_requires_word() {
        let runtime = create_runtime();
        let error = tokio::runtime::Builder::new_current_thread()
            .enable_all()
            .build()
            .unwrap()
            .block_on(async {
                runtime
                    .dictionary("iciba".to_owned())
                    .unwrap()
                    .lookup(RustLookupRequest {
                        provider_config_yaml: Some("api_key: test-key".to_owned()),
                        source_language: "en".to_owned(),
                        target_language: "zh".to_owned(),
                        word: String::new(),
                    })
                    .await
            })
            .unwrap_err();

        assert_eq!(error, "word is required");
    }
}
