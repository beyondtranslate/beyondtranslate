# Beyond Translate Desktop

## Rust Bridge Codegen

Run commands from `apps/desktop`.

`flutter_rust_bridge` config is in `flutter_rust_bridge.yaml`.

Current config:

```yaml
rust_input: crate::api
rust_root: rust/
dart_output: lib/src/rust
```

Regenerate bindings after changing FRB-exposed Rust APIs:

```bash
cd apps/desktop
flutter_rust_bridge_codegen generate --config-file flutter_rust_bridge.yaml
```

Generated files:

- Rust: `rust/src/frb_generated.rs`
- Dart: files under the configured `dart_output`

Do not edit generated files by hand.

Useful follow-up commands:

```bash
cargo fmt --manifest-path rust/Cargo.toml
cargo test --manifest-path rust/Cargo.toml
dart format lib
flutter analyze
```
