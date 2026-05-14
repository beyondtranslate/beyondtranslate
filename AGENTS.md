# AGENTS.md — BeyondTranslate

This file serves as a quick-start reference for AI agents (and human contributors) working on this project. It describes the project structure, tech stack, build tools, conventions, and common workflows.

## Project Overview

**BeyondTranslate** (formerly **Biyi**) is a convenient translation and dictionary app written in **Flutter** (desktop) with **Rust** native modules. It supports Linux, macOS, and Windows.

- **Homepage:** <https://beyondtranslate.com/>
- **Repository:** <https://github.com/beyondtranslate/beyondtranslate>

---

## Repository Structure

```
beyondtranslate/
├── apps/
│   ├── desktop/                  # Flutter desktop application (main app)
│   │   ├── lib/                  # Dart source code
│   │   ├── linux/                # Linux platform-specific files
│   │   ├── macos/                # macOS platform-specific files
│   │   ├── windows/              # Windows platform-specific files
│   │   ├── resources/            # Static assets (images, fonts)
│   │   └── pubspec.yaml
│   └── api/                      # Rust API server (Cloudflare Workers + Rust)
│       ├── src/                  # Rust source code
│       ├── scripts/              # Build/deploy scripts
│       ├── config.yaml
│       ├── openapi.yaml
│       └── wrangler.toml
├── crates/
│   ├── core/                     # Rust crate: core logic (shared)
│   │   ├── src/                  # Rust source
│   │   └── Cargo.toml
│   └── engine/                   # Rust crate: translation engine
│       ├── src/                  # Rust source
│       └── Cargo.toml
├── packages/
│   └── runtime/                  # Flutter package: Rust FFI bridge (Dart)
│       ├── lib/                  # Dart FFI bindings
│       ├── rust/                 # Rust source for the runtime bridge
│       ├── macos/                # macOS-specific build config
│       ├── hook/                 # Build hooks
│       └── pubspec.yaml
├── extensions/
│   └── browser/                  # Browser extension
├── integrations/
│   ├── popclip/                  # PopClip integration
│   └── snipdo/                   # SnipDo integration
├── scripts/
│   ├── generate/                 # Code generation scripts
│   ├── codegen.py                # Code generation entry
│   └── format.py                 # Formatting helper
├── screenshots/                  # App screenshots
├── melos.yaml                    # Melos workspace config
├── Cargo.toml                    # Rust workspace root
└── pubspec.yaml                  # Workspace pubspec (root)
```

### Key Packages and Their Roles

| Directory | Language | Role |
|-----------|----------|------|
| `apps/desktop` | Dart (Flutter) | Main desktop application |
| `apps/api` | Rust + Cloudflare Workers | Backend API server |
| `crates/core` | Rust | Shared core logic (models, utilities) |
| `crates/engine` | Rust | Translation engine interface/logic |
| `packages/runtime` | Dart + Rust | FFI bridge between Flutter and Rust |

---

## Tech Stack

### Languages
- **Dart** — Flutter application code
- **Rust** — Native modules (core, engine, runtime bridge, API server)
- **Python** — Code generation and build scripts

### Key Frameworks & Tools
- **Flutter** (SDK >=3.3.0) — Desktop UI framework
- **Melos** (^3.0.1) — Monorepo management and orchestration
- **Cargo** — Rust build system
- **wrangler** — Cloudflare Workers deployment (API server)
- **go_router** — Flutter routing
- **slang / slang_flutter** — Internationalization (i18n)
- **bot_toast** — Toast notifications
- **dio** — HTTP client
- **screen_text_extractor / screen_capturer** — Screen text extraction
- **hotkey_manager** — Global hotkeys
- **audioplayers** — Audio playback
- **uniffi** (0.31.1) — Rust FFI bindings generation
- **reqwest** — Rust HTTP client

---

## Conventions & Guidelines

### Code Style
- **Dart:** Use `dart format` for formatting. Run `melos run format` to format all packages.
- **Rust:** Use `cargo fmt` for formatting. Follow standard Rust naming conventions (snake_case for functions/variables, PascalCase for types).
- **Python:** Follow PEP 8.

### Naming Conventions
- **Dart files:** `snake_case.dart`
- **Rust files:** `snake_case.rs`
- **Classes/Structs:** `PascalCase`
- **Functions/Methods:** `camelCase` (Dart), `snake_case` (Rust)
- **Constants:** `lowerCamelCase` (Dart), `SCREAMING_SNAKE_CASE` (Rust)

### Git Practices
- Write clear, descriptive commit messages in English.
- Reference issues and pull requests when applicable.
- Keep commits focused on a single concern.

---

## Common Workflows

### Setup

```bash
# 1. Install Melos (if not already installed)
flutter pub global activate melos

# 2. Bootstrap the workspace
melos bs
```

### Development

```bash
# Run the desktop app
cd apps/desktop
flutter run -d linux   # or macos / windows

# Run all tests across the workspace
melos run test

# Run Dart analyzer across all packages
melos run analyze

# Format all Dart code
melos run format
```

### Rust Development

```bash
# Build all Rust crates
cargo build --workspace

# Run Rust tests
cargo test --workspace

# Build the runtime Rust crate (used by Flutter)
cd packages/runtime/rust
cargo build
```

### Code Generation

```bash
# Run Python code generation scripts
python scripts/codegen.py

# Run Dart build_runner (for generated code like routing, i18n)
cd apps/desktop
flutter pub run build_runner build
```

---

## Architecture Notes

### Flutter ↔ Rust Bridge
The `packages/runtime` package uses **uniffi** to generate Dart FFI bindings for the Rust native code. The Rust source lives under `packages/runtime/rust/`.

### Translation Flow
1. **Input:** User enters text (or selects from screen via `screen_text_extractor`).
2. **OCR (optional):** Text can be extracted from images using built-in or Youdao OCR engines.
3. **Translation:** Text is sent to the translation engine (`crates/engine`) which supports multiple providers.
4. **Display:** Results are shown in the UI with pronunciation, definitions, and examples.

### API Server
The `apps/api` directory contains a Rust-based API server deployed via Cloudflare Workers. It uses `wrangler.toml` for configuration and is independent of the desktop app.

---

## Useful Commands

| Command | Description |
|---------|-------------|
| `melos bs` | Bootstrap the monorepo (install + link dependencies) |
| `melos run analyze` | Run Flutter analyze on all packages |
| `melos run format` | Format all Dart code |
| `melos run test` | Run all Flutter tests |
| `melos run fix` | Apply Dart fixes |
| `cargo build --workspace` | Build all Rust crates |
| `cargo test --workspace` | Run all Rust tests |

---

## Troubleshooting

### `melos bs` fails
- Ensure Flutter SDK >=3.3.0 is installed.
- Run `flutter pub global activate melos` to ensure Melos is installed.
- Check that all dependencies in `pubspec.yaml` files are resolvable.

### Rust build errors in `packages/runtime`
- Ensure the correct Rust toolchain is installed (see `rust-toolchain.toml` or `Cargo.toml`).
- If uniffi bindings fail, try cleaning: `cargo clean` and rebuild.

### Flutter desktop build errors on Linux
- Install required system dependencies: `libappindicator3-dev`, `keybinder-3.0`.
- See the [Linux requirements section](https://github.com/beyondtranslate/beyondtranslate#linux-requirements) in the README.

---

## License

This project is licensed under the **AGPL** license. See the [LICENSE](./LICENSE) file for details.
