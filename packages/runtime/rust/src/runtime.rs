use std::collections::HashMap;
use std::future::Future;
use std::path::PathBuf;
use std::sync::Arc;
use std::thread;

use beyondtranslate_core::{LookUpRequest, LookUpResponse, TranslateRequest, TranslateResponse};
use struct_patch::Patch as ApplyPatch;
use tokio::sync::RwLock;

use crate::domain::engine;
use crate::domain::settings::{
    provider_entry_from_config, AdvancedSettings, AdvancedSettingsPatch, AppearanceSettings,
    AppearanceSettingsPatch, GeneralSettings, GeneralSettingsPatch, ProviderConfigEntry, Settings,
    ShortcutSettings, ShortcutSettingsPatch,
};

/// Error type returned by all uniffi-exported Runtime methods.
#[derive(Debug, thiserror::Error, uniffi::Error)]
pub enum RuntimeError {
    #[error("{msg}")]
    Error { msg: String },
}

impl From<String> for RuntimeError {
    fn from(s: String) -> Self {
        RuntimeError::Error { msg: s }
    }
}

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

#[derive(Clone, uniffi::Object)]
pub struct Runtime {
    settings_file_path: Arc<str>,
    state: Arc<RwLock<RuntimeState>>,
}

#[derive(uniffi::Object)]
pub struct RuntimeSettings {
    runtime: Runtime,
}

#[derive(uniffi::Object)]
pub struct RuntimeTranslation {
    runtime: Runtime,
    provider_id: String,
}

#[derive(uniffi::Object)]
pub struct RuntimeDictionary {
    runtime: Runtime,
    provider_id: String,
}

impl Runtime {
    fn new_impl(data_dir: String) -> Result<Self, String> {
        let settings_file_path = runtime_settings_file_path(&data_dir);
        let settings = Settings::load(&settings_file_path)?;
        let state = RuntimeState::new(settings)?;
        Ok(Self {
            settings_file_path: Arc::from(settings_file_path.to_string_lossy().into_owned()),
            state: Arc::new(RwLock::new(state)),
        })
    }
}

#[uniffi::export]
impl Runtime {
    #[uniffi::constructor]
    pub fn new(data_dir: String) -> Result<Arc<Self>, RuntimeError> {
        Self::new_impl(data_dir).map(Arc::new).map_err(Into::into)
    }

    pub fn settings(self: Arc<Self>) -> Arc<RuntimeSettings> {
        Arc::new(RuntimeSettings {
            runtime: (*self).clone(),
        })
    }

    pub fn translation(
        self: Arc<Self>,
        provider_id: String,
    ) -> Result<Arc<RuntimeTranslation>, RuntimeError> {
        let provider_id = validate_provider_id(provider_id).map_err(RuntimeError::from)?;
        Ok(Arc::new(RuntimeTranslation {
            runtime: (*self).clone(),
            provider_id,
        }))
    }

    pub fn dictionary(
        self: Arc<Self>,
        provider_id: String,
    ) -> Result<Arc<RuntimeDictionary>, RuntimeError> {
        let provider_id = validate_provider_id(provider_id).map_err(RuntimeError::from)?;
        Ok(Arc::new(RuntimeDictionary {
            runtime: (*self).clone(),
            provider_id,
        }))
    }
}

impl RuntimeSettings {
    async fn get_json_impl(&self) -> Result<String, String> {
        let state = self.runtime.state.read().await;
        state.settings.to_pretty_json()
    }

    async fn get_section<T: Clone>(&self, select: impl FnOnce(&Settings) -> &T) -> T {
        select(&self.runtime.state.read().await.settings).clone()
    }

    async fn update_section<T, P>(
        &self,
        patch: P,
        select: impl FnOnce(&mut Settings) -> &mut T + Send + 'static,
    ) -> Result<T, String>
    where
        T: Clone + ApplyPatch<P>,
        P: Send + 'static,
    {
        self.commit_settings(move |settings| {
            let section = select(settings);
            section.apply(patch);
            Ok(section.clone())
        })
        .await
    }

