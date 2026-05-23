#!/usr/bin/env python3
from __future__ import annotations

import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]

GENERATORS = [
    REPO_ROOT / "scripts/generate/runtime_bindings.py",
    REPO_ROOT / "scripts/generate/languages.py",
    REPO_ROOT / "scripts/generate/macos_i18n.py",
]
FORMATTER = REPO_ROOT / "scripts/format.py"


def main() -> int:
    for script in GENERATORS:
        exit_code = run_script(script)
        if exit_code != 0:
            return exit_code

    return run_script(FORMATTER)


def run_script(script: Path) -> int:
    result = subprocess.run([sys.executable, str(script)], cwd=REPO_ROOT, check=False)
    return result.returncode


if __name__ == "__main__":
    raise SystemExit(main())
