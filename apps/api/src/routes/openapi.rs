use serde_json::Value;
use worker::Response;

use crate::ApiError;

const OPENAPI_YAML: &str = include_str!("../../openapi.yaml");

pub async fn handle() -> Result<Response, ApiError> {
    let document = document()?;
    Response::from_json(&document).map_err(ApiError::from_worker_error)
}

fn document() -> Result<Value, ApiError> {
    serde_yaml::from_str(OPENAPI_YAML).map_err(|error| {
        ApiError::internal(
            "INTERNAL_OPENAPI_ERROR",
            format!("Failed to parse openapi.yaml: {error}"),
        )
    })
}

#[cfg(test)]
mod tests {
    use super::document;

    #[test]
    fn includes_referenceable_paths() {
        let document = document().expect("valid openapi.yaml");
        let paths = document["paths"].as_object().expect("paths object");

        assert!(paths.contains_key("/health"));
        assert!(paths.contains_key("/dictionaries/{provider}/lookup"));
        assert!(paths.contains_key("/translations/{provider}/translate"));
        assert!(paths.contains_key("/translations/{provider}/detect-language"));
        assert!(paths.contains_key("/translations/{provider}/supported-language-pairs"));
    }
}