    async fn commit_settings<F, T>(&self, update: F) -> Result<T, String>
    where
        F: FnOnce(&mut Settings) -> Result<T, String>,
    {
        let mut state = self.runtime.state.write().await;
        let mut next_settings = state.settings.clone();
        let result = update(&mut next_settings)?;
        next_settings.touch_last_updated()?;

        let engine_changed = next_settings.providers != state.settings.providers;

        if engine_changed {
            let next_engine = engine::build_from_settings(&next_settings)?;
            next_settings.save(self.runtime.settings_file_path.as_ref())?;
            *state = RuntimeState {
                settings: next_settings,
                engine: next_engine,
            };
        } else {
            next_settings.save(self.runtime.settings_file_path.as_ref())?;
            state.settings = next_settings;
        }

        Ok(result)
    }
}

#[uniffi::export(async_runtime = "tokio")]
impl RuntimeSettings {
    pub async fn get_json(&self) -> Result<String, RuntimeError> {
        self.get_json_impl().await.map_err(Into::into)
    }

    pub async fn get_general(&self) -> Result<GeneralSettings, RuntimeError> {
        Ok(self.get_section(|s| &s.general).await)
    }

    pub async fn update_general(
        &self,
        patch: GeneralSettingsPatch,
    ) -> Result<GeneralSettings, RuntimeError> {
        self.update_section(patch, |s| &mut s.general)
            .await
            .map_err(Into::into)
    }

    pub async fn get_appearance(&self) -> Result<AppearanceSettings, RuntimeError> {
        Ok(self.get_section(|s| &s.appearance).await)
    }

    pub async fn update_appearance(
        &self,
        patch: AppearanceSettingsPatch,
    ) -> Result<AppearanceSettings, RuntimeError> {
        self.update_section(patch, |s| &mut s.appearance)
            .await
            .map_err(Into::into)
    }

    pub async fn get_shortcuts(&self) -> Result<ShortcutSettings, RuntimeError> {
        Ok(self.get_section(|s| &s.shortcuts).await)
    }

    pub async fn update_shortcuts(
        &self,
        patch: ShortcutSettingsPatch,
    ) -> Result<ShortcutSettings, RuntimeError> {
        self.update_section(patch, |s| &mut s.shortcuts)
            .await
            .map_err(Into::into)
    }

    pub async fn get_advanced(&self) -> Result<AdvancedSettings, RuntimeError> {
        Ok(self.get_section(|s| &s.advanced).await)
    }

    pub async fn update_advanced(
        &self,
        patch: AdvancedSettingsPatch,
    ) -> Result<AdvancedSettings, RuntimeError> {
        self.update_section(patch, |s| &mut s.advanced)
            .await
            .map_err(Into::into)
    }

    pub async fn list_providers(&self) -> Result<Vec<ProviderConfigEntry>, RuntimeError> {
        let state = self.runtime.state.read().await;
        Ok(state
            .settings
            .providers
            .iter()
            .map(|(provider_id, provider)| {
                let capabilities = state
                    .engine
                    .require(provider_id)
                    .map(|p| {
                        p.capabilities()
                            .into_iter()
                            .map(|c| {
                                serde_json::to_value(&c)
                                    .ok()
                                    .and_then(|v| v.as_str().map(ToOwned::to_owned))
                                    .unwrap_or_default()
                            })
                            .collect::<Vec<_>>()
                    })
                    .unwrap_or_default();
                let mut entry = normalized_provider_entry(provider_id, provider);
                entry.capabilities = capabilities;
                entry
            })
            .collect())
    }

    pub async fn get_provider(
        &self,
        provider_id: String,
    ) -> Result<Option<ProviderConfigEntry>, RuntimeError> {
        let provider_id = validate_provider_id(provider_id).map_err(RuntimeError::from)?;
        let state = self.runtime.state.read().await;
        Ok(state
            .settings
            .providers
            .get(&provider_id)
            .map(|provider| normalized_provider_entry(&provider_id, provider)))
    }

    pub async fn update_provider(
        &self,
        provider_id: String,
        provider_type: String,
        fields: HashMap<String, String>,
    ) -> Result<ProviderConfigEntry, RuntimeError> {
        let provider_id = validate_provider_id(provider_id).map_err(RuntimeError::from)?;
        let provider_type =
            validate_required("provider_type", provider_type).map_err(RuntimeError::from)?;
        let entry = ProviderConfigEntry {
            id: provider_id.clone(),
            r#type: provider_type,
            fields,
            capabilities: Vec::new(),
        };
        let config = crate::domain::settings::provider_config_from_settings(&entry)
            .map_err(RuntimeError::from)?;

        self.commit_settings(move |settings| {
            let entry = provider_entry_from_config(&provider_id, &config)?;
            if let Some(existing) = settings.providers.get_mut(&provider_id) {
                existing.id = provider_id;
                existing.r#type = entry.r#type.clone();
                existing.fields = entry.fields.clone();
            } else {
                settings.providers.insert(provider_id, entry.clone());
            }
            Ok(entry)
        })
        .await
        .map_err(Into::into)
    }

