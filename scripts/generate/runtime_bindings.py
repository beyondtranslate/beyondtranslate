#!/usr/bin/env python3
from __future__ import annotations

import json
import platform
import re
import shutil
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]
PKG_DIR = REPO_ROOT / "packages/runtime"
RUST_DIR = PKG_DIR / "rust"
SWIFT_OUT = PKG_DIR / "swift/Generated"
DART_OUT = PKG_DIR / "lib/src/generated"
SPM_DIR = PKG_DIR / "macos/beyondtranslate_runtime/Sources"
SPM_SWIFT_OUT = SPM_DIR / "beyondtranslate_runtime/Generated"
SPM_FFI_OUT = SPM_DIR / "beyondtranslate_runtimeFFI/include"
SPM_CORE_SWIFT_OUT = SPM_DIR / "beyondtranslate_core/Generated"
SPM_CORE_FFI_OUT = SPM_DIR / "beyondtranslate_coreFFI/include"


def main() -> int:
    if not validate_inputs():
        return 1

    exit_code = run(
        ["cargo", "build", "--release", "--manifest-path", str(cargo_manifest())]
    )
    if exit_code != 0:
        return exit_code

    target_dir = cargo_target_dir()
    host_lib = host_cdylib(target_dir)
    if host_lib is None:
        print(f"Unsupported host OS: {platform.system()}", file=sys.stderr)
        return 1
    if not host_lib.exists():
        print(f"Host cdylib not found at {host_lib}", file=sys.stderr)
        return 1

    SWIFT_OUT.mkdir(parents=True, exist_ok=True)
    DART_OUT.mkdir(parents=True, exist_ok=True)

    print(f"==> Generating Swift bindings (uniffi-rs) -> {SWIFT_OUT}", flush=True)
    exit_code = run(
        [
            "cargo",
            "run",
            "--quiet",
            "--release",
            "--manifest-path",
            str(cargo_manifest()),
            "--bin",
            "uniffi-bindgen",
            "--",
            "generate",
            "--library",
            str(host_lib),
            "--language",
            "swift",
            "--out-dir",
            str(SWIFT_OUT),
        ]
    )
    if exit_code != 0:
        return exit_code

    print(f"==> Generating Dart bindings (uniffi-dart) -> {DART_OUT}", flush=True)
    exit_code = run(
        [
            "cargo",
            "run",
            "--quiet",
            "--release",
            "--manifest-path",
            str(cargo_manifest()),
            "--bin",
            "uniffi-bindgen-dart",
            "--",
            str(host_lib),
            str(DART_OUT),
        ]
    )
    if exit_code != 0:
        return exit_code

    sanitize_swift_bindings()
    patch_swift_cross_crate_import()
    format_dart_output()
    patch_dart_cross_crate_lifters()
    mirror_swift_artifacts()
    print_generated_files()
    return 0


def validate_inputs() -> bool:
    if not cargo_manifest().exists():
        print(f"Missing Cargo manifest: {cargo_manifest()}", file=sys.stderr)
        return False
    return True


def cargo_manifest() -> Path:
    return RUST_DIR / "Cargo.toml"


def cargo_target_dir() -> Path:
    result = subprocess.run(
        [
            "cargo",
            "metadata",
            "--no-deps",
            "--format-version=1",
            "--manifest-path",
            str(cargo_manifest()),
        ],
        cwd=REPO_ROOT,
        check=False,
        stdout=subprocess.PIPE,
        text=True,
    )
    if result.returncode != 0:
        raise SystemExit(result.returncode)
    return Path(json.loads(result.stdout)["target_directory"])


def host_cdylib(target_dir: Path) -> Path | None:
    system = platform.system()
    if system == "Darwin":
        return target_dir / "release/libbeyondtranslate_runtime.dylib"
    if system == "Linux":
        return target_dir / "release/libbeyondtranslate_runtime.so"
    if system == "Windows" or system.startswith(("MSYS", "MINGW", "CYGWIN")):
        return target_dir / "release/beyondtranslate_runtime.dll"
    return None


