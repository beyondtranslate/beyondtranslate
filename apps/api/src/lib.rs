mod config;
mod error;
mod handlers;
mod middleware;
mod models;
mod router;
mod services;
mod utils;

use worker::*;

#[event(fetch)]
async fn fetch(req: Request, env: Env, _ctx: Context) -> Result<Response> {
    console_error_panic_hook::set_once();
    router::handle(req, env).await
}
