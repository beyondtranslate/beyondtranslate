# AGENTS.md — BeyondTranslate

This file serves as a quick-start reference for AI agents (and human contributors) working on this project. It describes the project structure, tech stack, build tools, conventions, and common workflows.

## Project Overview

**BeyondTranslate** is a convenient translation and dictionary app written in **Flutter** (desktop) with **Rust** native modules. It supports Linux, macOS, and Windows.

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
├── Cargo.toml                    # Rust workspace root
└── pubspec.yaml                  # Pub Workspaces + Melos config (root)
```

### Key Packages and Their Roles

| Directory | Language | Role |
|-----------|----------|------|
| `apps/desktop` | Dart (Flutter) | Main desktop application |
| `apps/api` | Rust + Cloudflare Workers | Backend API server |
| `crates/core` | Rust | Shared core logic (models, utilities) |
| `crates/engine` | Rust | Translation engine interface/logic |
| `packages/runtime` | Dart + Rust + Swift | FFI bridge between Flutter and Rust; generates **Dart** bindings for Flutter and **Swift** bindings for the macOS SPM package |

---

## Tech Stack

### Languages
- **Dart** — Flutter application code
- **Rust** — Native modules (core, engine, runtime bridge, API server)
- **Python** — Code generation and build scripts

### Key Frameworks & Tools
- **Flutter** (SDK >=3.27.0) — Desktop UI framework. Dart SDK constraints for workspace packages are `>=3.6.0 <4.0.0` because Pub Workspaces require Dart 3.6+.
- **Melos** (^7.0.0) — Monorepo orchestration. Configuration lives under the root `pubspec.yaml` `melos:` section.
- **Cargo** — Rust build system
- **wrangler** — Cloudflare Workers deployment (API server)
- **go_router** — Flutter routing
- **slang / slang_flutter** — Internationalization (i18n)
- **bot_toast** — Toast notifications
- **dio** — HTTP client
- **screen_text_extractor / screen_capturer** — Screen text extraction
- **hotkey_manager** — Global hotkeys
- **audioplayers** — Audio playback
- **uniffi** (0.31.1) — Rust FFI bindings generation (Swift via `uniffi-bindgen`)
- **uniffi-dart** (0.2.0) — Dart FFI bindings generation (via `uniffi-bindgen-dart`)
- **reqwest** — Rust HTTP client

---

## Conventions & Guidelines

### Code Style
- **Dart:** Use `dart format` for formatting. Run `dart run melos run format` to format Dart packages managed by Melos.
- **Rust:** Use `cargo fmt` for formatting. Follow standard Rust naming conventions (snake_case for functions/variables, PascalCase for types).
- **Swift:** Use `swift-format` for Swift formatting.
- **Python:** Follow PEP 8.
- **Whole repository:** Run `python scripts/format.py` to format Dart, Rust, and Swift together. Use `python scripts/format.py --check` for a non-mutating check.

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
# 1. Resolve the Pub Workspace dependencies
dart pub get

# 2. Bootstrap the Melos workspace
dart run melos bootstrap
```

This repository uses Dart Pub Workspaces. The root `pubspec.yaml` owns the `workspace:` package list and the single shared `pubspec.lock`. Workspace packages must include `resolution: workspace`, and internal workspace dependencies should use normal version constraints (for example `beyondtranslate_runtime: ^0.0.1`) instead of `path:` overrides.

### Development

```bash
# Run the desktop app
cd apps/desktop
flutter run -d linux   # or macos / windows

# Run all tests across the workspace
dart run melos run test

# Run Dart analyzer across all packages
dart run melos run analyze

# Format Dart code in Melos packages
dart run melos run format

# Format Dart, Rust, and Swift across the repository
python scripts/format.py
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

> **Important:** After modifying Rust code in `packages/runtime/rust/`, you **must** run the codegen script to regenerate the **Dart** and **Swift** FFI bindings. See the [Code Generation](#code-generation) section below.

### Code Generation

```bash
# Run Python code generation scripts
# Regenerates:
#   - Dart FFI bindings   → packages/runtime/lib/src/generated/
#   - Swift FFI bindings  → packages/runtime/macos/beyondtranslate_runtime/Sources/beyondtranslate_runtime/Generated/
#   - FFI C header/modulemap → packages/runtime/macos/beyondtranslate_runtime/Sources/beyondtranslate_runtimeFFI/include/
#   - macOS localization files → apps/desktop/macos/Runner/*.lproj/Localizable.strings
#   - macOS locale key constants → apps/desktop/macos/Runner/Shared/I18n/LocaleKeys.swift
# Then formats Dart, Rust, and Swift via scripts/format.py.
python scripts/codegen.py

