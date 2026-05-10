library beyondtranslate_runtime;

import "dart:async";
import "dart:convert";
import "dart:ffi";
import "dart:io" show Platform, File, Directory;
import "dart:isolate";
import "dart:typed_data";
import "package:ffi/ffi.dart";
import "beyondtranslate_core.dart";
import "beyondtranslate_core.dart" as beyondtranslate_core;

// Bridge functions that adapt beyondtranslate_core converters to accept
// this file's RustBuffer type (both are structurally identical Uint8List
// wrappers, but Dart's nominal typing requires explicit adapters when
// they are passed to uniffiRustCallAsync).
LookUpResponse _liftLookUpResponse(RustBuffer buf) =>
    beyondtranslate_core.FfiConverterLookUpResponse.read(buf.asUint8List())
        .value;

TranslateResponse _liftTranslateResponse(RustBuffer buf) =>
    beyondtranslate_core.FfiConverterTranslateResponse.read(buf.asUint8List())
        .value;

class AdvancedSettings {
  AdvancedSettings();
}

class FfiConverterAdvancedSettings {
  static AdvancedSettings lift(RustBuffer buf) {
    return FfiConverterAdvancedSettings.read(buf.asUint8List()).value;
  }

  static LiftRetVal<AdvancedSettings> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(AdvancedSettings(), new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(AdvancedSettings value) {
    final total_length = 0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(AdvancedSettings value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(AdvancedSettings value) {
    return 0;
  }
}

class AdvancedSettingsPatch {
  AdvancedSettingsPatch();
}

class FfiConverterAdvancedSettingsPatch {
  static AdvancedSettingsPatch lift(RustBuffer buf) {
    return FfiConverterAdvancedSettingsPatch.read(buf.asUint8List()).value;
  }

  static LiftRetVal<AdvancedSettingsPatch> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return LiftRetVal(AdvancedSettingsPatch(), new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(AdvancedSettingsPatch value) {
    final total_length = 0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(AdvancedSettingsPatch value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(AdvancedSettingsPatch value) {
    return 0;
  }
}

class AppearanceSettings {
  final String language;
  final String themeMode;
  AppearanceSettings({
    required this.language,
    required this.themeMode,
  });
}

class FfiConverterAppearanceSettings {
  static AppearanceSettings lift(RustBuffer buf) {
    return FfiConverterAppearanceSettings.read(buf.asUint8List()).value;
  }

  static LiftRetVal<AppearanceSettings> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final language_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final language = language_lifted.value;
    new_offset += language_lifted.bytesRead;
    final themeMode_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final themeMode = themeMode_lifted.value;
    new_offset += themeMode_lifted.bytesRead;
    return LiftRetVal(
        AppearanceSettings(
          language: language,
          themeMode: themeMode,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(AppearanceSettings value) {
    final total_length = FfiConverterString.allocationSize(value.language) +
        FfiConverterString.allocationSize(value.themeMode) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(AppearanceSettings value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterString.write(
        value.language, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(
        value.themeMode, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(AppearanceSettings value) {
    return FfiConverterString.allocationSize(value.language) +
        FfiConverterString.allocationSize(value.themeMode) +
        0;
  }
}

class AppearanceSettingsPatch {
  final String? language;
  final String? themeMode;
  AppearanceSettingsPatch({
    this.language,
    this.themeMode,
  });
}

class FfiConverterAppearanceSettingsPatch {
  static AppearanceSettingsPatch lift(RustBuffer buf) {
    return FfiConverterAppearanceSettingsPatch.read(buf.asUint8List()).value;
  }

  static LiftRetVal<AppearanceSettingsPatch> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final language_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final language = language_lifted.value;
    new_offset += language_lifted.bytesRead;
    final themeMode_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final themeMode = themeMode_lifted.value;
    new_offset += themeMode_lifted.bytesRead;
    return LiftRetVal(
        AppearanceSettingsPatch(
          language: language,
          themeMode: themeMode,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(AppearanceSettingsPatch value) {
    final total_length =
        FfiConverterOptionalString.allocationSize(value.language) +
            FfiConverterOptionalString.allocationSize(value.themeMode) +
            0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(AppearanceSettingsPatch value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterOptionalString.write(
        value.language, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.themeMode, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(AppearanceSettingsPatch value) {
    return FfiConverterOptionalString.allocationSize(value.language) +
        FfiConverterOptionalString.allocationSize(value.themeMode) +
        0;
  }
}

class GeneralSettings {
  final bool launchAtLogin;
  final bool showMenuBar;
  final String defaultOcrService;
  final bool autoCopyDetectedText;
  final String defaultDirectoryService;
  final String defaultTranslationService;
  final TranslationMode translationMode;
  final List<TranslationTarget> translationTargets;
  final InputSubmitMode inputSubmitMode;
  final bool doubleClickCopyResult;
  GeneralSettings({
    required this.launchAtLogin,
    required this.showMenuBar,
    required this.defaultOcrService,
    required this.autoCopyDetectedText,
    required this.defaultDirectoryService,
    required this.defaultTranslationService,
    required this.translationMode,
    required this.translationTargets,
    required this.inputSubmitMode,
    required this.doubleClickCopyResult,
  });
}

class FfiConverterGeneralSettings {
  static GeneralSettings lift(RustBuffer buf) {
    return FfiConverterGeneralSettings.read(buf.asUint8List()).value;
  }

  static LiftRetVal<GeneralSettings> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final launchAtLogin_lifted =
        FfiConverterBool.read(Uint8List.view(buf.buffer, new_offset));
    final launchAtLogin = launchAtLogin_lifted.value;
    new_offset += launchAtLogin_lifted.bytesRead;
    final showMenuBar_lifted =
        FfiConverterBool.read(Uint8List.view(buf.buffer, new_offset));
    final showMenuBar = showMenuBar_lifted.value;
    new_offset += showMenuBar_lifted.bytesRead;
    final defaultOcrService_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final defaultOcrService = defaultOcrService_lifted.value;
    new_offset += defaultOcrService_lifted.bytesRead;
    final autoCopyDetectedText_lifted =
        FfiConverterBool.read(Uint8List.view(buf.buffer, new_offset));
    final autoCopyDetectedText = autoCopyDetectedText_lifted.value;
    new_offset += autoCopyDetectedText_lifted.bytesRead;
    final defaultDirectoryService_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final defaultDirectoryService = defaultDirectoryService_lifted.value;
    new_offset += defaultDirectoryService_lifted.bytesRead;
    final defaultTranslationService_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final defaultTranslationService = defaultTranslationService_lifted.value;
    new_offset += defaultTranslationService_lifted.bytesRead;
    final translationMode_lifted = FfiConverterTranslationMode.read(
        Uint8List.view(buf.buffer, new_offset));
    final translationMode = translationMode_lifted.value;
    new_offset += translationMode_lifted.bytesRead;
    final translationTargets_lifted =
        FfiConverterSequenceTranslationTarget.read(
            Uint8List.view(buf.buffer, new_offset));
    final translationTargets = translationTargets_lifted.value;
    new_offset += translationTargets_lifted.bytesRead;
    final inputSubmitMode_lifted = FfiConverterInputSubmitMode.read(
        Uint8List.view(buf.buffer, new_offset));
    final inputSubmitMode = inputSubmitMode_lifted.value;
    new_offset += inputSubmitMode_lifted.bytesRead;
    final doubleClickCopyResult_lifted =
        FfiConverterBool.read(Uint8List.view(buf.buffer, new_offset));
    final doubleClickCopyResult = doubleClickCopyResult_lifted.value;
    new_offset += doubleClickCopyResult_lifted.bytesRead;
    return LiftRetVal(
        GeneralSettings(
          launchAtLogin: launchAtLogin,
          showMenuBar: showMenuBar,
          defaultOcrService: defaultOcrService,
          autoCopyDetectedText: autoCopyDetectedText,
          defaultDirectoryService: defaultDirectoryService,
          defaultTranslationService: defaultTranslationService,
          translationMode: translationMode,
          translationTargets: translationTargets,
          inputSubmitMode: inputSubmitMode,
          doubleClickCopyResult: doubleClickCopyResult,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(GeneralSettings value) {
    final total_length = FfiConverterBool.allocationSize(value.launchAtLogin) +
        FfiConverterBool.allocationSize(value.showMenuBar) +
        FfiConverterString.allocationSize(value.defaultOcrService) +
        FfiConverterBool.allocationSize(value.autoCopyDetectedText) +
        FfiConverterString.allocationSize(value.defaultDirectoryService) +
        FfiConverterString.allocationSize(value.defaultTranslationService) +
        FfiConverterTranslationMode.allocationSize(value.translationMode) +
        FfiConverterSequenceTranslationTarget.allocationSize(
            value.translationTargets) +
        FfiConverterInputSubmitMode.allocationSize(value.inputSubmitMode) +
        FfiConverterBool.allocationSize(value.doubleClickCopyResult) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(GeneralSettings value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterBool.write(
        value.launchAtLogin, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterBool.write(
        value.showMenuBar, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(
        value.defaultOcrService, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterBool.write(
        value.autoCopyDetectedText, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(
        value.defaultDirectoryService, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(value.defaultTranslationService,
        Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterTranslationMode.write(
        value.translationMode, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterSequenceTranslationTarget.write(
        value.translationTargets, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterInputSubmitMode.write(
        value.inputSubmitMode, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterBool.write(
        value.doubleClickCopyResult, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(GeneralSettings value) {
    return FfiConverterBool.allocationSize(value.launchAtLogin) +
        FfiConverterBool.allocationSize(value.showMenuBar) +
        FfiConverterString.allocationSize(value.defaultOcrService) +
        FfiConverterBool.allocationSize(value.autoCopyDetectedText) +
        FfiConverterString.allocationSize(value.defaultDirectoryService) +
        FfiConverterString.allocationSize(value.defaultTranslationService) +
        FfiConverterTranslationMode.allocationSize(value.translationMode) +
        FfiConverterSequenceTranslationTarget.allocationSize(
            value.translationTargets) +
        FfiConverterInputSubmitMode.allocationSize(value.inputSubmitMode) +
        FfiConverterBool.allocationSize(value.doubleClickCopyResult) +
        0;
  }
}

class GeneralSettingsPatch {
  final bool? launchAtLogin;
  final bool? showMenuBar;
  final String? defaultOcrService;
  final bool? autoCopyDetectedText;
  final String? defaultDirectoryService;
  final String? defaultTranslationService;
  final TranslationMode? translationMode;
  final List<TranslationTarget>? translationTargets;
  final InputSubmitMode? inputSubmitMode;
  final bool? doubleClickCopyResult;
  GeneralSettingsPatch({
    this.launchAtLogin,
    this.showMenuBar,
    this.defaultOcrService,
    this.autoCopyDetectedText,
    this.defaultDirectoryService,
    this.defaultTranslationService,
    this.translationMode,
    this.translationTargets,
    this.inputSubmitMode,
    this.doubleClickCopyResult,
  });
}

class FfiConverterGeneralSettingsPatch {
  static GeneralSettingsPatch lift(RustBuffer buf) {
    return FfiConverterGeneralSettingsPatch.read(buf.asUint8List()).value;
  }

  static LiftRetVal<GeneralSettingsPatch> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final launchAtLogin_lifted =
        FfiConverterOptionalBool.read(Uint8List.view(buf.buffer, new_offset));
    final launchAtLogin = launchAtLogin_lifted.value;
    new_offset += launchAtLogin_lifted.bytesRead;
    final showMenuBar_lifted =
        FfiConverterOptionalBool.read(Uint8List.view(buf.buffer, new_offset));
    final showMenuBar = showMenuBar_lifted.value;
    new_offset += showMenuBar_lifted.bytesRead;
    final defaultOcrService_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final defaultOcrService = defaultOcrService_lifted.value;
    new_offset += defaultOcrService_lifted.bytesRead;
    final autoCopyDetectedText_lifted =
        FfiConverterOptionalBool.read(Uint8List.view(buf.buffer, new_offset));
    final autoCopyDetectedText = autoCopyDetectedText_lifted.value;
    new_offset += autoCopyDetectedText_lifted.bytesRead;
    final defaultDirectoryService_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final defaultDirectoryService = defaultDirectoryService_lifted.value;
    new_offset += defaultDirectoryService_lifted.bytesRead;
    final defaultTranslationService_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final defaultTranslationService = defaultTranslationService_lifted.value;
    new_offset += defaultTranslationService_lifted.bytesRead;
    final translationMode_lifted = FfiConverterOptionalTranslationMode.read(
        Uint8List.view(buf.buffer, new_offset));
    final translationMode = translationMode_lifted.value;
    new_offset += translationMode_lifted.bytesRead;
    final translationTargets_lifted =
        FfiConverterOptionalSequenceTranslationTarget.read(
            Uint8List.view(buf.buffer, new_offset));
    final translationTargets = translationTargets_lifted.value;
    new_offset += translationTargets_lifted.bytesRead;
    final inputSubmitMode_lifted = FfiConverterOptionalInputSubmitMode.read(
        Uint8List.view(buf.buffer, new_offset));
    final inputSubmitMode = inputSubmitMode_lifted.value;
    new_offset += inputSubmitMode_lifted.bytesRead;
    final doubleClickCopyResult_lifted =
        FfiConverterOptionalBool.read(Uint8List.view(buf.buffer, new_offset));
    final doubleClickCopyResult = doubleClickCopyResult_lifted.value;
    new_offset += doubleClickCopyResult_lifted.bytesRead;
    return LiftRetVal(
        GeneralSettingsPatch(
          launchAtLogin: launchAtLogin,
          showMenuBar: showMenuBar,
          defaultOcrService: defaultOcrService,
          autoCopyDetectedText: autoCopyDetectedText,
          defaultDirectoryService: defaultDirectoryService,
          defaultTranslationService: defaultTranslationService,
          translationMode: translationMode,
          translationTargets: translationTargets,
          inputSubmitMode: inputSubmitMode,
          doubleClickCopyResult: doubleClickCopyResult,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(GeneralSettingsPatch value) {
    final total_length = FfiConverterOptionalBool.allocationSize(
            value.launchAtLogin) +
        FfiConverterOptionalBool.allocationSize(value.showMenuBar) +
        FfiConverterOptionalString.allocationSize(value.defaultOcrService) +
        FfiConverterOptionalBool.allocationSize(value.autoCopyDetectedText) +
        FfiConverterOptionalString.allocationSize(
            value.defaultDirectoryService) +
        FfiConverterOptionalString.allocationSize(
            value.defaultTranslationService) +
        FfiConverterOptionalTranslationMode.allocationSize(
            value.translationMode) +
        FfiConverterOptionalSequenceTranslationTarget.allocationSize(
            value.translationTargets) +
        FfiConverterOptionalInputSubmitMode.allocationSize(
            value.inputSubmitMode) +
        FfiConverterOptionalBool.allocationSize(value.doubleClickCopyResult) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(GeneralSettingsPatch value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterOptionalBool.write(
        value.launchAtLogin, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalBool.write(
        value.showMenuBar, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.defaultOcrService, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalBool.write(
        value.autoCopyDetectedText, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.defaultDirectoryService, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.defaultTranslationService,
        Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalTranslationMode.write(
        value.translationMode, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalSequenceTranslationTarget.write(
        value.translationTargets, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalInputSubmitMode.write(
        value.inputSubmitMode, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalBool.write(
        value.doubleClickCopyResult, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(GeneralSettingsPatch value) {
    return FfiConverterOptionalBool.allocationSize(value.launchAtLogin) +
        FfiConverterOptionalBool.allocationSize(value.showMenuBar) +
        FfiConverterOptionalString.allocationSize(value.defaultOcrService) +
        FfiConverterOptionalBool.allocationSize(value.autoCopyDetectedText) +
        FfiConverterOptionalString.allocationSize(
            value.defaultDirectoryService) +
        FfiConverterOptionalString.allocationSize(
            value.defaultTranslationService) +
        FfiConverterOptionalTranslationMode.allocationSize(
            value.translationMode) +
        FfiConverterOptionalSequenceTranslationTarget.allocationSize(
            value.translationTargets) +
        FfiConverterOptionalInputSubmitMode.allocationSize(
            value.inputSubmitMode) +
        FfiConverterOptionalBool.allocationSize(value.doubleClickCopyResult) +
        0;
  }
}

class ProviderConfigEntry {
  final String id;
  final String type;
  final Map<String, String> fields;
  final List<String> capabilities;
  ProviderConfigEntry({
    required this.id,
    required this.type,
    required this.fields,
    required this.capabilities,
  });
}

class FfiConverterProviderConfigEntry {
  static ProviderConfigEntry lift(RustBuffer buf) {
    return FfiConverterProviderConfigEntry.read(buf.asUint8List()).value;
  }

  static LiftRetVal<ProviderConfigEntry> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final id_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final id = id_lifted.value;
    new_offset += id_lifted.bytesRead;
    final type_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final type = type_lifted.value;
    new_offset += type_lifted.bytesRead;
    final fields_lifted = FfiConverterMapStringToString.read(
        Uint8List.view(buf.buffer, new_offset));
    final fields = fields_lifted.value;
    new_offset += fields_lifted.bytesRead;
    final capabilities_lifted =
        FfiConverterSequenceString.read(Uint8List.view(buf.buffer, new_offset));
    final capabilities = capabilities_lifted.value;
    new_offset += capabilities_lifted.bytesRead;
    return LiftRetVal(
        ProviderConfigEntry(
          id: id,
          type: type,
          fields: fields,
          capabilities: capabilities,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(ProviderConfigEntry value) {
    final total_length = FfiConverterString.allocationSize(value.id) +
        FfiConverterString.allocationSize(value.type) +
        FfiConverterMapStringToString.allocationSize(value.fields) +
        FfiConverterSequenceString.allocationSize(value.capabilities) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(ProviderConfigEntry value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterString.write(
        value.id, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(
        value.type, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterMapStringToString.write(
        value.fields, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterSequenceString.write(
        value.capabilities, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(ProviderConfigEntry value) {
    return FfiConverterString.allocationSize(value.id) +
        FfiConverterString.allocationSize(value.type) +
        FfiConverterMapStringToString.allocationSize(value.fields) +
        FfiConverterSequenceString.allocationSize(value.capabilities) +
        0;
  }
}

class ShortcutSettings {
  final String toggleApp;
  final String hideApp;
  final String extractFromScreenSelection;
  final String extractFromScreenCapture;
  final String extractFromClipboard;
  ShortcutSettings({
    required this.toggleApp,
    required this.hideApp,
    required this.extractFromScreenSelection,
    required this.extractFromScreenCapture,
    required this.extractFromClipboard,
  });
}

class FfiConverterShortcutSettings {
  static ShortcutSettings lift(RustBuffer buf) {
    return FfiConverterShortcutSettings.read(buf.asUint8List()).value;
  }

  static LiftRetVal<ShortcutSettings> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final toggleApp_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final toggleApp = toggleApp_lifted.value;
    new_offset += toggleApp_lifted.bytesRead;
    final hideApp_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final hideApp = hideApp_lifted.value;
    new_offset += hideApp_lifted.bytesRead;
    final extractFromScreenSelection_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final extractFromScreenSelection = extractFromScreenSelection_lifted.value;
    new_offset += extractFromScreenSelection_lifted.bytesRead;
    final extractFromScreenCapture_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final extractFromScreenCapture = extractFromScreenCapture_lifted.value;
    new_offset += extractFromScreenCapture_lifted.bytesRead;
    final extractFromClipboard_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final extractFromClipboard = extractFromClipboard_lifted.value;
    new_offset += extractFromClipboard_lifted.bytesRead;
    return LiftRetVal(
        ShortcutSettings(
          toggleApp: toggleApp,
          hideApp: hideApp,
          extractFromScreenSelection: extractFromScreenSelection,
          extractFromScreenCapture: extractFromScreenCapture,
          extractFromClipboard: extractFromClipboard,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(ShortcutSettings value) {
    final total_length = FfiConverterString.allocationSize(value.toggleApp) +
        FfiConverterString.allocationSize(value.hideApp) +
        FfiConverterString.allocationSize(value.extractFromScreenSelection) +
        FfiConverterString.allocationSize(value.extractFromScreenCapture) +
        FfiConverterString.allocationSize(value.extractFromClipboard) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(ShortcutSettings value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterString.write(
        value.toggleApp, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(
        value.hideApp, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(value.extractFromScreenSelection,
        Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(
        value.extractFromScreenCapture, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(
        value.extractFromClipboard, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(ShortcutSettings value) {
    return FfiConverterString.allocationSize(value.toggleApp) +
        FfiConverterString.allocationSize(value.hideApp) +
        FfiConverterString.allocationSize(value.extractFromScreenSelection) +
        FfiConverterString.allocationSize(value.extractFromScreenCapture) +
        FfiConverterString.allocationSize(value.extractFromClipboard) +
        0;
  }
}

class ShortcutSettingsPatch {
  final String? toggleApp;
  final String? hideApp;
  final String? extractFromScreenSelection;
  final String? extractFromScreenCapture;
  final String? extractFromClipboard;
  ShortcutSettingsPatch({
    this.toggleApp,
    this.hideApp,
    this.extractFromScreenSelection,
    this.extractFromScreenCapture,
    this.extractFromClipboard,
  });
}

class FfiConverterShortcutSettingsPatch {
  static ShortcutSettingsPatch lift(RustBuffer buf) {
    return FfiConverterShortcutSettingsPatch.read(buf.asUint8List()).value;
  }

  static LiftRetVal<ShortcutSettingsPatch> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final toggleApp_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final toggleApp = toggleApp_lifted.value;
    new_offset += toggleApp_lifted.bytesRead;
    final hideApp_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final hideApp = hideApp_lifted.value;
    new_offset += hideApp_lifted.bytesRead;
    final extractFromScreenSelection_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final extractFromScreenSelection = extractFromScreenSelection_lifted.value;
    new_offset += extractFromScreenSelection_lifted.bytesRead;
    final extractFromScreenCapture_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final extractFromScreenCapture = extractFromScreenCapture_lifted.value;
    new_offset += extractFromScreenCapture_lifted.bytesRead;
    final extractFromClipboard_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final extractFromClipboard = extractFromClipboard_lifted.value;
    new_offset += extractFromClipboard_lifted.bytesRead;
    return LiftRetVal(
        ShortcutSettingsPatch(
          toggleApp: toggleApp,
          hideApp: hideApp,
          extractFromScreenSelection: extractFromScreenSelection,
          extractFromScreenCapture: extractFromScreenCapture,
          extractFromClipboard: extractFromClipboard,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(ShortcutSettingsPatch value) {
    final total_length = FfiConverterOptionalString.allocationSize(
            value.toggleApp) +
        FfiConverterOptionalString.allocationSize(value.hideApp) +
        FfiConverterOptionalString.allocationSize(
            value.extractFromScreenSelection) +
        FfiConverterOptionalString.allocationSize(
            value.extractFromScreenCapture) +
        FfiConverterOptionalString.allocationSize(value.extractFromClipboard) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(ShortcutSettingsPatch value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterOptionalString.write(
        value.toggleApp, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.hideApp, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.extractFromScreenSelection,
        Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.extractFromScreenCapture, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.extractFromClipboard, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(ShortcutSettingsPatch value) {
    return FfiConverterOptionalString.allocationSize(value.toggleApp) +
        FfiConverterOptionalString.allocationSize(value.hideApp) +
        FfiConverterOptionalString.allocationSize(
            value.extractFromScreenSelection) +
        FfiConverterOptionalString.allocationSize(
            value.extractFromScreenCapture) +
        FfiConverterOptionalString.allocationSize(value.extractFromClipboard) +
        0;
  }
}

class TranslationTarget {
  final String source;
  final String target;
  TranslationTarget({
    required this.source,
    required this.target,
  });
}

class FfiConverterTranslationTarget {
  static TranslationTarget lift(RustBuffer buf) {
    return FfiConverterTranslationTarget.read(buf.asUint8List()).value;
  }

  static LiftRetVal<TranslationTarget> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final source_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final source = source_lifted.value;
    new_offset += source_lifted.bytesRead;
    final target_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final target = target_lifted.value;
    new_offset += target_lifted.bytesRead;
    return LiftRetVal(
        TranslationTarget(
          source: source,
          target: target,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(TranslationTarget value) {
    final total_length = FfiConverterString.allocationSize(value.source) +
        FfiConverterString.allocationSize(value.target) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(TranslationTarget value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterString.write(
        value.source, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(
        value.target, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(TranslationTarget value) {
    return FfiConverterString.allocationSize(value.source) +
        FfiConverterString.allocationSize(value.target) +
        0;
  }
}

enum InputSubmitMode {
  enter,
  commandEnter,
  ;
}

class FfiConverterInputSubmitMode {
  static LiftRetVal<InputSubmitMode> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    switch (index) {
      case 1:
        return LiftRetVal(
          InputSubmitMode.enter,
          4,
        );
      case 2:
        return LiftRetVal(
          InputSubmitMode.commandEnter,
          4,
        );
      default:
        throw UniffiInternalError(UniffiInternalError.unexpectedEnumCase,
            "Unable to determine enum variant");
    }
  }

  static InputSubmitMode lift(RustBuffer buffer) {
    return FfiConverterInputSubmitMode.read(buffer.asUint8List()).value;
  }

  static RustBuffer lower(InputSubmitMode input) {
    return toRustBuffer(createUint8ListFromInt(input.index + 1));
  }

  static int allocationSize(InputSubmitMode _value) {
    return 4;
  }

  static int write(InputSubmitMode value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.index + 1);
    return 4;
  }
}

enum TranslationMode {
  auto,
  manual,
  ;
}

class FfiConverterTranslationMode {
  static LiftRetVal<TranslationMode> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    switch (index) {
      case 1:
        return LiftRetVal(
          TranslationMode.auto,
          4,
        );
      case 2:
        return LiftRetVal(
          TranslationMode.manual,
          4,
        );
      default:
        throw UniffiInternalError(UniffiInternalError.unexpectedEnumCase,
            "Unable to determine enum variant");
    }
  }

  static TranslationMode lift(RustBuffer buffer) {
    return FfiConverterTranslationMode.read(buffer.asUint8List()).value;
  }

  static RustBuffer lower(TranslationMode input) {
    return toRustBuffer(createUint8ListFromInt(input.index + 1));
  }

  static int allocationSize(TranslationMode _value) {
    return 4;
  }

  static int write(TranslationMode value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.index + 1);
    return 4;
  }
}

abstract class RuntimeException implements Exception {
  RustBuffer lower();
  int allocationSize();
  int write(Uint8List buf);
}

class FfiConverterRuntimeException {
  static RuntimeException lift(RustBuffer buffer) {
    return FfiConverterRuntimeException.read(buffer.asUint8List()).value;
  }

  static LiftRetVal<RuntimeException> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    final subview = Uint8List.view(buf.buffer, buf.offsetInBytes + 4);
    switch (index) {
      case 1:
        final lifted = ErrorExceptionRuntimeException.read(subview);
        return LiftRetVal<RuntimeException>(
            lifted.value, lifted.bytesRead - subview.offsetInBytes + 4);
      default:
        throw UniffiInternalError(UniffiInternalError.unexpectedEnumCase,
            "Unable to determine enum variant");
    }
  }

  static RustBuffer lower(RuntimeException value) {
    return value.lower();
  }

  static int allocationSize(RuntimeException value) {
    return value.allocationSize();
  }

  static int write(RuntimeException value, Uint8List buf) {
    return value.write(buf) - buf.offsetInBytes;
  }
}

class ErrorExceptionRuntimeException extends RuntimeException {
  final String msg;
  ErrorExceptionRuntimeException(
    String this.msg,
  );
  ErrorExceptionRuntimeException._(
    String this.msg,
  );
  static LiftRetVal<ErrorExceptionRuntimeException> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final msg_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final msg = msg_lifted.value;
    new_offset += msg_lifted.bytesRead;
    return LiftRetVal(
        ErrorExceptionRuntimeException._(
          msg,
        ),
        new_offset);
  }

  @override
  RustBuffer lower() {
    final buf = Uint8List(allocationSize());
    write(buf);
    return toRustBuffer(buf);
  }

  @override
  int allocationSize() {
    return FfiConverterString.allocationSize(msg) + 4;
  }

  @override
  int write(Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, 1);
    int new_offset = buf.offsetInBytes + 4;
    new_offset +=
        FfiConverterString.write(msg, Uint8List.view(buf.buffer, new_offset));
    return new_offset;
  }

  @override
  String toString() {
    return "ErrorExceptionRuntimeException($msg)";
  }
}

class RuntimeExceptionErrorHandler extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    return FfiConverterRuntimeException.lift(errorBuf);
  }
}

final RuntimeExceptionErrorHandler runtimeExceptionErrorHandler =
    RuntimeExceptionErrorHandler();

abstract class RuntimeInterface {
  RuntimeDictionary dictionary({
    required String providerId,
  });
  RuntimeSettings settings();
  RuntimeTranslation translation({
    required String providerId,
  });
}

final _RuntimeFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall(
      (status) => uniffi_beyondtranslate_runtime_fn_free_runtime(ptr, status));
});

class Runtime implements RuntimeInterface {
  late final Pointer<Void> _ptr;
  Runtime._(this._ptr) {
    _RuntimeFinalizer.attach(this, _ptr, detach: this);
  }
  Runtime({
    required String dataDir,
  }) : _ptr = rustCall(
            (status) =>
                uniffi_beyondtranslate_runtime_fn_constructor_runtime_new(
                    FfiConverterString.lower(dataDir), status),
            runtimeExceptionErrorHandler) {
    _RuntimeFinalizer.attach(this, _ptr, detach: this);
  }
  factory Runtime.lift(Pointer<Void> ptr) {
    return Runtime._(ptr);
  }
  static Pointer<Void> lower(Runtime value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall((status) =>
        uniffi_beyondtranslate_runtime_fn_clone_runtime(_ptr, status));
  }

  static int allocationSize(Runtime value) {
    return 8;
  }

  static LiftRetVal<Runtime> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(Runtime.lift(pointer), 8);
  }

  static int write(Runtime value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _RuntimeFinalizer.detach(this);
    rustCall((status) =>
        uniffi_beyondtranslate_runtime_fn_free_runtime(_ptr, status));
  }

  RuntimeDictionary dictionary({
    required String providerId,
  }) {
    return rustCallWithLifter(
        (status) => uniffi_beyondtranslate_runtime_fn_method_runtime_dictionary(
            uniffiClonePointer(), FfiConverterString.lower(providerId), status),
        RuntimeDictionary.lift,
        runtimeExceptionErrorHandler);
  }

  RuntimeSettings settings() {
    return rustCallWithLifter(
        (status) => uniffi_beyondtranslate_runtime_fn_method_runtime_settings(
            uniffiClonePointer(), status),
        RuntimeSettings.lift,
        null);
  }

  RuntimeTranslation translation({
    required String providerId,
  }) {
    return rustCallWithLifter(
        (status) =>
            uniffi_beyondtranslate_runtime_fn_method_runtime_translation(
                uniffiClonePointer(),
                FfiConverterString.lower(providerId),
                status),
        RuntimeTranslation.lift,
        runtimeExceptionErrorHandler);
  }
}

abstract class RuntimeDictionaryInterface {
  Future<LookUpResponse> lookup({
    required LookUpRequest request,
  });
}

final _RuntimeDictionaryFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) =>
      uniffi_beyondtranslate_runtime_fn_free_runtimedictionary(ptr, status));
});

class RuntimeDictionary implements RuntimeDictionaryInterface {
  late final Pointer<Void> _ptr;
  RuntimeDictionary._(this._ptr) {
    _RuntimeDictionaryFinalizer.attach(this, _ptr, detach: this);
  }
  factory RuntimeDictionary.lift(Pointer<Void> ptr) {
    return RuntimeDictionary._(ptr);
  }
  static Pointer<Void> lower(RuntimeDictionary value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall((status) =>
        uniffi_beyondtranslate_runtime_fn_clone_runtimedictionary(
            _ptr, status));
  }

  static int allocationSize(RuntimeDictionary value) {
    return 8;
  }

  static LiftRetVal<RuntimeDictionary> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(RuntimeDictionary.lift(pointer), 8);
  }

  static int write(RuntimeDictionary value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _RuntimeDictionaryFinalizer.detach(this);
    rustCall((status) =>
        uniffi_beyondtranslate_runtime_fn_free_runtimedictionary(_ptr, status));
  }

  Future<LookUpResponse> lookup({
    required LookUpRequest request,
  }) {
    return uniffiRustCallAsync(
      () => uniffi_beyondtranslate_runtime_fn_method_runtimedictionary_lookup(
        uniffiClonePointer(),
        FfiConverterLookUpRequest.lower(request),
      ),
      ffi_beyondtranslate_runtime_rust_future_poll_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_complete_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_free_rust_buffer,
      _liftLookUpResponse,
      runtimeExceptionErrorHandler,
    );
  }
}

abstract class RuntimeSettingsInterface {
  Future<ProviderConfigEntry?> deleteProvider({
    required String providerId,
  });
  Future<AdvancedSettings> getAdvanced();
  Future<AppearanceSettings> getAppearance();
  Future<GeneralSettings> getGeneral();
  Future<String> getJson();
  Future<ProviderConfigEntry?> getProvider({
    required String providerId,
  });
  Future<ShortcutSettings> getShortcuts();
  Future<List<ProviderConfigEntry>> listProviders();
  Future<AdvancedSettings> updateAdvanced({
    required AdvancedSettingsPatch patch,
  });
  Future<AppearanceSettings> updateAppearance({
    required AppearanceSettingsPatch patch,
  });
  Future<GeneralSettings> updateGeneral({
    required GeneralSettingsPatch patch,
  });
  Future<ProviderConfigEntry> updateProvider({
    required String providerId,
    required String providerType,
    required Map<String, String> fields,
  });
  Future<ShortcutSettings> updateShortcuts({
    required ShortcutSettingsPatch patch,
  });
}

final _RuntimeSettingsFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) =>
      uniffi_beyondtranslate_runtime_fn_free_runtimesettings(ptr, status));
});

class RuntimeSettings implements RuntimeSettingsInterface {
  late final Pointer<Void> _ptr;
  RuntimeSettings._(this._ptr) {
    _RuntimeSettingsFinalizer.attach(this, _ptr, detach: this);
  }
  factory RuntimeSettings.lift(Pointer<Void> ptr) {
    return RuntimeSettings._(ptr);
  }
  static Pointer<Void> lower(RuntimeSettings value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall((status) =>
        uniffi_beyondtranslate_runtime_fn_clone_runtimesettings(_ptr, status));
  }

  static int allocationSize(RuntimeSettings value) {
    return 8;
  }

  static LiftRetVal<RuntimeSettings> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(RuntimeSettings.lift(pointer), 8);
  }

  static int write(RuntimeSettings value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _RuntimeSettingsFinalizer.detach(this);
    rustCall((status) =>
        uniffi_beyondtranslate_runtime_fn_free_runtimesettings(_ptr, status));
  }

  Future<ProviderConfigEntry?> deleteProvider({
    required String providerId,
  }) {
    return uniffiRustCallAsync(
      () =>
          uniffi_beyondtranslate_runtime_fn_method_runtimesettings_delete_provider(
        uniffiClonePointer(),
        FfiConverterString.lower(providerId),
      ),
      ffi_beyondtranslate_runtime_rust_future_poll_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_complete_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_free_rust_buffer,
      FfiConverterOptionalProviderConfigEntry.lift,
      runtimeExceptionErrorHandler,
    );
  }

  Future<AdvancedSettings> getAdvanced() {
    return uniffiRustCallAsync(
      () =>
          uniffi_beyondtranslate_runtime_fn_method_runtimesettings_get_advanced(
        uniffiClonePointer(),
      ),
      ffi_beyondtranslate_runtime_rust_future_poll_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_complete_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_free_rust_buffer,
      FfiConverterAdvancedSettings.lift,
      runtimeExceptionErrorHandler,
    );
  }

  Future<AppearanceSettings> getAppearance() {
    return uniffiRustCallAsync(
      () =>
          uniffi_beyondtranslate_runtime_fn_method_runtimesettings_get_appearance(
        uniffiClonePointer(),
      ),
      ffi_beyondtranslate_runtime_rust_future_poll_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_complete_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_free_rust_buffer,
      FfiConverterAppearanceSettings.lift,
      runtimeExceptionErrorHandler,
    );
  }

  Future<GeneralSettings> getGeneral() {
    return uniffiRustCallAsync(
      () =>
          uniffi_beyondtranslate_runtime_fn_method_runtimesettings_get_general(
        uniffiClonePointer(),
      ),
      ffi_beyondtranslate_runtime_rust_future_poll_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_complete_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_free_rust_buffer,
      FfiConverterGeneralSettings.lift,
      runtimeExceptionErrorHandler,
    );
  }

  Future<String> getJson() {
    return uniffiRustCallAsync(
      () => uniffi_beyondtranslate_runtime_fn_method_runtimesettings_get_json(
        uniffiClonePointer(),
      ),
      ffi_beyondtranslate_runtime_rust_future_poll_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_complete_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_free_rust_buffer,
      FfiConverterString.lift,
      runtimeExceptionErrorHandler,
    );
  }

  Future<ProviderConfigEntry?> getProvider({
    required String providerId,
  }) {
    return uniffiRustCallAsync(
      () =>
          uniffi_beyondtranslate_runtime_fn_method_runtimesettings_get_provider(
        uniffiClonePointer(),
        FfiConverterString.lower(providerId),
      ),
      ffi_beyondtranslate_runtime_rust_future_poll_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_complete_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_free_rust_buffer,
      FfiConverterOptionalProviderConfigEntry.lift,
      runtimeExceptionErrorHandler,
    );
  }

  Future<ShortcutSettings> getShortcuts() {
    return uniffiRustCallAsync(
      () =>
          uniffi_beyondtranslate_runtime_fn_method_runtimesettings_get_shortcuts(
        uniffiClonePointer(),
      ),
      ffi_beyondtranslate_runtime_rust_future_poll_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_complete_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_free_rust_buffer,
      FfiConverterShortcutSettings.lift,
      runtimeExceptionErrorHandler,
    );
  }

  Future<List<ProviderConfigEntry>> listProviders() {
    return uniffiRustCallAsync(
      () =>
          uniffi_beyondtranslate_runtime_fn_method_runtimesettings_list_providers(
        uniffiClonePointer(),
      ),
      ffi_beyondtranslate_runtime_rust_future_poll_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_complete_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_free_rust_buffer,
      FfiConverterSequenceProviderConfigEntry.lift,
      runtimeExceptionErrorHandler,
    );
  }

  Future<AdvancedSettings> updateAdvanced({
    required AdvancedSettingsPatch patch,
  }) {
    return uniffiRustCallAsync(
      () =>
          uniffi_beyondtranslate_runtime_fn_method_runtimesettings_update_advanced(
        uniffiClonePointer(),
        FfiConverterAdvancedSettingsPatch.lower(patch),
      ),
      ffi_beyondtranslate_runtime_rust_future_poll_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_complete_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_free_rust_buffer,
      FfiConverterAdvancedSettings.lift,
      runtimeExceptionErrorHandler,
    );
  }

  Future<AppearanceSettings> updateAppearance({
    required AppearanceSettingsPatch patch,
  }) {
    return uniffiRustCallAsync(
      () =>
          uniffi_beyondtranslate_runtime_fn_method_runtimesettings_update_appearance(
        uniffiClonePointer(),
        FfiConverterAppearanceSettingsPatch.lower(patch),
      ),
      ffi_beyondtranslate_runtime_rust_future_poll_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_complete_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_free_rust_buffer,
      FfiConverterAppearanceSettings.lift,
      runtimeExceptionErrorHandler,
    );
  }

  Future<GeneralSettings> updateGeneral({
    required GeneralSettingsPatch patch,
  }) {
    return uniffiRustCallAsync(
      () =>
          uniffi_beyondtranslate_runtime_fn_method_runtimesettings_update_general(
        uniffiClonePointer(),
        FfiConverterGeneralSettingsPatch.lower(patch),
      ),
      ffi_beyondtranslate_runtime_rust_future_poll_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_complete_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_free_rust_buffer,
      FfiConverterGeneralSettings.lift,
      runtimeExceptionErrorHandler,
    );
  }

  Future<ProviderConfigEntry> updateProvider({
    required String providerId,
    required String providerType,
    required Map<String, String> fields,
  }) {
    return uniffiRustCallAsync(
      () =>
          uniffi_beyondtranslate_runtime_fn_method_runtimesettings_update_provider(
        uniffiClonePointer(),
        FfiConverterString.lower(providerId),
        FfiConverterString.lower(providerType),
        FfiConverterMapStringToString.lower(fields),
      ),
      ffi_beyondtranslate_runtime_rust_future_poll_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_complete_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_free_rust_buffer,
      FfiConverterProviderConfigEntry.lift,
      runtimeExceptionErrorHandler,
    );
  }

  Future<ShortcutSettings> updateShortcuts({
    required ShortcutSettingsPatch patch,
  }) {
    return uniffiRustCallAsync(
      () =>
          uniffi_beyondtranslate_runtime_fn_method_runtimesettings_update_shortcuts(
        uniffiClonePointer(),
        FfiConverterShortcutSettingsPatch.lower(patch),
      ),
      ffi_beyondtranslate_runtime_rust_future_poll_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_complete_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_free_rust_buffer,
      FfiConverterShortcutSettings.lift,
      runtimeExceptionErrorHandler,
    );
  }
}

abstract class RuntimeTranslationInterface {
  Future<TranslateResponse> translate({
    required TranslateRequest request,
  });
}

final _RuntimeTranslationFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) =>
      uniffi_beyondtranslate_runtime_fn_free_runtimetranslation(ptr, status));
});

class RuntimeTranslation implements RuntimeTranslationInterface {
  late final Pointer<Void> _ptr;
  RuntimeTranslation._(this._ptr) {
    _RuntimeTranslationFinalizer.attach(this, _ptr, detach: this);
  }
  factory RuntimeTranslation.lift(Pointer<Void> ptr) {
    return RuntimeTranslation._(ptr);
  }
  static Pointer<Void> lower(RuntimeTranslation value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall((status) =>
        uniffi_beyondtranslate_runtime_fn_clone_runtimetranslation(
            _ptr, status));
  }

  static int allocationSize(RuntimeTranslation value) {
    return 8;
  }

  static LiftRetVal<RuntimeTranslation> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(RuntimeTranslation.lift(pointer), 8);
  }

  static int write(RuntimeTranslation value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _RuntimeTranslationFinalizer.detach(this);
    rustCall((status) =>
        uniffi_beyondtranslate_runtime_fn_free_runtimetranslation(
            _ptr, status));
  }

  Future<TranslateResponse> translate({
    required TranslateRequest request,
  }) {
    return uniffiRustCallAsync(
      () =>
          uniffi_beyondtranslate_runtime_fn_method_runtimetranslation_translate(
        uniffiClonePointer(),
        FfiConverterTranslateRequest.lower(request),
      ),
      ffi_beyondtranslate_runtime_rust_future_poll_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_complete_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_free_rust_buffer,
      _liftTranslateResponse,
      runtimeExceptionErrorHandler,
    );
  }
}

class UniffiInternalError implements Exception {
  static const int bufferOverflow = 0;
  static const int incompleteData = 1;
  static const int unexpectedOptionalTag = 2;
  static const int unexpectedEnumCase = 3;
  static const int unexpectedNullPointer = 4;
  static const int unexpectedRustCallStatusCode = 5;
  static const int unexpectedRustCallError = 6;
  static const int unexpectedStaleHandle = 7;
  static const int rustPanic = 8;
  final int errorCode;
  final String? panicMessage;
  const UniffiInternalError(this.errorCode, this.panicMessage);
  static UniffiInternalError panicked(String message) {
    return UniffiInternalError(rustPanic, message);
  }

  @override
  String toString() {
    switch (errorCode) {
      case bufferOverflow:
        return "UniFfi::BufferOverflow";
      case incompleteData:
        return "UniFfi::IncompleteData";
      case unexpectedOptionalTag:
        return "UniFfi::UnexpectedOptionalTag";
      case unexpectedEnumCase:
        return "UniFfi::UnexpectedEnumCase";
      case unexpectedNullPointer:
        return "UniFfi::UnexpectedNullPointer";
      case unexpectedRustCallStatusCode:
        return "UniFfi::UnexpectedRustCallStatusCode";
      case unexpectedRustCallError:
        return "UniFfi::UnexpectedRustCallError";
      case unexpectedStaleHandle:
        return "UniFfi::UnexpectedStaleHandle";
      case rustPanic:
        return "UniFfi::rustPanic: $panicMessage";
      default:
        return "UniFfi::UnknownError: $errorCode";
    }
  }
}

const int CALL_SUCCESS = 0;
const int CALL_ERROR = 1;
const int CALL_UNEXPECTED_ERROR = 2;

final class RustCallStatus extends Struct {
  @Int8()
  external int code;
  external RustBuffer errorBuf;
}

void checkCallStatus(UniffiRustCallStatusErrorHandler errorHandler,
    Pointer<RustCallStatus> status) {
  if (status.ref.code == CALL_SUCCESS) {
    return;
  } else if (status.ref.code == CALL_ERROR) {
    throw errorHandler.lift(status.ref.errorBuf);
  } else if (status.ref.code == CALL_UNEXPECTED_ERROR) {
    if (status.ref.errorBuf.len > 0) {
      throw UniffiInternalError.panicked(
          FfiConverterString.lift(status.ref.errorBuf));
    } else {
      throw UniffiInternalError.panicked("Rust panic");
    }
  } else {
    throw UniffiInternalError.panicked(
        "Unexpected RustCallStatus code: \${status.ref.code}");
  }
}

T rustCall<T>(T Function(Pointer<RustCallStatus>) callback,
    [UniffiRustCallStatusErrorHandler? errorHandler]) {
  final status = calloc<RustCallStatus>();
  try {
    final result = callback(status);
    checkCallStatus(errorHandler ?? NullRustCallStatusErrorHandler(), status);
    return result;
  } finally {
    calloc.free(status);
  }
}

T rustCallWithLifter<T, F>(
    F Function(Pointer<RustCallStatus>) ffiCall, T Function(F) lifter,
    [UniffiRustCallStatusErrorHandler? errorHandler]) {
  final status = calloc<RustCallStatus>();
  try {
    final rawResult = ffiCall(status);
    checkCallStatus(errorHandler ?? NullRustCallStatusErrorHandler(), status);
    return lifter(rawResult);
  } finally {
    calloc.free(status);
  }
}

class NullRustCallStatusErrorHandler extends UniffiRustCallStatusErrorHandler {
  @override
  Exception lift(RustBuffer errorBuf) {
    errorBuf.free();
    return UniffiInternalError.panicked("Unexpected CALL_ERROR");
  }
}

abstract class UniffiRustCallStatusErrorHandler {
  Exception lift(RustBuffer errorBuf);
}

final class RustBuffer extends Struct {
  @Uint64()
  external int capacity;
  @Uint64()
  external int len;
  external Pointer<Uint8> data;
  static RustBuffer alloc(int size) {
    return rustCall(
        (status) => ffi_beyondtranslate_runtime_rustbuffer_alloc(size, status));
  }

  static RustBuffer fromBytes(ForeignBytes bytes) {
    return rustCall((status) =>
        ffi_beyondtranslate_runtime_rustbuffer_from_bytes(bytes, status));
  }

  void free() {
    rustCall(
        (status) => ffi_beyondtranslate_runtime_rustbuffer_free(this, status));
  }

  RustBuffer reserve(int additionalCapacity) {
    return rustCall((status) => ffi_beyondtranslate_runtime_rustbuffer_reserve(
        this, additionalCapacity, status));
  }

  Uint8List asUint8List() {
    final dataList = data.asTypedList(len);
    final byteData = ByteData.sublistView(dataList);
    return Uint8List.view(byteData.buffer);
  }

  @override
  String toString() {
    return "RustBuffer{capacity: \$capacity, len: \$len, data: \$data}";
  }
}

RustBuffer toRustBuffer(Uint8List data) {
  final length = data.length;
  final Pointer<Uint8> frameData = calloc<Uint8>(length);
  final pointerList = frameData.asTypedList(length);
  pointerList.setAll(0, data);
  final bytes = calloc<ForeignBytes>();
  bytes.ref.len = length;
  bytes.ref.data = frameData;
  return RustBuffer.fromBytes(bytes.ref);
}

final class ForeignBytes extends Struct {
  @Int32()
  external int len;
  external Pointer<Uint8> data;
  void free() {
    calloc.free(data);
  }
}

class LiftRetVal<T> {
  final T value;
  final int bytesRead;
  const LiftRetVal(this.value, this.bytesRead);
  LiftRetVal<T> copyWithOffset(int offset) {
    return LiftRetVal(value, bytesRead + offset);
  }
}

abstract class FfiConverter<D, F> {
  const FfiConverter();
  D lift(F value);
  F lower(D value);
  D read(ByteData buffer, int offset);
  void write(D value, ByteData buffer, int offset);
  int size(D value);
}

mixin FfiConverterPrimitive<T> on FfiConverter<T, T> {
  @override
  T lift(T value) => value;
  @override
  T lower(T value) => value;
}
Uint8List createUint8ListFromInt(int value) {
  int length = value.bitLength ~/ 8 + 1;
  if (length != 4 && length != 8) {
    length = (value < 0x100000000) ? 4 : 8;
  }
  Uint8List uint8List = Uint8List(length);
  for (int i = length - 1; i >= 0; i--) {
    uint8List[i] = value & 0xFF;
    value >>= 8;
  }
  return uint8List;
}

class FfiConverterMapStringToString {
  static Map<String, String> lift(RustBuffer buf) {
    return FfiConverterMapStringToString.read(buf.asUint8List()).value;
  }

  static LiftRetVal<Map<String, String>> read(Uint8List buf) {
    final map = <String, String>{};
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final k = FfiConverterString.read(Uint8List.view(buf.buffer, offset));
      offset += k.bytesRead;
      final v = FfiConverterString.read(Uint8List.view(buf.buffer, offset));
      offset += v.bytesRead;
      map[k.value] = v.value;
    }
    return LiftRetVal(map, offset - buf.offsetInBytes);
  }

  static int write(Map<String, String> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (final entry in value.entries) {
      offset += FfiConverterString.write(
          entry.key, Uint8List.view(buf.buffer, offset));
      offset += FfiConverterString.write(
          entry.value, Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(Map<String, String> value) {
    return value.entries
        .map((e) =>
            FfiConverterString.allocationSize(e.key) +
            FfiConverterString.allocationSize(e.value))
        .fold(4, (a, b) => a + b);
  }

  static RustBuffer lower(Map<String, String> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalInputSubmitMode {
  static InputSubmitMode? lift(RustBuffer buf) {
    return FfiConverterOptionalInputSubmitMode.read(buf.asUint8List()).value;
  }

  static LiftRetVal<InputSubmitMode?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterInputSubmitMode.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<InputSubmitMode?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([InputSubmitMode? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterInputSubmitMode.allocationSize(value) + 1;
  }

  static RustBuffer lower(InputSubmitMode? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalInputSubmitMode.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalInputSubmitMode.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(InputSubmitMode? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterInputSubmitMode.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

class FfiConverterOptionalTranslationMode {
  static TranslationMode? lift(RustBuffer buf) {
    return FfiConverterOptionalTranslationMode.read(buf.asUint8List()).value;
  }

  static LiftRetVal<TranslationMode?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterTranslationMode.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<TranslationMode?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([TranslationMode? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterTranslationMode.allocationSize(value) + 1;
  }

  static RustBuffer lower(TranslationMode? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalTranslationMode.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalTranslationMode.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(TranslationMode? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterTranslationMode.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

class FfiConverterInt32 {
  static int lift(int value) => value;
  static LiftRetVal<int> read(Uint8List buf) {
    return LiftRetVal(buf.buffer.asByteData(buf.offsetInBytes).getInt32(0), 4);
  }

  static int lower(int value) {
    if (value < -2147483648 || value > 2147483647) {
      throw ArgumentError("Value out of range for i32: " + value.toString());
    }
    return value;
  }

  static int allocationSize([int value = 0]) {
    return 4;
  }

  static int write(int value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, lower(value));
    return 4;
  }
}

class FfiConverterString {
  static String lift(RustBuffer buf) {
    return utf8.decoder.convert(buf.asUint8List());
  }

  static RustBuffer lower(String value) {
    return toRustBuffer(Utf8Encoder().convert(value));
  }

  static LiftRetVal<String> read(Uint8List buf) {
    final end = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0) + 4;
    return LiftRetVal(utf8.decoder.convert(buf, 4, end), end);
  }

  static int allocationSize([String value = ""]) {
    return utf8.encoder.convert(value).length + 4;
  }

  static int write(String value, Uint8List buf) {
    final list = utf8.encoder.convert(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, list.length);
    buf.setAll(4, list);
    return list.length + 4;
  }
}

class FfiConverterSequenceString {
  static List<String> lift(RustBuffer buf) {
    return FfiConverterSequenceString.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<String>> read(Uint8List buf) {
    List<String> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterString.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<String> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterString.write(
          value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<String> value) {
    return value
            .map((l) => FfiConverterString.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<String> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalProviderConfigEntry {
  static ProviderConfigEntry? lift(RustBuffer buf) {
    return FfiConverterOptionalProviderConfigEntry.read(buf.asUint8List())
        .value;
  }

  static LiftRetVal<ProviderConfigEntry?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterProviderConfigEntry.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<ProviderConfigEntry?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([ProviderConfigEntry? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterProviderConfigEntry.allocationSize(value) + 1;
  }

  static RustBuffer lower(ProviderConfigEntry? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length =
        FfiConverterOptionalProviderConfigEntry.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalProviderConfigEntry.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(ProviderConfigEntry? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterProviderConfigEntry.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

class FfiConverterBool {
  static bool lift(int value) {
    return value == 1;
  }

  static int lower(bool value) {
    return value ? 1 : 0;
  }

  static LiftRetVal<bool> read(Uint8List buf) {
    return LiftRetVal(FfiConverterBool.lift(buf.first), 1);
  }

  static RustBuffer lowerIntoRustBuffer(bool value) {
    return toRustBuffer(Uint8List.fromList([FfiConverterBool.lower(value)]));
  }

  static int allocationSize([bool value = false]) {
    return 1;
  }

  static int write(bool value, Uint8List buf) {
    buf.setAll(0, [value ? 1 : 0]);
    return allocationSize();
  }
}

class FfiConverterSequenceTranslationTarget {
  static List<TranslationTarget> lift(RustBuffer buf) {
    return FfiConverterSequenceTranslationTarget.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<TranslationTarget>> read(Uint8List buf) {
    List<TranslationTarget> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterTranslationTarget.read(
          Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<TranslationTarget> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterTranslationTarget.write(
          value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<TranslationTarget> value) {
    return value
            .map((l) => FfiConverterTranslationTarget.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<TranslationTarget> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalSequenceTranslationTarget {
  static List<TranslationTarget>? lift(RustBuffer buf) {
    return FfiConverterOptionalSequenceTranslationTarget.read(buf.asUint8List())
        .value;
  }

  static LiftRetVal<List<TranslationTarget>?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterSequenceTranslationTarget.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<List<TranslationTarget>?>(
        result.value, result.bytesRead + 1);
  }

  static int allocationSize([List<TranslationTarget>? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterSequenceTranslationTarget.allocationSize(value) + 1;
  }

  static RustBuffer lower(List<TranslationTarget>? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length =
        FfiConverterOptionalSequenceTranslationTarget.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalSequenceTranslationTarget.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(List<TranslationTarget>? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterSequenceTranslationTarget.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

class FfiConverterOptionalString {
  static String? lift(RustBuffer buf) {
    return FfiConverterOptionalString.read(buf.asUint8List()).value;
  }

  static LiftRetVal<String?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterString.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<String?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([String? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterString.allocationSize(value) + 1;
  }

  static RustBuffer lower(String? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalString.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalString.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(String? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterString.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

class FfiConverterSequenceProviderConfigEntry {
  static List<ProviderConfigEntry> lift(RustBuffer buf) {
    return FfiConverterSequenceProviderConfigEntry.read(buf.asUint8List())
        .value;
  }

  static LiftRetVal<List<ProviderConfigEntry>> read(Uint8List buf) {
    List<ProviderConfigEntry> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterProviderConfigEntry.read(
          Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<ProviderConfigEntry> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterProviderConfigEntry.write(
          value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<ProviderConfigEntry> value) {
    return value
            .map((l) => FfiConverterProviderConfigEntry.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<ProviderConfigEntry> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalBool {
  static bool? lift(RustBuffer buf) {
    return FfiConverterOptionalBool.read(buf.asUint8List()).value;
  }

  static LiftRetVal<bool?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterBool.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<bool?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([bool? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterBool.allocationSize(value) + 1;
  }

  static RustBuffer lower(bool? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalBool.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalBool.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(bool? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterBool.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

const int UNIFFI_RUST_FUTURE_POLL_READY = 0;
const int UNIFFI_RUST_FUTURE_POLL_MAYBE_READY = 1;
typedef UniffiRustFutureContinuationCallback = Void Function(Uint64, Int8);
final _uniffiRustFutureContinuationHandles = UniffiHandleMap<Completer<int>>();
Future<T> uniffiRustCallAsync<T, F>(
  Pointer<Void> Function() rustFutureFunc,
  void Function(
          Pointer<Void>,
          Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
          Pointer<Void>)
      pollFunc,
  F Function(Pointer<Void>, Pointer<RustCallStatus>) completeFunc,
  void Function(Pointer<Void>) freeFunc,
  T Function(F) liftFunc, [
  UniffiRustCallStatusErrorHandler? errorHandler,
]) async {
  final rustFuture = rustFutureFunc();
  final completer = Completer<int>();
  final handle = _uniffiRustFutureContinuationHandles.insert(completer);
  final callbackData = Pointer<Void>.fromAddress(handle);
  late final NativeCallable<UniffiRustFutureContinuationCallback> callback;
  void repoll() {
    pollFunc(
      rustFuture,
      callback.nativeFunction,
      callbackData,
    );
  }

  void onResponse(int data, int pollResult) {
    if (pollResult == UNIFFI_RUST_FUTURE_POLL_READY) {
      final readyCompleter =
          _uniffiRustFutureContinuationHandles.maybeRemove(data);
      if (readyCompleter != null && !readyCompleter.isCompleted) {
        readyCompleter.complete(pollResult);
      }
    } else if (pollResult == UNIFFI_RUST_FUTURE_POLL_MAYBE_READY) {
      repoll();
    } else {
      final errorCompleter =
          _uniffiRustFutureContinuationHandles.maybeRemove(data);
      if (errorCompleter != null && !errorCompleter.isCompleted) {
        errorCompleter.completeError(
          UniffiInternalError.panicked(
            "Unexpected poll result from Rust future: \$pollResult",
          ),
        );
      }
    }
  }

  callback = NativeCallable<UniffiRustFutureContinuationCallback>.listener(
    onResponse,
  );
  try {
    repoll();
    await completer.future;
    final status = calloc<RustCallStatus>();
    try {
      final result = completeFunc(rustFuture, status);
      checkCallStatus(
        errorHandler ?? NullRustCallStatusErrorHandler(),
        status,
      );
      return liftFunc(result);
    } finally {
      calloc.free(status);
    }
  } finally {
    callback.close();
    _uniffiRustFutureContinuationHandles.maybeRemove(handle);
    freeFunc(rustFuture);
  }
}

typedef UniffiForeignFutureFree = Void Function(Uint64);
typedef UniffiForeignFutureFreeDart = void Function(int);

class _UniffiForeignFutureState {
  bool cancelled = false;
}

final _uniffiForeignFutureHandleMap =
    UniffiHandleMap<_UniffiForeignFutureState>();
void _uniffiForeignFutureFree(int handle) {
  final state = _uniffiForeignFutureHandleMap.maybeRemove(handle);
  if (state != null) {
    state.cancelled = true;
  }
}

final Pointer<NativeFunction<UniffiForeignFutureFree>>
    _uniffiForeignFutureFreePointer =
    Pointer.fromFunction<UniffiForeignFutureFree>(_uniffiForeignFutureFree);

final class UniffiForeignFuture extends Struct {
  @Uint64()
  external int handle;
  external Pointer<NativeFunction<UniffiForeignFutureFree>> free;
}

class UniffiHandleMap<T> {
  final Map<int, T> _map = {};
  int _counter = 1;
  int insert(T obj) {
    final handle = _counter;
    _counter += 2;
    _map[handle] = obj;
    return handle;
  }

  T get(int handle) {
    final obj = _map[handle];
    if (obj == null) {
      throw UniffiInternalError(
          UniffiInternalError.unexpectedStaleHandle, "Handle not found");
    }
    return obj;
  }

  void remove(int handle) {
    if (maybeRemove(handle) == null) {
      throw UniffiInternalError(
          UniffiInternalError.unexpectedStaleHandle, "Handle not found");
    }
  }

  T? maybeRemove(int handle) {
    return _map.remove(handle);
  }
}

const _uniffiAssetId =
    "package:beyondtranslate_runtime/uniffi:beyondtranslate_runtime";
int add({
  required int a,
  required int b,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_add(
          FfiConverterInt32.lower(a), FfiConverterInt32.lower(b), status),
      FfiConverterInt32.lift,
      null);
}

DetectLanguageRequest echoDetectLanguageRequest({
  required DetectLanguageRequest request,
}) {
  return rustCallWithLifter(
      (status) =>
          uniffi_beyondtranslate_runtime_fn_func_echo_detect_language_request(
              FfiConverterDetectLanguageRequest.lower(request), status),
      FfiConverterDetectLanguageRequest.lift,
      null);
}

DetectLanguageResponse echoDetectLanguageResponse({
  required DetectLanguageResponse response,
}) {
  return rustCallWithLifter(
      (status) =>
          uniffi_beyondtranslate_runtime_fn_func_echo_detect_language_response(
              FfiConverterDetectLanguageResponse.lower(response), status),
      FfiConverterDetectLanguageResponse.lift,
      null);
}

LanguagePair echoLanguagePair({
  required LanguagePair languagePair,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_echo_language_pair(
          FfiConverterLanguagePair.lower(languagePair), status),
      FfiConverterLanguagePair.lift,
      null);
}

LookUpRequest echoLookUpRequest({
  required LookUpRequest request,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_echo_look_up_request(
          FfiConverterLookUpRequest.lower(request), status),
      FfiConverterLookUpRequest.lift,
      null);
}

LookUpResponse echoLookUpResponse({
  required LookUpResponse response,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_echo_look_up_response(
          FfiConverterLookUpResponse.lower(response), status),
      FfiConverterLookUpResponse.lift,
      null);
}

TextDetection echoTextDetection({
  required TextDetection textDetection,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_echo_text_detection(
          FfiConverterTextDetection.lower(textDetection), status),
      FfiConverterTextDetection.lift,
      null);
}

TextTranslation echoTextTranslation({
  required TextTranslation textTranslation,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_echo_text_translation(
          FfiConverterTextTranslation.lower(textTranslation), status),
      FfiConverterTextTranslation.lift,
      null);
}

TranslateRequest echoTranslateRequest({
  required TranslateRequest request,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_echo_translate_request(
          FfiConverterTranslateRequest.lower(request), status),
      FfiConverterTranslateRequest.lift,
      null);
}

TranslateResponse echoTranslateResponse({
  required TranslateResponse response,
}) {
  return rustCallWithLifter(
      (status) =>
          uniffi_beyondtranslate_runtime_fn_func_echo_translate_response(
              FfiConverterTranslateResponse.lower(response), status),
      FfiConverterTranslateResponse.lift,
      null);
}

WordDefinition echoWordDefinition({
  required WordDefinition wordDefinition,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_echo_word_definition(
          FfiConverterWordDefinition.lower(wordDefinition), status),
      FfiConverterWordDefinition.lift,
      null);
}

WordImage echoWordImage({
  required WordImage wordImage,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_echo_word_image(
          FfiConverterWordImage.lower(wordImage), status),
      FfiConverterWordImage.lift,
      null);
}

WordPhrase echoWordPhrase({
  required WordPhrase wordPhrase,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_echo_word_phrase(
          FfiConverterWordPhrase.lower(wordPhrase), status),
      FfiConverterWordPhrase.lift,
      null);
}

WordPronunciation echoWordPronunciation({
  required WordPronunciation wordPronunciation,
}) {
  return rustCallWithLifter(
      (status) =>
          uniffi_beyondtranslate_runtime_fn_func_echo_word_pronunciation(
              FfiConverterWordPronunciation.lower(wordPronunciation), status),
      FfiConverterWordPronunciation.lift,
      null);
}

WordSentence echoWordSentence({
  required WordSentence wordSentence,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_echo_word_sentence(
          FfiConverterWordSentence.lower(wordSentence), status),
      FfiConverterWordSentence.lift,
      null);
}

WordTag echoWordTag({
  required WordTag wordTag,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_echo_word_tag(
          FfiConverterWordTag.lower(wordTag), status),
      FfiConverterWordTag.lift,
      null);
}

WordTense echoWordTense({
  required WordTense wordTense,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_echo_word_tense(
          FfiConverterWordTense.lower(wordTense), status),
      FfiConverterWordTense.lift,
      null);
}

String greet({
  required String name,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_greet(
          FfiConverterString.lower(name), status),
      FfiConverterString.lift,
      null);
}

String version() {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_version(status),
      FfiConverterString.lift,
      null);
}

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external Pointer<Void> uniffi_beyondtranslate_runtime_fn_clone_runtime(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external void uniffi_beyondtranslate_runtime_fn_free_runtime(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<Pointer<Void> Function(RustBuffer, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_constructor_runtime_new(
        RustBuffer data_dir, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Pointer<Void> Function(Pointer<Void>, RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtime_dictionary(
        Pointer<Void> ptr,
        RustBuffer provider_id,
        Pointer<RustCallStatus> uniffiStatus);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtime_settings(
        Pointer<Void> ptr, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Pointer<Void> Function(Pointer<Void>, RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtime_translation(
        Pointer<Void> ptr,
        RustBuffer provider_id,
        Pointer<RustCallStatus> uniffiStatus);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_clone_runtimedictionary(
        Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external void uniffi_beyondtranslate_runtime_fn_free_runtimedictionary(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<Pointer<Void> Function(Pointer<Void>, beyondtranslate_core.RustBuffer)>(
    assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtimedictionary_lookup(
        Pointer<Void> ptr, beyondtranslate_core.RustBuffer request);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external Pointer<Void> uniffi_beyondtranslate_runtime_fn_clone_runtimesettings(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external void uniffi_beyondtranslate_runtime_fn_free_runtimesettings(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<Pointer<Void> Function(Pointer<Void>, RustBuffer)>(
    assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtimesettings_delete_provider(
        Pointer<Void> ptr, RustBuffer provider_id);

@Native<Pointer<Void> Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtimesettings_get_advanced(
        Pointer<Void> ptr);

@Native<Pointer<Void> Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtimesettings_get_appearance(
        Pointer<Void> ptr);

@Native<Pointer<Void> Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtimesettings_get_general(
        Pointer<Void> ptr);

@Native<Pointer<Void> Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtimesettings_get_json(
        Pointer<Void> ptr);

@Native<Pointer<Void> Function(Pointer<Void>, RustBuffer)>(
    assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtimesettings_get_provider(
        Pointer<Void> ptr, RustBuffer provider_id);

@Native<Pointer<Void> Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtimesettings_get_shortcuts(
        Pointer<Void> ptr);

@Native<Pointer<Void> Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtimesettings_list_providers(
        Pointer<Void> ptr);

@Native<Pointer<Void> Function(Pointer<Void>, RustBuffer)>(
    assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtimesettings_update_advanced(
        Pointer<Void> ptr, RustBuffer patch);

@Native<Pointer<Void> Function(Pointer<Void>, RustBuffer)>(
    assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtimesettings_update_appearance(
        Pointer<Void> ptr, RustBuffer patch);

@Native<Pointer<Void> Function(Pointer<Void>, RustBuffer)>(
    assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtimesettings_update_general(
        Pointer<Void> ptr, RustBuffer patch);

@Native<
    Pointer<Void> Function(Pointer<Void>, RustBuffer, RustBuffer,
        RustBuffer)>(assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtimesettings_update_provider(
        Pointer<Void> ptr,
        RustBuffer provider_id,
        RustBuffer provider_type,
        RustBuffer fields);

@Native<Pointer<Void> Function(Pointer<Void>, RustBuffer)>(
    assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtimesettings_update_shortcuts(
        Pointer<Void> ptr, RustBuffer patch);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_clone_runtimetranslation(
        Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external void uniffi_beyondtranslate_runtime_fn_free_runtimetranslation(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<Pointer<Void> Function(Pointer<Void>, beyondtranslate_core.RustBuffer)>(
    assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtimetranslation_translate(
        Pointer<Void> ptr, beyondtranslate_core.RustBuffer request);

@Native<Int32 Function(Int32, Int32, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external int uniffi_beyondtranslate_runtime_fn_func_add(
    int a, int b, Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_detect_language_request(
        beyondtranslate_core.RustBuffer request,
        Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_detect_language_response(
        beyondtranslate_core.RustBuffer response,
        Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_language_pair(
        beyondtranslate_core.RustBuffer language_pair,
        Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_look_up_request(
        beyondtranslate_core.RustBuffer request,
        Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_look_up_response(
        beyondtranslate_core.RustBuffer response,
        Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_text_detection(
        beyondtranslate_core.RustBuffer text_detection,
        Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_text_translation(
        beyondtranslate_core.RustBuffer text_translation,
        Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_translate_request(
        beyondtranslate_core.RustBuffer request,
        Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_translate_response(
        beyondtranslate_core.RustBuffer response,
        Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_word_definition(
        beyondtranslate_core.RustBuffer word_definition,
        Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_word_image(
        beyondtranslate_core.RustBuffer word_image,
        Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_word_phrase(
        beyondtranslate_core.RustBuffer word_phrase,
        Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_word_pronunciation(
        beyondtranslate_core.RustBuffer word_pronunciation,
        Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_word_sentence(
        beyondtranslate_core.RustBuffer word_sentence,
        Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_word_tag(
        beyondtranslate_core.RustBuffer word_tag,
        Pointer<RustCallStatus> uniffiStatus);

@Native<
    beyondtranslate_core.RustBuffer Function(beyondtranslate_core.RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external beyondtranslate_core.RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_word_tense(
        beyondtranslate_core.RustBuffer word_tense,
        Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(RustBuffer, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer uniffi_beyondtranslate_runtime_fn_func_greet(
    RustBuffer name, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external RustBuffer uniffi_beyondtranslate_runtime_fn_func_version(
    Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(Uint64, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer ffi_beyondtranslate_runtime_rustbuffer_alloc(
    int size, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(ForeignBytes, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer ffi_beyondtranslate_runtime_rustbuffer_from_bytes(
    ForeignBytes bytes, Pointer<RustCallStatus> uniffiStatus);

@Native<Void Function(RustBuffer, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rustbuffer_free(
    RustBuffer buf, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(RustBuffer, Uint64, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer ffi_beyondtranslate_runtime_rustbuffer_reserve(
    RustBuffer buf, int additional, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_poll_u8(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_cancel_u8(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_free_u8(
    Pointer<Void> handle);

@Native<Uint8 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external int ffi_beyondtranslate_runtime_rust_future_complete_u8(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_poll_i8(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_cancel_i8(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_free_i8(
    Pointer<Void> handle);

@Native<Int8 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external int ffi_beyondtranslate_runtime_rust_future_complete_i8(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_poll_u16(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_cancel_u16(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_free_u16(
    Pointer<Void> handle);

@Native<Uint16 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external int ffi_beyondtranslate_runtime_rust_future_complete_u16(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_poll_i16(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_cancel_i16(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_free_i16(
    Pointer<Void> handle);

@Native<Int16 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external int ffi_beyondtranslate_runtime_rust_future_complete_i16(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_poll_u32(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_cancel_u32(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_free_u32(
    Pointer<Void> handle);

@Native<Uint32 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external int ffi_beyondtranslate_runtime_rust_future_complete_u32(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_poll_i32(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_cancel_i32(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_free_i32(
    Pointer<Void> handle);

@Native<Int32 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external int ffi_beyondtranslate_runtime_rust_future_complete_i32(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_poll_u64(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_cancel_u64(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_free_u64(
    Pointer<Void> handle);

@Native<Uint64 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external int ffi_beyondtranslate_runtime_rust_future_complete_u64(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_poll_i64(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_cancel_i64(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_free_i64(
    Pointer<Void> handle);

@Native<Int64 Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external int ffi_beyondtranslate_runtime_rust_future_complete_i64(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_poll_f32(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_cancel_f32(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_free_f32(
    Pointer<Void> handle);

@Native<Float Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external double ffi_beyondtranslate_runtime_rust_future_complete_f32(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_poll_f64(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_cancel_f64(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_free_f64(
    Pointer<Void> handle);

@Native<Double Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external double ffi_beyondtranslate_runtime_rust_future_complete_f64(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_poll_rust_buffer(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_cancel_rust_buffer(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_free_rust_buffer(
    Pointer<Void> handle);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer
    ffi_beyondtranslate_runtime_rust_future_complete_rust_buffer(
        Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Void Function(
        Pointer<Void>,
        Pointer<NativeFunction<UniffiRustFutureContinuationCallback>>,
        Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_poll_void(
    Pointer<Void> handle,
    Pointer<NativeFunction<UniffiRustFutureContinuationCallback>> callback,
    Pointer<Void> callback_data);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_cancel_void(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_free_void(
    Pointer<Void> handle);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external void ffi_beyondtranslate_runtime_rust_future_complete_void(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_beyondtranslate_runtime_checksum_func_add();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_func_echo_detect_language_request();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_func_echo_detect_language_response();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_beyondtranslate_runtime_checksum_func_echo_language_pair();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_func_echo_look_up_request();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_func_echo_look_up_response();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_beyondtranslate_runtime_checksum_func_echo_text_detection();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_func_echo_text_translation();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_func_echo_translate_request();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_func_echo_translate_response();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_func_echo_word_definition();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_beyondtranslate_runtime_checksum_func_echo_word_image();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_beyondtranslate_runtime_checksum_func_echo_word_phrase();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_func_echo_word_pronunciation();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_beyondtranslate_runtime_checksum_func_echo_word_sentence();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_beyondtranslate_runtime_checksum_func_echo_word_tag();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_beyondtranslate_runtime_checksum_func_echo_word_tense();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_beyondtranslate_runtime_checksum_func_greet();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_beyondtranslate_runtime_checksum_func_version();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtime_dictionary();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_beyondtranslate_runtime_checksum_method_runtime_settings();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtime_translation();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtimedictionary_lookup();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_delete_provider();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_get_advanced();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_get_appearance();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_get_general();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_get_json();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_get_provider();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_get_shortcuts();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_list_providers();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_update_advanced();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_update_appearance();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_update_general();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_update_provider();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_update_shortcuts();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtimetranslation_translate();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_beyondtranslate_runtime_checksum_constructor_runtime_new();

@Native<Uint32 Function()>(assetId: _uniffiAssetId)
external int ffi_beyondtranslate_runtime_uniffi_contract_version();

void _checkApiVersion() {
  final bindingsVersion = 30;
  final scaffoldingVersion =
      ffi_beyondtranslate_runtime_uniffi_contract_version();
  if (bindingsVersion != scaffoldingVersion) {
    throw UniffiInternalError.panicked(
        "UniFFI contract version mismatch: bindings version \$bindingsVersion, scaffolding version \$scaffoldingVersion");
  }
}

void _checkApiChecksums() {
  if (uniffi_beyondtranslate_runtime_checksum_func_add() != 17790) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_detect_language_request() !=
      8599) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_detect_language_response() !=
      47914) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_language_pair() !=
      18868) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_look_up_request() !=
      3060) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_look_up_response() !=
      3637) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_text_detection() !=
      46612) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_text_translation() !=
      36395) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_translate_request() !=
      25811) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_translate_response() !=
      58236) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_word_definition() !=
      5681) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_word_image() != 60210) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_word_phrase() != 9437) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_word_pronunciation() !=
      42325) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_word_sentence() !=
      4677) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_word_tag() != 35137) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_word_tense() != 21321) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_greet() != 35598) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_version() != 42317) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtime_dictionary() !=
      13965) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtime_settings() !=
      37764) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtime_translation() !=
      36886) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimedictionary_lookup() !=
      25807) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_delete_provider() !=
      20557) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_get_advanced() !=
      3214) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_get_appearance() !=
      54826) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_get_general() !=
      54665) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_get_json() !=
      31105) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_get_provider() !=
      21807) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_get_shortcuts() !=
      44721) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_list_providers() !=
      34940) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_update_advanced() !=
      46849) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_update_appearance() !=
      59073) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_update_general() !=
      47378) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_update_provider() !=
      46276) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_update_shortcuts() !=
      11504) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimetranslation_translate() !=
      54604) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_constructor_runtime_new() !=
      50884) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
}

void ensureInitialized() {
  _checkApiVersion();
  _checkApiChecksums();
}

@Deprecated("Use ensureInitialized instead")
void initialize() {
  ensureInitialized();
}
