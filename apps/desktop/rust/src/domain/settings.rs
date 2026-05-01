use std::collections::BTreeMap;
use std::fs;
use std::path::Path;

use beyondtranslate_engine::EngineConfig;
use serde::{Deserialize, Serialize};
use serde_json::{Map, Value};
use struct_patch::Patch;

#[derive(Clone, Debug, Default, Deserialize, PartialEq, Serialize, Patch)]
#[patch(attribute(derive(Clone, Debug, Default, Deserialize, Serialize)))]
pub struct ShortcutSettings {
    #[serde(default, rename = "toggleApp")]
    pub toggle_app: String,
}

#[derive(Clone, Debug, Deserialize, PartialEq, Serialize, Patch)]
#[patch(attribute(derive(Clone, Debug, Default, Deserialize, Serialize)))]
pub struct AppearanceSettings {
    #[serde(default = "default_language")]
    pub language: String,
    #[serde(default = "default_theme_mode", rename = "themeMode")]
    pub theme_mode: String,
}

impl Default for AppearanceSettings {
    fn default() -> Self {
        Self {
            language: default_language(),
            theme_mode: default_theme_mode(),
        }
    }
}

#[derive(Clone, Debug, Default, Deserialize, PartialEq, Serialize, Patch)]
#[patch(attribute(derive(Clone, Debug, Default, Deserialize, Serialize)))]
pub struct AdvancedSettings {
    #[serde(default, rename = "launchAtLogin")]
    pub launch_at_login: bool,
    #[serde(default)]
    pub proxy: String,
}

#[derive(Clone, Debug, Default, Deserialize, PartialEq, Serialize)]
pub struct Settings {
    #[serde(default, skip_serializing_if = "engine_config_is_empty")]
    #[serde(flatten)]
    pub engine: EngineConfig,
    #[serde(default)]
    pub shortcuts: ShortcutSettings,
    #[serde(default)]
    pub appearance: AppearanceSettings,
    #[serde(default)]
    pub advanced: AdvancedSettings,
    #[serde(flatten)]
    pub values: BTreeMap<String, Value>,
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
}

fn engine_config_is_empty(config: &EngineConfig) -> bool {
    config.providers.is_empty()
}

fn default_language() -> String {
    "zh".to_owned()
}

fn default_theme_mode() -> String {
    "light".to_owned()
}

pub fn merge_raw_json_preserving_unknown_keys(
    raw_json: &str,
) -> Result<Map<String, Value>, String> {
    let value = serde_json::from_str::<Value>(raw_json)
        .map_err(|error| format!("failed to parse settings json: {error}"))?;
    match value {
        Value::Object(object) => Ok(object),
        _ => Err("settings json root must be an object".to_owned()),
    }
}

#[cfg(test)]
fn get_json_pointer(object: &Map<String, Value>, pointer: &str) -> Option<Value> {
    Value::Object(object.clone()).pointer(pointer).cloned()
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

        assert!(settings.engine.providers.is_empty());
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
    "toggleApp": "Command+Shift+Space"
  },
  "appearance": {
    "language": "en",
    "themeMode": "dark"
  },
  "advanced": {
    "launchAtLogin": true,
    "proxy": "http://127.0.0.1:7890"
  }
}"#,
        )
        .expect("failed to write settings");

        let settings = Settings::load(&path).expect("failed to load settings");
        assert_eq!(settings.shortcuts.toggle_app, "Command+Shift+Space");
        assert_eq!(settings.appearance.language, "en");
        assert_eq!(settings.appearance.theme_mode, "dark");
        assert!(settings.advanced.launch_at_login);
        assert_eq!(settings.advanced.proxy, "http://127.0.0.1:7890");
    }

    #[test]
    fn save_preserves_unknown_keys_and_writes_settings_schema() {
        let path = temp_settings_file();
        fs::create_dir_all(path.parent().unwrap()).expect("failed to create temp dir");
        fs::write(
            &path,
            r#"{
  "workbench.sideBar.location": "right",
  "shortcuts": {
    "toggleApp": "Command+Shift+Space"
  }
}"#,
        )
        .expect("failed to write settings");

        let mut settings = Settings::load(&path).expect("failed to load settings");
        settings.appearance.language = "en".to_owned();
        settings.appearance.theme_mode = "system".to_owned();
        settings.advanced.launch_at_login = true;
        settings.advanced.proxy = "http://127.0.0.1:7890".to_owned();
        settings.save(&path).expect("failed to save settings");

        let saved = fs::read_to_string(path).expect("failed to read saved settings");
        let json = merge_raw_json_preserving_unknown_keys(&saved).expect("invalid saved json");

        assert_eq!(
            json.get("workbench.sideBar.location")
                .and_then(Value::as_str),
            Some("right")
        );
        assert_eq!(
            get_json_pointer(&json, "/shortcuts/toggleApp"),
            Some(Value::String("Command+Shift+Space".to_owned()))
        );
        assert_eq!(
            get_json_pointer(&json, "/appearance/language"),
            Some(Value::String("en".to_owned()))
        );
        assert_eq!(
            get_json_pointer(&json, "/appearance/themeMode"),
            Some(Value::String("system".to_owned()))
        );
        assert_eq!(
            get_json_pointer(&json, "/advanced/launchAtLogin"),
            Some(Value::Bool(true))
        );
        assert_eq!(
            get_json_pointer(&json, "/advanced/proxy"),
            Some(Value::String("http://127.0.0.1:7890".to_owned()))
        );
    }

    #[test]
    fn engine_config_is_flattened() {
        let settings = Settings::default();
        let json = merge_raw_json_preserving_unknown_keys(&settings.to_pretty_json().unwrap())
            .expect("invalid settings json");

        assert!(!json.contains_key("engine"));
        assert!(json.contains_key("shortcuts"));
        assert!(json.contains_key("appearance"));
        assert!(json.contains_key("advanced"));
    }
}
