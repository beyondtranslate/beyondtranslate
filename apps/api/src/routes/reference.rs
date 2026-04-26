use worker::Response;

use crate::ApiError;

const HTML: &str = r#"<!doctype html>
<html>
  <head>
    <title>BeyondTranslate API Reference</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
      body {
        margin: 0;
      }
    </style>
  </head>
  <body>
    <div id="app"></div>
    <script src="https://cdn.jsdelivr.net/npm/@scalar/api-reference"></script>
    <script>
      Scalar.createApiReference('#app', {
        url: '/openapi.json',
      })
    </script>
  </body>
</html>
"#;

pub async fn handle() -> Result<Response, ApiError> {
    Response::from_html(HTML).map_err(ApiError::from_worker_error)
}

#[cfg(test)]
mod tests {
    use super::HTML;

    #[test]
    fn points_scalar_to_openapi_document() {
        assert!(HTML.contains("https://cdn.jsdelivr.net/npm/@scalar/api-reference"));
        assert!(HTML.contains("url: '/openapi.json'"));
    }
}
