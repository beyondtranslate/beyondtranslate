use std::collections::{BTreeMap, HashMap};
use std::fs;
use std::path::Path;
use std::time::{SystemTime, UNIX_EPOCH};

use beyondtranslate_engine::{ProviderConfig, ProviderType};
use flutter_rust_bridge::frb;
use serde::de::Error as DeError;
use serde::ser::SerializeMap;
use serde::{Deserialize, Deserializer, Serialize, Serializer};
use serde_json::Value;
use struct_patch::Patch;

#[derive(Clone, Debug, Deserialize, PartialEq, Serialize, Patch)]
#[patch(attribute(derive(Clone, Debug, Default, Deserialize, Serialize)))]
pub struct ShortcutSettings {
    #[serde(default, rename = "toggleApp")]
    pub toggle_app: String,
    #[serde(default, rename = "hideApp")]
    pub hide_app: String,
    #[serde(default, rename = "extractFromScreenSelection")]
    pub extract_from_screen_selection: String,
    #[serde(default, rename = "extractFromScreenCapture")]
    pub extract_from_screen_capture: String,
    #[serde(default, rename = "extractFromClipboard")]
    pub extract_from_clipboard: String,
}

impl Default for ShortcutSettings {
    fn default() -> Self {
        Self {
            toggle_app: "Control+Option+Space".to_owned(),
            hide_app: "Escape".to_owned(),
            extract_from_screen_selection: "Control+Shift+1".to_owned(),
            extract_from_screen_capture: "Control+Shift+2".to_owned(),
            extract_from_clipboard: "Control+Shift+3".to_owned(),
        }
    }
}

#[derive(Clone, Debug, Deserialize, PartialEq, Serialize, Patch)]
#[patch(attribute(derive(Clone, Debug, Default, Deserialize, Serialize)))]
#[serde(default)]
pub struct AppearanceSettings {
    pub language: String,
    #[serde(rename = "themeMode")]
    pub theme_mode: String,
}

impl Default for AppearanceSettings {
    fn default() -> Self {
        Self {
            language: "zh".to_owned(),
            theme_mode: "light".to_owned(),
        }
    }
}

#[derive(Clone, Debug, Deserialize, PartialEq, Serialize, Patch)]
#[patch(attribute(derive(Clone, Debug, Default, Deserialize, Serialize)))]
#[serde(default)]
pub struct GeneralSettings {
    #[serde(rename = "launchAtLogin")]
    pub launch_at_login: bool,
    #[serde(rename = "showMenuBar")]
    pub show_menu_bar: bool,
}

impl Default for GeneralSettings {
    fn default() -> Self {
        Self {
            launch_at_login: false,
            show_menu_bar: true,
        }
    }
}

#[derive(Clone, Debug, Default, Deserialize, PartialEq, Serialize, Patch)]
#[patch(attribute(derive(Clone, Debug, Default, Deserialize, Serialize)))]
pub struct AdvancedSettings {}

#[derive(Clone, Debug, Default, Deserialize, PartialEq, Serialize)]
pub struct ProviderConfigEntry {
    #[serde(default)]
    pub id: String,
    #[serde(default, rename = "type")]
    pub r#type: String,
    #[serde(default)]
    pub fields: HashMap<String, String>,
    /// Provider capabilities, populated at runtime from the engine instance.
    /// Not written to the settings file.
    #[serde(default, skip_serializing)]
    pub capabilities: Vec<String>,
}

#[derive(Clone, Debug, Default, Deserialize, PartialEq, Serialize)]
#[frb(non_opaque)]
pub struct Settings {
    #[serde(default, rename = "lastUpdated")]
    pub last_updated: u64,
    #[serde(
        default,
        skip_serializing_if = "HashMap::is_empty",
        serialize_with = "serialize_providers",
        deserialize_with = "deserialize_providers"
    )]
    pub providers: HashMap<String, ProviderConfigEntry>,
    #[serde(default)]
    pub general: GeneralSettings,
    #[serde(default)]
    pub shortcuts: ShortcutSettings,
    #[serde(default)]
    pub appearance: AppearanceSettings,
    #[serde(default)]
    pub advanced: AdvancedSettings,
}

