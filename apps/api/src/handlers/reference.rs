use worker::Response;

use crate::error::ApiError;

const API_REFERENCE_SCRIPT_URL: &str = "https://cdn.jsdelivr.net/npm/@scalar/api-reference";

pub async fn handle() -> Result<Response, ApiError> {
    let html = format!(
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
    );

    Response::from_html(html).map_err(ApiError::from_worker_error)
}

#[cfg(test)]
mod tests {
    use super::API_REFERENCE_SCRIPT_URL;

    #[test]
    fn points_scalar_to_openapi_document() {
        assert!(API_REFERENCE_SCRIPT_URL.contains("@scalar/api-reference"));
    }
}