# Run Dart build_runner (for generated code like routing, i18n)
cd apps/desktop
dart run build_runner build

# Regenerate Dart i18n translations after modifying .i18n.json files
cd apps/desktop
dart run slang
```

### Internationalization (i18n)

The project uses **slang** (`slang` / `slang_flutter`) for Flutter-side i18n, with a separate **Swift-native** localization system for the macOS Settings window.

#### Source Files

| File | Role |
|------|------|
| `apps/desktop/lib/src/i18n/*.i18n.json` (7 languages) | **Source of truth** for Flutter i18n keys and translations |
| `apps/desktop/lib/src/i18n/strings_*.g.dart` | Generated by `dart run slang` from the `.i18n.json` files |
| `apps/desktop/lib/src/i18n/strings.g.dart` | Entry point that `part`s `strings_en.g.dart` and imports other locales |
| `apps/desktop/macos/Runner/Shared/I18n/LocaleKeys.swift` | macOS-side locale key constants (Swift) |
| `apps/desktop/macos/Runner/Shared/I18n/AppLocale.swift` | macOS-side locale switching logic |
| `apps/desktop/macos/Runner/*.lproj/Localizable.strings` | macOS-side native string files (generated by `scripts/codegen.py`) |

#### Workflow

1. **Add a new translation key:** Edit all 7 `*.i18n.json` files to add the key with translations for each language.
2. **Regenerate Dart bindings:** Run `dart run slang` from `apps/desktop/` to regenerate `strings_*.g.dart` and `strings.g.dart`.
3. **Regenerate macOS bindings:** Run `python scripts/codegen.py` from the repo root to regenerate `LocalesKeys.swift`, `AppLocale.swift`, and `Localizable.strings` files.

> ⚠️ **Important:** The `.i18n.json` files are the **only source of truth** for Flutter i18n keys. The `strings_*.g.dart` files are generated artifacts and will be **overwritten** by `dart run slang`. If you add a key only to the `.g.dart` files (or only to the Swift files), it will be **lost** the next time `dart run slang` runs. Always add new keys to **all 7** `.i18n.json` files first.

#### Adding a New Translation Key

1. Add the key to all 7 `*.i18n.json` files at `apps/desktop/lib/src/i18n/`. Use existing keys in the same section as a reference for the correct nesting level.
2. Run `dart run slang` from `apps/desktop/` to regenerate the Dart bindings.
3. Run `python scripts/codegen.py` from the repo root to regenerate the macOS Swift bindings and `Localizable.strings` files.
4. (Optional) Add the corresponding `LocaleKey(...)` constant to `LocaleKeys.swift` if it doesn't already exist for the new path. Check the existing structure at `LocalesKeys.swift` for the correct enum nesting.

---

## Architecture Notes

### Desktop App Architecture

The desktop application (`apps/desktop/`) is built on **Flutter** across all three platforms (Linux, macOS, Windows), with **Rust** native modules providing core services via an FFI bridge.

#### Cross-Platform Layer

All platforms share the following architecture:

| Layer | Technology | Location |
|-------|-----------|----------|
| **UI** | Flutter (Dart) | `apps/desktop/lib/` |
| **FFI Bridge** | `packages/runtime` (Dart + Rust) | `packages/runtime/` |
| **Dart Bindings** | `uniffi-bindgen-dart` generated | `packages/runtime/lib/src/generated/` |
| **Rust cdylib** | Platform-native shared library | Built via `packages/runtime/hook/build.dart` (native-assets) |
| **Rust Crates** | `core` + `engine` | `crates/` |

At startup, Flutter's native-assets system loads the Rust cdylib (`.dylib` / `.so` / `.dll`) and Dart code calls into it via the generated uniffi bindings. The `Runtime` singleton manages settings, translation, OCR, and dictionary services — shared by all bindings that use the same `dataDir`.

```
┌──────────────────────────────────────┐
│  Flutter (Dart)                      │
│  ┌────────────────────────────────┐  │
│  │ Dart FFI bindings (uniffi)     │  │
│  └────────────┬───────────────────┘  │
│               │                      │
├───────────────┼──────────────────────┤
│  OS Layer     │                      │
│               ▼                      │
│  ┌──────────────────────────────┐   │
│  │ beyondtranslate_runtime      │   │
│  │ (cdylib: .dylib/.so/.dll)    │   │
│  │ - Runtime                    │   │
│  │ - RuntimeSettings            │   │
│  │ - RuntimeTranslation         │   │
│  │ - RuntimeOcr                 │   │
│  └──────────────────────────────┘   │
└──────────────────────────────────────┘
```

On **Linux** and **Windows**, this is the complete architecture — Flutter + Rust via Dart FFI, with no platform-native code involved beyond what Flutter itself provides.

---

#### macOS Specifics

macOS is unique in that it adopts a **SwiftUI + Flutter** hybrid architecture. In addition to the cross-platform Dart FFI path, macOS provides a native SwiftUI layer that calls Rust directly through **Swift bindings** generated by uniffi-rs. This requires an **SPM (Swift Package Manager)** package to bridge the Rust cdylib into the Swift runtime.

##### macOS Directory Structure

```
apps/desktop/macos/
├── Runner/                            # macOS app entry (SwiftUI + FlutterEngine)
│   ├── AppDelegate.swift              # SwiftUI app entry, manages FlutterEngine
│   ├── Info.plist                     # LSUIElement=true (menu bar only, no Dock icon)
│   ├── Plugins/
│   │   ├── MacSettingsPlugin.swift    # MethodChannel for native Settings window
│   │   └── MacWindowAppearancePlugin.swift  # MethodChannel for window appearance
│   ├── Shared/
│   │   ├── Components/Settings/       # Reusable SwiftUI components (Picker, Row, Toggle, etc.)
│   │   ├── I18n/                      # macOS-side localization (AppLocale, LocaleKeys)
│   │   └── Services/RuntimeProvider.swift  # Rust Runtime singleton accessor
│   └── Features/Settings/             # Native Settings window (SwiftUI)
│       ├── Views/                     # Setting pages (General, Appearance, Shortcuts, Providers, Advanced)
│       ├── ViewModels/                # ViewModels for each page
│       ├── Models/                    # Data models (ProviderConfigField, SettingOption, etc.)
│       └── Repository/SettingsRepository.swift  # Wraps Rust Runtime API calls
├── Flutter/                           # Flutter framework integration
├── Podfile                            # CocoaPods (for Flutter plugin dependencies)
└── Runner.xcodeproj / Runner.xcworkspace
```

##### Startup Flow

The macOS startup sequence involves both SwiftUI and Flutter:

1. **`@main struct RunnerApp: App`** — SwiftUI app entry, `@NSApplicationDelegateAdaptor` bridges `AppDelegate`
2. **`AppDelegate.applicationDidFinishLaunching`** — Creates and starts `FlutterEngine` (supports headless mode), calls `RegisterGeneratedPlugins` to register Flutter plugins
3. **`BeyondtranslateRuntimePlugin.register(with:)`** — On plugin registration, `dlopen`s the Rust cdylib so native Swift code can resolve FFI symbols
4. **`RuntimeProvider.shared`** — Creates the Rust `Runtime` singleton (shared with Flutter side, same `dataDir`)

##### Flutter ↔ Native ↔ Rust Communication Paths

On macOS, Flutter can reach Rust through **two separate paths**, both sharing the same underlying `Runtime` instance:

```
┌────────────────────────────────────────────────────┐
│  Flutter (Dart)                                    │
│  ┌──────────────────────┐   ┌───────────────────┐  │
│  │ Dart FFI bindings    │   │ MethodChannel     │  │
│  │ (uniffi-bindgen-dart)│   │ (e.g. mac_settings)│  │
│  └──────────┬───────────┘   └────────┬──────────┘  │
│             │                         │             │
├─────────────┼─────────────────────────┼─────────────┤
│  macOS      │                         │             │
│             ▼                         ▼             │
│  ┌──────────────────┐   ┌──────────────────────┐   │
│  │ Swift bindings   │   │ FlutterPlugin         │   │
│  │ (uniffi-rs)      │   │ (MethodChannel handler)│  │
│  └──────────┬───────┘   └──────────────────────┘   │
│             │                                       │
│             ▼                                       │
│  ┌──────────────────┐                              │
│  │ RuntimeProvider  │━━ Shared Rust Runtime ━━     │
│  │ (Swift singleton)│                              │
│  └──────────┬───────┘                              │
│             │                                       │
├─────────────┼─────────────────────────────────────┤
│  Rust       │                                       │
│             ▼                                       │
│  ┌──────────────────────────────────┐            │
│  │ beyondtranslate_runtime (cdylib) │            │
│  │ - Runtime                        │            │
│  │ - RuntimeSettings                │            │
│  │ - RuntimeTranslation             │            │
│  │ - RuntimeOcr                     │            │
│  └──────────────────────────────────┘            │
└────────────────────────────────────────────────────┘
```

**Path 1 (Dart → Rust):** Flutter calls into Rust via `uniffi-bindgen-dart` generated Dart bindings — available on all platforms.

**Path 2 (FlutterPlugin → Rust, or SwiftUI → Rust):** The Swift bindings (uniffi-rs) are used by `MacSettingsPlugin`, `MacWindowAppearancePlugin`, the native Settings window, and any other native Swift code. The `BeyondtranslateRuntimePlugin` performs a one-shot `dlopen` at registration time so that Swift FFI symbols resolve correctly.

Both paths operate on handles backed by the same Rust runtime state when they use the same `dataDir`. Dart creates its handle in `apps/desktop/lib/src/services/runtime.dart`, Swift creates its handle through `RuntimeProvider`, and Rust deduplicates them through a process-wide registry keyed by the canonical `data_dir`. Configuration changes from the SwiftUI Settings window are immediately visible to the Flutter Dart code, and vice versa.

##### SPM Package Structure (`packages/runtime/macos/beyondtranslate_runtime/`)

| Target | Path | Description |
|--------|------|-------------|
| `beyondtranslate_runtime` | `Sources/beyondtranslate_runtime/` | Swift bindings + FlutterPlugin stub |
| `beyondtranslate_runtimeFFI` | `Sources/beyondtranslate_runtimeFFI/` | C module exposing the FFI header |

- **`Package.swift`** — SPM manifest, auto-discovered by Flutter's macOS plugin tooling and linked into the host app
- **`Generated/beyondtranslate_runtime.swift`** — uniffi-rs auto-generated Swift bindings (generated by `python scripts/codegen.py`)
- **`BeyondtranslateRuntimePlugin.swift`** — `FlutterPlugin` implementation; `register(with:)` calls `dlopen` on the cdylib to make FFI symbols resolvable
- **`include/beyondtranslate_runtimeFFI.h`** — Auto-generated C FFI header
- **`include/module.modulemap`** — Clang module map, exposes the C header to Swift
- **`dummy.c`** — Placeholder source file required by SPM C targets (actual code lives in the header)

##### Native Flutter Plugins

macOS registers two additional Flutter plugins via MethodChannel (not present on Linux or Windows):

| Plugin | MethodChannel | Purpose |
|--------|---------------|---------|
| `MacSettingsPlugin` | `beyondtranslate/mac_settings` | Show/focus the native Settings window, highlight permission sections |
| `MacWindowAppearancePlugin` | `beyondtranslate/mac_window_appearance` | Set window transparency, toolbar style, frosted-glass background |

##### Native Settings Window (SwiftUI)

On Linux and Windows, settings are rendered with Flutter widgets. On macOS, a **native SwiftUI Settings window** is used instead, providing a more platform-consistent experience.

The window uses a `NavigationSplitView` layout and reads/writes config via `SettingsRepository`, which calls the Rust Runtime's async API.

```
SettingsView
├── General     — General (default services, permissions, shortcuts, etc.)
├── Appearance  — Appearance (language, theme)
├── Shortcuts   — Shortcut settings
├── Providers   — Translation provider management
└── Advanced    — Advanced settings
```

**Key macOS-specific features:**
- The Rust `Runtime` singleton is **shared** between the Flutter Dart side and the native Swift side; config changes from either side are immediately visible to the other
- Settings pages support English/Chinese switching via `AppLocale`, with language preference stored in `UserDefaults`
- Supports custom URL schemes (`beyondtranslate://`)
- `LSUIElement = true` makes the app run in the menu bar without a Dock icon

##### Summary: macOS vs. Linux/Windows

| Aspect | Linux / Windows | macOS |
|--------|----------------|-------|
| **Flutter UI** | Full Flutter UI | Hybrid SwiftUI + Flutter |
| **Settings UI** | Flutter widgets | Native SwiftUI window |
| **Rust FFI bindings** | Dart only (uniffi-dart) | Dart + Swift (uniffi-dart + uniffi-rs) |
| **Rust bridging** | Native assets (cdylib) | Native assets + SPM + `dlopen` |
| **Platform plugins** | Standard Flutter plugins | MethodChannel plugins for native features |
| **Runtime sharing** | Dart-only Runtime singleton | Shared Dart + Swift Runtime singleton via `RuntimeProvider` |
| **App lifecycle** | Standard Flutter desktop | SwiftUI `@main` with `FlutterEngine` managed in `AppDelegate` |
| **Menu bar / Dock** | Standard window | `LSUIElement=true` (menu bar only, no Dock icon) |

---

### Flutter ↔ Rust Bridge
The `packages/runtime` package uses **uniffi** to generate Dart FFI bindings for the Rust native code. The Rust source lives under `packages/runtime/rust/`. After modifying any Rust code in this directory, you **must** run `python scripts/codegen.py` from the project root to regenerate the Dart and Swift FFI bindings.

- **Dart bindings** are generated by `uniffi-bindgen-dart` and written to `packages/runtime/lib/src/generated/`.
- **Swift bindings** are generated by `uniffi-bindgen` (uniffi-rs) and written to `packages/runtime/macos/beyondtranslate_runtime/Sources/beyondtranslate_runtime/Generated/`, along with a C header and modulemap deployed to `.../Sources/beyondtranslate_runtimeFFI/include/`.
- The macOS side also includes a Swift Package Manager manifest (`Package.swift`) that provides an `beyondtranslate_runtime` SPM target, which is auto-discovered by Flutter's macOS plugin tooling.

### Translation Flow
1. **Input:** User enters text (or selects from screen via `screen_text_extractor`).
2. **OCR (optional):** Text can be extracted from images using built-in or Youdao OCR engines.
3. **Translation:** Text is sent to the translation engine (`crates/engine`) which supports multiple providers.
4. **Display:** Results are shown in the UI with pronunciation, definitions, and examples.

### API Server
The `apps/api` directory contains a Rust-based API server deployed via Cloudflare Workers. It uses `wrangler.toml` for configuration and is independent of the desktop app.

Common API commands:

```bash
cd apps/api
npm run dev      # Run wrangler dev
npm run build    # Build the Cloudflare Worker
npm run deploy   # Deploy the Cloudflare Worker
```

---

## Useful Commands

| Command | Description |
|---------|-------------|
| `dart pub get` | Resolve the Pub Workspace and update the shared root lockfile |
| `dart run melos bootstrap` | Bootstrap the monorepo using Melos |
| `dart run melos run analyze` | Run Flutter analyze on all packages |
| `dart run melos run format` | Format all Dart code |
| `dart run melos run test` | Run all Flutter tests |
| `dart run melos run fix` | Apply Dart fixes |
| `cargo build --workspace` | Build all Rust crates |
| `cargo test --workspace` | Run all Rust tests |
| `python scripts/format.py` | Format Dart, Rust, and Swift source files |
| `python scripts/format.py --check` | Check Dart, Rust, and Swift formatting without modifying files |

---

## Troubleshooting

### `dart run melos bootstrap` fails
- Ensure Flutter SDK >=3.27.0 is installed and the bundled Dart SDK is >=3.6.0.
- Run `dart pub get` from the repository root first; Pub Workspaces resolve dependencies at the root.
- Do not add `path:` overrides between workspace packages. Use a version constraint and let Pub Workspaces resolve the local package.

### Rust build errors in `packages/runtime`
- Ensure a compatible stable Rust toolchain is installed. This repository currently does not pin a `rust-toolchain.toml`; use the crate/workspace `Cargo.toml` files and build errors as the source of truth for required targets and dependencies.
- If uniffi bindings fail, try cleaning: `cargo clean` and rebuild.
- After modifying Rust code, remember to run `python scripts/codegen.py` from the project root to regenerate the Dart and Swift FFI bindings.

### Flutter desktop build errors on Linux
- Install required system dependencies: `libappindicator3-dev`, `keybinder-3.0`.
- See the [Linux requirements section](https://github.com/beyondtranslate/beyondtranslate#linux-requirements) in the README.

---

## License

This project is licensed under the **AGPL** license. See the [LICENSE](./LICENSE) file for details.
