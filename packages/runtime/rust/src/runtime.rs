use std::collections::HashMap;
use std::future::Future;
use std::path::PathBuf;
use std::sync::{Arc, Mutex, OnceLock};
use std::thread;

use beyondtranslate_core::{
    LookUpRequest, LookUpResponse, RecognizeTextRequest, RecognizeTextResponse, TranslateRequest,
    TranslateResponse,
};
use struct_patch::Patch as ApplyPatch;
use tokio::sync::{broadcast, Mutex as AsyncMutex, RwLock};

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
    fn new(settings: Settings) -> Result<Self, String> {
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
    provider_id: String,
}

#[derive(uniffi::Object)]
pub struct RuntimeDictionary {
    runtime: Runtime,
    provider_id: String,
}

#[derive(uniffi::Object)]
pub struct RuntimeOcr {
    runtime: Runtime,
    provider_id: String,
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

    pub fn ocr(self: Arc<Self>, provider_id: String) -> Result<Arc<RuntimeOcr>, RuntimeError> {
        let provider_id = validate_provider_id(provider_id).map_err(RuntimeError::from)?;
        Ok(Arc::new(RuntimeOcr {
            runtime: (*self).clone(),
            provider_id,
        }))
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

        let engine_changed = next_settings.providers != state.settings.providers;

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

    pub async fn list_providers(&self) -> Result<Vec<ProviderConfigEntry>, RuntimeError> {
        let state = self.runtime.inner.state.read().await;
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

        self.commit_settings(SettingsChange::Providers, move |settings| {
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
        self.commit_settings(SettingsChange::Providers, move |settings| {
            Ok(settings
                .providers
                .remove(&provider_id)
                .map(|provider| normalized_provider_entry(&provider_id, &provider)))
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
        let provider_id = self.provider_id.clone();
        let runtime = self.runtime.clone();
        run_on_worker_thread(move || async move {
            let target_language =
                validate_optional_required("target_language", request.target_language)?;
            let text = validate_required("text", request.text)?;
            let state = runtime.inner.state.read().await;
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
            let state = runtime.inner.state.read().await;
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

impl RuntimeOcr {
    async fn recognize_text_impl(
        &self,
        request: RecognizeTextRequest,
    ) -> Result<RecognizeTextResponse, String> {
        let provider_id = self.provider_id.clone();
        let runtime = self.runtime.clone();
        run_on_worker_thread(move || async move {
            let state = runtime.inner.state.read().await;
            let ocr_service = state
                .engine
                .ocr(&provider_id)
                .map_err(|error| error.to_string())?;

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
                        show_menu_bar: None,
                        default_ocr_service: None,
                        auto_copy_detected_text: None,
                        default_directory_service: None,
                        default_translation_service: None,
                        translation_mode: None,
                        translation_targets: None,
                        input_submit_mode: None,
                        double_click_copy_result: None,
                    })
                    .await
                    .expect("update_general failed");
                assert_eq!(
                    subscription.next().await.expect("recv failed"),
                    Some(SettingsChange::General)
                );

                settings
                    .update_shortcuts(ShortcutSettingsPatch {
                        toggle_app: Some("Cmd+Space".to_owned()),
                        hide_app: None,
                        extract_from_screen_selection: None,
                        extract_from_screen_capture: None,
                        extract_from_clipboard: None,
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
                        language: Some("zh".to_owned()),
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
                        language: Some("zh".to_owned()),
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
                        language: Some("zh".to_owned()),
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

                assert_eq!(read_back.language, "zh");
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