def patch_swift_cross_crate_import() -> None:
    """Patch the generated beyondtranslate_runtime.swift to import the sibling
    beyondtranslate_core Swift module.

    uniffi-rs's Swift backend assumes all generated bindings are compiled into
    a single Swift module, so it never emits a cross-crate `import` for types
    declared in another crate (DetectLanguageRequest, LookUpResponse,
    TranslateRequest, ...).  Our SPM package builds beyondtranslate_core and
    beyondtranslate_runtime as two separate Swift targets, so the runtime file
    needs an explicit `import beyondtranslate_core`.
    """
    swift_file = SWIFT_OUT / "beyondtranslate_runtime.swift"
    if not swift_file.exists():
        return

    source = swift_file.read_text()

    if "import beyondtranslate_core" in source:
        return

    # Match the runtimeFFI conditional import block regardless of how the
    # uniffi-bindgen / swift-format pipeline indents the body.
    anchor_pattern = re.compile(
        r"#if canImport\(beyondtranslate_runtimeFFI\)\n"
        r"[ \t]*import beyondtranslate_runtimeFFI\n"
        r"#endif",
        re.MULTILINE,
    )
    match = anchor_pattern.search(source)
    if match is None:
        print(
            "WARNING: cross-crate import anchor not found in beyondtranslate_runtime.swift; "
            "skipping patch",
            file=sys.stderr,
        )
        return

    patched_block = (
        match.group(0)
        + "\n"
        + "// Cross-crate types (DetectLanguageRequest, LookUpResponse, TranslateRequest, ...) live in\n"
        + "// the sibling `beyondtranslate_core` Swift module. uniffi-rs's Swift backend assumes all\n"
        + "// generated bindings are compiled together, so it never emits the import; we add it here as\n"
        + "// a post-generation patch so this file builds when the two crates are split into separate\n"
        + "// SPM targets.\n"
        + "#if canImport(beyondtranslate_core)\n"
        + "  import beyondtranslate_core\n"
        + "#endif"
    )
    source = source[: match.start()] + patched_block + source[match.end() :]

    swift_file.write_text(source)
    print(
        "==> Applied cross-crate import patch to beyondtranslate_runtime.swift",
        flush=True,
    )


def patch_dart_cross_crate_lifters() -> None:
    """Patch the generated beyondtranslate_runtime.dart to fix a uniffi-dart
    limitation where async methods returning cross-crate types (LookUpResponse,
    TranslateResponse) reach for FfiConverter.lift functions defined in
    beyondtranslate_core.dart.  Those `lift` functions take beyondtranslate_core's
    RustBuffer, but `uniffiRustCallAsync` (and the matching
    `ffi_beyondtranslate_runtime_rust_future_complete_rust_buffer` complete-func)
    operate on this file's own `RustBuffer` type.  Bridge functions are inserted
    after the imports to adapt the types.

    The corresponding *synchronous* echo functions use `rustCallWithLifter` and
    invoke FFI functions that already return `beyondtranslate_core.RustBuffer`,
    so they don't need the bridge - we leave their `FfiConverter*.lift,` calls
    untouched.  The substitution is therefore anchored on the
    `ffi_beyondtranslate_runtime_rust_future_free_rust_buffer,` line that only
    appears in the async call sites.
    """
    dart_file = DART_OUT / "beyondtranslate_runtime.dart"
    if not dart_file.exists():
        return

    source = dart_file.read_text()

    import_anchor = 'import "beyondtranslate_core.dart" as beyondtranslate_core;'
    if import_anchor not in source:
        return

    if "_liftLookUpResponse" not in source:
        bridge_block = (
            import_anchor
            + "\n\n"
            + "// Bridge functions that adapt beyondtranslate_core converters to accept\n"
            + "// this file's RustBuffer type (both are structurally identical Uint8List\n"
            + "// wrappers, but Dart's nominal typing requires explicit adapters when\n"
            + "// they are passed to uniffiRustCallAsync).\n"
            + "LookUpResponse _liftLookUpResponse(RustBuffer buf) =>\n"
            + "    beyondtranslate_core.FfiConverterLookUpResponse.read(buf.asUint8List())\n"
            + "        .value;\n\n"
            + "TranslateResponse _liftTranslateResponse(RustBuffer buf) =>\n"
            + "    beyondtranslate_core.FfiConverterTranslateResponse.read(buf.asUint8List())\n"
            + "        .value;"
        )
        source = source.replace(import_anchor, bridge_block, 1)

    # Only rewrite the async lifter: it appears immediately after the
    # `_rust_future_free_rust_buffer,` line in `uniffiRustCallAsync(...)`.  The
    # sync echo helpers (rustCallWithLifter) need the original
    # `FfiConverter*.lift` because their FFI functions already return
    # `beyondtranslate_core.RustBuffer`.
    async_lift_pattern = re.compile(
        r"(ffi_beyondtranslate_runtime_rust_future_free_rust_buffer,\s*\n\s*)"
        r"FfiConverter(LookUpResponse|TranslateResponse)\.lift,"
    )
    source, n_async = async_lift_pattern.subn(
        lambda m: f"{m.group(1)}_lift{m.group(2)},",
        source,
    )

    dart_file.write_text(source)
    if n_async:
        print(
            f"==> Applied cross-crate lift bridge patch to beyondtranslate_runtime.dart ({n_async} async sites)",
            flush=True,
        )


