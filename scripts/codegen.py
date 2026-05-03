#!/usr/bin/env python3
from __future__ import annotations

import re
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
DESKTOP_ROOT = REPO_ROOT / "apps/desktop"
SCRIPT_DISPLAY_NAME = "scripts/codegen.py"


# =============================================================================
# Entrypoint
# =============================================================================


def main() -> int:
    if not validate_inputs():
        return 1

    if generate_frb_bindings() != 0:
        return 1

    generate_native_settings_swift()
    generate_native_provider_swift()
    return 0


def validate_inputs() -> bool:
    if not SETTINGS_INPUT_PATH.exists():
        print(f"Missing Rust settings source: {SETTINGS_INPUT_PATH}", file=sys.stderr)
        return False
    if not FRB_CONFIG_PATH.exists():
        print(f"Missing FRB config: {FRB_CONFIG_PATH}", file=sys.stderr)
        return False
    if not ENGINE_INPUT_PATH.exists():
        print(f"Missing Rust engine source: {ENGINE_INPUT_PATH}", file=sys.stderr)
        return False
    if not PROVIDER_INPUT_DIR.exists():
        print(
            f"Missing Rust provider source directory: {PROVIDER_INPUT_DIR}",
            file=sys.stderr,
        )
        return False
    if not CORE_INPUT_PATH.exists():
        print(f"Missing Rust core provider source: {CORE_INPUT_PATH}", file=sys.stderr)
        return False
    return True


# =============================================================================
# Flutter Rust Bridge bindings codegen
# =============================================================================


FRB_CONFIG_PATH = DESKTOP_ROOT / "flutter_rust_bridge.yaml"


def generate_frb_bindings() -> int:
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


# =============================================================================
# Native Swift settings model codegen
# =============================================================================


SETTINGS_INPUT_PATH = DESKTOP_ROOT / "rust/src/domain/settings.rs"
SETTINGS_OUTPUT_DIR = DESKTOP_ROOT / "macos/Runner/Features/Settings/Models"
SETTINGS_SECTION_MODELS = [
    "GeneralSettings",
    "ProviderConfigEntry",
    "ShortcutSettings",
    "AppearanceSettings",
    "AdvancedSettings",
]
SETTINGS_VALUE_MODELS = [
    "TranslationTarget",
]
SETTINGS_ENUM_MODELS = [
    "TranslationMode",
    "InputSubmitMode",
]
CORE_INPUT_PATH = REPO_ROOT / "crates/core/src/provider.rs"
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

# Abbreviations to expand when building labels from snake_case field names
LABEL_EXPAND: dict[str, str] = {
    "api": "API",
    "url": "URL",
    "id": "ID",
}

# Secret-indicating words that appear as the LAST component of a snake_case name
SECRET_LAST_WORDS: set[str] = {"key", "secret", "token", "password"}

# Placeholder lookup: {ConfigStructName: {rust_field_name: placeholder}}
FIELD_PLACEHOLDERS: dict[str, dict[str, str]] = {
    "DeepLProviderConfig": {"base_url": "https://api.deepl.com"},
    "GoogleProviderConfig": {
        "api_key": "AIza\u2026",
        "base_url": "https://translation.googleapis.com",
    },
    "BaiduProviderConfig": {"base_url": "https://fanyi-api.baidu.com"},
    "CaiyunProviderConfig": {"base_url": "http://api.interpreter.caiyunai.com"},
    "YoudaoProviderConfig": {
        "base_url": "https://openapi.youdao.com",
        "picture_base_url": "https://picdict.youdao.com",
    },
}


@dataclass(frozen=True)
class SettingsSwiftField:
    rust_name: str
    wire_name: str
    swift_name: str
    swift_type: str


@dataclass(frozen=True)
class SettingsSwiftStruct:
    name: str
    has_patch: bool
    fields: list[SettingsSwiftField]


@dataclass(frozen=True)
class SettingsSwiftRootField:
    wire_name: str
    swift_name: str
    swift_type: str


@dataclass(frozen=True)
class SwiftEnumCase:
    rust_name: str
    wire_name: str
    swift_name: str


