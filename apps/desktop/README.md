# Beyond Translate Desktop

## Desktop Codegen

Run commands from the repository root.

Bindings are generated with **uniffi-rs** (Swift) and **uniffi-dart** (Dart).
The Rust interface is declared in `packages/runtime/rust/src/api.udl`.

Regenerate all generated code after changing the UDL interface or the i18n
strings:

```bash
python3 scripts/codegen.py
```

`codegen.py` runs two generators in order, then formats all source files:

| Generator | Script | What it does |
|---|---|---|
| Runtime bindings | `scripts/generate/runtime_bindings.py` | Builds the Rust cdylib, then generates Swift and Dart bindings with uniffi-rs / uniffi-dart |
| macOS i18n | `scripts/generate/macos_i18n.py` | Converts Flutter i18n JSON to `Localizable.strings` and a Swift `LocaleKeys` enum |

Generated files:

- **Dart** – `packages/runtime/lib/src/generated/`
- **Swift** – `packages/runtime/swift/Generated/` (mirrored into the SPM package under `packages/runtime/macos/`)
- **macOS i18n** – `apps/desktop/macos/Runner/<locale>.lproj/Localizable.strings` and `apps/desktop/macos/Runner/Shared/I18n/LocaleKeys.swift`

Do not edit generated files by hand.

Useful follow-up commands:

```bash
cargo fmt --all
cargo test --manifest-path packages/runtime/rust/Cargo.toml
dart format lib
flutter analyze
```
