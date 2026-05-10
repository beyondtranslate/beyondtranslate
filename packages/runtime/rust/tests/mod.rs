use anyhow::Result;

/// End-to-end fixture test: regenerates Dart bindings from `src/api.udl`,
/// builds the cdylib, copies it into a temp directory and runs every
/// `*.dart` file from `rust/test/` against it via `dart test`.
///
/// Mirrors the upstream `fixtures/hello_world` pattern from uniffi-dart.
/// Skipped automatically in CI environments that don't have `dart` on PATH.
#[test]
fn beyondtranslate_runtime() -> Result<()> {
    if std::process::Command::new("dart")
        .arg("--version")
        .output()
        .is_err()
    {
        eprintln!("`dart` not found on PATH; skipping uniffi-dart fixture test");
        return Ok(());
    }
    uniffi_dart::testing::run_test(
        "beyondtranslate_runtime",
        "src/api.udl",
        Some("uniffi.toml"),
    )
}