def generate_native_settings_swift() -> None:
    print("Generating native Swift settings models...", flush=True)
    source = SETTINGS_INPUT_PATH.read_text()
    parsed = parse_settings_swift_structs(source)
    settings_fields = parse_settings_fields(source)
    settings_models = SETTINGS_SECTION_MODELS + SETTINGS_VALUE_MODELS
    structs = [parsed[name] for name in settings_models if name in parsed]
    missing = sorted(set(settings_models) - set(parsed.keys()))
    if missing:
        raise ValueError(
            f"Missing expected Rust settings structs: {', '.join(missing)}"
        )

    SETTINGS_OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    write_generated_swift_file("Settings", render_settings_struct(settings_fields))
    for struct in structs:
        write_generated_swift_file(struct.name, render_struct(struct, patch=False))
        if struct.has_patch:
            write_generated_swift_file(
                f"{struct.name}Patch",
                render_struct(struct, patch=True),
            )
    for enum_name in SETTINGS_ENUM_MODELS:
        cases = parse_settings_enum_cases(source, enum_name)
        write_generated_swift_file(enum_name, render_enum(enum_name, cases))


def generate_native_provider_swift() -> None:
    print("Generating native Swift provider models...", flush=True)
    engine_source = ENGINE_INPUT_PATH.read_text()
    cases = parse_provider_type_cases(engine_source)

    core_source = CORE_INPUT_PATH.read_text()
    capability_cases = parse_provider_capability_cases(core_source)

    write_generated_swift_file(
        "ProviderCapability", render_enum("ProviderCapability", capability_cases)
    )
    write_generated_swift_file("ProviderType", render_provider_type_enum(cases))
    write_generated_swift_file(
        "ProviderConfigField", render_provider_config_field_struct()
    )

    parsed = parse_provider_config_structs()
    missing = sorted(set(PROVIDER_CONFIG_MODELS) - set(parsed.keys()))
    if missing:
        raise ValueError(
            f"Missing expected Rust provider config structs: {', '.join(missing)}"
        )

    for name in PROVIDER_CONFIG_MODELS:
        write_generated_swift_file(name, render_struct(parsed[name], patch=False))
        write_generated_swift_file(
            f"{name}+Fields",
            render_provider_config_fields_extension(parsed[name]),
        )

    write_generated_swift_file(
        "ProviderType+Fields",
        render_provider_type_fields(cases, parsed),
    )


def write_generated_swift_file(name: str, body: list[str]) -> None:
    lines = [
        "// This file is automatically generated. Do not edit by hand.",
        f"// Generated by `python3 {SCRIPT_DISPLAY_NAME}`.",
        "",
        "import Foundation",
        "",
        *body,
        "",
    ]
    (SETTINGS_OUTPUT_DIR / f"{name}.swift").write_text("\n".join(lines))


def parse_settings_swift_structs(source: str) -> dict[str, SettingsSwiftStruct]:
    structs: dict[str, SettingsSwiftStruct] = {}
    pattern = re.compile(
        r"#\[derive\(([^)]*)\)\](.*?)pub struct (\w+) \{([^{}]*)\}", re.S
    )

    for match in pattern.finditer(source):
        derives = [part.strip() for part in match.group(1).split(",")]
        name = match.group(3)
        if name not in SETTINGS_SECTION_MODELS + SETTINGS_VALUE_MODELS:
            continue

        structs[name] = SettingsSwiftStruct(
            name=name,
            has_patch="Patch" in derives,
            fields=parse_settings_swift_fields(match.group(4)),
        )

    return structs


def parse_settings_fields(source: str) -> list[SettingsSwiftRootField]:
    match = re.search(r"pub struct Settings \{(.*?)\n\}", source, re.S)
    if not match:
        raise ValueError("Missing Rust Settings struct")

    fields: list[SettingsSwiftRootField] = []
    attrs: list[str] = []
    for raw_line in match.group(1).splitlines():
        line = raw_line.strip()
        if line.startswith("#["):
            attrs.append(line)
            continue

        field_match = re.match(r"pub (?:r#)?(\w+): (.+),$", line)
        if not field_match:
            attrs.clear()
            continue

        if any("flatten" in attr for attr in attrs):
            attrs.clear()
            continue

        rust_name = field_match.group(1)
        rust_type = field_match.group(2).strip()
        swift_type = settings_root_swift_type_name(rust_type)
        if swift_type is not None:
            fields.append(
                SettingsSwiftRootField(
                    wire_name=serde_rename(attrs) or camel_case(rust_name),
                    swift_name=camel_case(rust_name),
                    swift_type=swift_type,
                )
            )
        attrs.clear()

    return fields


