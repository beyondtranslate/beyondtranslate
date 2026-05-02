use std::{
    env, fs,
    time::{SystemTime, UNIX_EPOCH},
};

use crate::{from_yaml_str, load_from_file, EngineError};

#[test]
fn loads_configured_provider() {
    let registry = from_yaml_str(
        r#"
providers:
  deepl:
    type: deepl
    api_key: test-key
"#,
    )
    .expect("valid config");

    assert_eq!(registry.names(), vec!["deepl"]);
    let provider = registry.require("deepl").expect("deepl provider");
    assert_eq!(provider.name(), "deepl");
    assert!(registry.require("missing").is_err());
}

#[test]
fn loads_camel_case_provider_config() {
    let registry = from_yaml_str(
        r#"
providers:
  deepl:
    type: deepl
    appKey: test-key
"#,
    )
    .expect("valid config");

    assert_eq!(registry.names(), vec!["deepl"]);
}

#[cfg(feature = "iciba")]
#[test]
fn loads_multiple_providers() {
    let registry = from_yaml_str(
        r#"
providers:
  deepl-main:
    type: deepl
    api_key: deepl-key
  iciba-main:
    type: iciba
    api_key: iciba-key
"#,
    )
    .expect("valid config");

    assert_eq!(registry.names(), vec!["deepl-main", "iciba-main"]);
}

#[test]
fn rejects_unknown_provider() {
    let error = from_yaml_str(
        r#"
providers:
  unknown:
    type: unknown
    api_key: test-key
"#,
    )
    .expect_err("unknown provider should fail");

    assert!(matches!(error, EngineError::ParseConfig(_)));
}

#[test]
fn rejects_invalid_provider_config() {
    let error = from_yaml_str(
        r#"
providers:
  deepl:
    type: deepl
    base_url: https://api.deepl.com
"#,
    )
    .expect_err("missing api_key should fail");

    assert!(matches!(
        error,
        EngineError::InvalidProviderConfig { provider, .. } if provider == "deepl"
    ));
}

#[test]
fn rejects_empty_api_key() {
    let error = from_yaml_str(
        r#"
providers:
  deepl:
    type: deepl
    api_key: ""
"#,
    )
    .expect_err("empty api_key should fail");

    assert!(matches!(
        error,
        EngineError::ConfigValidationFailed { ref provider, ref reason }
            if provider == "deepl" && reason == "api_key must not be empty"
    ));
}

#[test]
fn rejects_invalid_yaml() {
    let error = from_yaml_str("providers: [").expect_err("invalid yaml should fail");

    assert!(matches!(error, EngineError::ParseConfig(_)));
}

#[test]
fn reads_yaml_from_file() {
    let suffix = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .expect("valid time")
        .as_nanos();
    let path = env::temp_dir().join(format!("beyondtranslate-engine-{suffix}.yaml"));
    fs::write(
        &path,
        r#"
providers:
  deepl:
    type: deepl
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
  baidu-main:
    type: baidu
    app_id: test-id
    app_key: test-key
"#,
    )
    .expect_err("disabled provider should fail");

    assert!(matches!(
        error,
        EngineError::ProviderNotEnabled(name) if name == "baidu-main"
    ));
}
