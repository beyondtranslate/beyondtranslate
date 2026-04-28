use worker::{Env, Method, Request, Response};

use crate::{handlers, ApiError};

pub async fn handle(req: Request, env: Env) -> Result<Response, ApiError> {
    match req.method() {
        Method::Get if req.path() == "/" => crate::routes::index::handle(req).await,
        Method::Get if req.path() == "/health" => crate::routes::health::handle().await,
        Method::Get if req.path() == "/openapi.json" => crate::routes::openapi::handle().await,
        Method::Get if req.path() == "/reference" => crate::routes::reference::handle().await,
        Method::Get => {
            if let Some(provider) = match_provider_route(
                req.path().as_str(),
                "translations",
                "supported-language-pairs",
            ) {
                return handlers::translations::handle_supported_language_pairs(env, provider)
                    .await;
            }

            Err(ApiError::not_found("Route not found"))
        }
        Method::Post => {
            if let Some(provider) =
                match_provider_route(req.path().as_str(), "dictionaries", "lookup")
            {
                return handlers::dictionaries::handle(req, env, provider).await;
            }

            if let Some(provider) =
                match_provider_route(req.path().as_str(), "translations", "translate")
            {
                return handlers::translations::handle_translate(req, env, provider).await;
            }

            if let Some(provider) =
                match_provider_route(req.path().as_str(), "translations", "detect-language")
            {
                return handlers::translations::handle_detect_language(req, env, provider).await;
            }

            Err(ApiError::not_found("Route not found"))
        }
        _ => Err(ApiError::not_found("Route not found")),
    }
}

fn match_provider_route<'a>(path: &'a str, domain: &str, action: &str) -> Option<&'a str> {
    let mut segments = path.trim_matches('/').split('/');
    let first = segments.next()?;
    let provider = segments.next()?;
    let third = segments.next()?;

    if first == domain && third == action && segments.next().is_none() {
        Some(provider)
    } else {
        None
    }
}

#[cfg(test)]
mod tests {
    use super::match_provider_route;

    #[test]
    fn matches_dictionary_provider_route() {
        assert_eq!(
            match_provider_route("/dictionaries/iciba/lookup", "dictionaries", "lookup"),
            Some("iciba")
        );
    }

    #[test]
    fn rejects_non_matching_route() {
        assert_eq!(
            match_provider_route("/dictionaries/iciba/translate", "dictionaries", "lookup"),
            None
        );
    }

    #[test]
    fn matches_translation_detect_language_route() {
        assert_eq!(
            match_provider_route(
                "/translations/iciba/detect-language",
                "translations",
                "detect-language",
            ),
            Some("iciba")
        );
    }

    #[test]
    fn matches_translation_supported_language_pairs_route() {
        assert_eq!(
            match_provider_route(
                "/translations/iciba/supported-language-pairs",
                "translations",
                "supported-language-pairs",
            ),
            Some("iciba")
        );
    }
}