def parse_settings_swift_fields(body: str) -> list[SettingsSwiftField]:
    fields: list[SettingsSwiftField] = []
    attrs: list[str] = []

    for raw_line in body.splitlines():
        line = raw_line.strip()
        if not line:
            continue

        if line.startswith("#["):
            attrs.append(line)
            continue

        field_match = re.match(r"pub (?:r#)?(\w+): (.+),$", line)
        if not field_match:
            attrs.clear()
            continue

        rust_name = field_match.group(1)
        rust_type = field_match.group(2).strip()
        fields.append(
            SettingsSwiftField(
                rust_name=rust_name,
                wire_name=serde_rename(attrs) or camel_case(rust_name),
                swift_name=camel_case(rust_name),
                swift_type=swift_type_name(rust_type),
            )
        )
        attrs.clear()

    return fields


def parse_settings_enum_cases(source: str, enum_name: str) -> list[SwiftEnumCase]:
    match = re.search(rf"pub enum {enum_name} \{{(.*?)\n\}}", source, re.S)
    if not match:
        raise ValueError(f"Missing Rust settings enum: {enum_name}")

    cases: list[SwiftEnumCase] = []
    for raw_line in match.group(1).splitlines():
        line = raw_line.strip().rstrip(",")
        if not line or line.startswith("#[") or line.startswith("//"):
            continue
        if not re.fullmatch(r"\w+", line):
            continue
        # #[serde(rename_all = "camelCase")] on the enum -> PascalCase -> camelCase
        swift_name = lower_camel_case(line)
        cases.append(
            SwiftEnumCase(
                rust_name=line,
                wire_name=swift_name,
                swift_name=swift_name,
            )
        )
    return cases


def parse_provider_capability_cases(source: str) -> list[SwiftEnumCase]:
    match = re.search(r"pub enum ProviderCapability \{(.*?)\n\}", source, re.S)
    if not match:
        raise ValueError("Missing Rust ProviderCapability enum")

    cases: list[SwiftEnumCase] = []
    for raw_line in match.group(1).splitlines():
        line = raw_line.strip().rstrip(",")
        if not line or line.startswith("#[") or line.startswith("//"):
            continue
        if not re.fullmatch(r"\w+", line):
            continue
        # #[serde(rename_all = "camelCase")] → Translation→translation, Dictionary→dictionary
        swift_name = lower_camel_case(line)
        cases.append(
            SwiftEnumCase(
                rust_name=line,
                wire_name=swift_name,
                swift_name=swift_name,
            )
        )
    return cases


def parse_provider_type_cases(source: str) -> list[SwiftEnumCase]:
    match = re.search(r"pub enum ProviderType \{(.*?)\n\}", source, re.S)
    if not match:
        raise ValueError("Missing Rust ProviderType enum")

    cases: list[SwiftEnumCase] = []
    attrs: list[str] = []
    for raw_line in match.group(1).splitlines():
        line = raw_line.strip().rstrip(",")
        if not line:
            continue

        if line.startswith("#["):
            attrs.append(line)
            continue

        if not re.fullmatch(r"\w+", line):
            attrs.clear()
            continue

        cases.append(
            SwiftEnumCase(
                rust_name=line,
                wire_name=serde_rename(attrs) or lower_camel_case(line),
                swift_name=lower_camel_case(line),
            )
        )
        attrs.clear()

    return cases


def parse_provider_config_structs() -> dict[str, SettingsSwiftStruct]:
    structs: dict[str, SettingsSwiftStruct] = {}
    pattern = re.compile(r"#\[derive\(([^)]*)\)\]\s*pub struct (\w+) \{(.*?)\n\}", re.S)

    for path in PROVIDER_INPUT_DIR.glob("*.rs"):
        source = path.read_text()
        for match in pattern.finditer(source):
            name = match.group(2)
            if name not in PROVIDER_CONFIG_MODELS:
                continue

            structs[name] = SettingsSwiftStruct(
                name=name,
                has_patch=False,
                fields=parse_settings_swift_fields(match.group(3)),
            )

    return structs


