use std::collections::HashMap;
use std::future::Future;
use std::path::PathBuf;
use std::sync::{Arc, Mutex, OnceLock};
use std::thread;
use std::time::{SystemTime, UNIX_EPOCH};

use beyondtranslate_core::{
    ChatMessage, DetectLanguageRequest, DetectLanguageResponse, LanguageInfo, LanguagePair,
    LookUpRequest, LookUpResponse, RecognizeTextRequest, RecognizeTextResponse, TranslateRequest,
    TranslateResponse,
};
use struct_patch::Patch as ApplyPatch;
use tokio::sync::{broadcast, Mutex as AsyncMutex, RwLock};

use crate::domain::engine;
use crate::domain::permission;
use crate::domain::settings::{
    provider_entry_from_config, AdvancedSettings, AdvancedSettingsPatch, AppearanceSettings,
    AppearanceSettingsPatch, GeneralSettings, GeneralSettingsPatch, ProviderConfigEntry,
    ServiceConfigEntry, ServiceType, Settings, ShortcutSettings, ShortcutSettingsPatch,
};
use crate::domain::text_extractor;
use crate::RuntimeApiServer;
use beyondtranslate_core::TranslationTarget;

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

/// Identifies which top-level settings section was just modified.
///
/// Emitted by [`SettingsSubscription::next`] every time settings are
/// successfully written through any [`RuntimeSettings`] handle. Consumers
/// (Dart `SettingsStore`, Swift `SettingsViewModel`, etc.) receive these
/// events regardless of which language binding initiated the change, and
/// typically respond by re-fetching the affected section.
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash, uniffi::Enum)]
pub enum SettingsChange {
    General,
    Appearance,
    Shortcuts,
    Advanced,
    Providers,
}

/// Callback invoked by the Rust runtime as LLM streaming chunks arrive.
///
/// Dart/Swift implement this trait and pass it to
/// [`RuntimeLlm::translate_stream`]. The Rust side calls:
///
/// 1. `on_chunk(content)` — for each token delta (may be called many times)
/// 2. `on_finish(reason)` — when the stream completes (`"stop"`, `"length"`, etc.)
/// 3. `on_error(error)` — if the stream encounters an error
#[uniffi::export(callback_interface)]
pub trait StreamCallback: Send + Sync {
    fn on_chunk(&self, content: String);
    fn on_finish(&self, finish_reason: String);
    fn on_error(&self, error: String);
}

/// Broadcast channel buffer size; settings updates are infrequent so 64
/// is generous. If a subscriber falls more than this many events behind,
/// they receive [`broadcast::error::RecvError::Lagged`] and we transparently
/// resume from the next event.
const EVENT_CHANNEL_CAPACITY: usize = 64;

struct RuntimeState {
    settings: Settings,
    engine: beyondtranslate_engine::Engine,
}

impl RuntimeState {
    fn new(mut settings: Settings) -> Result<Self, String> {
        // Auto-register the internal system provider; it is stripped before
        // persisting to file and excluded from list APIs.
        if !settings.providers.contains_key("system") {
            settings.providers.insert(
                "system".to_owned(),
                ProviderConfigEntry {
                    id: "system".to_owned(),
                    r#type: beyondtranslate_engine::ProviderType::System,
                    fields: HashMap::new(),
                    created_at: None,
                },
            );
        }
        let engine = engine::build_from_settings(&settings)?;
        Ok(Self { settings, engine })
    }
}

/// Shared, process-wide state behind a [`Runtime`] handle. All [`Runtime`]
/// instances built for the same `data_dir` reference the **same**
/// `RuntimeInner`, so Dart and Swift bindings observe the same in-memory
/// settings/engine state and the same `settings.json` on disk.
struct RuntimeInner {
    settings_file_path: Arc<str>,
    state: RwLock<RuntimeState>,
    /// Broadcasts a [`SettingsChange`] event after every successful
    /// settings write. The sender is kept alive for the lifetime of
    /// `RuntimeInner`, so receivers obtained via `subscribe()` will only
    /// see [`broadcast::error::RecvError::Closed`] once the runtime itself
    /// is dropped (i.e. process shutdown).
    events: broadcast::Sender<SettingsChange>,
}

/// Process-wide registry mapping a canonical `data_dir` path to the
/// [`RuntimeInner`] currently backing it. The first call to
/// [`Runtime::new`] for a given `data_dir` populates the entry; subsequent
/// calls (regardless of which language binding they originate from) return
/// a cheap [`Runtime`] handle that shares the same `Arc<RuntimeInner>`.
static RUNTIME_REGISTRY: OnceLock<Mutex<HashMap<PathBuf, Arc<RuntimeInner>>>> = OnceLock::new();

fn runtime_registry() -> &'static Mutex<HashMap<PathBuf, Arc<RuntimeInner>>> {
    RUNTIME_REGISTRY.get_or_init(|| Mutex::new(HashMap::new()))
}

/// Resolves `data_dir` to a stable canonical path used as the registry key.
/// The directory is created if missing so that paths from different
/// language bindings (`/Users/...` vs `/private/Users/...` symlinks on
/// macOS, trailing slashes, etc.) collapse to the same key.
fn canonical_data_dir(data_dir: &str) -> PathBuf {
    let raw = PathBuf::from(data_dir);
    let _ = std::fs::create_dir_all(&raw);
    std::fs::canonicalize(&raw).unwrap_or(raw)
}

#[derive(Clone, uniffi::Object)]
pub struct Runtime {
    inner: Arc<RuntimeInner>,
}

#[derive(uniffi::Object)]
pub struct RuntimeSettings {
    runtime: Runtime,
}

#[derive(uniffi::Object)]
pub struct RuntimeTranslation {
    runtime: Runtime,
    service_id: String,
}

#[derive(uniffi::Object)]
pub struct RuntimeDictionary {
    runtime: Runtime,
    service_id: String,
}

#[derive(Clone, uniffi::Object)]
pub struct RuntimeLlm {
    runtime: Runtime,
    service_id: String,
}

#[derive(uniffi::Object)]
pub struct RuntimeOcr {
    runtime: Runtime,
    service_id: String,
}

#[derive(uniffi::Object)]
pub struct RuntimePermission;

/// Rust-native screen text extractor.
///
/// Provides clipboard reading, screen selection text extraction,
/// and screen capture with OCR across all supported platforms.
#[derive(uniffi::Object)]
pub struct RuntimeTextExtractor {
    runtime: Runtime,
}

/// Foreign-language handle for observing [`SettingsChange`] events.
///
/// Obtain one via [`RuntimeSettings::subscribe`] and call
/// [`SettingsSubscription::next`] in a loop:
///
/// * `Some(change)` — a section was modified; reload it if you care.
/// * `None` — the runtime has been torn down and no further events
///   will arrive (terminate the loop).
///
/// Each subscription has its own independent cursor in the broadcast
/// channel; multiple subscribers can coexist and all see the same events.
#[derive(uniffi::Object)]
pub struct SettingsSubscription {
    receiver: AsyncMutex<broadcast::Receiver<SettingsChange>>,
}

impl Runtime {
    fn new_impl(data_dir: String) -> Result<Self, String> {
        let key = canonical_data_dir(&data_dir);

        let mut registry = runtime_registry()
            .lock()
            .map_err(|error| format!("runtime registry mutex poisoned: {error}"))?;

        if let Some(existing) = registry.get(&key) {
            return Ok(Self {
                inner: existing.clone(),
            });
        }

        let settings_file_path = key.join("settings.json");
        let settings = Settings::load(&settings_file_path)?;
        let state = RuntimeState::new(settings)?;
        let (events, _) = broadcast::channel(EVENT_CHANNEL_CAPACITY);
        let inner = Arc::new(RuntimeInner {
            settings_file_path: Arc::from(settings_file_path.to_string_lossy().into_owned()),
            state: RwLock::new(state),
            events,
        });
        registry.insert(key, inner.clone());
        Ok(Self { inner })
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
        let service_id = validate_service_provider_id(provider_id, "+translation")
            .map_err(RuntimeError::from)?;
        Ok(Arc::new(RuntimeTranslation {
            runtime: (*self).clone(),
            service_id,
        }))
    }

