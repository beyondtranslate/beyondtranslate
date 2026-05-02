# Beyond Translate Desktop

## Desktop Codegen

Run commands from the repository root.

`flutter_rust_bridge` config is in `flutter_rust_bridge.yaml`.

Current config:

```yaml
rust_input: crate::api
rust_root: rust/
dart_output: lib/src/rust
```

Regenerate generated desktop code after changing FRB-exposed Rust APIs or the
Rust settings schema:

```bash
python3 scripts/codegen.py
```

Generated files:

- Rust: `rust/src/frb_generated.rs`
- Dart: files under the configured `dart_output`
- macOS Swift: `macos/Runner/Features/Settings/Models/Settings.swift`

Do not edit generated files by hand.

Useful follow-up commands:

```bash
cargo fmt --manifest-path rust/Cargo.toml
cargo test --manifest-path rust/Cargo.toml
dart format lib
flutter analyze
```