def serde_rename(attrs: list[str]) -> str | None:
    for attr in attrs:
        match = re.search(r'rename = "([^"]+)"', attr)
        if match:
            return match.group(1)
    return None


def camel_case(snake_case: str) -> str:
    head, *tail = snake_case.split("_")
    return head + "".join(part[:1].upper() + part[1:] for part in tail)


def lower_camel_case(name: str) -> str:
    return name[:1].lower() + name[1:]


def swift_type_name(rust_type: str) -> str:
    if rust_type == "String":
        return "String"
    if rust_type == "bool":
        return "Bool"
    if rust_type == "u64":
        return "UInt64"
    if rust_type in SETTINGS_ENUM_MODELS + SETTINGS_VALUE_MODELS:
        return rust_type
    optional_inner_type = option_inner_type(rust_type)
    if optional_inner_type is not None:
        return f"{swift_type_name(optional_inner_type)}?"
    list_item_type = vec_item_type(rust_type)
    if list_item_type is not None:
        return f"[{swift_type_name(list_item_type)}]"
    map_value_type = string_map_value_type(rust_type)
    if map_value_type is not None:
        return f"[String: {swift_type_name(map_value_type)}]"
    raise ValueError(f"Unsupported Rust field type: {rust_type}")


def settings_root_swift_type_name(rust_type: str) -> str | None:
    if rust_type in SETTINGS_SECTION_MODELS:
        return rust_type
    list_item_type = vec_item_type(rust_type)
    if list_item_type in SETTINGS_SECTION_MODELS:
        return f"[{list_item_type}]"
    map_value_type = string_map_value_type(rust_type)
    if map_value_type in SETTINGS_SECTION_MODELS:
        return f"[String: {map_value_type}]"
    if rust_type in {"String", "bool"}:
        return swift_type_name(rust_type)
    if rust_type == "u64":
        return swift_type_name(rust_type)
    return None


def vec_item_type(rust_type: str) -> str | None:
    match = re.fullmatch(r"Vec<\s*([^>]+)\s*>", rust_type)
    if not match:
        return None
    return match.group(1).strip()


def option_inner_type(rust_type: str) -> str | None:
    match = re.fullmatch(r"Option<\s*([^>]+)\s*>", rust_type)
    if not match:
        return None
    return match.group(1).strip()


def string_map_value_type(rust_type: str) -> str | None:
    match = re.fullmatch(r"(?:BTreeMap|HashMap)<\s*String\s*,\s*([^>]+)\s*>", rust_type)
    if not match:
        return None
    return match.group(1).strip()


def render_settings_struct(settings_fields: list[SettingsSwiftRootField]) -> list[str]:
    lines = ["struct Settings: Codable {"]
    for field in settings_fields:
        lines.append(f"  var {field.swift_name}: {field.swift_type}")

    renamed = [
        field for field in settings_fields if field.swift_name != field.wire_name
    ]
    if renamed:
        lines.append("")
        lines.append("  enum CodingKeys: String, CodingKey {")
        for field in settings_fields:
            if field.swift_name == field.wire_name:
                lines.append(f"    case {field.swift_name}")
            else:
                lines.append(f'    case {field.swift_name} = "{field.wire_name}"')
        lines.append("  }")

    lines.append("}")
    return lines


def render_enum(name: str, cases: list[SwiftEnumCase]) -> list[str]:
    lines = [f"enum {name}: String, Codable, CaseIterable, Identifiable {{"]
    for case in cases:
        if case.swift_name == case.wire_name:
            lines.append(f"  case {case.swift_name}")
        else:
            lines.append(f'  case {case.swift_name} = "{case.wire_name}"')
    lines.append("")
    lines.append("  var id: String { rawValue }")
    lines.append("}")
    return lines