    pub fn dictionary(
        self: Arc<Self>,
        provider_id: String,
    ) -> Result<Arc<RuntimeDictionary>, RuntimeError> {
        let service_id =
            validate_service_provider_id(provider_id, "+dictionary").map_err(RuntimeError::from)?;
        Ok(Arc::new(RuntimeDictionary {
            runtime: (*self).clone(),
            service_id,
        }))
    }

    pub fn ocr(self: Arc<Self>, provider_id: String) -> Result<Arc<RuntimeOcr>, RuntimeError> {
        let service_id =
            validate_service_provider_id(provider_id, "+ocr").map_err(RuntimeError::from)?;
        Ok(Arc::new(RuntimeOcr {
            runtime: (*self).clone(),
            service_id,
        }))
    }

    pub fn llm(self: Arc<Self>, provider_id: String) -> Result<Arc<RuntimeLlm>, RuntimeError> {
        let service_id =
            validate_service_provider_id(provider_id, "+llm").map_err(RuntimeError::from)?;
        Ok(Arc::new(RuntimeLlm {
            runtime: (*self).clone(),
            service_id,
        }))
    }

    pub fn text_extractor(self: Arc<Self>) -> Arc<RuntimeTextExtractor> {
        Arc::new(RuntimeTextExtractor {
            runtime: (*self).clone(),
        })
    }

    pub fn permission(self: Arc<Self>) -> Arc<RuntimePermission> {
        Arc::new(RuntimePermission)
    }

    pub fn start_api_server(
        self: Arc<Self>,
        host: String,
        port: u16,
    ) -> Result<Arc<RuntimeApiServer>, RuntimeError> {
        RuntimeApiServer::start((*self).clone(), host, port)
    }

    /// Returns the curated language list supported by the app.
    pub fn list_languages(&self) -> Vec<LanguageInfo> {
        beyondtranslate_engine::all_languages()
    }

    /// Returns languages supported by the app UI.
    pub fn list_app_languages(&self) -> Vec<LanguageInfo> {
        beyondtranslate_engine::app_languages()
    }
}

impl Runtime {
    pub(crate) async fn api_translate(
        &self,
        provider_id: String,
        request: TranslateRequest,
    ) -> Result<TranslateResponse, beyondtranslate_api_core::ApiError> {
        let request = beyondtranslate_api_core::translate_request(request)?;
        let provider = {
            let state = self.inner.state.read().await;
            state
                .engine
                .require(&provider_id)
                .map_err(beyondtranslate_api_core::ApiError::from_engine_error)?
                .clone()
        };
        let service = provider.translation().ok_or_else(|| {
            beyondtranslate_api_core::ApiError::from_engine_error(
                beyondtranslate_engine::EngineError::TranslationNotSupported(provider_id.clone()),
            )
        })?;

        service.translate(request).await.map_err(Into::into)
    }

    pub(crate) async fn api_detect_language(
        &self,
        provider_id: String,
        request: DetectLanguageRequest,
    ) -> Result<DetectLanguageResponse, beyondtranslate_api_core::ApiError> {
        let request = beyondtranslate_api_core::detect_language_request(request)?;
        let provider = {
            let state = self.inner.state.read().await;
            state
                .engine
                .require(&provider_id)
                .map_err(beyondtranslate_api_core::ApiError::from_engine_error)?
                .clone()
        };
        let service = provider.translation().ok_or_else(|| {
            beyondtranslate_api_core::ApiError::from_engine_error(
                beyondtranslate_engine::EngineError::TranslationNotSupported(provider_id.clone()),
            )
        })?;

        service.detect_language(request).await.map_err(Into::into)
    }

    pub(crate) async fn api_supported_language_pairs(
        &self,
        provider_id: String,
    ) -> Result<Vec<LanguagePair>, beyondtranslate_api_core::ApiError> {
        let provider = {
            let state = self.inner.state.read().await;
            state
                .engine
                .require(&provider_id)
                .map_err(beyondtranslate_api_core::ApiError::from_engine_error)?
                .clone()
        };
        let service = provider.translation().ok_or_else(|| {
            beyondtranslate_api_core::ApiError::from_engine_error(
                beyondtranslate_engine::EngineError::TranslationNotSupported(provider_id.clone()),
            )
        })?;

        service
            .get_supported_language_pairs()
            .await
            .map_err(Into::into)
    }

    pub(crate) async fn api_lookup(
        &self,
        provider_id: String,
        request: LookUpRequest,
    ) -> Result<LookUpResponse, beyondtranslate_api_core::ApiError> {
        let request = beyondtranslate_api_core::lookup_request(request)?;
        let provider = {
            let state = self.inner.state.read().await;
            state
                .engine
                .require(&provider_id)
                .map_err(beyondtranslate_api_core::ApiError::from_engine_error)?
                .clone()
        };
        let service = provider.dictionary().ok_or_else(|| {
            beyondtranslate_api_core::ApiError::from_engine_error(
                beyondtranslate_engine::EngineError::DictionaryNotSupported(provider_id.clone()),
            )
        })?;

        service.look_up(request).await.map_err(Into::into)
    }

    async fn resolve_service(
        &self,
        service_id: &str,
        expected_type: ServiceType,
    ) -> Result<ResolvedService, String> {
        let state = self.inner.state.read().await;
        if let Some(service) = state.settings.services.get(service_id) {
            if service.r#type != expected_type {
                return Err(format!(
                    "service `{service_id}` is not a {expected_type:?} service"
                ));
            }
            if !state.settings.providers.contains_key(&service.provider_id) {
                return Err(format!(
                    "service `{service_id}` references unknown provider `{}`",
                    service.provider_id
                ));
            }
            let mut entry = service.clone();
            entry.id = service_id.to_owned();
            return Ok(ResolvedService {
                provider_id: entry.provider_id.clone(),
                entry,
            });
        }

        let provider = state
            .settings
            .providers
            .get(service_id)
            .ok_or_else(|| format!("service or provider `{service_id}` does not exist"))?;
        let engine_provider = state
            .engine
            .require(service_id)
            .map_err(|error| error.to_string())?;
        let supported = match expected_type {
            ServiceType::Dictionary => engine_provider.dictionary().is_some(),
            ServiceType::Ocr => engine_provider.ocr().is_some(),
            ServiceType::Translation => engine_provider.translation().is_some(),
            ServiceType::Llm => engine_provider.llm().is_some(),
        };
        if !supported {
            return Err(format!(
                "provider `{service_id}` does not support {expected_type:?}"
            ));
        }
        Ok(ResolvedService {
            provider_id: service_id.to_owned(),
            entry: service_entry_for_provider_type(
                service_id,
                &normalized_provider_entry(service_id, provider),
                expected_type,
            ),
        })
    }

    async fn resolve_llm_service(&self, service_id: &str) -> Result<ResolvedService, String> {
        match self.resolve_service(service_id, ServiceType::Llm).await {
            Ok(service) => Ok(service),
            Err(_) => {
                let state = self.inner.state.read().await;
                let Some(service) = state.settings.services.get(service_id) else {
                    return Err(format!("service or provider `{service_id}` does not exist"));
                };
                if service.r#type != ServiceType::Translation
                    && service.r#type != ServiceType::Dictionary
                {
                    return Err(format!("service `{service_id}` is not an llm service"));
                }
                if !state.settings.providers.contains_key(&service.provider_id) {
                    return Err(format!(
                        "service `{service_id}` references unknown provider `{}`",
                        service.provider_id
                    ));
                }
                let provider = state
                    .engine
                    .require(&service.provider_id)
                    .map_err(|error| error.to_string())?;
                if provider.llm().is_none() {
                    return Err(format!(
                        "provider `{}` does not support llm",
                        service.provider_id
                    ));
                }
                let mut entry = service.clone();
                entry.id = service_id.to_owned();
                Ok(ResolvedService {
                    provider_id: entry.provider_id.clone(),
                    entry,
                })
            }
        }
    }
}

