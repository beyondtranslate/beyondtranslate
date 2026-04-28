use worker::{Env, Request, Response, RouteContext, Router};

use crate::{error::ApiError, handlers, middleware::cors};

pub async fn handle(req: Request, env: Env) -> worker::Result<Response> {
    Router::new()
        .get_async("/", |req, _ctx| async move {
            respond(handlers::index::handle(req).await)
        })
        .get_async("/health", |_req, _ctx| async move {
            respond(handlers::health::handle().await)
        })
        .get_async("/openapi.json", |_req, _ctx| async move {
            respond(handlers::openapi::handle().await)
        })
        .get_async("/reference", |_req, _ctx| async move {
            respond(handlers::reference::handle().await)
        })
        .post_async("/dictionaries/:provider/lookup", |req, ctx| async move {
            match provider_param(&ctx) {
                Ok(provider) => {
                    respond(handlers::dictionaries::lookup(req, ctx.env, provider.as_str()).await)
                }
                Err(error) => respond(Err(error)),
            }
        })
        .post_async("/translations/:provider/translate", |req, ctx| async move {
            match provider_param(&ctx) {
                Ok(provider) => respond(
                    handlers::translations::translate(req, ctx.env, provider.as_str()).await,
                ),
                Err(error) => respond(Err(error)),
            }
        })
        .post_async(
            "/translations/:provider/detect-language",
            |req, ctx| async move {
                match provider_param(&ctx) {
                    Ok(provider) => respond(
                        handlers::translations::detect_language(req, ctx.env, provider.as_str())
                            .await,
                    ),
                    Err(error) => respond(Err(error)),
                }
            },
        )
        .get_async(
            "/translations/:provider/supported-language-pairs",
            |_req, ctx| async move {
                match provider_param(&ctx) {
                    Ok(provider) => respond(
                        handlers::translations::supported_language_pairs(
                            ctx.env,
                            provider.as_str(),
                        )
                        .await,
                    ),
                    Err(error) => respond(Err(error)),
                }
            },
        )
        .options_async("/*path", |_req, _ctx| async move {
            respond(Response::empty().map_err(ApiError::from_worker_error))
        })
        .or_else_any_method_async("/*path", |req, _ctx| async move {
            let error = match req.method() {
                worker::Method::Get | worker::Method::Post | worker::Method::Options => {
                    ApiError::not_found("Route not found")
                }
                _ => ApiError::method_not_allowed("Method not allowed"),
            };
            respond(Err(error))
        })
        .run(req, env)
        .await
}

fn provider_param(ctx: &RouteContext<()>) -> Result<String, ApiError> {
    ctx.param("provider")
        .cloned()
        .ok_or_else(|| ApiError::bad_request("INVALID_PROVIDER", "Missing provider"))
}

fn respond(result: Result<Response, ApiError>) -> worker::Result<Response> {
    let mut response = match result {
        Ok(response) => response,
        Err(error) => error.into_response()?,
    };
    cors::apply(&mut response)?;
    Ok(response)
}
