# API Worker

Cloudflare Worker API app written in Rust.

## Endpoints

- `GET /health` -> `200 ok`

## Local development

1. Install the Rust target:

```bash
rustup target add wasm32-unknown-unknown
```

2. Start Wrangler:

```bash
cd apps/api
npx wrangler dev
```

## Deploy

```bash
cd apps/api
npx wrangler deploy
```

## Cloudflare Builds

The official Rust Worker flow keeps the custom build step in `wrangler.toml`.
If you use Cloudflare Workers Builds with a connected Git repository, set:

- Root directory: `apps/api`
- Build command: `npm run build`
- Deploy command: `npm run deploy`

Workers Builds does not provide Rust by default, so the build step must install it
before Wrangler runs the deploy step.
