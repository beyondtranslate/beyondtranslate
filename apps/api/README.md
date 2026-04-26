# API Worker

Cloudflare Worker API app written in Rust.

## Endpoints

- `GET /health`
- `POST /dictionaries/{provider}/lookup`
- `POST /translations/{provider}/translate`

### `POST /dictionaries/{provider}/lookup`

Request body:

```json
{
  "sourceLanguage": "en",
  "targetLanguage": "zh",
  "word": "hello"
}
```

Currently implemented dictionary provider:

- `iciba`

### `POST /translations/{provider}/translate`

Request body:

```json
{
  "sourceLanguage": "en",
  "targetLanguage": "zh",
  "text": "hello"
}
```

The translation domain is separated from dictionaries, but this route is still a
placeholder. It currently returns a "no translation providers configured" error
until a real translation provider is wired in.

Currently accepted translation path provider:

- `iciba`

## Environment variables

- `ICIBA_API_KEY` (required)
- `ICIBA_BASE_URL` (optional)

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
before Wrangler runs the deploy step. The deploy script also reloads
`$HOME/.cargo/env`, because Builds runs deploy in a fresh shell.
