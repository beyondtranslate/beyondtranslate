use worker::*;

#[event(fetch)]
async fn fetch(req: Request, _env: Env, _ctx: Context) -> Result<Response> {
    match (req.method(), req.path().as_str()) {
        (Method::Get, "/health") => Response::ok("ok"),
        _ => Response::error("Not Found", 404),
    }
}
