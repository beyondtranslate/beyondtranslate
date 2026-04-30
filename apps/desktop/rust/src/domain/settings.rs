use std::collections::BTreeMap;
use std::fs;
use std::path::{Path, PathBuf};

use beyondtranslate_engine::EngineConfig;
use serde::{Deserialize, Serialize};
use serde_json::{Map, Value};

const WINDOW_THEME_KEY: &str = "window.theme";
const WINDOW_LANGUAGE_KEY: &str = "window.language";
const DEFAULT_WINDOW_THEME: &str = "system";
const DEFAULT_WINDOW_LANGUAGE: &str = "zh";

#[derive(Clone, Debug, Deserialize, Serialize)]
pub struct RustSettingsDto {
    pub window_theme: String,
    pub window_language: String,
    pub raw_json: String,
}

#[derive(Clone, Debug, Default, Deserialize, Serialize)]
pub struct Settings {
    #[serde(default, skip_serializing_if = "engine_config_is_empty")]
    pub engine: EngineConfig,
    #[serde(flatten)]
    pub values: BTreeMap<String, Value>,
}

impl Settings {
    pub fn load(storage_dir: impl AsRef<Path>) -> Result<Self, String> {
        let path = settings_file_path(storage_dir);
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

    pub fn save(&self, storage_dir: impl AsRef<Path>) -> Result<(), String> {
        let path = settings_file_path(storage_dir);
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

    pub fn window_theme(&self) -> String {
        match self.values.get(WINDOW_THEME_KEY).and_then(Value::as_str) {
            Some("light") => "light".to_owned(),
            Some("dark") => "dark".to_owned(),
            Some("system") => "system".to_owned(),
            _ => DEFAULT_WINDOW_THEME.to_owned(),
        }
    }

    pub fn set_window_theme(&mut self, theme: &str) {
        self.values.insert(
            WINDOW_THEME_KEY.to_owned(),
            Value::String(normalize_theme(theme)),
        );
    }

    pub fn window_language(&self) -> String {
        match self.values.get(WINDOW_LANGUAGE_KEY).and_then(Value::as_str) {
            Some("en") => "en".to_owned(),
            Some("zh") => "zh".to_owned(),
            _ => DEFAULT_WINDOW_LANGUAGE.to_owned(),
        }
    }

    pub fn set_window_language(&mut self, language: &str) {
        self.values.insert(
            WINDOW_LANGUAGE_KEY.to_owned(),
            Value::String(normalize_language(language)),
        );
    }

    pub fn to_dto(&self) -> Result<RustSettingsDto, String> {
        Ok(RustSettingsDto {
            window_theme: self.window_theme(),
            window_language: self.window_language(),
            raw_json: self.to_pretty_json()?,
        })
    }

    fn to_pretty_json(&self) -> Result<String, String> {
        let mut root = serde_json::to_value(self)
            .map_err(|error| format!("failed to encode settings: {error}"))?;

        let Value::Object(ref mut object) = root else {
            return Err("settings root must encode to a JSON object".to_owned());
        };

        object.insert(
            WINDOW_THEME_KEY.to_owned(),
            Value::String(self.window_theme()),
        );
        object.insert(
            WINDOW_LANGUAGE_KEY.to_owned(),
            Value::String(self.window_language()),
        );

        serde_json::to_string_pretty(&root)
            .map_err(|error| format!("failed to render settings json: {error}"))
    }
}

pub fn settings_file_path(storage_dir: impl AsRef<Path>) -> PathBuf {
    storage_dir.as_ref().join("settings.json")
}

fn engine_config_is_empty(config: &EngineConfig) -> bool {
    config.providers.is_empty()
}

fn normalize_theme(theme: &str) -> String {
    match theme.trim() {
        "light" => "light".to_owned(),
        "dark" => "dark".to_owned(),
        "system" => "system".to_owned(),
        _ => DEFAULT_WINDOW_THEME.to_owned(),
    }
}

fn normalize_language(language: &str) -> String {
    match language.trim() {
        "en" => "en".to_owned(),
        "zh" => "zh".to_owned(),
        _ => DEFAULT_WINDOW_LANGUAGE.to_owned(),
    }
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
mod tests {
    use super::*;
    use std::time::{SystemTime, UNIX_EPOCH};

    fn temp_dir() -> PathBuf {
        let unique = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .expect("time went backwards")
            .as_nanos();
        let path = std::env::temp_dir().join(format!("beyondtranslate-settings-{unique}"));
        fs::create_dir_all(&path).expect("failed to create temp dir");
        path
    }

    #[test]
    fn load_missing_file_returns_defaults() {
        let dir = temp_dir();
        let settings = Settings::load(&dir).expect("failed to load settings");

        assert_eq!(settings.window_theme(), DEFAULT_WINDOW_THEME);
        assert_eq!(settings.window_language(), DEFAULT_WINDOW_LANGUAGE);
    }

    #[test]
    fn invalid_values_fall_back_to_defaults() {
        let dir = temp_dir();
        let path = settings_file_path(&dir);
        fs::write(
            &path,
            r#"{
  "window.theme": "sepia",
  "window.language": "jp"
}"#,
        )
        .expect("failed to write settings");

        let settings = Settings::load(&dir).expect("failed to load settings");
        assert_eq!(settings.window_theme(), DEFAULT_WINDOW_THEME);
        assert_eq!(settings.window_language(), DEFAULT_WINDOW_LANGUAGE);
    }

    #[test]
    fn save_preserves_unknown_keys() {
        let dir = temp_dir();
        let path = settings_file_path(&dir);
        fs::write(
            &path,
            r#"{
  "workbench.sideBar.location": "right",
  "window.theme": "light"
}"#,
        )
        .expect("failed to write settings");

        let mut settings = Settings::load(&dir).expect("failed to load settings");
        settings.set_window_language("en");
        settings.save(&dir).expect("failed to save settings");

        let saved = fs::read_to_string(path).expect("failed to read saved settings");
        let json = merge_raw_json_preserving_unknown_keys(&saved).expect("invalid saved json");

        assert_eq!(
            json.get("workbench.sideBar.location")
                .and_then(Value::as_str),
            Some("right")
        );
        assert_eq!(
            json.get(WINDOW_THEME_KEY).and_then(Value::as_str),
            Some("light")
        );
        assert_eq!(
            json.get(WINDOW_LANGUAGE_KEY).and_then(Value::as_str),
            Some("en")
        );
    }
}