impl RuntimeSettings {
    async fn get_json_impl(&self) -> Result<String, String> {
        let state = self.runtime.inner.state.read().await;
        state.settings.to_pretty_json()
    }

    async fn get_section<T: Clone>(&self, select: impl FnOnce(&Settings) -> &T) -> T {
        select(&self.runtime.inner.state.read().await.settings).clone()
    }

    async fn update_section<T, P>(
        &self,
        change: SettingsChange,
        patch: P,
        select: impl FnOnce(&mut Settings) -> &mut T + Send + 'static,
    ) -> Result<T, String>
    where
        T: Clone + ApplyPatch<P>,
        P: Send + 'static,
    {
        self.commit_settings(change, move |settings| {
            let section = select(settings);
            section.apply(patch);
            Ok(section.clone())
        })
        .await
    }

    async fn commit_settings<F, T>(&self, change: SettingsChange, update: F) -> Result<T, String>
    where
        F: FnOnce(&mut Settings) -> Result<T, String>,
    {
        let mut state = self.runtime.inner.state.write().await;
        let mut next_settings = state.settings.clone();
        let result = update(&mut next_settings)?;
        next_settings.touch_last_updated()?;

        // Strip the internal system provider before persisting to file.
        next_settings.providers.remove("system");
        let mut prev_settings = state.settings.clone();
        prev_settings.providers.remove("system");

        let engine_changed = next_settings.providers != prev_settings.providers;

        let settings_file_path = self.runtime.inner.settings_file_path.as_ref();
        if engine_changed {
            let next_engine = engine::build_from_settings(&next_settings)?;
            next_settings.save(settings_file_path)?;
            *state = RuntimeState {
                settings: next_settings,
                engine: next_engine,
            };
        } else {
            next_settings.save(settings_file_path)?;
            state.settings = next_settings;
        }

        // Release the write lock before broadcasting so a subscriber that
        // immediately re-reads doesn't block on the same lock.
        drop(state);

        // `send` only fails when there are zero active receivers, which is
        // a benign condition (no one is listening yet); ignore it.
        let _ = self.runtime.inner.events.send(change);

        Ok(result)
    }
}

#[derive(Clone)]
struct ResolvedService {
    provider_id: String,
    entry: ServiceConfigEntry,
}

impl ResolvedService {
    fn field(&self, key: &str) -> Option<&str> {
        self.entry
            .fields
            .get(key)
            .map(|value| value.trim())
            .filter(|value| !value.is_empty())
    }
}

fn service_entry_for_provider_type(
    service_id: &str,
    provider: &ProviderConfigEntry,
    service_type: ServiceType,
) -> ServiceConfigEntry {
    ServiceConfigEntry {
        id: service_id.to_owned(),
        provider_id: provider.id.clone(),
        r#type: service_type,
        name: provider.id.clone(),
        fields: HashMap::new(),
        created_at: provider.created_at,
    }
}

fn render_prompt_template(
    template: &str,
    source_language: &str,
    target_language: &str,
    text: &str,
) -> String {
    template
        .replace("{{sourceLanguage}}", source_language)
        .replace("{{targetLanguage}}", target_language)
        .replace("{{text}}", text)
}

