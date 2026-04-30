use std::future::Future;
use std::sync::Arc;
use std::thread;

pub use super::mirrors::{
    LookUpRequest, LookUpResponse, TextTranslation, TranslateRequest, TranslateResponse,
    WordDefinition, WordImage, WordPhrase, WordPronunciation, WordSentence, WordTag, WordTense,
};
use beyondtranslate_engine::ProviderConfig;
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
    provider_id: String,
}

#[frb(opaque)]
pub struct RuntimeDictionary {
    inner: Arc<RuntimeInner>,
    provider_id: String,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct RustProviderEntry {
    pub id: String,
    pub r#type: String,
    pub config_yaml: String,
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
    pub fn translation(&self, provider_id: String) -> Result<RuntimeTranslation, String> {
        let provider_id = validate_provider_id(provider_id)?;
        Ok(RuntimeTranslation {
            inner: Arc::clone(&self.inner),
            provider_id,
        })
    }

    #[frb(sync)]
    pub fn dictionary(&self, provider_id: String) -> Result<RuntimeDictionary, String> {
        let provider_id = validate_provider_id(provider_id)?;
        Ok(RuntimeDictionary {
            inner: Arc::clone(&self.inner),
            provider_id,
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

    pub async fn list_providers(&self) -> Result<Vec<RustProviderEntry>, String> {
        let state = self.inner.state.read().await;
        state
            .settings
            .engine
            .providers
            .iter()
            .map(|(id, config)| provider_entry(id, config))
            .collect()
    }

    pub async fn get_provider(
        &self,
        provider_id: String,
    ) -> Result<Option<RustProviderEntry>, String> {
        let provider_id = validate_provider_id(provider_id)?;
        let state = self.inner.state.read().await;
        state
            .settings
            .engine
            .providers
            .get(&provider_id)
            .map(|config| provider_entry(&provider_id, config))
            .transpose()
    }

    pub async fn update_provider(
        &self,
        provider_id: String,
        config_yaml: String,
    ) -> Result<RustProviderEntry, String> {
        let provider_id = validate_provider_id(provider_id)?;
        let config_yaml = validate_required("config_yaml", config_yaml)?;
        let config = engine::parse_provider_config(&config_yaml)?;
        let provider_id_for_insert = provider_id.clone();

        self.update_with_result(
            move |settings| {
                settings
                    .engine
                    .providers
                    .insert(provider_id_for_insert, config);
            },
            move |settings| {
                let config = settings
                    .engine
                    .providers
                    .get(&provider_id)
                    .ok_or_else(|| format!("provider `{provider_id}` was not saved"))?;
                provider_entry(&provider_id, config)
            },
        )
        .await
    }

    pub async fn delete_provider(
        &self,
        provider_id: String,
    ) -> Result<Option<RustProviderEntry>, String> {
        let provider_id = validate_provider_id(provider_id)?;
        let mut state = self.inner.state.write().await;
        let mut next_settings = state.settings.clone();
        let deleted = next_settings.engine.providers.remove(&provider_id);

        let next_engine = engine::build_from_settings(&next_settings)?;
        next_settings.save(&self.inner.storage_dir)?;
        let deleted = deleted
            .as_ref()
            .map(|config| provider_entry(&provider_id, config))
            .transpose()?;

        *state = RuntimeState {
            settings: next_settings,
            engine: next_engine,
        };

        Ok(deleted)
    }

    async fn update<F>(&self, mutator: F) -> Result<RustSettingsDto, String>
    where
        F: FnOnce(&mut Settings),
    {
        self.update_with_result(mutator, |settings| settings.to_dto()).await
    }

    async fn update_with_result<F, T, G>(&self, mutator: F, result: G) -> Result<T, String>
    where
        F: FnOnce(&mut Settings),
        G: FnOnce(&Settings) -> Result<T, String>,
    {
        let mut state = self.inner.state.write().await;
        let mut next_settings = state.settings.clone();
        mutator(&mut next_settings);

        let next_engine = engine::build_from_settings(&next_settings)?;
        next_settings.save(&self.inner.storage_dir)?;
        let result = result(&next_settings)?;

        *state = RuntimeState {
            settings: next_settings,
            engine: next_engine,
        };

        Ok(result)
    }
}

impl RuntimeTranslation {
    pub async fn translate(&self, request: TranslateRequest) -> Result<TranslateResponse, String> {
        let provider_id = self.provider_id.clone();
        let inner = Arc::clone(&self.inner);
        run_on_worker_thread(move || async move {
            let target_language = validate_optional_required(
                "target_language",
                request.target_language,
            )?;
            let text = validate_required("text", request.text)?;
            let state = inner.state.read().await;
            let translation_service = state
                .engine
                .translation(&provider_id)
                .map_err(|error| error.to_string())?;

            translation_service
                .translate(TranslateRequest {
                    source_language: optional_trimmed(request.source_language),
                    target_language: Some(target_language),
                    text,
                })
                .await
                .map_err(|error| error.to_string())
        })
        .await
    }
}

impl RuntimeDictionary {
    pub async fn lookup(&self, request: LookUpRequest) -> Result<LookUpResponse, String> {
        let provider_id = self.provider_id.clone();
        let inner = Arc::clone(&self.inner);
        run_on_worker_thread(move || async move {
            let source_language = validate_required("source_language", request.source_language)?;
            let target_language = validate_required("target_language", request.target_language)?;
            let word = validate_required("word", request.word)?;
            let state = inner.state.read().await;
            let dictionary_service = state
                .engine
                .dictionary(&provider_id)
                .map_err(|error| error.to_string())?;

            dictionary_service
                .look_up(LookUpRequest {
                    source_language,
                    target_language,
                    word,
                })
                .await
                .map_err(|error| error.to_string())
        })
        .await
    }
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}

fn provider_entry(provider_id: &str, config: &ProviderConfig) -> Result<RustProviderEntry, String> {
    Ok(RustProviderEntry {
        id: provider_id.to_owned(),
        r#type: config.provider_type.as_str().to_owned(),
        config_yaml: serde_yaml::to_string(config)
            .map_err(|error| format!("failed to encode provider config yaml: {error}"))?,
    })
}

fn validate_provider_id(provider_id: String) -> Result<String, String> {
    validate_required("provider_id", provider_id)
}

fn validate_optional_required(name: &str, value: Option<String>) -> Result<String, String> {
    validate_required(name, value.unwrap_or_default())
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
                    .translate(TranslateRequest {
                        source_language: Some("en".to_owned()),
                        target_language: Some(String::new()),
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
                    .lookup(LookUpRequest {
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
