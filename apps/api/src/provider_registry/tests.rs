use super::render_runtime_config;

#[test]
fn replaces_placeholders_with_env_values() {
    let rendered = render_runtime_config(
        "api_key: ${ICIBA_API_KEY}\nbase_url: ${ICIBA_BASE_URL}\n",
        |key| match key {
            "ICIBA_API_KEY" => Some("test-key".to_owned()),
            "ICIBA_BASE_URL" => Some("https://example.com".to_owned()),
            _ => None,
        },
    );

    assert_eq!(
        rendered,
        "api_key: test-key\nbase_url: https://example.com\n"
    );
}

#[test]
fn renders_missing_placeholders_as_null() {
    let rendered = render_runtime_config("base_url: ${ICIBA_BASE_URL}\n", |_| None);

    assert_eq!(rendered, "base_url: null\n");
}