#[uniffi::export(async_runtime = "tokio")]
impl RuntimeSettings {
    /// Returns the active subset of translation targets based on the
    /// detected source language.
    ///
    /// * `Always` targets are always included.
    /// * `AutoDetect` targets are included only when their source matches
    ///   the detected language (or when no detected language is available).
    pub async fn get_active_translation_targets(
        &self,
        targets: Vec<TranslationTarget>,
        detected_language: Option<String>,
    ) -> Vec<TranslationTarget> {
        TranslationTarget::filter_active(&targets, detected_language.as_deref())
    }

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
        self.update_section(SettingsChange::General, patch, |s| &mut s.general)
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
        self.update_section(SettingsChange::Appearance, patch, |s| &mut s.appearance)
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
        self.update_section(SettingsChange::Shortcuts, patch, |s| &mut s.shortcuts)
            .await
            .map_err(Into::into)
    }

    pub async fn reset_shortcuts(&self) -> Result<ShortcutSettings, RuntimeError> {
        self.commit_settings(SettingsChange::Shortcuts, |settings| {
            settings.shortcuts = ShortcutSettings::default();
            Ok(settings.shortcuts.clone())
        })
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
        self.update_section(SettingsChange::Advanced, patch, |s| &mut s.advanced)
            .await
            .map_err(Into::into)
    }

    pub async fn generate_provider_id(
        &self,
        provider_type: String,
    ) -> Result<String, RuntimeError> {
        let base_id = provider_type.trim().to_lowercase();
        if base_id.is_empty() {
            return Err(RuntimeError::from("provider_type is required".to_owned()));
        }

        let state = self.runtime.inner.state.read().await;
        let existing_ids: Vec<&String> = state.settings.providers.keys().collect();

        // If the base ID is free, use it as-is
        if !existing_ids.contains(&&base_id) {
            return Ok(base_id);
        }

        // Find the first available numeric suffix starting from 1
        for suffix in 1.. {
            let candidate = format!("{base_id}{suffix}");
            if !existing_ids.contains(&&candidate) {
                return Ok(candidate);
            }
        }

        unreachable!()
    }

    pub async fn list_providers(&self) -> Result<Vec<ProviderConfigEntry>, RuntimeError> {
        let state = self.runtime.inner.state.read().await;
        Ok(state
            .settings
            .providers
            .iter()
            .filter(|(provider_id, _)| *provider_id != "system")
            .map(|(provider_id, provider)| normalized_provider_entry(provider_id, provider))
            .collect())
    }

    pub async fn list_services(&self) -> Result<Vec<ServiceConfigEntry>, RuntimeError> {
        let state = self.runtime.inner.state.read().await;
        let mut services = Vec::new();

        for (provider_id, provider) in &state.settings.providers {
            if provider_id == "system" {
                continue;
            }
            let entry = normalized_provider_entry(provider_id, provider);
            if let Ok(engine_provider) = state.engine.require(provider_id) {
                if engine_provider.dictionary().is_some() {
                    services.push(service_entry_for_provider_type(
                        provider_id,
                        &entry,
                        ServiceType::Dictionary,
                    ));
                }
                if engine_provider.translation().is_some() {
                    services.push(service_entry_for_provider_type(
                        provider_id,
                        &entry,
                        ServiceType::Translation,
                    ));
                }
                if engine_provider.ocr().is_some() {
                    services.push(service_entry_for_provider_type(
                        provider_id,
                        &entry,
                        ServiceType::Ocr,
                    ));
                }
                if engine_provider.llm().is_some() {
                    services.push(service_entry_for_provider_type(
                        &format!("{provider_id}+llm"),
                        &entry,
                        ServiceType::Llm,
                    ));
                }
            }
        }

        for (service_id, service) in &state.settings.services {
            if !state.settings.providers.contains_key(&service.provider_id) {
                continue;
            }
            let mut entry = service.clone();
            entry.id = service_id.clone();
            services.push(entry);
        }

        services.sort_by(|a, b| a.id.cmp(&b.id));
        Ok(services)
    }

    pub async fn list_models(&self, provider_id: String) -> Result<Vec<String>, RuntimeError> {
        let provider_id = validate_provider_id(provider_id).map_err(RuntimeError::from)?;
        let runtime = self.runtime.clone();
        run_on_worker_thread(move || async move {
            let provider = {
                let state = runtime.inner.state.read().await;
                state
                    .engine
                    .require(&provider_id)
                    .map_err(|e| e.to_string())?
                    .clone()
            };
            let llm_service = provider
                .llm()
                .ok_or_else(|| format!("provider `{provider_id}` does not support llm"))?;
            llm_service.list_models().await.map_err(|e| e.to_string())
        })
        .await
        .map_err(|e: String| RuntimeError::from(e))
    }

    pub async fn get_service(
        &self,
        service_id: String,
    ) -> Result<Option<ServiceConfigEntry>, RuntimeError> {
        let service_id = validate_provider_id(service_id).map_err(RuntimeError::from)?;
        let state = self.runtime.inner.state.read().await;
        if let Some(service) = state.settings.services.get(&service_id) {
            let mut entry = service.clone();
            entry.id = service_id;
            return Ok(Some(entry));
        }

        let Some(provider) = state.settings.providers.get(&service_id) else {
            return Ok(None);
        };
        let entry = normalized_provider_entry(&service_id, provider);
        let service_type = state.engine.require(&service_id).ok().and_then(|provider| {
            if provider.translation().is_some() {
                Some(ServiceType::Translation)
            } else if provider.dictionary().is_some() {
                Some(ServiceType::Dictionary)
            } else if provider.ocr().is_some() {
                Some(ServiceType::Ocr)
            } else if provider.llm().is_some() {
                Some(ServiceType::Llm)
            } else {
                None
            }
        });

        Ok(service_type
            .map(|service_type| service_entry_for_provider_type(&service_id, &entry, service_type)))
    }

    pub async fn get_provider(
        &self,
        provider_id: String,
    ) -> Result<Option<ProviderConfigEntry>, RuntimeError> {
        let provider_id = validate_provider_id(provider_id).map_err(RuntimeError::from)?;
        let state = self.runtime.inner.state.read().await;
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
        if provider_id == "system" {
            return Err(RuntimeError::from(
                "the built-in system provider cannot be modified".to_owned(),
            ));
        }
        let provider_type =
            validate_required("provider_type", provider_type).map_err(RuntimeError::from)?;
        let provider_type = crate::domain::settings::parse_provider_type(&provider_type)
            .map_err(RuntimeError::from)?;
        let entry = ProviderConfigEntry {
            id: provider_id.clone(),
            r#type: provider_type,
            fields,
            created_at: None,
        };
        let config = crate::domain::settings::provider_config_from_settings(&entry)
            .map_err(RuntimeError::from)?;

        let now = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .map(|d| d.as_secs())
            .ok();

        self.commit_settings(SettingsChange::Providers, move |settings| {
            let entry = provider_entry_from_config(&provider_id, &config)?;
            if let Some(existing) = settings.providers.get_mut(&provider_id) {
                existing.id = provider_id;
                existing.r#type = entry.r#type.clone();
                existing.fields = entry.fields.clone();
            } else {
                let mut new_entry = entry.clone();
                new_entry.created_at = now;
                settings.providers.insert(provider_id, new_entry);
            }
            Ok(entry)
        })
        .await
        .map_err(Into::into)
    }

    pub async fn update_service(
        &self,
        service_id: String,
        provider_id: String,
        service_type: ServiceType,
        name: String,
        fields: HashMap<String, String>,
    ) -> Result<ServiceConfigEntry, RuntimeError> {
        let service_id = validate_provider_id(service_id).map_err(RuntimeError::from)?;
        let provider_id = validate_provider_id(provider_id).map_err(RuntimeError::from)?;
        let name = name.trim().to_owned();
        let now = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .map(|d| d.as_secs())
            .ok();

        self.commit_settings(SettingsChange::Providers, move |settings| {
            let provider = settings
                .providers
                .get(&provider_id)
                .ok_or_else(|| format!("provider `{provider_id}` does not exist"))?;
            if provider.r#type == beyondtranslate_engine::ProviderType::System {
                return Err("system provider services cannot be customized".to_owned());
            }
            if service_id == provider_id {
                return Err("custom service id must be different from provider id".to_owned());
            }

            let mut entry = ServiceConfigEntry {
                id: service_id.clone(),
                provider_id,
                r#type: service_type,
                name,
                fields,
                created_at: None,
            };
            if let Some(existing) = settings.services.get(&service_id) {
                entry.created_at = existing.created_at.or(now);
            } else {
                entry.created_at = now;
            }
            settings.services.insert(service_id, entry.clone());
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
        if provider_id == "system" {
            return Err(RuntimeError::from(
                "the built-in system provider cannot be deleted".to_owned(),
            ));
        }
        self.commit_settings(SettingsChange::Providers, move |settings| {
            let removed = settings
                .providers
                .remove(&provider_id)
                .map(|provider| normalized_provider_entry(&provider_id, &provider));
            settings
                .services
                .retain(|_, service| service.provider_id != provider_id);
            Ok(removed)
        })
        .await
        .map_err(Into::into)
    }

    pub async fn delete_service(
        &self,
        service_id: String,
    ) -> Result<Option<ServiceConfigEntry>, RuntimeError> {
        let service_id = validate_provider_id(service_id).map_err(RuntimeError::from)?;
        self.commit_settings(SettingsChange::Providers, move |settings| {
            Ok(settings.services.remove(&service_id).map(|mut service| {
                service.id = service_id;
                service
            }))
        })
        .await
        .map_err(Into::into)
    }

    /// Returns a fresh subscription that starts receiving
    /// [`SettingsChange`] events emitted **after** this call. Existing
    /// state should be loaded eagerly via the corresponding `get_*`
    /// methods; subscriptions are intentionally not replayed.
    pub fn subscribe(&self) -> Arc<SettingsSubscription> {
        Arc::new(SettingsSubscription {
            receiver: AsyncMutex::new(self.runtime.inner.events.subscribe()),
        })
    }
}

#[uniffi::export(async_runtime = "tokio")]
impl SettingsSubscription {
    /// Awaits the next [`SettingsChange`] event. Returns `None` when the
    /// owning [`Runtime`] has been dropped (no further events will arrive).
    /// If this subscription falls behind, missed events are silently
    /// skipped and the next available event is returned.
    pub async fn next(&self) -> Result<Option<SettingsChange>, RuntimeError> {
        let mut rx = self.receiver.lock().await;
        loop {
            match rx.recv().await {
                Ok(change) => return Ok(Some(change)),
                Err(broadcast::error::RecvError::Closed) => return Ok(None),
                Err(broadcast::error::RecvError::Lagged(_)) => continue,
            }
        }
    }
}

impl RuntimeTranslation {
    async fn translate_impl(&self, request: TranslateRequest) -> Result<TranslateResponse, String> {
        let service_id = self.service_id.clone();
        let runtime = self.runtime.clone();
        run_on_worker_thread(move || async move {
            let target_language =
                validate_optional_required("target_language", request.target_language)?;
            let text = validate_required("text", request.text)?;
            let source_language = optional_trimmed(request.source_language);
            let resolved = runtime
                .resolve_service(&service_id, ServiceType::Translation)
                .await?;
            let provider_id = resolved.provider_id.clone();
            let provider = {
                let state = runtime.inner.state.read().await;
                state
                    .engine
                    .require(&provider_id)
                    .map_err(|error| error.to_string())?
                    .clone()
            };

            if let (Some(system_prompt), Some(llm_service)) =
                (resolved.field("systemPrompt"), provider.llm())
            {
                let model = resolved
                    .field("model")
                    .map(str::to_owned)
                    .or_else(|| llm_service.available_models().into_iter().next())
                    .ok_or_else(|| "llm default model must be configured".to_owned())?;
                let system_prompt = render_prompt_template(
                    system_prompt,
                    source_language.as_deref().unwrap_or("auto"),
                    &target_language,
                    &text,
                );
                let response = llm_service
                    .chat(beyondtranslate_core::ChatRequest {
                        model,
                        messages: vec![ChatMessage::system(system_prompt), ChatMessage::user(text)],
                        temperature: Some(0.3),
                        max_tokens: Some(4096),
                        stream: None,
                    })
                    .await
                    .map_err(|error| error.to_string())?;
                let text = response
                    .choices
                    .first()
                    .map(|choice| choice.message.content.clone())
                    .ok_or_else(|| "no response from llm".to_owned())?;
                return Ok(TranslateResponse {
                    translations: vec![beyondtranslate_core::TextTranslation {
                        text,
                        detected_source_language: None,
                        audio_url: None,
                    }],
                });
            }

            let translation_service = provider
                .translation()
                .ok_or_else(|| format!("provider `{provider_id}` does not support translation"))?;

            translation_service
                .translate(TranslateRequest {
                    source_language,
                    target_language: Some(target_language),
                    text,
                })
                .await
                .map_err(|error| error.to_string())
        })
        .await
    }
}