def render_provider_type_enum(cases: list[SwiftEnumCase]) -> list[str]:
    lines = ["enum ProviderType: String, Codable, CaseIterable, Identifiable {"]
    for case in cases:
        if case.swift_name == case.wire_name:
            lines.append(f"  case {case.swift_name}")
        else:
            lines.append(f'  case {case.swift_name} = "{case.wire_name}"')
    lines.append("")
    lines.append("  var id: String { rawValue }")
    lines.append("}")
    return lines


def render_provider_config_field_struct() -> list[str]:
    return [
        "struct ProviderConfigField: Identifiable {",
        "  var id: String { key }",
        "  let key: String",
        "  let label: String",
        "  let placeholder: String",
        "  let isSecret: Bool",
        "  let isOptional: Bool",
        "}",
    ]


def field_label(rust_name: str) -> str:
    """Convert snake_case rust field name to a human-readable label."""
    parts = rust_name.split("_")
    return " ".join(LABEL_EXPAND.get(p, p.capitalize()) for p in parts)


def field_is_secret(rust_name: str) -> bool:
    """Return True if the field should be treated as a secret (password-style input)."""
    last_word = rust_name.rsplit("_", 1)[-1]
    return last_word in SECRET_LAST_WORDS


def render_provider_config_fields_extension(struct: SettingsSwiftStruct) -> list[str]:
    """Render the `+Fields.swift` extension for one provider config struct."""
    struct_name = struct.name
    placeholders = FIELD_PLACEHOLDERS.get(struct_name, {})

    lines = [f"extension {struct_name} {{"]
    lines.append("  static let configFields: [ProviderConfigField] = [")

    for field in struct.fields:
        rust_name = field.rust_name
        wire_name = field.wire_name
        label = field_label(rust_name)
        is_secret_val = "true" if field_is_secret(rust_name) else "false"
        is_optional_val = "true" if field.swift_type.endswith("?") else "false"
        placeholder = placeholders.get(rust_name, "")
        lines.append(
            f"    ProviderConfigField("
            f'key: "{wire_name}", '
            f'label: "{label}", '
            f'placeholder: "{placeholder}", '
            f"isSecret: {is_secret_val}, "
            f"isOptional: {is_optional_val}),"
        )

    lines.append("  ]")
    lines.append("}")
    return lines


def render_provider_type_fields(
    cases: list[SwiftEnumCase],
    config_structs: dict[str, SettingsSwiftStruct],
) -> list[str]:
    """Render ProviderType+Fields.swift mapping each case to its configFields."""
    lines = ["extension ProviderType {"]
    lines.append("  var configFields: [ProviderConfigField] {")
    lines.append("    switch self {")
    for case in cases:
        struct_name = next(
            (
                name
                for name in PROVIDER_CONFIG_MODELS
                if name.lower().startswith(case.rust_name.lower())
            ),
            None,
        )
        if struct_name:
            lines.append(
                f"    case .{case.swift_name}: return {struct_name}.configFields"
            )
    lines.append("    }")
    lines.append("  }")
    lines.append("}")
    return lines


def render_struct(struct: SettingsSwiftStruct, *, patch: bool) -> list[str]:
    name = f"{struct.name}Patch" if patch else struct.name
    protocols = "Codable"
    if not patch and struct.name == "TranslationTarget":
        protocols = "Codable, Identifiable"
    lines = [f"struct {name}: {protocols} {{"]

    for field in struct.fields:
        if patch:
            lines.append(f"  var {field.swift_name}: {field.swift_type}? = nil")
        else:
            lines.append(f"  var {field.swift_name}: {field.swift_type}")

    if not patch and struct.name == "TranslationTarget":
        lines.append("")
        lines.append('  var id: String { "\\(source)->\\(target)" }')

    renamed = [field for field in struct.fields if field.swift_name != field.wire_name]
    if renamed:
        lines.append("")
        lines.append("  enum CodingKeys: String, CodingKey {")
        for field in struct.fields:
            if field.swift_name == field.wire_name:
                lines.append(f"    case {field.swift_name}")
            else:
                lines.append(f'    case {field.swift_name} = "{field.wire_name}"')
        lines.append("  }")

    lines.append("}")
    return lines


if __name__ == "__main__":
    raise SystemExit(main())
