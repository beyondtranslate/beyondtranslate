#!/usr/bin/env python3
"""Format Dart, Rust, and Swift source files in this repository."""

from __future__ import annotations

import argparse
import shutil
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]

EXCLUDED_DIRS = {
    ".dart_tool",
    ".git",
    ".idea",
    "build",
    "ephemeral",
    "Pods",
    "target",
}

DEFAULT_IGNORED_FILES = {
    Path("apps/desktop/macos/Flutter/GeneratedPluginRegistrant.swift"),
}


def run(command: list[str], *, cwd: Path = ROOT) -> int:
    print(f"$ {' '.join(command)}", flush=True)
    completed = subprocess.run(command, cwd=cwd)
    return completed.returncode


def require_command(command: str) -> bool:
    if shutil.which(command):
        return True

    print(f"error: required command not found: {command}", file=sys.stderr)
    return False


def normalize_ignore_path(path: str) -> Path:
    return Path(path).expanduser()


def is_ignored_file(path: Path, ignored_files: set[Path]) -> bool:
    return any(path == ignored_file or path.name == str(ignored_file) for ignored_file in ignored_files)


def source_files(extension: str, ignored_files: set[Path]) -> list[Path]:
    tracked_files = subprocess.run(
        ["git", "ls-files", f"*.{extension}"],
        cwd=ROOT,
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
        text=True,
    )
    if tracked_files.returncode == 0:
        return [
            Path(path)
            for path in tracked_files.stdout.splitlines()
            if not any(part in EXCLUDED_DIRS for part in Path(path).parts)
            and not is_ignored_file(Path(path), ignored_files)
        ]

    files: list[Path] = []
    for path in ROOT.rglob(f"*.{extension}"):
        relative_path = path.relative_to(ROOT)
        if any(part in EXCLUDED_DIRS for part in relative_path.parts):
            continue
        if is_ignored_file(relative_path, ignored_files):
            continue
        files.append(relative_path)
    return sorted(files)


def format_dart(check: bool, ignored_files: set[Path]) -> int:
    if not require_command("dart"):
        return 127

    files = source_files("dart", ignored_files)
    if not files:
        print("No Dart files found.")
        return 0

    command = ["dart", "format"]
    if check:
        command.extend(["--output=none", "--set-exit-if-changed"])
    command.extend(str(path) for path in files)

    return run(command)


def format_rust(check: bool, ignored_files: set[Path]) -> int:
    if not require_command("cargo"):
        return 127

    command = ["cargo", "fmt", "--all"]
    if check:
        command.append("--check")

    return run(command)


def format_swift(check: bool, ignored_files: set[Path]) -> int:
    if not require_command("swift-format"):
        return 127

    files = source_files("swift", ignored_files)
    if not files:
        print("No Swift files found.")
        return 0

    if check:
        print("$ swift-format format <swift files>", flush=True)
        exit_code = 0
        for path in files:
            completed = subprocess.run(
                ["swift-format", "format", str(path)],
                cwd=ROOT,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
            )
            if completed.returncode != 0:
                sys.stderr.buffer.write(completed.stderr)
                exit_code = completed.returncode
                continue

            if completed.stdout != (ROOT / path).read_bytes():
                print(f"Would reformat {path}", file=sys.stderr)
                exit_code = 1

        return exit_code

    command = ["swift-format", "format", "--in-place", "--parallel"]
    command.extend(str(path) for path in files)

    return run(command)


FORMATTERS = {
    "dart": format_dart,
    "rust": format_rust,
    "swift": format_swift,
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Format Dart, Rust, and Swift code in this repository.",
    )
    parser.add_argument(
        "--check",
        action="store_true",
        help="Check formatting without modifying files.",
    )
    parser.add_argument(
        "--ignore",
        action="append",
        default=[],
        metavar="PATH",
        help=(
            "Ignore a file by repository-relative path or basename. "
            "Can be passed multiple times."
        ),
    )
    parser.add_argument(
        "languages",
        nargs="*",
        choices=FORMATTERS.keys(),
        help="Languages to format. Defaults to all languages.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    languages = args.languages or list(FORMATTERS)
    ignored_files = DEFAULT_IGNORED_FILES | {
        normalize_ignore_path(path) for path in args.ignore
    }

    exit_code = 0
    for language in languages:
        print(f"\n==> {language}", flush=True)
        result = FORMATTERS[language](args.check, ignored_files)
        if result != 0 and exit_code == 0:
            exit_code = result

    return exit_code


if __name__ == "__main__":
    raise SystemExit(main())
