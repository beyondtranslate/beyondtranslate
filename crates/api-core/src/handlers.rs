use beyondtranslate_core::{DetectLanguageRequest, LanguagePair, LookUpRequest, TranslateRequest};
use serde::Serialize;
use serde_json::Value;

use crate::{utils, ApiError};

const OPENAPI_YAML: &str = include_str!("../../../apps/api/openapi.yaml");
const API_REFERENCE_SCRIPT_URL: &str = "https://cdn.jsdelivr.net/npm/@scalar/api-reference";

#[derive(Debug, Serialize)]
pub struct HealthResponse {
    pub ok: bool,
}

#[derive(Debug, Serialize)]
pub struct IndexResponse {
    pub message: &'static str,
    pub references: Vec<String>,
}

pub fn health() -> HealthResponse {
    HealthResponse { ok: true }
}

pub fn index(path: &str) -> IndexResponse {
    let prefix = utils::normalized_prefix(path);
    IndexResponse {
        message: "Welcome to BeyondTranslate API",
        references: vec![format!("{prefix}/reference")],
    }
}

pub fn openapi_document() -> Result<Value, ApiError> {
    serde_yaml::from_str(OPENAPI_YAML).map_err(|error| {
        ApiError::internal(
            "INTERNAL_OPENAPI_ERROR",
            format!("Failed to parse openapi.yaml: {error}"),
        )
    })
}

pub fn reference_html() -> String {
    format!(
        r#"<!doctype html>
<html>
  <head>
    <title>BeyondTranslate API Reference</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
      body {{
        margin: 0;
      }}
    </style>
  </head>
  <body>
    <div id="app"></div>
    <script src="{API_REFERENCE_SCRIPT_URL}"></script>
    <script>
      Scalar.createApiReference('#app', {{
        url: '/openapi.json',
      }})
    </script>
  </body>
</html>
"#
    )
}

pub fn translate_request(request: TranslateRequest) -> Result<TranslateRequest, ApiError> {
    let text = utils::trim_required_text(request.text);
    if text.is_empty() {
        return Err(ApiError::bad_request(
            "INVALID_REQUEST",
            "`text` is required",
        ));
    }

    Ok(TranslateRequest {
        source_language: utils::normalize_optional_language(request.source_language),
        target_language: utils::normalize_optional_language(request.target_language),
        text,
    })
}

pub fn detect_language_request(
    request: DetectLanguageRequest,
) -> Result<DetectLanguageRequest, ApiError> {
    let texts = request
        .texts
        .into_iter()
        .map(utils::trim_required_text)
        .filter(|value| !value.is_empty())
        .collect::<Vec<_>>();

    if texts.is_empty() {
        return Err(ApiError::bad_request(
            "INVALID_REQUEST",
            "`texts` must contain at least one non-empty item",
        ));
    }

    Ok(DetectLanguageRequest { texts })
}

pub fn lookup_request(request: LookUpRequest) -> Result<LookUpRequest, ApiError> {
    let source_language = utils::normalize_required_language(request.source_language);
    let target_language = utils::normalize_required_language(request.target_language);
    let word = utils::trim_required_text(request.word);

    if word.is_empty() {
        return Err(ApiError::bad_request(
            "INVALID_REQUEST",
            "`word` is required",
        ));
    }

    Ok(LookUpRequest {
        source_language,
        target_language,
        word,
    })
}

pub fn supported_language_pairs(pairs: Vec<LanguagePair>) -> Vec<LanguagePair> {
    pairs
}

#[cfg(test)]
mod tests {
    use beyondtranslate_core::{DetectLanguageRequest, TranslateRequest};

    use super::{detect_language_request, openapi_document, translate_request};

    #[test]
    fn validates_translate_request() {
        let request = TranslateRequest {
            source_language: Some("EN".to_owned()),
            target_language: Some("ZH".to_owned()),
            text: "  hello  ".to_owned(),
        };
        let request = translate_request(request).expect("valid translate request");

        assert_eq!(request.text, "hello");
        assert_eq!(request.source_language.as_deref(), Some("en"));
    }

    #[test]
    fn validates_detect_language_request() {
        let request = DetectLanguageRequest {
            texts: vec!["  hello  ".to_owned(), "".to_owned(), " world ".to_owned()],
        };
        let request = detect_language_request(request).expect("valid detect request");

        assert_eq!(request.texts, vec!["hello".to_owned(), "world".to_owned()]);
    }

    #[test]
    fn includes_referenceable_paths() {
        let document = openapi_document().expect("valid openapi.yaml");
        let paths = document["paths"].as_object().expect("paths object");

        assert!(paths.contains_key("/health"));
        assert!(paths.contains_key("/dictionaries/{provider}/lookup"));
        assert!(paths.contains_key("/translations/{provider}/translate"));
        assert!(paths.contains_key("/translations/{provider}/detect-language"));
        assert!(paths.contains_key("/translations/{provider}/supported-language-pairs"));
    }
}
