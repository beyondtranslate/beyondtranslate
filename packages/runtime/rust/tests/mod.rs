use anyhow::Result;
use camino::{Utf8Path, Utf8PathBuf};
use std::fs::{copy, create_dir_all, remove_dir_all, File};
use std::io::Write;
use std::process::Command;

use uniffi_testing::UniFFITestHelper;

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
    run_dart_test_with_library_mode()
}

fn run_dart_test_with_library_mode() -> Result<()> {
    let test_helper = UniFFITestHelper::new("beyondtranslate_runtime")?;
    let manifest_dir = Utf8PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let temp_root = Utf8PathBuf::from_path_buf(std::env::temp_dir())
        .expect("temp dir path is not valid UTF-8")
        .join(format!(
            "beyondtranslate_runtime_uniffi_test_{}",
            std::process::id()
        ));

    if temp_root.exists() {
        remove_dir_all(&temp_root)?;
    }
    create_dir_all(&temp_root)?;
    let out_dir = test_helper.create_out_dir(&temp_root, &manifest_dir)?;

    write_pubspec(&out_dir)?;
    write_build_hook(&out_dir, &test_helper)?;
    copy_fixture_tests(&manifest_dir, &out_dir)?;

    let udl = manifest_dir.join("src/api.udl");
    let config = manifest_dir.join("uniffi.toml");
    let cdylib = test_helper.cdylib_path()?;
    test_helper.copy_cdylib_to_out_dir(&out_dir)?;

    uniffi_dart::gen::generate_dart_bindings(
        &udl,
        Some(config.as_path()),
        Some(&out_dir),
        &cdylib,
        true,
    )?;

    let mut format = Command::new("dart");
    format.current_dir(&out_dir).arg("format").arg(".");
    let _ = format.spawn().and_then(|mut child| child.wait());

    let mut test = Command::new("dart");
    test.current_dir(&out_dir).arg("test");
    let status = test.spawn()?.wait()?;
    anyhow::ensure!(status.success(), "running Dart fixture tests failed");

    remove_dir_all(&temp_root)?;
    Ok(())
}

fn write_pubspec(out_dir: &Utf8Path) -> Result<()> {
    let mut pubspec = File::create(out_dir.join("pubspec.yaml"))?;
    pubspec.write_all(
        br#"
name: beyondtranslate_runtime
description: testing module for uniffi
version: 1.0.0

environment:
  sdk: '>=3.10.0'
dev_dependencies:
  test: ^1.24.3
dependencies:
  ffi: ^2.0.1
  code_assets: any
  hooks: any
"#,
    )?;
    Ok(())
}

fn write_build_hook(out_dir: &Utf8Path, test_helper: &UniFFITestHelper) -> Result<()> {
    let hook_dir = out_dir.join("hook");
    create_dir_all(&hook_dir)?;

    let cdylib_path = test_helper.cdylib_path()?;
    let cdylib_filename = cdylib_path.file_name().expect("cdylib has no filename");
    let cdylib_stem = cdylib_path
        .file_stem()
        .expect("cdylib has no stem")
        .trim_start_matches("lib");

    let mut build_hook = File::create(hook_dir.join("build.dart"))?;
    build_hook.write_all(
        format!(
            r#"import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';

void main(List<String> args) async {{
  await build(args, (input, output) async {{
    output.assets.code.add(
      CodeAsset(
        package: input.packageName,
        name: 'uniffi:{}',
        linkMode: DynamicLoadingBundled(),
        file: input.packageRoot.resolve('{}'),
      ),
    );
  }});
}}
"#,
            cdylib_stem, cdylib_filename
        )
        .as_bytes(),
    )?;
    Ok(())
}

fn copy_fixture_tests(manifest_dir: &Utf8Path, out_dir: &Utf8Path) -> Result<()> {
    let test_outdir = out_dir.join("test");
    create_dir_all(&test_outdir)?;
    copy(
        manifest_dir.join("test/beyondtranslate_runtime_test.dart"),
        test_outdir.join("beyondtranslate_runtime_test.dart"),
    )?;
    Ok(())
}
