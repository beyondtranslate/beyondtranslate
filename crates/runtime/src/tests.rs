use std::{
    env, fs,
    time::{SystemTime, UNIX_EPOCH},
};

use crate::{from_yaml_str, load_from_file, RuntimeError};

#[test]
fn loads_configured_provider() {
    let registry = from_yaml_str(
        r#"
providers:
  deepl:
    api_key: test-key
"#,
    )
    .expect("valid config");

    assert_eq!(registry.names(), vec!["deepl"]);
    let provider = registry.require("deepl").expect("deepl provider");
    assert_eq!(provider.name(), "deepl");
    assert!(registry.get("missing").is_none());
}

#[cfg(feature = "iciba")]
#[test]
fn loads_multiple_providers() {
    let registry = from_yaml_str(
        r#"
providers:
  deepl:
    api_key: deepl-key
  iciba:
    api_key: iciba-key
"#,
    )
    .expect("valid config");

    assert_eq!(registry.names(), vec!["deepl", "iciba"]);
}

#[test]
fn rejects_unknown_provider() {
    let error = from_yaml_str(
        r#"
providers:
  unknown:
    api_key: test-key
"#,
    )
    .expect_err("unknown provider should fail");

    assert!(matches!(error, RuntimeError::UnknownProvider(name) if name == "unknown"));
}

#[test]
fn rejects_invalid_provider_config() {
    let error = from_yaml_str(
        r#"
providers:
  deepl:
    base_url: https://api.deepl.com
"#,
    )
    .expect_err("missing api_key should fail");

    assert!(matches!(
        error,
        RuntimeError::InvalidProviderConfig { provider, .. } if provider == "deepl"
    ));
}

#[test]
fn rejects_invalid_yaml() {
    let error = from_yaml_str("providers: [").expect_err("invalid yaml should fail");

    assert!(matches!(error, RuntimeError::ParseConfig(_)));
}

#[test]
fn reads_yaml_from_file() {
    let suffix = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .expect("valid time")
        .as_nanos();
    let path = env::temp_dir().join(format!("beyondtranslate-runtime-{suffix}.yaml"));
    fs::write(
        &path,
        r#"
providers:
  deepl:
    api_key: file-key
"#,
    )
    .expect("write temp config");

    let registry = load_from_file(&path).expect("load config from file");
    fs::remove_file(&path).expect("remove temp config");

    assert_eq!(registry.names(), vec!["deepl"]);
}

#[test]
fn errors_when_feature_is_disabled() {
    let error = from_yaml_str(
        r#"
providers:
  google:
    api_key: test-key
"#,
    )
    .expect_err("disabled provider should fail");

    assert!(matches!(
        error,
        RuntimeError::ProviderNotEnabled(name) if name == "google"
    ));
}
