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