impl RuntimeTranslation {
    async fn detect_language_impl(
        &self,
        request: DetectLanguageRequest,
    ) -> Result<DetectLanguageResponse, String> {
        let service_id = self.service_id.clone();
        let runtime = self.runtime.clone();
        run_on_worker_thread(move || async move {
            let texts = request
                .texts
                .into_iter()
                .map(|text| text.trim().to_string())
                .filter(|text| !text.is_empty())
                .collect::<Vec<_>>();
            if texts.is_empty() {
                return Err("texts must not be empty".to_owned());
            }
            let resolved = runtime
                .resolve_service(&service_id, ServiceType::Translation)
                .await?;
            let provider_id = resolved.provider_id;
            let provider = {
                let state = runtime.inner.state.read().await;
                state
                    .engine
                    .require(&provider_id)
                    .map_err(|error| error.to_string())?
                    .clone()
            };
            let translation_service = provider
                .translation()
                .ok_or_else(|| format!("provider `{provider_id}` does not support translation"))?;

            translation_service
                .detect_language(DetectLanguageRequest { texts })
                .await
                .map_err(|error| error.to_string())
        })
        .await
    }
}

impl RuntimeDictionary {
    async fn lookup_impl(&self, request: LookUpRequest) -> Result<LookUpResponse, String> {
        let service_id = self.service_id.clone();
        let runtime = self.runtime.clone();
        run_on_worker_thread(move || async move {
            let source_language = validate_required("source_language", request.source_language)?;
            let target_language = validate_required("target_language", request.target_language)?;
            let word = validate_required("word", request.word)?;
            let resolved = runtime
                .resolve_service(&service_id, ServiceType::Dictionary)
                .await?;
            let provider_id = resolved.provider_id.clone();
            let provider = {
                let state = runtime.inner.state.read().await;
                state
                    .engine
                    .require(&provider_id)
                    .map_err(|error| error.to_string())?
                    .clone()
            };
            let dictionary_service = provider
                .dictionary()
                .ok_or_else(|| format!("provider `{provider_id}` does not support dictionary"))?;

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

    pub async fn detect_language(
        &self,
        request: DetectLanguageRequest,
    ) -> Result<DetectLanguageResponse, RuntimeError> {
        self.detect_language_impl(request).await.map_err(Into::into)
    }
}

#[uniffi::export(async_runtime = "tokio")]
impl RuntimeDictionary {
    pub async fn lookup(&self, request: LookUpRequest) -> Result<LookUpResponse, RuntimeError> {
        self.lookup_impl(request).await.map_err(Into::into)
    }
}

impl RuntimeLlm {
    async fn chat_impl(
        &self,
        model: String,
        messages: Vec<beyondtranslate_core::ChatMessage>,
    ) -> Result<beyondtranslate_core::ChatResponse, String> {
        let service_id = self.service_id.clone();
        let runtime = self.runtime.clone();
        run_on_worker_thread(move || async move {
            let model = validate_required("model", model)?;
            if messages.is_empty() {
                return Err("messages must not be empty".to_owned());
            }
            let resolved = runtime.resolve_llm_service(&service_id).await?;
            let provider_id = resolved.provider_id;
            let provider = {
                let state = runtime.inner.state.read().await;
                state
                    .engine
                    .require(&provider_id)
                    .map_err(|error| error.to_string())?
                    .clone()
            };
            let llm_service = provider
                .llm()
                .ok_or_else(|| format!("provider `{provider_id}` does not support llm"))?;

            llm_service
                .chat(beyondtranslate_core::ChatRequest {
                    model,
                    messages,
                    temperature: None,
                    max_tokens: None,
                    stream: None,
                })
                .await
                .map_err(|error| error.to_string())
        })
        .await
    }

    async fn polish_impl(&self, text: String, style: String) -> Result<String, String> {
        let service_id = self.service_id.clone();
        let runtime = self.runtime.clone();
        run_on_worker_thread(move || async move {
            let text = validate_required("text", text)?;
            let style = validate_required("style", style)?;
            let resolved = runtime.resolve_llm_service(&service_id).await?;
            let provider_id = resolved.provider_id.clone();
            let provider = {
                let state = runtime.inner.state.read().await;
                state
                    .engine
                    .require(&provider_id)
                    .map_err(|error| error.to_string())?
                    .clone()
            };
            let llm_service = provider
                .llm()
                .ok_or_else(|| format!("provider `{provider_id}` does not support llm"))?;

            let model = resolved
                .field("model")
                .map(str::to_owned)
                .or_else(|| llm_service.available_models().into_iter().next())
                .ok_or_else(|| "llm default model must be configured".to_owned())?;
            let system_prompt =
                beyondtranslate_engine::prompt::polish_translation_system_prompt(&style);

            let response = llm_service
                .chat(beyondtranslate_core::ChatRequest {
                    model,
                    messages: vec![
                        beyondtranslate_core::ChatMessage::system(system_prompt),
                        beyondtranslate_core::ChatMessage::user(text),
                    ],
                    temperature: None,
                    max_tokens: None,
                    stream: None,
                })
                .await
                .map_err(|error| error.to_string())?;

            response
                .choices
                .first()
                .map(|c| c.message.content.clone())
                .ok_or_else(|| "no response from llm".to_owned())
        })
        .await
    }

    async fn explain_impl(&self, source: String, translation: String) -> Result<String, String> {
        let service_id = self.service_id.clone();
        let runtime = self.runtime.clone();
        run_on_worker_thread(move || async move {
            let source = validate_required("source", source)?;
            let translation = validate_required("translation", translation)?;
            let resolved = runtime.resolve_llm_service(&service_id).await?;
            let provider_id = resolved.provider_id.clone();
            let provider = {
                let state = runtime.inner.state.read().await;
                state
                    .engine
                    .require(&provider_id)
                    .map_err(|error| error.to_string())?
                    .clone()
            };
            let llm_service = provider
                .llm()
                .ok_or_else(|| format!("provider `{provider_id}` does not support llm"))?;

            let model = resolved
                .field("model")
                .map(str::to_owned)
                .or_else(|| llm_service.available_models().into_iter().next())
                .ok_or_else(|| "llm default model must be configured".to_owned())?;
            let system_prompt = beyondtranslate_engine::prompt::explain_translation_system_prompt();
            let user_prompt = format!("Source text: {source}\n\nTranslation: {translation}");

            let response = llm_service
                .chat(beyondtranslate_core::ChatRequest {
                    model,
                    messages: vec![
                        beyondtranslate_core::ChatMessage::system(system_prompt),
                        beyondtranslate_core::ChatMessage::user(user_prompt),
                    ],
                    temperature: None,
                    max_tokens: None,
                    stream: None,
                })
                .await
                .map_err(|error| error.to_string())?;

            response
                .choices
                .first()
                .map(|c| c.message.content.clone())
                .ok_or_else(|| "no response from llm".to_owned())
        })
        .await
    }

    async fn alternatives_impl(
        &self,
        text: String,
        source_lang: String,
        target_lang: String,
        count: u32,
        style: Option<String>,
    ) -> Result<Vec<String>, String> {
        let service_id = self.service_id.clone();
        let runtime = self.runtime.clone();
        run_on_worker_thread(move || async move {
            let text = validate_required("text", text)?;
            let source_lang = validate_required("source_lang", source_lang)?;
            let target_lang = validate_required("target_lang", target_lang)?;
            if count == 0 {
                return Err("count must be greater than 0".to_owned());
            }
            let resolved = runtime.resolve_llm_service(&service_id).await?;
            let provider_id = resolved.provider_id.clone();
            let provider = {
                let state = runtime.inner.state.read().await;
                state
                    .engine
                    .require(&provider_id)
                    .map_err(|error| error.to_string())?
                    .clone()
            };
            let llm_service = provider
                .llm()
                .ok_or_else(|| format!("provider `{provider_id}` does not support llm"))?;

            let model = resolved
                .field("model")
                .map(str::to_owned)
                .or_else(|| llm_service.available_models().into_iter().next())
                .ok_or_else(|| "llm default model must be configured".to_owned())?;
            let system_prompt =
                beyondtranslate_engine::prompt::alternative_translations_system_prompt(
                    count,
                    style.as_deref(),
                );
            let user_prompt = format!(
                "Source language: {source_lang}\nTarget language: {target_lang}\nText: {text}"
            );

            let response = llm_service
                .chat(beyondtranslate_core::ChatRequest {
                    model,
                    messages: vec![
                        beyondtranslate_core::ChatMessage::system(system_prompt),
                        beyondtranslate_core::ChatMessage::user(user_prompt),
                    ],
                    temperature: None,
                    max_tokens: None,
                    stream: None,
                })
                .await
                .map_err(|error| error.to_string())?;

            let content = response
                .choices
                .first()
                .map(|c| c.message.content.clone())
                .ok_or_else(|| "no response from llm".to_owned())?;

            parse_alternatives_json(&content)
        })
        .await
    }

    async fn translate_stream_impl(
        &self,
        source_lang: String,
        target_lang: String,
        text: String,
        callback: Arc<dyn StreamCallback>,
    ) -> Result<(), String> {
        let service_id = self.service_id.clone();
        let runtime = self.runtime.clone();
        run_on_worker_thread(move || async move {
            let text = validate_required("text", text)?;
            let resolved = match runtime
                .resolve_service(&service_id, ServiceType::Translation)
                .await
            {
                Ok(service) => service,
                Err(_) => runtime.resolve_llm_service(&service_id).await?,
            };
            let provider_id = resolved.provider_id.clone();
            let provider = {
                let state = runtime.inner.state.read().await;
                state
                    .engine
                    .require(&provider_id)
                    .map_err(|error| error.to_string())?
                    .clone()
            };
            let llm_service = provider
                .llm()
                .ok_or_else(|| format!("provider `{provider_id}` does not support llm"))?;

            let model = resolved
                .field("model")
                .map(str::to_owned)
                .or_else(|| llm_service.available_models().into_iter().next())
                .ok_or_else(|| "llm default model must be configured".to_owned())?;
            let system_prompt = if let Some(system_prompt) = resolved.field("systemPrompt") {
                render_prompt_template(system_prompt, &source_lang, &target_lang, &text)
            } else {
                beyondtranslate_engine::prompt::translate_text_system_prompt(
                    &source_lang,
                    &target_lang,
                    None,
                )
            };
            let user_prompt = beyondtranslate_engine::prompt::translate_text_user_prompt(&text);

            let receiver = llm_service
                .chat_stream(beyondtranslate_core::ChatRequest {
                    model,
                    messages: vec![
                        beyondtranslate_core::ChatMessage::system(system_prompt),
                        beyondtranslate_core::ChatMessage::user(user_prompt),
                    ],
                    temperature: Some(0.3),
                    max_tokens: Some(4096),
                    stream: Some(true),
                })
                .await
                .map_err(|error| error.to_string())?;

            loop {
                match receiver.rx.recv() {
                    Ok(chunk) => {
                        if let Some(reason) = chunk.finish_reason {
                            if reason == "error" {
                                callback.on_error(chunk.content);
                            } else {
                                callback.on_finish(reason);
                            }
                            break;
                        }
                        callback.on_chunk(chunk.content);
                    }
                    Err(_) => {
                        callback.on_finish("stop".to_string());
                        break;
                    }
                }
            }

            Ok(())
        })
        .await
    }
}

#[uniffi::export(async_runtime = "tokio")]
impl RuntimeLlm {
    pub async fn chat(
        &self,
        model: String,
        messages: Vec<beyondtranslate_core::ChatMessage>,
    ) -> Result<beyondtranslate_core::ChatResponse, RuntimeError> {
        self.chat_impl(model, messages).await.map_err(Into::into)
    }

    pub async fn polish(&self, text: String, style: String) -> Result<String, RuntimeError> {
        self.polish_impl(text, style).await.map_err(Into::into)
    }

    pub async fn explain(
        &self,
        source: String,
        translation: String,
    ) -> Result<String, RuntimeError> {
        self.explain_impl(source, translation)
            .await
            .map_err(Into::into)
    }

    pub async fn alternatives(
        &self,
        text: String,
        source_lang: String,
        target_lang: String,
        count: u32,
        style: Option<String>,
    ) -> Result<Vec<String>, RuntimeError> {
        self.alternatives_impl(text, source_lang, target_lang, count, style)
            .await
            .map_err(Into::into)
    }
}

#[uniffi::export]
impl RuntimeLlm {
    pub fn translate_stream(
        &self,
        source_lang: String,
        target_lang: String,
        text: String,
        callback: Box<dyn StreamCallback>,
    ) {
        let this = self.clone();
        let callback: Arc<dyn StreamCallback> = callback.into();
        let callback_for_worker = callback.clone();

        if let Err(error) = thread::Builder::new()
            .name("beyondtranslate-engine-bridge".to_owned())
            .spawn(move || {
                let result = tokio::runtime::Builder::new_current_thread()
                    .enable_all()
                    .build()
                    .map_err(|error| format!("failed to build tokio runtime: {error}"))
                    .and_then(|runtime| {
                        runtime.block_on(this.translate_stream_impl(
                            source_lang,
                            target_lang,
                            text,
                            callback_for_worker.clone(),
                        ))
                    });

                if let Err(error) = result {
                    callback_for_worker.on_error(error);
                }
            })
        {
            callback.on_error(format!("failed to spawn runtime worker thread: {error}"));
        }
    }
}

fn parse_alternatives_json(content: &str) -> Result<Vec<String>, String> {
    #[derive(serde::Deserialize)]
    struct AlternativesContainer {
        alternatives: Vec<AlternativeEntry>,
    }

    #[derive(serde::Deserialize)]
    struct AlternativeEntry {
        text: String,
    }

    let parsed: AlternativesContainer = serde_json::from_str(content)
        .map_err(|error| format!("failed to parse alternatives response: {error}"))?;

    Ok(parsed.alternatives.into_iter().map(|a| a.text).collect())
}

impl RuntimeOcr {
    async fn recognize_text_impl(
        &self,
        request: RecognizeTextRequest,
    ) -> Result<RecognizeTextResponse, String> {
        let service_id = self.service_id.clone();
        let runtime = self.runtime.clone();
        run_on_worker_thread(move || async move {
            let resolved = runtime
                .resolve_service(&service_id, ServiceType::Ocr)
                .await?;
            let provider_id = resolved.provider_id;
            let provider = {
                let state = runtime.inner.state.read().await;
                state
                    .engine
                    .require(&provider_id)
                    .map_err(|error| error.to_string())?
                    .clone()
            };
            let ocr_service = provider
                .ocr()
                .ok_or_else(|| format!("provider `{provider_id}` does not support ocr"))?;

            ocr_service
                .recognize_text(request)
                .await
                .map_err(|error| error.to_string())
        })
        .await
    }
}

#[uniffi::export(async_runtime = "tokio")]
impl RuntimeOcr {
    pub async fn recognize_text(
        &self,
        request: RecognizeTextRequest,
    ) -> Result<RecognizeTextResponse, RuntimeError> {
        self.recognize_text_impl(request).await.map_err(Into::into)
    }
}

#[uniffi::export(async_runtime = "tokio")]
impl RuntimePermission {
    /// macOS only: check if Screen Recording permission is granted.
    /// Returns `true` on other platforms.
    pub async fn is_screen_recording_permission_granted(&self) -> bool {
        permission::is_screen_recording_permission_granted()
    }

    /// macOS only: request Screen Recording permission.
    /// If `only_open_system_settings` is true, just opens System Settings.
    /// No-op on other platforms.
    pub async fn request_screen_recording_permission(&self, only_open_system_settings: bool) {
        permission::request_screen_recording_permission(only_open_system_settings);
    }

    /// macOS only: check if Accessibility permission is granted.
    /// Returns `true` on other platforms.
    pub async fn is_accessibility_permission_granted(&self) -> bool {
        permission::is_accessibility_permission_granted()
    }

    /// macOS only: request Accessibility permission.
    /// If `only_open_system_settings` is true, just opens System Settings.
    /// No-op on other platforms.
    pub async fn request_accessibility_permission(&self, only_open_system_settings: bool) {
        permission::request_accessibility_permission(only_open_system_settings);
    }
}

#[uniffi::export(async_runtime = "tokio")]
impl RuntimeTextExtractor {
    /// Read the current clipboard text.
    pub async fn extract_from_clipboard(&self) -> Result<String, RuntimeError> {
        text_extractor::extract_from_clipboard()
            .map_err(|e| RuntimeError::Error { msg: e.to_string() })
    }

    /// Extract text from the current screen selection.
    ///
    /// **macOS / Windows:** Simulates Cmd+C / Ctrl+C, polls the clipboard
    /// until content changes (or 3s timeout), then returns the text.
    ///
    /// **Linux:** Reads the PRIMARY selection directly via `xclip`.
    pub async fn extract_from_screen_selection(&self) -> Result<String, RuntimeError> {
        text_extractor::extract_from_screen_selection()
            .map_err(|e| RuntimeError::Error { msg: e.to_string() })
    }

    /// Capture a screenshot and recognize text using the default OCR service.
    ///
    /// 1. Interactively captures a screen region (via `screencapture` on macOS
    ///    or `import` on Linux; unsupported on Windows).
    /// 2. Sends the captured image to the configured default OCR service.
    /// 3. Returns the recognized text.
    ///
    /// The user must have a default OCR service configured in settings.
    pub async fn extract_from_screen_capture(&self) -> Result<String, RuntimeError> {
        let runtime = self.runtime.clone();

        // 1. Take a screenshot to a temporary file.
        let image_path =
            capture_screenshot().map_err(|e| RuntimeError::Error { msg: e.to_string() })?;

        // 2. Read settings to get the default OCR service ID.
        let service_id = {
            let state = runtime.inner.state.read().await;
            let ocr_service_id = state.settings.general.default_ocr_service.clone();
            if ocr_service_id.is_empty() {
                return Err(RuntimeError::Error {
                    msg: "no default OCR service configured".into(),
                });
            }
            ocr_service_id
        };

        // 3. Run OCR on the worker thread.
        let result = run_on_worker_thread(move || async move {
            let resolved = runtime
                .resolve_service(&service_id, ServiceType::Ocr)
                .await?;
            let provider_id = resolved.provider_id;
            let provider = {
                let state = runtime.inner.state.read().await;
                state
                    .engine
                    .require(&provider_id)
                    .map_err(|error| error.to_string())?
                    .clone()
            };
            let ocr_service = provider
                .ocr()
                .ok_or_else(|| format!("provider `{provider_id}` does not support ocr"))?;

            let request = RecognizeTextRequest {
                image_path: Some(image_path),
                base64_image: None,
            };

            let response = ocr_service
                .recognize_text(request)
                .await
                .map_err(|error| error.to_string())?;

            Ok(response.text)
        })
        .await;

        result.map_err(|e| RuntimeError::Error { msg: e })
    }
}

/// Capture a screenshot of a selected screen region and return the path.
///
/// Creates a temporary PNG file, invokes the platform-specific screen
/// capture command, and returns the path to the saved image.
fn capture_screenshot() -> Result<String, String> {
    let timestamp = std::time::SystemTime::now()
        .duration_since(std::time::UNIX_EPOCH)
        .unwrap_or_default()
        .as_millis();
    let file_name = format!("beyondtranslate-screenshot-{timestamp}.png");
    let path = std::env::temp_dir().join(&file_name);
    let path_str = path
        .to_str()
        .ok_or_else(|| "failed to convert screenshot path to string".to_owned())?;

    text_extractor::capture_screen(path_str).map_err(|e| format!("screen capture failed: {e}"))
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

fn validate_provider_id(provider_id: String) -> Result<String, String> {
    validate_required("provider_id", provider_id)
}

fn validate_service_provider_id(provider_id: String, suffix: &str) -> Result<String, String> {
    let provider_id = validate_provider_id(provider_id)?;
    Ok(provider_id
        .strip_suffix(suffix)
        .unwrap_or(&provider_id)
        .to_owned())
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

    fn unique_data_dir() -> PathBuf {
        std::env::temp_dir().join(format!(
            "beyondtranslate-runtime-{}",
            std::time::SystemTime::now()
                .duration_since(std::time::UNIX_EPOCH)
                .expect("time went backwards")
                .as_nanos()
        ))
    }

    fn create_runtime() -> Arc<Runtime> {
        let data_dir = unique_data_dir();
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
    fn update_shortcuts_persists_all_fields_to_settings_file() {
        let data_dir = unique_data_dir();
        let settings_file = data_dir.join("settings.json");
        let runtime =
            Runtime::new(data_dir.display().to_string()).expect("failed to create runtime");

        tokio::runtime::Builder::new_current_thread()
            .enable_all()
            .build()
            .unwrap()
            .block_on(async {
                runtime
                    .clone()
                    .settings()
                    .update_shortcuts(ShortcutSettingsPatch {
                        toggle_mini_translator: Some("Command+Shift+Space".to_owned()),
                        extract_text_from_screen_selection: Some("Command+Shift+1".to_owned()),
                        extract_text_from_screen_capture: Some("Command+Shift+2".to_owned()),
                        extract_text_from_clipboard: Some("Command+Shift+3".to_owned()),
                        translate_input_content: Some("Option+Z".to_owned()),
                    })
                    .await
                    .expect("failed to update shortcuts");
            });

        let saved = std::fs::read_to_string(settings_file).expect("failed to read settings file");
        let json =
            serde_json::from_str::<serde_json::Value>(&saved).expect("invalid settings json");
        assert_eq!(
            json.pointer("/shortcuts/toggleMiniTranslator").cloned(),
            Some(serde_json::Value::String("Command+Shift+Space".to_owned()))
        );
        assert_eq!(
            json.pointer("/shortcuts/extractTextFromScreenSelection")
                .cloned(),
            Some(serde_json::Value::String("Command+Shift+1".to_owned()))
        );
        assert_eq!(
            json.pointer("/shortcuts/extractTextFromScreenCapture")
                .cloned(),
            Some(serde_json::Value::String("Command+Shift+2".to_owned()))
        );
        assert_eq!(
            json.pointer("/shortcuts/extractTextFromClipboard").cloned(),
            Some(serde_json::Value::String("Command+Shift+3".to_owned()))
        );
        assert_eq!(
            json.pointer("/shortcuts/translateInputContent").cloned(),
            Some(serde_json::Value::String("Option+Z".to_owned()))
        );
    }

    #[test]
    fn reset_shortcuts_persists_rust_defaults_to_settings_file() {
        let data_dir = unique_data_dir();
        let settings_file = data_dir.join("settings.json");
        let runtime =
            Runtime::new(data_dir.display().to_string()).expect("failed to create runtime");

        tokio::runtime::Builder::new_current_thread()
            .enable_all()
            .build()
            .unwrap()
            .block_on(async {
                runtime
                    .clone()
                    .settings()
                    .update_shortcuts(ShortcutSettingsPatch {
                        toggle_mini_translator: Some("Command+Shift+Space".to_owned()),
                        extract_text_from_screen_selection: Some("Command+Shift+1".to_owned()),
                        extract_text_from_screen_capture: Some("Command+Shift+2".to_owned()),
                        extract_text_from_clipboard: Some("Command+Shift+3".to_owned()),
                        translate_input_content: Some("Command+Shift+4".to_owned()),
                    })
                    .await
                    .expect("failed to update shortcuts");

                let reset = runtime
                    .settings()
                    .reset_shortcuts()
                    .await
                    .expect("failed to reset shortcuts");
                assert_eq!(reset, ShortcutSettings::default());
            });

        let saved = std::fs::read_to_string(settings_file).expect("failed to read settings file");
        let settings =
            serde_json::from_str::<Settings>(&saved).expect("failed to parse settings file");
        assert_eq!(settings.shortcuts, ShortcutSettings::default());
    }

    #[test]
    fn service_provider_id_suffixes_are_accepted_for_compatibility() {
        assert_eq!(
            validate_service_provider_id("system+translation".to_owned(), "+translation").unwrap(),
            "system"
        );
        assert_eq!(
            validate_service_provider_id("system+dictionary".to_owned(), "+dictionary").unwrap(),
            "system"
        );
        assert_eq!(
            validate_service_provider_id("system+ocr".to_owned(), "+ocr").unwrap(),
            "system"
        );
        assert_eq!(
            validate_service_provider_id("system".to_owned(), "+translation").unwrap(),
            "system"
        );
    }

    #[cfg(target_os = "macos")]
    #[test]
    fn system_dictionary_lookup_returns_structured_definitions() {
        let runtime = create_runtime();

        let response = tokio::runtime::Builder::new_current_thread()
            .enable_all()
            .build()
            .unwrap()
            .block_on(async {
                runtime
                    .clone()
                    .dictionary("system".to_owned())
                    .expect("failed to get dictionary")
                    .lookup(LookUpRequest {
                        source_language: "en".to_owned(),
                        target_language: "zh".to_owned(),
                        word: "hello".to_owned(),
                    })
                    .await
                    .expect("failed to look up hello")
            });

        let pronunciations = response.pronunciations.expect("pronunciations");
        assert_eq!(pronunciations.len(), 2);
        assert_eq!(pronunciations[0].r#type.as_deref(), Some("uk"));
        assert_eq!(pronunciations[1].r#type.as_deref(), Some("us"));

        let definitions = response.definitions.expect("definitions");
        assert!(
            definitions.iter().any(|definition| definition
                .values
                .as_ref()
                .map(|values| values.iter().any(|value| value.contains("问候")))
                .unwrap_or(false)),
            "expected parsed definitions to include the noun translation: {definitions:#?}"
        );
        assert!(
            definitions
                .iter()
                .flat_map(|definition| definition.values.as_deref().unwrap_or_default())
                .all(|value| !value.trim().is_empty()),
            "definitions should not contain empty values: {definitions:#?}"
        );
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
    fn runtime_new_returns_same_inner_for_same_data_dir() {
        let data_dir = unique_data_dir();
        let path = data_dir.display().to_string();

        let first = Runtime::new(path.clone()).expect("failed to create first runtime");
        let second = Runtime::new(path).expect("failed to create second runtime");

        assert!(
            Arc::ptr_eq(&first.inner, &second.inner),
            "Runtime::new should return a handle backed by the shared singleton inner"
        );
    }

    #[test]
    fn runtime_new_returns_distinct_inner_for_different_data_dirs() {
        let first =
            Runtime::new(unique_data_dir().display().to_string()).expect("failed to create first");
        let second =
            Runtime::new(unique_data_dir().display().to_string()).expect("failed to create second");

        assert!(
            !Arc::ptr_eq(&first.inner, &second.inner),
            "different data dirs should produce independent runtimes"
        );
    }

    #[test]
    fn subscribe_receives_change_for_each_section() {
        let runtime = create_runtime();

        tokio::runtime::Builder::new_current_thread()
            .enable_all()
            .build()
            .unwrap()
            .block_on(async {
                let settings = runtime.clone().settings();
                let subscription = settings.subscribe();

                settings
                    .update_appearance(AppearanceSettingsPatch {
                        language: Some("en".to_owned()),
                        theme_mode: None,
                    })
                    .await
                    .expect("update_appearance failed");
                assert_eq!(
                    subscription.next().await.expect("recv failed"),
                    Some(SettingsChange::Appearance)
                );

                settings
                    .update_general(GeneralSettingsPatch {
                        launch_at_login: Some(true),
                        show_in_menu_bar: None,
                        default_ocr_service: None,
                        auto_copy_detected_text: None,
                        default_directory_service: None,
                        default_translation_service: None,
                        translation_targets: None,
                        input_submit_mode: None,
                        double_click_copy_result: None,
                        common_languages: None,
                    })
                    .await
                    .expect("update_general failed");
                assert_eq!(
                    subscription.next().await.expect("recv failed"),
                    Some(SettingsChange::General)
                );

                settings
                    .update_shortcuts(ShortcutSettingsPatch {
                        toggle_mini_translator: Some("Cmd+Space".to_owned()),
                        extract_text_from_screen_selection: None,
                        extract_text_from_screen_capture: None,
                        extract_text_from_clipboard: None,
                        translate_input_content: None,
                    })
                    .await
                    .expect("update_shortcuts failed");
                assert_eq!(
                    subscription.next().await.expect("recv failed"),
                    Some(SettingsChange::Shortcuts)
                );
            });
    }

    #[test]
    fn subscribe_fans_out_to_multiple_subscribers() {
        let runtime = create_runtime();

        tokio::runtime::Builder::new_current_thread()
            .enable_all()
            .build()
            .unwrap()
            .block_on(async {
                let settings = runtime.clone().settings();
                let sub_a = settings.subscribe();
                let sub_b = settings.subscribe();

                settings
                    .update_appearance(AppearanceSettingsPatch {
                        language: Some("zh-Hans".to_owned()),
                        theme_mode: None,
                    })
                    .await
                    .expect("update_appearance failed");

                assert_eq!(
                    sub_a.next().await.expect("recv failed"),
                    Some(SettingsChange::Appearance)
                );
                assert_eq!(
                    sub_b.next().await.expect("recv failed"),
                    Some(SettingsChange::Appearance)
                );
            });
    }

    #[test]
    fn subscribe_observes_writes_from_other_handles() {
        // Mirrors the cross-binding scenario: writer and reader both
        // come from the same singleton; subscribing on one observes
        // writes performed on the other.
        let data_dir = unique_data_dir();
        let path = data_dir.display().to_string();
        let writer = Runtime::new(path.clone()).expect("failed to create writer runtime");
        let reader = Runtime::new(path).expect("failed to create reader runtime");

        tokio::runtime::Builder::new_current_thread()
            .enable_all()
            .build()
            .unwrap()
            .block_on(async {
                let subscription = reader.clone().settings().subscribe();

                writer
                    .clone()
                    .settings()
                    .update_appearance(AppearanceSettingsPatch {
                        language: Some("zh-Hans".to_owned()),
                        theme_mode: None,
                    })
                    .await
                    .expect("writer update_appearance failed");

                assert_eq!(
                    subscription.next().await.expect("recv failed"),
                    Some(SettingsChange::Appearance)
                );
            });
    }

    #[test]
    fn shared_runtime_observes_each_other_writes() {
        let data_dir = unique_data_dir();
        let path = data_dir.display().to_string();
        let writer = Runtime::new(path.clone()).expect("failed to create writer runtime");
        let reader = Runtime::new(path).expect("failed to create reader runtime");

        tokio::runtime::Builder::new_current_thread()
            .enable_all()
            .build()
            .unwrap()
            .block_on(async {
                writer
                    .clone()
                    .settings()
                    .update_appearance(AppearanceSettingsPatch {
                        language: Some("zh-Hans".to_owned()),
                        theme_mode: None,
                    })
                    .await
                    .expect("failed to update appearance via writer");

                let read_back = reader
                    .clone()
                    .settings()
                    .get_appearance()
                    .await
                    .expect("failed to read appearance via reader");

                assert_eq!(read_back.language, "zh-Hans");
            });
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