def format_dart_output() -> None:
    if shutil.which("dart") is None:
        return
    result = subprocess.run(
        ["dart", "format", str(DART_OUT)],
        cwd=REPO_ROOT,
        check=False,
        stdout=subprocess.DEVNULL,
    )
    if result.returncode != 0:
        print(
            "WARNING: dart format failed or is unavailable; proceeding without full formatting",
            file=sys.stderr,
        )


def sanitize_swift_bindings() -> None:
    generated_header = (
        "// This file is automatically generated. Do not edit by hand.\n\n"
    )
    sanitize_generated_header(SWIFT_OUT.glob("*.swift"), generated_header)
    sanitize_generated_header(
        SWIFT_OUT.glob("*.h"),
        "// This file is automatically generated. Do not edit by hand.\n",
    )


def sanitize_generated_header(paths, replacement: str) -> None:
    original = (
        "// This file was autogenerated by some "
        "hot "
        "garbage in the `uniffi` crate.\n"
        "// Trust "
        "me, you don't want to "
        "mess with it!\n"
        "\n"
    )
    for path in paths:
        source = path.read_text()
        source = source.replace(original, replacement, 1)
        path.write_text(source)


def mirror_swift_artifacts() -> None:
    print(f"==> Mirroring Swift artefacts into SPM package -> {SPM_DIR}", flush=True)
    SPM_SWIFT_OUT.mkdir(parents=True, exist_ok=True)
    SPM_FFI_OUT.mkdir(parents=True, exist_ok=True)
    SPM_CORE_SWIFT_OUT.mkdir(parents=True, exist_ok=True)
    SPM_CORE_FFI_OUT.mkdir(parents=True, exist_ok=True)

    copies = [
        (
            SWIFT_OUT / "beyondtranslate_runtime.swift",
            SPM_SWIFT_OUT / "beyondtranslate_runtime.swift",
        ),
        (
            SWIFT_OUT / "beyondtranslate_runtimeFFI.h",
            SPM_FFI_OUT / "beyondtranslate_runtimeFFI.h",
        ),
        (
            SWIFT_OUT / "beyondtranslate_runtimeFFI.modulemap",
            SPM_FFI_OUT / "module.modulemap",
        ),
        (
            SWIFT_OUT / "beyondtranslate_core.swift",
            SPM_CORE_SWIFT_OUT / "beyondtranslate_core.swift",
        ),
        (
            SWIFT_OUT / "beyondtranslate_coreFFI.h",
            SPM_CORE_FFI_OUT / "beyondtranslate_coreFFI.h",
        ),
        (
            SWIFT_OUT / "beyondtranslate_coreFFI.modulemap",
            SPM_CORE_FFI_OUT / "module.modulemap",
        ),
    ]
    for source, destination in copies:
        shutil.copyfile(source, destination)


def print_generated_files() -> None:
    print("Done. Generated files:")
    list_dir(SWIFT_OUT)
    list_dir(DART_OUT)
    print("SPM mirror:")
    list_dir(SPM_SWIFT_OUT)
    list_dir(SPM_FFI_OUT)
    list_dir(SPM_CORE_SWIFT_OUT)
    list_dir(SPM_CORE_FFI_OUT)


def list_dir(path: Path) -> None:
    print(f"{path}:")
    for child in sorted(path.iterdir()):
        print(child.name)
    print()


def run(args: list[str]) -> int:
    result = subprocess.run(args, cwd=REPO_ROOT, check=False)
    return result.returncode


if __name__ == "__main__":
    raise SystemExit(main())
