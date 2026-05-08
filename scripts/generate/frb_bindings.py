#!/usr/bin/env python3
from __future__ import annotations

import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]
DESKTOP_ROOT = REPO_ROOT / "apps/desktop"
FRB_CONFIG_PATH = DESKTOP_ROOT / "flutter_rust_bridge.yaml"


def main() -> int:
    if not FRB_CONFIG_PATH.exists():
        print(f"Missing FRB config: {FRB_CONFIG_PATH}", file=sys.stderr)
        return 1

    print("Generating Flutter Rust Bridge bindings...", flush=True)
    result = subprocess.run(
        [
            "flutter_rust_bridge_codegen",
            "generate",
            "--config-file",
            FRB_CONFIG_PATH.name,
        ],
        cwd=DESKTOP_ROOT,
        check=False,
    )
    return result.returncode


if __name__ == "__main__":
    raise SystemExit(main())
