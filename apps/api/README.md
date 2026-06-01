# API Worker

Cloudflare Worker API app written in Rust.

## Project structure

```text
apps/api
├── Cargo.toml
├── wrangler.toml
├── package.json
├── README.md
├── src
│   ├── lib.rs
│   ├── router.rs
│   ├── config.rs
│   ├── error.rs
│   ├── utils.rs
│   ├── handlers/
│   ├── middleware/
│   ├── models/
│   └── services/
└── build/
```

`lib.rs` only handles the Worker fetch entrypoint. `router.rs` centralizes route
registration. `handlers/` is responsible for HTTP parsing and response shaping.
`services/` currently only keeps `engine`, which loads the translation engine from
runtime config. `middleware/` applies shared CORS headers, `models/` keeps DTOs,
and `config.rs` renders `config.yaml` from Worker environment variables.

## Endpoints

- `GET /`
- `GET /health`
- `GET /openapi.json`
- `GET /reference`
- `POST /dictionaries/{provider}/lookup`
- `POST /translations/{provider}/translate`
- `POST /translations/{provider}/detect-language`
- `GET /translations/{provider}/supported-language-pairs`

### `POST /dictionaries/{provider}/lookup`

Request body:

```json
{
  "sourceLanguage": "en",
  "targetLanguage": "zh",
  "word": "hello"
}
```

### `POST /translations/{provider}/translate`

Request body:

```json
{
  "sourceLanguage": "en",
  "targetLanguage": "zh",
  "text": "hello"
}
```

### `POST /translations/{provider}/detect-language`

Request body:

```json
{
  "texts": ["hello", "bonjour"]
}
```

### `GET /translations/{provider}/supported-language-pairs`

Returns the provider's supported language pairs.

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

.env is only for local development.

## Cloudflare Builds

The official Rust Worker flow keeps the custom build step in `wrangler.toml`.
If you use Cloudflare Workers Builds with a connected Git repository, set:

- Root directory: `apps/api`
- Build command: `npm run build`
- Deploy command: `npm run deploy`

Workers Builds does not provide Rust by default, so the build step must install it
before Wrangler runs the deploy step. The deploy script also reloads
`$HOME/.cargo/env`, because Builds runs deploy in a fresh shell.
