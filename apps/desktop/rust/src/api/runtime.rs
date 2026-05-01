use std::future::Future;
use std::path::PathBuf;
use std::sync::Arc;
use std::thread;

pub use super::mirrors::{
    LookUpRequest, LookUpResponse, TextTranslation, TranslateRequest, TranslateResponse,
    WordDefinition, WordImage, WordPhrase, WordPronunciation, WordSentence, WordTag, WordTense,
};
pub use crate::domain::settings::{
    AdvancedSettings, AdvancedSettingsPatch, AppearanceSettings, AppearanceSettingsPatch,
    ShortcutSettings, ShortcutSettingsPatch,
};
use beyondtranslate_engine::ProviderConfig;
use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};
use struct_patch::Patch as ApplyPatch;
use tokio::sync::RwLock;

use crate::domain::engine;
use crate::domain::settings::Settings;

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

#[frb(opaque)]
#[derive(Clone)]
pub struct Runtime {
    settings_file_path: Arc<str>,
    state: Arc<RwLock<RuntimeState>>,
}

#[frb(opaque)]
pub struct RuntimeSettings {
    runtime: Runtime,
}

#[frb(opaque)]
pub struct RuntimeTranslation {
    runtime: Runtime,
    provider_id: String,
}

#[frb(opaque)]
pub struct RuntimeDictionary {
    runtime: Runtime,
    provider_id: String,
}

#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct ProviderConfigEntry {
    pub id: String,
    pub r#type: String,
    pub config_yaml: String,
}

impl Runtime {
    #[frb(sync)]
    pub fn new(data_dir: String) -> Result<Self, String> {
        let settings_file_path = runtime_settings_file_path(&data_dir);
        let settings = Settings::load(&settings_file_path)?;
        let state = RuntimeState::new(settings)?;
        Ok(Self {
            settings_file_path: Arc::from(settings_file_path.to_string_lossy().into_owned()),
            state: Arc::new(RwLock::new(state)),
        })
    }

    #[frb(sync)]
    pub fn settings(&self) -> RuntimeSettings {
        RuntimeSettings {
            runtime: self.clone(),
        }
    }

    #[frb(sync)]
    pub fn translation(&self, provider_id: String) -> Result<RuntimeTranslation, String> {
        let provider_id = validate_provider_id(provider_id)?;
        Ok(RuntimeTranslation {
            runtime: self.clone(),
            provider_id,
        })
    }

    #[frb(sync)]
    pub fn dictionary(&self, provider_id: String) -> Result<RuntimeDictionary, String> {
        let provider_id = validate_provider_id(provider_id)?;
        Ok(RuntimeDictionary {
            runtime: self.clone(),
            provider_id,
        })
    }
}

impl RuntimeSettings {
    pub async fn get_json(&self) -> Result<String, String> {
        let state = self.runtime.state.read().await;
        state.settings.to_pretty_json()
    }

    pub async fn get_appearance(&self) -> Result<AppearanceSettings, String> {
        Ok(self.get_section(|s| &s.appearance).await)
    }

    pub async fn update_appearance(
        &self,
        patch: AppearanceSettingsPatch,
    ) -> Result<AppearanceSettings, String> {
        self.update_section(patch, |s| &mut s.appearance).await
    }

    pub async fn get_shortcuts(&self) -> Result<ShortcutSettings, String> {
        Ok(self.get_section(|s| &s.shortcuts).await)
    }

    pub async fn update_shortcuts(
        &self,
        patch: ShortcutSettingsPatch,
    ) -> Result<ShortcutSettings, String> {
        self.update_section(patch, |s| &mut s.shortcuts).await
    }

    pub async fn get_advanced(&self) -> Result<AdvancedSettings, String> {
        Ok(self.get_section(|s| &s.advanced).await)
    }

    pub async fn update_advanced(
        &self,
        patch: AdvancedSettingsPatch,
    ) -> Result<AdvancedSettings, String> {
        self.update_section(patch, |s| &mut s.advanced).await
    }

    pub async fn list_providers(&self) -> Result<Vec<ProviderConfigEntry>, String> {
        let state = self.runtime.state.read().await;
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
    ) -> Result<Option<ProviderConfigEntry>, String> {
        let provider_id = validate_provider_id(provider_id)?;
        let state = self.runtime.state.read().await;
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
    ) -> Result<ProviderConfigEntry, String> {
        let provider_id = validate_provider_id(provider_id)?;
        let config_yaml = validate_required("config_yaml", config_yaml)?;
        let config = engine::parse_provider_config(&config_yaml)?;

        self.commit_settings(move |settings| {
            let entry = provider_entry(&provider_id, &config)?;
            settings.engine.providers.insert(provider_id, config);
            Ok(entry)
        })
        .await
    }

    pub async fn delete_provider(
        &self,
        provider_id: String,
    ) -> Result<Option<ProviderConfigEntry>, String> {
        let provider_id = validate_provider_id(provider_id)?;
        self.commit_settings(move |settings| {
            settings
                .engine
                .providers
                .remove(&provider_id)
                .as_ref()
                .map(|config| provider_entry(&provider_id, config))
                .transpose()
        })
        .await
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

        let engine_changed = next_settings.engine != state.settings.engine;

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

impl RuntimeTranslation {
    pub async fn translate(&self, request: TranslateRequest) -> Result<TranslateResponse, String> {
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
    pub async fn lookup(&self, request: LookUpRequest) -> Result<LookUpResponse, String> {
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

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}

fn provider_entry(
    provider_id: &str,
    config: &ProviderConfig,
) -> Result<ProviderConfigEntry, String> {
    Ok(ProviderConfigEntry {
        id: provider_id.to_owned(),
        r#type: config.provider_type.as_str().to_owned(),
        config_yaml: serde_yaml::to_string(config)
            .map_err(|error| format!("failed to encode provider config yaml: {error}"))?,
    })
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

    fn create_runtime() -> Runtime {
        let data_dir = std::env::temp_dir().join(format!(
            "beyondtranslate-runtime-{}",
            std::time::SystemTime::now()
                .duration_since(std::time::UNIX_EPOCH)
                .expect("time went backwards")
                .as_nanos()
        ));

        Runtime::new(data_dir.display().to_string()).expect("failed to create runtime")
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