impl Settings {
    pub fn load(file_path: impl AsRef<Path>) -> Result<Self, String> {
        let path = file_path.as_ref();
        if !path.exists() {
            return Ok(Self::default());
        }

        let content = fs::read_to_string(&path).map_err(|error| {
            format!("failed to read settings file `{}`: {error}", path.display())
        })?;

        serde_json::from_str::<Self>(&content).map_err(|error| {
            format!(
                "failed to parse settings file `{}`: {error}",
                path.display()
            )
        })
    }

    pub fn save(&self, file_path: impl AsRef<Path>) -> Result<(), String> {
        let path = file_path.as_ref();
        if let Some(parent) = path.parent() {
            fs::create_dir_all(parent).map_err(|error| {
                format!(
                    "failed to create settings directory `{}`: {error}",
                    parent.display()
                )
            })?;
        }

        let content = self.to_pretty_json()?;
        fs::write(&path, content).map_err(|error| {
            format!(
                "failed to write settings file `{}`: {error}",
                path.display()
            )
        })
    }

    pub fn to_pretty_json(&self) -> Result<String, String> {
        let root = serde_json::to_value(self)
            .map_err(|error| format!("failed to encode settings: {error}"))?;

        if !root.is_object() {
            return Err("settings root must encode to a JSON object".to_owned());
        }

        serde_json::to_string_pretty(&root)
            .map_err(|error| format!("failed to render settings json: {error}"))
    }

    pub fn touch_last_updated(&mut self) -> Result<(), String> {
        self.last_updated = current_timestamp_millis()?;
        Ok(())
    }
}

fn current_timestamp_millis() -> Result<u64, String> {
    SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .map_err(|error| format!("system clock is before unix epoch: {error}"))?
        .as_millis()
        .try_into()
        .map_err(|_| "current timestamp does not fit in u64".to_owned())
}

pub fn provider_config_from_settings(
    provider: &ProviderConfigEntry,
) -> Result<ProviderConfig, String> {
    let provider_type = parse_provider_type(&provider.r#type)?;
    let mut options = BTreeMap::new();
    for (key, value) in &provider.fields {
        options.insert(key.clone(), serde_yaml::Value::String(value.clone()));
    }
    Ok(ProviderConfig {
        provider_type,
        options,
    })
}

fn serialize_providers<S>(
    providers: &HashMap<String, ProviderConfigEntry>,
    serializer: S,
) -> Result<S::Ok, S::Error>
where
    S: Serializer,
{
    let mut map = serializer.serialize_map(Some(providers.len()))?;
    for (provider_id, provider) in providers {
        let config = provider_config_from_settings(provider).map_err(serde::ser::Error::custom)?;
        let value = provider_config_json_value(&config).map_err(serde::ser::Error::custom)?;
        map.serialize_entry(provider_id, &value)?;
    }
    map.end()
}

fn deserialize_providers<'de, D>(
    deserializer: D,
) -> Result<HashMap<String, ProviderConfigEntry>, D::Error>
where
    D: Deserializer<'de>,
{
    let providers = HashMap::<String, Value>::deserialize(deserializer)?;
    providers
        .into_iter()
        .map(|(provider_id, value)| {
            provider_entry_from_value(&provider_id, value)
                .map(|entry| (provider_id, entry))
                .map_err(D::Error::custom)
        })
        .collect()
}

fn provider_entry_from_value(
    provider_id: &str,
    value: Value,
) -> Result<ProviderConfigEntry, String> {
    let config = serde_json::from_value::<ProviderConfig>(value)
        .map_err(|error| format!("invalid provider config `{provider_id}`: {error}"))?;
    provider_entry_from_config(provider_id, &config)
}

pub fn provider_entry_from_config(
    provider_id: &str,
    config: &ProviderConfig,
) -> Result<ProviderConfigEntry, String> {
    let value = provider_config_json_value(config)?;
    let Value::Object(mut object) = value else {
        return Err("provider config must encode to an object".to_owned());
    };
    object.remove("type");

    let fields = object
        .into_iter()
        .filter_map(|(key, value)| provider_config_field_value(value).map(|value| (key, value)))
        .collect();

    Ok(ProviderConfigEntry {
        id: provider_id.to_owned(),
        r#type: config.provider_type.as_str().to_owned(),
        fields,
        capabilities: Vec::new(),
    })
}

