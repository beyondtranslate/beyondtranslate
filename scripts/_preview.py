#!/usr/bin/env python3
"""Temporary script to preview codegen output without running FRB.
Run from the repo root: python3 scripts/_preview.py
"""
# pylint: disable=all
# ruff: noqa

from __future__ import annotations

import re
import sys
from dataclasses import dataclass
from pathlib import Path

# ---- copy the relevant bits from codegen.py so we can run standalone ----

REPO_ROOT = Path(__file__).resolve().parents[1]
DESKTOP_ROOT = REPO_ROOT / "apps/desktop"
SCRIPT_DISPLAY_NAME = "scripts/codegen.py"

SETTINGS_INPUT_PATH = DESKTOP_ROOT / "rust/src/domain/settings.rs"
SETTINGS_OUTPUT_DIR = DESKTOP_ROOT / "macos/Runner/Features/Settings/Models"
ENGINE_INPUT_PATH = REPO_ROOT / "crates/engine/src/engine.rs"
PROVIDER_INPUT_DIR = REPO_ROOT / "crates/engine/src/provider"
PROVIDER_CONFIG_MODELS = [
    "BaiduProviderConfig",
    "CaiyunProviderConfig",
    "DeepLProviderConfig",
    "GoogleProviderConfig",
    "IcibaProviderConfig",
    "TencentProviderConfig",
    "YoudaoProviderConfig",
]

# Import everything from the real codegen
import sys, types as _types

_codegen_path = REPO_ROOT / "scripts/codegen.py"
_codegen_src = _codegen_path.read_text()
_fake_mod = _types.ModuleType("__codegen_preview__")
_fake_mod.__file__ = str(_codegen_path)
sys.modules["__codegen_preview__"] = _fake_mod
_ns = _fake_mod.__dict__
exec(compile(_codegen_src, str(_codegen_path), "exec"), _ns)

# Grab helpers
parse_provider_type_cases = _ns["parse_provider_type_cases"]
render_provider_type_enum = _ns["render_provider_type_enum"]
render_provider_config_field_struct = _ns["render_provider_config_field_struct"]
parse_provider_config_structs = _ns["parse_provider_config_structs"]
render_provider_config_fields_extension = _ns["render_provider_config_fields_extension"]
render_provider_type_fields = _ns["render_provider_type_fields"]
parse_provider_capability_cases = _ns["parse_provider_capability_cases"]
render_enum = _ns["render_enum"]

parse_settings_swift_structs = _ns["parse_settings_swift_structs"]
render_struct = _ns["render_struct"]

core_source = (REPO_ROOT / "crates/core/src/provider.rs").read_text()
capability_cases = parse_provider_capability_cases(core_source)
print("=== ProviderCapability.swift ===")
print("\n".join(render_enum("ProviderCapability", capability_cases)))

engine_source = ENGINE_INPUT_PATH.read_text()
cases = parse_provider_type_cases(engine_source)

print("=== ProviderType.swift ===")
print("\n".join(render_provider_type_enum(cases)))

print("\n=== ProviderConfigField.swift ===")
print("\n".join(render_provider_config_field_struct()))

parsed = parse_provider_config_structs()

print("\n=== DeepLProviderConfig+Fields.swift ===")
print("\n".join(render_provider_config_fields_extension(parsed["DeepLProviderConfig"])))

print("\n=== YoudaoProviderConfig+Fields.swift ===")
print(
    "\n".join(render_provider_config_fields_extension(parsed["YoudaoProviderConfig"]))
)

print("\n=== ProviderType+Fields.swift ===")
print("\n".join(render_provider_type_fields(cases, parsed)))


settings_source = SETTINGS_INPUT_PATH.read_text()
settings_parsed = parse_settings_swift_structs(settings_source)
print("\n=== ProviderConfigEntry.swift ===")
print("\n".join(render_struct(settings_parsed["ProviderConfigEntry"], patch=False)))
