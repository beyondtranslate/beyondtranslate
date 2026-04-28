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

Currently configured dictionary provider:

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

## Provider config

The Worker loads providers from [`config.yaml`](./config.yaml), which is bundled
into the Worker at build time. Because Cloudflare Workers does not expose a
normal filesystem at runtime, the API resolves `${ENV_VAR}` placeholders from
Worker environment variables before handing the rendered YAML to
`beyondtranslate-runtime`.

Current config template:

```yaml
providers:
  iciba:
    api_key: ${ICIBA_API_KEY}
    base_url: ${ICIBA_BASE_URL}
```

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

Wrangler supports loading local variables from `.env` during development. Create
`apps/api/.env` first:

```dotenv
ICIBA_API_KEY="your-iciba-api-key"
# ICIBA_BASE_URL="http://dict-co.iciba.com"
```

You can also copy the template:

```bash
cd apps/api
cp .env.example .env
```

## Deploy

```bash
cd apps/api
npx wrangler deploy
```

`.env` is only for local development. For deployed Workers, configure the secret
in Cloudflare before running deploy:

```bash
cd apps/api
npx wrangler secret put ICIBA_API_KEY
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