fn parse_provider_type(value: &str) -> Result<ProviderType, String> {
    serde_yaml::from_value::<ProviderType>(serde_yaml::Value::String(value.to_owned()))
        .map_err(|error| format!("invalid provider type `{value}`: {error}"))
}

fn provider_config_field_value(value: Value) -> Option<String> {
    match value {
        Value::String(value) => Some(value),
        Value::Number(value) => Some(value.to_string()),
        Value::Bool(value) => Some(value.to_string()),
        Value::Null => None,
        Value::Array(_) | Value::Object(_) => Some(value.to_string()),
    }
}

fn provider_config_json_value(config: &ProviderConfig) -> Result<Value, String> {
    let mut value = serde_json::to_value(config)
        .map_err(|error| format!("failed to encode provider: {error}"))?;
    normalize_provider_config_keys(&mut value);
    Ok(value)
}

fn normalize_provider_config_keys(value: &mut Value) {
    let Value::Object(object) = value else {
        return;
    };

    for (from, to) in [
        ("api_key", "appKey"),
        ("apiKey", "appKey"),
        ("app_key", "appKey"),
        ("app_id", "appId"),
        ("base_url", "baseUrl"),
        ("request_id", "requestId"),
        ("secret_id", "secretId"),
        ("secret_key", "secretKey"),
        ("app_secret", "appSecret"),
        ("picture_base_url", "pictureBaseUrl"),
    ] {
        if let Some(value) = object.remove(from) {
            object.insert(to.to_owned(), value);
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::path::PathBuf;
    use std::time::{SystemTime, UNIX_EPOCH};

    fn temp_settings_file() -> PathBuf {
        let unique = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .expect("time went backwards")
            .as_nanos();
        std::env::temp_dir()
            .join(format!("beyondtranslate-settings-{unique}"))
            .join("settings.json")
    }

    #[test]
    fn load_missing_file_returns_defaults() {
        let file_path = temp_settings_file();
        let settings = Settings::load(&file_path).expect("failed to load settings");

        assert!(settings.providers.is_empty());
        assert_eq!(settings.general, GeneralSettings::default());
        assert_eq!(settings.shortcuts, ShortcutSettings::default());
        assert_eq!(settings.appearance, AppearanceSettings::default());
        assert_eq!(settings.advanced, AdvancedSettings::default());
    }

    #[test]
    fn load_settings_schema() {
        let path = temp_settings_file();
        fs::create_dir_all(path.parent().unwrap()).expect("failed to create temp dir");
        fs::write(
            &path,
            r#"{
  "shortcuts": {
    "toggleApp": "Command+Shift+Space",
    "hideApp": "Escape",
    "extractFromScreenSelection": "Command+Shift+1",
    "extractFromScreenCapture": "Command+Shift+2",
    "extractFromClipboard": "Command+Shift+3"
  },
  "appearance": {
    "language": "en",
    "themeMode": "dark"
  },
  "general": {
    "launchAtLogin": true,
    "showMenuBar": false
  },
  "advanced": {},
  "providers": {
    "deepl-main": {
      "type": "deepl",
      "appKey": "test-key"
    }
  },
  "lastUpdated": 1710000000000
}"#,
        )
        .expect("failed to write settings");

        let settings = Settings::load(&path).expect("failed to load settings");
        assert_eq!(settings.last_updated, 1710000000000);
        assert_eq!(settings.shortcuts.toggle_app, "Command+Shift+Space");
        assert_eq!(settings.shortcuts.hide_app, "Escape");
        assert_eq!(
            settings.shortcuts.extract_from_screen_selection,
            "Command+Shift+1"
        );
        assert_eq!(
            settings.shortcuts.extract_from_screen_capture,
            "Command+Shift+2"
        );
        assert_eq!(settings.shortcuts.extract_from_clipboard, "Command+Shift+3");
        assert_eq!(settings.appearance.language, "en");
        assert_eq!(settings.appearance.theme_mode, "dark");
        assert!(settings.general.launch_at_login);
        assert!(!settings.general.show_menu_bar);
        assert_eq!(settings.providers.len(), 1);
        let provider = settings.providers.get("deepl-main").unwrap();
        assert_eq!(provider.id, "deepl-main");
        assert_eq!(provider.r#type, "deepl");
        let parsed = provider_config_from_settings(provider).unwrap();
        assert_eq!(parsed.provider_type.as_str(), "deepl");
        assert_eq!(
            parsed.options.get("appKey"),
            Some(&serde_yaml::Value::String("test-key".to_owned()))
        );
    }

    #[test]
    fn save_writes_settings_schema() {
        let path = temp_settings_file();
        fs::create_dir_all(path.parent().unwrap()).expect("failed to create temp dir");

        let mut settings = Settings::default();
        settings.shortcuts.toggle_app = "Command+Shift+Space".to_owned();
        settings.shortcuts.hide_app = "Escape".to_owned();
        settings.shortcuts.extract_from_screen_selection = "Command+Shift+1".to_owned();
        settings.shortcuts.extract_from_screen_capture = "Command+Shift+2".to_owned();
        settings.shortcuts.extract_from_clipboard = "Command+Shift+3".to_owned();
        settings.appearance.language = "en".to_owned();
        settings.appearance.theme_mode = "system".to_owned();
        settings.general.launch_at_login = true;
        settings.general.show_menu_bar = false;
        settings.providers.insert(
            "deepl-main".to_owned(),
            ProviderConfigEntry {
                id: "deepl-main".to_owned(),
                r#type: "deepl".to_owned(),
                fields: HashMap::from([("appKey".to_owned(), "test-key".to_owned())]),
                capabilities: Vec::new(),
            },
        );
        settings.save(&path).expect("failed to save settings");

        let saved = fs::read_to_string(path).expect("failed to read saved settings");
        let json = serde_json::from_str::<Value>(&saved).expect("invalid saved json");
        assert_eq!(
            json.pointer("/shortcuts/toggleApp").cloned(),
            Some(Value::String("Command+Shift+Space".to_owned()))
        );
        assert_eq!(
            json.pointer("/shortcuts/hideApp").cloned(),
            Some(Value::String("Escape".to_owned()))
        );
        assert_eq!(
            json.pointer("/shortcuts/extractFromScreenSelection")
                .cloned(),
            Some(Value::String("Command+Shift+1".to_owned()))
        );
        assert_eq!(
            json.pointer("/shortcuts/extractFromScreenCapture").cloned(),
            Some(Value::String("Command+Shift+2".to_owned()))
        );
        assert_eq!(
            json.pointer("/shortcuts/extractFromClipboard").cloned(),
            Some(Value::String("Command+Shift+3".to_owned()))
        );
        assert_eq!(
            json.pointer("/appearance/language").cloned(),
            Some(Value::String("en".to_owned()))
        );
        assert_eq!(
            json.pointer("/appearance/themeMode").cloned(),
            Some(Value::String("system".to_owned()))
        );
        assert_eq!(
            json.pointer("/general/launchAtLogin").cloned(),
            Some(Value::Bool(true))
        );
        assert_eq!(
            json.pointer("/general/showMenuBar").cloned(),
            Some(Value::Bool(false))
        );
        assert_eq!(
            json.pointer("/providers/deepl-main/type").cloned(),
            Some(Value::String("deepl".to_owned()))
        );
        assert_eq!(
            json.pointer("/providers/deepl-main/appKey").cloned(),
            Some(Value::String("test-key".to_owned()))
        );
        assert!(json.pointer("/providers/deepl-main/id").is_none());
        assert_eq!(json.get("lastUpdated").and_then(Value::as_u64), Some(0));
    }

    #[test]
    fn engine_config_is_flattened() {
        let settings = Settings::default();
        let json = serde_json::from_str::<Value>(&settings.to_pretty_json().unwrap())
            .expect("invalid settings json");

        assert!(json.get("engine").is_none());
        assert!(json.get("general").is_some());
        assert!(json.get("shortcuts").is_some());
        assert!(json.get("providers").is_none());
        assert!(json.get("appearance").is_some());
        assert!(json.get("advanced").is_some());
        assert!(json.get("lastUpdated").is_some());
    }
}