    pub async fn delete_provider(
        &self,
        provider_id: String,
    ) -> Result<Option<ProviderConfigEntry>, RuntimeError> {
        let provider_id = validate_provider_id(provider_id).map_err(RuntimeError::from)?;
        self.commit_settings(move |settings| {
            Ok(settings
                .providers
                .remove(&provider_id)
                .map(|provider| normalized_provider_entry(&provider_id, &provider)))
        })
        .await
        .map_err(Into::into)
    }
}

impl RuntimeTranslation {
    async fn translate_impl(&self, request: TranslateRequest) -> Result<TranslateResponse, String> {
        let provider_id = self.provider_id.clone();
        let runtime = self.runtime.clone();
        run_on_worker_thread(move || async move {
            let target_language =
                validate_optional_required("target_language", request.target_language)?;
            let text = validate_required("text", request.text)?;
            let state = runtime.state.read().await;
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
    async fn lookup_impl(&self, request: LookUpRequest) -> Result<LookUpResponse, String> {
        let provider_id = self.provider_id.clone();
        let runtime = self.runtime.clone();
        run_on_worker_thread(move || async move {
            let source_language = validate_required("source_language", request.source_language)?;
            let target_language = validate_required("target_language", request.target_language)?;
            let word = validate_required("word", request.word)?;
            let state = runtime.state.read().await;
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

#[uniffi::export(async_runtime = "tokio")]
impl RuntimeTranslation {
    pub async fn translate(
        &self,
        request: TranslateRequest,
    ) -> Result<TranslateResponse, RuntimeError> {
        self.translate_impl(request).await.map_err(Into::into)
    }
}

#[uniffi::export(async_runtime = "tokio")]
impl RuntimeDictionary {
    pub async fn lookup(&self, request: LookUpRequest) -> Result<LookUpResponse, RuntimeError> {
        self.lookup_impl(request).await.map_err(Into::into)
    }
}

fn normalized_provider_entry(
    provider_id: &str,
    provider: &ProviderConfigEntry,
) -> ProviderConfigEntry {
    let mut provider = provider.clone();
    if provider.id.trim().is_empty() {
        provider.id = provider_id.to_owned();
    }
    provider
}

fn runtime_settings_file_path(data_dir: &str) -> PathBuf {
    PathBuf::from(data_dir).join("settings.json")
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

    fn create_runtime() -> Arc<Runtime> {
        let data_dir = std::env::temp_dir().join(format!(
            "beyondtranslate-runtime-{}",
            std::time::SystemTime::now()
                .duration_since(std::time::UNIX_EPOCH)
                .expect("time went backwards")
                .as_nanos()
        ));

        Runtime::new(data_dir.display().to_string()).expect("failed to create runtime")
    }

    fn current_timestamp_millis() -> u64 {
        std::time::SystemTime::now()
            .duration_since(std::time::UNIX_EPOCH)
            .expect("time went backwards")
            .as_millis()
            .try_into()
            .expect("timestamp does not fit in u64")
    }

    #[test]
    fn commit_settings_updates_last_updated() {
        let runtime = create_runtime();

        tokio::runtime::Builder::new_current_thread()
            .enable_all()
            .build()
            .unwrap()
            .block_on(async {
                let before = current_timestamp_millis();
                runtime
                    .clone()
                    .settings()
                    .update_appearance(AppearanceSettingsPatch {
                        language: Some("en".to_owned()),
                        theme_mode: None,
                    })
                    .await
                    .expect("failed to update appearance");
                let after = current_timestamp_millis();

                let json = runtime
                    .clone()
                    .settings()
                    .get_json()
                    .await
                    .expect("failed to get settings json");
                let value = serde_json::from_str::<serde_json::Value>(&json)
                    .expect("settings json should parse");
                let last_updated = value
                    .get("lastUpdated")
                    .and_then(serde_json::Value::as_u64)
                    .expect("lastUpdated should be a number");

                assert!(last_updated >= before);
                assert!(last_updated <= after);
            });
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
                    .clone()
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

        assert_eq!(error.to_string(), "target_language is required");
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
                    .clone()
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

        assert_eq!(error.to_string(), "word is required");
    }
}
