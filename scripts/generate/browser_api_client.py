#!/usr/bin/env python3
from __future__ import annotations

import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]
OPENAPI_SPEC = REPO_ROOT / "apps/api/openapi.yaml"
BROWSER_EXTENSION_DIR = REPO_ROOT / "extensions/browser"
CLIENT_OUTPUT_DIR = BROWSER_EXTENSION_DIR / "libs/client/src"

def main() -> int:
    if not validate_inputs():
        return 1

    generator = shutil.which("openapi-generator-cli")
    if generator is None:
        print("Missing command: openapi-generator-cli", file=sys.stderr)
        print(
            "Install it with your preferred package manager, for example: "
            "pnpm add -g @openapitools/openapi-generator-cli",
            file=sys.stderr,
        )
        return 1

    print(f"Generating browser API client -> {CLIENT_OUTPUT_DIR}", flush=True)
    with tempfile.TemporaryDirectory(prefix="beyondtranslate-openapi-") as temp_dir:
        temp_root = Path(temp_dir)
        temp_output_dir = temp_root / "generated"
        exit_code = subprocess.run(
            [
                generator,
                "generate",
                "-i",
                str(OPENAPI_SPEC),
                "-g",
                "typescript-fetch",
                "-o",
                str(temp_output_dir),
                "--additional-properties=supportsES6=true,npmName=@beyondtranslate/client",
            ],
            cwd=temp_root,
            check=False,
        ).returncode
        if exit_code != 0:
            return exit_code

        generated_src_dir = temp_output_dir / "src"
        if not generated_src_dir.exists():
            print(f"Missing generated src directory: {generated_src_dir}", file=sys.stderr)
            return 1

        remove_previous_outputs()
        CLIENT_OUTPUT_DIR.parent.mkdir(parents=True, exist_ok=True)
        shutil.copytree(generated_src_dir, CLIENT_OUTPUT_DIR)

    return 0


def validate_inputs() -> bool:
    if not OPENAPI_SPEC.exists():
        print(f"Missing OpenAPI spec: {OPENAPI_SPEC}", file=sys.stderr)
        return False
    if not BROWSER_EXTENSION_DIR.exists():
        print(f"Missing browser extension directory: {BROWSER_EXTENSION_DIR}", file=sys.stderr)
        return False
    return True


def remove_previous_outputs() -> None:
    if CLIENT_OUTPUT_DIR.exists():
        shutil.rmtree(CLIENT_OUTPUT_DIR)


if __name__ == "__main__":
    raise SystemExit(main())
