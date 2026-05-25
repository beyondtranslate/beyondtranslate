library beyondtranslate_runtime;

import "dart:async";
import "dart:convert";
import "dart:ffi";
import "dart:io" show Platform, File, Directory;
import "dart:isolate";
import "dart:typed_data";
import "package:ffi/ffi.dart";

class ApiServerInfo {
  final String host;
  final int port;
  final String baseUrl;
  ApiServerInfo({
    required this.host,
    required this.port,
    required this.baseUrl,
  });
}

class FfiConverterApiServerInfo {
  static ApiServerInfo lift(RustBuffer buf) {
    return FfiConverterApiServerInfo.read(buf.asUint8List()).value;
  }

  static LiftRetVal<ApiServerInfo> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final host_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final host = host_lifted.value;
    new_offset += host_lifted.bytesRead;
    final port_lifted =
        FfiConverterUInt16.read(Uint8List.view(buf.buffer, new_offset));
    final port = port_lifted.value;
    new_offset += port_lifted.bytesRead;
    final baseUrl_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final baseUrl = baseUrl_lifted.value;
    new_offset += baseUrl_lifted.bytesRead;
    return LiftRetVal(
        ApiServerInfo(
          host: host,
          port: port,
          baseUrl: baseUrl,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(ApiServerInfo value) {
    final total_length = FfiConverterString.allocationSize(value.host) +
        FfiConverterUInt16.allocationSize(value.port) +
        FfiConverterString.allocationSize(value.baseUrl) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(ApiServerInfo value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterString.write(
        value.host, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterUInt16.write(
        value.port, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(
        value.baseUrl, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(ApiServerInfo value) {
    return FfiConverterString.allocationSize(value.host) +
        FfiConverterUInt16.allocationSize(value.port) +
        FfiConverterString.allocationSize(value.baseUrl) +
        0;
  }
}

class AdvancedSettings {
  final bool apiServerEnabled;
  final String apiServerHost;
  final int apiServerPort;
  AdvancedSettings({
    required this.apiServerEnabled,
    required this.apiServerHost,
    required this.apiServerPort,
  });
}

class FfiConverterAdvancedSettings {
  static AdvancedSettings lift(RustBuffer buf) {
    return FfiConverterAdvancedSettings.read(buf.asUint8List()).value;
  }

  static LiftRetVal<AdvancedSettings> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final apiServerEnabled_lifted =
        FfiConverterBool.read(Uint8List.view(buf.buffer, new_offset));
    final apiServerEnabled = apiServerEnabled_lifted.value;
    new_offset += apiServerEnabled_lifted.bytesRead;
    final apiServerHost_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final apiServerHost = apiServerHost_lifted.value;
    new_offset += apiServerHost_lifted.bytesRead;
    final apiServerPort_lifted =
        FfiConverterUInt16.read(Uint8List.view(buf.buffer, new_offset));
    final apiServerPort = apiServerPort_lifted.value;
    new_offset += apiServerPort_lifted.bytesRead;
    return LiftRetVal(
        AdvancedSettings(
          apiServerEnabled: apiServerEnabled,
          apiServerHost: apiServerHost,
          apiServerPort: apiServerPort,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(AdvancedSettings value) {
    final total_length =
        FfiConverterBool.allocationSize(value.apiServerEnabled) +
            FfiConverterString.allocationSize(value.apiServerHost) +
            FfiConverterUInt16.allocationSize(value.apiServerPort) +
            0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(AdvancedSettings value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterBool.write(
        value.apiServerEnabled, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(
        value.apiServerHost, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterUInt16.write(
        value.apiServerPort, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(AdvancedSettings value) {
    return FfiConverterBool.allocationSize(value.apiServerEnabled) +
        FfiConverterString.allocationSize(value.apiServerHost) +
        FfiConverterUInt16.allocationSize(value.apiServerPort) +
        0;
  }
}

class AdvancedSettingsPatch {
  final bool? apiServerEnabled;
  final String? apiServerHost;
  final int? apiServerPort;
  AdvancedSettingsPatch({
    this.apiServerEnabled,
    this.apiServerHost,
    this.apiServerPort,
  });
}

class FfiConverterAdvancedSettingsPatch {
  static AdvancedSettingsPatch lift(RustBuffer buf) {
    return FfiConverterAdvancedSettingsPatch.read(buf.asUint8List()).value;
  }

  static LiftRetVal<AdvancedSettingsPatch> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final apiServerEnabled_lifted =
        FfiConverterOptionalBool.read(Uint8List.view(buf.buffer, new_offset));
    final apiServerEnabled = apiServerEnabled_lifted.value;
    new_offset += apiServerEnabled_lifted.bytesRead;
    final apiServerHost_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final apiServerHost = apiServerHost_lifted.value;
    new_offset += apiServerHost_lifted.bytesRead;
    final apiServerPort_lifted =
        FfiConverterOptionalUInt16.read(Uint8List.view(buf.buffer, new_offset));
    final apiServerPort = apiServerPort_lifted.value;
    new_offset += apiServerPort_lifted.bytesRead;
    return LiftRetVal(
        AdvancedSettingsPatch(
          apiServerEnabled: apiServerEnabled,
          apiServerHost: apiServerHost,
          apiServerPort: apiServerPort,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(AdvancedSettingsPatch value) {
    final total_length =
        FfiConverterOptionalBool.allocationSize(value.apiServerEnabled) +
            FfiConverterOptionalString.allocationSize(value.apiServerHost) +
            FfiConverterOptionalUInt16.allocationSize(value.apiServerPort) +
            0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(AdvancedSettingsPatch value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterOptionalBool.write(
        value.apiServerEnabled, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.apiServerHost, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalUInt16.write(
        value.apiServerPort, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(AdvancedSettingsPatch value) {
    return FfiConverterOptionalBool.allocationSize(value.apiServerEnabled) +
        FfiConverterOptionalString.allocationSize(value.apiServerHost) +
        FfiConverterOptionalUInt16.allocationSize(value.apiServerPort) +
        0;
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
  final bool showInMenuBar;
  final String defaultOcrService;
  final bool autoCopyDetectedText;
  final String defaultDirectoryService;
  final String defaultTranslationService;
  final List<TranslationTarget> translationTargets;
  final InputSubmitMode inputSubmitMode;
  final bool doubleClickCopyResult;
  final List<String> commonLanguages;
  GeneralSettings({
    required this.launchAtLogin,
    required this.showInMenuBar,
    required this.defaultOcrService,
    required this.autoCopyDetectedText,
    required this.defaultDirectoryService,
    required this.defaultTranslationService,
    required this.translationTargets,
    required this.inputSubmitMode,
    required this.doubleClickCopyResult,
    required this.commonLanguages,
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
    final showInMenuBar_lifted =
        FfiConverterBool.read(Uint8List.view(buf.buffer, new_offset));
    final showInMenuBar = showInMenuBar_lifted.value;
    new_offset += showInMenuBar_lifted.bytesRead;
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
    final commonLanguages_lifted =
        FfiConverterSequenceString.read(Uint8List.view(buf.buffer, new_offset));
    final commonLanguages = commonLanguages_lifted.value;
    new_offset += commonLanguages_lifted.bytesRead;
    return LiftRetVal(
        GeneralSettings(
          launchAtLogin: launchAtLogin,
          showInMenuBar: showInMenuBar,
          defaultOcrService: defaultOcrService,
          autoCopyDetectedText: autoCopyDetectedText,
          defaultDirectoryService: defaultDirectoryService,
          defaultTranslationService: defaultTranslationService,
          translationTargets: translationTargets,
          inputSubmitMode: inputSubmitMode,
          doubleClickCopyResult: doubleClickCopyResult,
          commonLanguages: commonLanguages,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(GeneralSettings value) {
    final total_length = FfiConverterBool.allocationSize(value.launchAtLogin) +
        FfiConverterBool.allocationSize(value.showInMenuBar) +
        FfiConverterString.allocationSize(value.defaultOcrService) +
        FfiConverterBool.allocationSize(value.autoCopyDetectedText) +
        FfiConverterString.allocationSize(value.defaultDirectoryService) +
        FfiConverterString.allocationSize(value.defaultTranslationService) +
        FfiConverterSequenceTranslationTarget.allocationSize(
            value.translationTargets) +
        FfiConverterInputSubmitMode.allocationSize(value.inputSubmitMode) +
        FfiConverterBool.allocationSize(value.doubleClickCopyResult) +
        FfiConverterSequenceString.allocationSize(value.commonLanguages) +
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
        value.showInMenuBar, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(
        value.defaultOcrService, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterBool.write(
        value.autoCopyDetectedText, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(
        value.defaultDirectoryService, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(value.defaultTranslationService,
        Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterSequenceTranslationTarget.write(
        value.translationTargets, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterInputSubmitMode.write(
        value.inputSubmitMode, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterBool.write(
        value.doubleClickCopyResult, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterSequenceString.write(
        value.commonLanguages, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(GeneralSettings value) {
    return FfiConverterBool.allocationSize(value.launchAtLogin) +
        FfiConverterBool.allocationSize(value.showInMenuBar) +
        FfiConverterString.allocationSize(value.defaultOcrService) +
        FfiConverterBool.allocationSize(value.autoCopyDetectedText) +
        FfiConverterString.allocationSize(value.defaultDirectoryService) +
        FfiConverterString.allocationSize(value.defaultTranslationService) +
        FfiConverterSequenceTranslationTarget.allocationSize(
            value.translationTargets) +
        FfiConverterInputSubmitMode.allocationSize(value.inputSubmitMode) +
        FfiConverterBool.allocationSize(value.doubleClickCopyResult) +
        FfiConverterSequenceString.allocationSize(value.commonLanguages) +
        0;
  }
}

class GeneralSettingsPatch {
  final bool? launchAtLogin;
  final bool? showInMenuBar;
  final String? defaultOcrService;
  final bool? autoCopyDetectedText;
  final String? defaultDirectoryService;
  final String? defaultTranslationService;
  final List<TranslationTarget>? translationTargets;
  final InputSubmitMode? inputSubmitMode;
  final bool? doubleClickCopyResult;
  final List<String>? commonLanguages;
  GeneralSettingsPatch({
    this.launchAtLogin,
    this.showInMenuBar,
    this.defaultOcrService,
    this.autoCopyDetectedText,
    this.defaultDirectoryService,
    this.defaultTranslationService,
    this.translationTargets,
    this.inputSubmitMode,
    this.doubleClickCopyResult,
    this.commonLanguages,
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
    final showInMenuBar_lifted =
        FfiConverterOptionalBool.read(Uint8List.view(buf.buffer, new_offset));
    final showInMenuBar = showInMenuBar_lifted.value;
    new_offset += showInMenuBar_lifted.bytesRead;
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
    final commonLanguages_lifted = FfiConverterOptionalSequenceString.read(
        Uint8List.view(buf.buffer, new_offset));
    final commonLanguages = commonLanguages_lifted.value;
    new_offset += commonLanguages_lifted.bytesRead;
    return LiftRetVal(
        GeneralSettingsPatch(
          launchAtLogin: launchAtLogin,
          showInMenuBar: showInMenuBar,
          defaultOcrService: defaultOcrService,
          autoCopyDetectedText: autoCopyDetectedText,
          defaultDirectoryService: defaultDirectoryService,
          defaultTranslationService: defaultTranslationService,
          translationTargets: translationTargets,
          inputSubmitMode: inputSubmitMode,
          doubleClickCopyResult: doubleClickCopyResult,
          commonLanguages: commonLanguages,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(GeneralSettingsPatch value) {
    final total_length = FfiConverterOptionalBool.allocationSize(
            value.launchAtLogin) +
        FfiConverterOptionalBool.allocationSize(value.showInMenuBar) +
        FfiConverterOptionalString.allocationSize(value.defaultOcrService) +
        FfiConverterOptionalBool.allocationSize(value.autoCopyDetectedText) +
        FfiConverterOptionalString.allocationSize(
            value.defaultDirectoryService) +
        FfiConverterOptionalString.allocationSize(
            value.defaultTranslationService) +
        FfiConverterOptionalSequenceTranslationTarget.allocationSize(
            value.translationTargets) +
        FfiConverterOptionalInputSubmitMode.allocationSize(
            value.inputSubmitMode) +
        FfiConverterOptionalBool.allocationSize(value.doubleClickCopyResult) +
        FfiConverterOptionalSequenceString.allocationSize(
            value.commonLanguages) +
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
        value.showInMenuBar, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.defaultOcrService, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalBool.write(
        value.autoCopyDetectedText, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.defaultDirectoryService, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.defaultTranslationService,
        Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalSequenceTranslationTarget.write(
        value.translationTargets, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalInputSubmitMode.write(
        value.inputSubmitMode, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalBool.write(
        value.doubleClickCopyResult, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalSequenceString.write(
        value.commonLanguages, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(GeneralSettingsPatch value) {
    return FfiConverterOptionalBool.allocationSize(value.launchAtLogin) +
        FfiConverterOptionalBool.allocationSize(value.showInMenuBar) +
        FfiConverterOptionalString.allocationSize(value.defaultOcrService) +
        FfiConverterOptionalBool.allocationSize(value.autoCopyDetectedText) +
        FfiConverterOptionalString.allocationSize(
            value.defaultDirectoryService) +
        FfiConverterOptionalString.allocationSize(
            value.defaultTranslationService) +
        FfiConverterOptionalSequenceTranslationTarget.allocationSize(
            value.translationTargets) +
        FfiConverterOptionalInputSubmitMode.allocationSize(
            value.inputSubmitMode) +
        FfiConverterOptionalBool.allocationSize(value.doubleClickCopyResult) +
        FfiConverterOptionalSequenceString.allocationSize(
            value.commonLanguages) +
        0;
  }
}

class ProviderConfigEntry {
  final String id;
  final ProviderType type;
  final Map<String, String> fields;
  final List<ProviderCapability> capabilities;
  final int? createdAt;
  ProviderConfigEntry({
    required this.id,
    required this.type,
    required this.fields,
    required this.capabilities,
    this.createdAt,
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
        FfiConverterProviderType.read(Uint8List.view(buf.buffer, new_offset));
    final type = type_lifted.value;
    new_offset += type_lifted.bytesRead;
    final fields_lifted = FfiConverterMapStringToString.read(
        Uint8List.view(buf.buffer, new_offset));
    final fields = fields_lifted.value;
    new_offset += fields_lifted.bytesRead;
    final capabilities_lifted = FfiConverterSequenceProviderCapability.read(
        Uint8List.view(buf.buffer, new_offset));
    final capabilities = capabilities_lifted.value;
    new_offset += capabilities_lifted.bytesRead;
    final createdAt_lifted =
        FfiConverterOptionalUInt64.read(Uint8List.view(buf.buffer, new_offset));
    final createdAt = createdAt_lifted.value;
    new_offset += createdAt_lifted.bytesRead;
    return LiftRetVal(
        ProviderConfigEntry(
          id: id,
          type: type,
          fields: fields,
          capabilities: capabilities,
          createdAt: createdAt,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(ProviderConfigEntry value) {
    final total_length = FfiConverterString.allocationSize(value.id) +
        FfiConverterProviderType.allocationSize(value.type) +
        FfiConverterMapStringToString.allocationSize(value.fields) +
        FfiConverterSequenceProviderCapability.allocationSize(
            value.capabilities) +
        FfiConverterOptionalUInt64.allocationSize(value.createdAt) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(ProviderConfigEntry value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterString.write(
        value.id, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterProviderType.write(
        value.type, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterMapStringToString.write(
        value.fields, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterSequenceProviderCapability.write(
        value.capabilities, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalUInt64.write(
        value.createdAt, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(ProviderConfigEntry value) {
    return FfiConverterString.allocationSize(value.id) +
        FfiConverterProviderType.allocationSize(value.type) +
        FfiConverterMapStringToString.allocationSize(value.fields) +
        FfiConverterSequenceProviderCapability.allocationSize(
            value.capabilities) +
        FfiConverterOptionalUInt64.allocationSize(value.createdAt) +
        0;
  }
}

class ShortcutSettings {
  final String toggleMiniTranslator;
  final String extractTextFromScreenSelection;
  final String extractTextFromScreenCapture;
  final String extractTextFromClipboard;
  final String translateInputContent;
  ShortcutSettings({
    required this.toggleMiniTranslator,
    required this.extractTextFromScreenSelection,
    required this.extractTextFromScreenCapture,
    required this.extractTextFromClipboard,
    required this.translateInputContent,
  });
}

class FfiConverterShortcutSettings {
  static ShortcutSettings lift(RustBuffer buf) {
    return FfiConverterShortcutSettings.read(buf.asUint8List()).value;
  }

  static LiftRetVal<ShortcutSettings> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final toggleMiniTranslator_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final toggleMiniTranslator = toggleMiniTranslator_lifted.value;
    new_offset += toggleMiniTranslator_lifted.bytesRead;
    final extractTextFromScreenSelection_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final extractTextFromScreenSelection =
        extractTextFromScreenSelection_lifted.value;
    new_offset += extractTextFromScreenSelection_lifted.bytesRead;
    final extractTextFromScreenCapture_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final extractTextFromScreenCapture =
        extractTextFromScreenCapture_lifted.value;
    new_offset += extractTextFromScreenCapture_lifted.bytesRead;
    final extractTextFromClipboard_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final extractTextFromClipboard = extractTextFromClipboard_lifted.value;
    new_offset += extractTextFromClipboard_lifted.bytesRead;
    final translateInputContent_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final translateInputContent = translateInputContent_lifted.value;
    new_offset += translateInputContent_lifted.bytesRead;
    return LiftRetVal(
        ShortcutSettings(
          toggleMiniTranslator: toggleMiniTranslator,
          extractTextFromScreenSelection: extractTextFromScreenSelection,
          extractTextFromScreenCapture: extractTextFromScreenCapture,
          extractTextFromClipboard: extractTextFromClipboard,
          translateInputContent: translateInputContent,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(ShortcutSettings value) {
    final total_length = FfiConverterString.allocationSize(
            value.toggleMiniTranslator) +
        FfiConverterString.allocationSize(
            value.extractTextFromScreenSelection) +
        FfiConverterString.allocationSize(value.extractTextFromScreenCapture) +
        FfiConverterString.allocationSize(value.extractTextFromClipboard) +
        FfiConverterString.allocationSize(value.translateInputContent) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(ShortcutSettings value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterString.write(
        value.toggleMiniTranslator, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(value.extractTextFromScreenSelection,
        Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(value.extractTextFromScreenCapture,
        Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(
        value.extractTextFromClipboard, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(
        value.translateInputContent, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(ShortcutSettings value) {
    return FfiConverterString.allocationSize(value.toggleMiniTranslator) +
        FfiConverterString.allocationSize(
            value.extractTextFromScreenSelection) +
        FfiConverterString.allocationSize(value.extractTextFromScreenCapture) +
        FfiConverterString.allocationSize(value.extractTextFromClipboard) +
        FfiConverterString.allocationSize(value.translateInputContent) +
        0;
  }
}

class ShortcutSettingsPatch {
  final String? toggleMiniTranslator;
  final String? extractTextFromScreenSelection;
  final String? extractTextFromScreenCapture;
  final String? extractTextFromClipboard;
  final String? translateInputContent;
  ShortcutSettingsPatch({
    this.toggleMiniTranslator,
    this.extractTextFromScreenSelection,
    this.extractTextFromScreenCapture,
    this.extractTextFromClipboard,
    this.translateInputContent,
  });
}

class FfiConverterShortcutSettingsPatch {
  static ShortcutSettingsPatch lift(RustBuffer buf) {
    return FfiConverterShortcutSettingsPatch.read(buf.asUint8List()).value;
  }

  static LiftRetVal<ShortcutSettingsPatch> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final toggleMiniTranslator_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final toggleMiniTranslator = toggleMiniTranslator_lifted.value;
    new_offset += toggleMiniTranslator_lifted.bytesRead;
    final extractTextFromScreenSelection_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final extractTextFromScreenSelection =
        extractTextFromScreenSelection_lifted.value;
    new_offset += extractTextFromScreenSelection_lifted.bytesRead;
    final extractTextFromScreenCapture_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final extractTextFromScreenCapture =
        extractTextFromScreenCapture_lifted.value;
    new_offset += extractTextFromScreenCapture_lifted.bytesRead;
    final extractTextFromClipboard_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final extractTextFromClipboard = extractTextFromClipboard_lifted.value;
    new_offset += extractTextFromClipboard_lifted.bytesRead;
    final translateInputContent_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final translateInputContent = translateInputContent_lifted.value;
    new_offset += translateInputContent_lifted.bytesRead;
    return LiftRetVal(
        ShortcutSettingsPatch(
          toggleMiniTranslator: toggleMiniTranslator,
          extractTextFromScreenSelection: extractTextFromScreenSelection,
          extractTextFromScreenCapture: extractTextFromScreenCapture,
          extractTextFromClipboard: extractTextFromClipboard,
          translateInputContent: translateInputContent,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(ShortcutSettingsPatch value) {
    final total_length = FfiConverterOptionalString.allocationSize(
            value.toggleMiniTranslator) +
        FfiConverterOptionalString.allocationSize(
            value.extractTextFromScreenSelection) +
        FfiConverterOptionalString.allocationSize(
            value.extractTextFromScreenCapture) +
        FfiConverterOptionalString.allocationSize(
            value.extractTextFromClipboard) +
        FfiConverterOptionalString.allocationSize(value.translateInputContent) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(ShortcutSettingsPatch value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterOptionalString.write(
        value.toggleMiniTranslator, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.extractTextFromScreenSelection,
        Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.extractTextFromScreenCapture,
        Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.extractTextFromClipboard, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.translateInputContent, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(ShortcutSettingsPatch value) {
    return FfiConverterOptionalString.allocationSize(
            value.toggleMiniTranslator) +
        FfiConverterOptionalString.allocationSize(
            value.extractTextFromScreenSelection) +
        FfiConverterOptionalString.allocationSize(
            value.extractTextFromScreenCapture) +
        FfiConverterOptionalString.allocationSize(
            value.extractTextFromClipboard) +
        FfiConverterOptionalString.allocationSize(value.translateInputContent) +
        0;
  }
}

class DetectLanguageRequest {
  final List<String> texts;
  DetectLanguageRequest({
    required this.texts,
  });
}

class FfiConverterDetectLanguageRequest {
  static DetectLanguageRequest lift(RustBuffer buf) {
    return FfiConverterDetectLanguageRequest.read(buf.asUint8List()).value;
  }

  static LiftRetVal<DetectLanguageRequest> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final texts_lifted =
        FfiConverterSequenceString.read(Uint8List.view(buf.buffer, new_offset));
    final texts = texts_lifted.value;
    new_offset += texts_lifted.bytesRead;
    return LiftRetVal(
        DetectLanguageRequest(
          texts: texts,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(DetectLanguageRequest value) {
    final total_length =
        FfiConverterSequenceString.allocationSize(value.texts) + 0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(DetectLanguageRequest value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterSequenceString.write(
        value.texts, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(DetectLanguageRequest value) {
    return FfiConverterSequenceString.allocationSize(value.texts) + 0;
  }
}

class DetectLanguageResponse {
  final List<TextDetection>? detections;
  DetectLanguageResponse({
    this.detections,
  });
}

class FfiConverterDetectLanguageResponse {
  static DetectLanguageResponse lift(RustBuffer buf) {
    return FfiConverterDetectLanguageResponse.read(buf.asUint8List()).value;
  }

  static LiftRetVal<DetectLanguageResponse> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final detections_lifted = FfiConverterOptionalSequenceTextDetection.read(
        Uint8List.view(buf.buffer, new_offset));
    final detections = detections_lifted.value;
    new_offset += detections_lifted.bytesRead;
    return LiftRetVal(
        DetectLanguageResponse(
          detections: detections,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(DetectLanguageResponse value) {
    final total_length =
        FfiConverterOptionalSequenceTextDetection.allocationSize(
                value.detections) +
            0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(DetectLanguageResponse value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterOptionalSequenceTextDetection.write(
        value.detections, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(DetectLanguageResponse value) {
    return FfiConverterOptionalSequenceTextDetection.allocationSize(
            value.detections) +
        0;
  }
}

class LanguageInfo {
  final String code;
  final String localName;
  LanguageInfo({
    required this.code,
    required this.localName,
  });
}

class FfiConverterLanguageInfo {
  static LanguageInfo lift(RustBuffer buf) {
    return FfiConverterLanguageInfo.read(buf.asUint8List()).value;
  }

  static LiftRetVal<LanguageInfo> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final code_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final code = code_lifted.value;
    new_offset += code_lifted.bytesRead;
    final localName_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final localName = localName_lifted.value;
    new_offset += localName_lifted.bytesRead;
    return LiftRetVal(
        LanguageInfo(
          code: code,
          localName: localName,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(LanguageInfo value) {
    final total_length = FfiConverterString.allocationSize(value.code) +
        FfiConverterString.allocationSize(value.localName) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(LanguageInfo value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterString.write(
        value.code, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(
        value.localName, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(LanguageInfo value) {
    return FfiConverterString.allocationSize(value.code) +
        FfiConverterString.allocationSize(value.localName) +
        0;
  }
}

class LanguagePair {
  final String? sourceLanguage;
  final String? sourceLanguageId;
  final String? targetLanguage;
  final String? targetLanguageId;
  LanguagePair({
    this.sourceLanguage,
    this.sourceLanguageId,
    this.targetLanguage,
    this.targetLanguageId,
  });
}

class FfiConverterLanguagePair {
  static LanguagePair lift(RustBuffer buf) {
    return FfiConverterLanguagePair.read(buf.asUint8List()).value;
  }

  static LiftRetVal<LanguagePair> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final sourceLanguage_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final sourceLanguage = sourceLanguage_lifted.value;
    new_offset += sourceLanguage_lifted.bytesRead;
    final sourceLanguageId_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final sourceLanguageId = sourceLanguageId_lifted.value;
    new_offset += sourceLanguageId_lifted.bytesRead;
    final targetLanguage_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final targetLanguage = targetLanguage_lifted.value;
    new_offset += targetLanguage_lifted.bytesRead;
    final targetLanguageId_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final targetLanguageId = targetLanguageId_lifted.value;
    new_offset += targetLanguageId_lifted.bytesRead;
    return LiftRetVal(
        LanguagePair(
          sourceLanguage: sourceLanguage,
          sourceLanguageId: sourceLanguageId,
          targetLanguage: targetLanguage,
          targetLanguageId: targetLanguageId,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(LanguagePair value) {
    final total_length =
        FfiConverterOptionalString.allocationSize(value.sourceLanguage) +
            FfiConverterOptionalString.allocationSize(value.sourceLanguageId) +
            FfiConverterOptionalString.allocationSize(value.targetLanguage) +
            FfiConverterOptionalString.allocationSize(value.targetLanguageId) +
            0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(LanguagePair value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterOptionalString.write(
        value.sourceLanguage, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.sourceLanguageId, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.targetLanguage, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.targetLanguageId, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(LanguagePair value) {
    return FfiConverterOptionalString.allocationSize(value.sourceLanguage) +
        FfiConverterOptionalString.allocationSize(value.sourceLanguageId) +
        FfiConverterOptionalString.allocationSize(value.targetLanguage) +
        FfiConverterOptionalString.allocationSize(value.targetLanguageId) +
        0;
  }
}

class LookUpRequest {
  final String sourceLanguage;
  final String targetLanguage;
  final String word;
  LookUpRequest({
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.word,
  });
}

class FfiConverterLookUpRequest {
  static LookUpRequest lift(RustBuffer buf) {
    return FfiConverterLookUpRequest.read(buf.asUint8List()).value;
  }

  static LiftRetVal<LookUpRequest> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final sourceLanguage_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final sourceLanguage = sourceLanguage_lifted.value;
    new_offset += sourceLanguage_lifted.bytesRead;
    final targetLanguage_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final targetLanguage = targetLanguage_lifted.value;
    new_offset += targetLanguage_lifted.bytesRead;
    final word_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final word = word_lifted.value;
    new_offset += word_lifted.bytesRead;
    return LiftRetVal(
        LookUpRequest(
          sourceLanguage: sourceLanguage,
          targetLanguage: targetLanguage,
          word: word,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(LookUpRequest value) {
    final total_length =
        FfiConverterString.allocationSize(value.sourceLanguage) +
            FfiConverterString.allocationSize(value.targetLanguage) +
            FfiConverterString.allocationSize(value.word) +
            0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(LookUpRequest value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterString.write(
        value.sourceLanguage, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(
        value.targetLanguage, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(
        value.word, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(LookUpRequest value) {
    return FfiConverterString.allocationSize(value.sourceLanguage) +
        FfiConverterString.allocationSize(value.targetLanguage) +
        FfiConverterString.allocationSize(value.word) +
        0;
  }
}

class LookUpResponse {
  final List<TextTranslation> translations;
  final String? word;
  final String? tip;
  final List<WordTag>? tags;
  final List<WordDefinition>? definitions;
  final List<WordPronunciation>? pronunciations;
  final List<WordImage>? images;
  final List<WordPhrase>? phrases;
  final List<WordTense>? tenses;
  final List<WordSentence>? sentences;
  final List<WordEtymology>? etymology;
  final List<WordSynonym>? synonyms;
  LookUpResponse({
    required this.translations,
    this.word,
    this.tip,
    this.tags,
    this.definitions,
    this.pronunciations,
    this.images,
    this.phrases,
    this.tenses,
    this.sentences,
    this.etymology,
    this.synonyms,
  });
}

class FfiConverterLookUpResponse {
  static LookUpResponse lift(RustBuffer buf) {
    return FfiConverterLookUpResponse.read(buf.asUint8List()).value;
  }

  static LiftRetVal<LookUpResponse> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final translations_lifted = FfiConverterSequenceTextTranslation.read(
        Uint8List.view(buf.buffer, new_offset));
    final translations = translations_lifted.value;
    new_offset += translations_lifted.bytesRead;
    final word_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final word = word_lifted.value;
    new_offset += word_lifted.bytesRead;
    final tip_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final tip = tip_lifted.value;
    new_offset += tip_lifted.bytesRead;
    final tags_lifted = FfiConverterOptionalSequenceWordTag.read(
        Uint8List.view(buf.buffer, new_offset));
    final tags = tags_lifted.value;
    new_offset += tags_lifted.bytesRead;
    final definitions_lifted = FfiConverterOptionalSequenceWordDefinition.read(
        Uint8List.view(buf.buffer, new_offset));
    final definitions = definitions_lifted.value;
    new_offset += definitions_lifted.bytesRead;
    final pronunciations_lifted =
        FfiConverterOptionalSequenceWordPronunciation.read(
            Uint8List.view(buf.buffer, new_offset));
    final pronunciations = pronunciations_lifted.value;
    new_offset += pronunciations_lifted.bytesRead;
    final images_lifted = FfiConverterOptionalSequenceWordImage.read(
        Uint8List.view(buf.buffer, new_offset));
    final images = images_lifted.value;
    new_offset += images_lifted.bytesRead;
    final phrases_lifted = FfiConverterOptionalSequenceWordPhrase.read(
        Uint8List.view(buf.buffer, new_offset));
    final phrases = phrases_lifted.value;
    new_offset += phrases_lifted.bytesRead;
    final tenses_lifted = FfiConverterOptionalSequenceWordTense.read(
        Uint8List.view(buf.buffer, new_offset));
    final tenses = tenses_lifted.value;
    new_offset += tenses_lifted.bytesRead;
    final sentences_lifted = FfiConverterOptionalSequenceWordSentence.read(
        Uint8List.view(buf.buffer, new_offset));
    final sentences = sentences_lifted.value;
    new_offset += sentences_lifted.bytesRead;
    final etymology_lifted = FfiConverterOptionalSequenceWordEtymology.read(
        Uint8List.view(buf.buffer, new_offset));
    final etymology = etymology_lifted.value;
    new_offset += etymology_lifted.bytesRead;
    final synonyms_lifted = FfiConverterOptionalSequenceWordSynonym.read(
        Uint8List.view(buf.buffer, new_offset));
    final synonyms = synonyms_lifted.value;
    new_offset += synonyms_lifted.bytesRead;
    return LiftRetVal(
        LookUpResponse(
          translations: translations,
          word: word,
          tip: tip,
          tags: tags,
          definitions: definitions,
          pronunciations: pronunciations,
          images: images,
          phrases: phrases,
          tenses: tenses,
          sentences: sentences,
          etymology: etymology,
          synonyms: synonyms,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(LookUpResponse value) {
    final total_length = FfiConverterSequenceTextTranslation.allocationSize(
            value.translations) +
        FfiConverterOptionalString.allocationSize(value.word) +
        FfiConverterOptionalString.allocationSize(value.tip) +
        FfiConverterOptionalSequenceWordTag.allocationSize(value.tags) +
        FfiConverterOptionalSequenceWordDefinition.allocationSize(
            value.definitions) +
        FfiConverterOptionalSequenceWordPronunciation.allocationSize(
            value.pronunciations) +
        FfiConverterOptionalSequenceWordImage.allocationSize(value.images) +
        FfiConverterOptionalSequenceWordPhrase.allocationSize(value.phrases) +
        FfiConverterOptionalSequenceWordTense.allocationSize(value.tenses) +
        FfiConverterOptionalSequenceWordSentence.allocationSize(
            value.sentences) +
        FfiConverterOptionalSequenceWordEtymology.allocationSize(
            value.etymology) +
        FfiConverterOptionalSequenceWordSynonym.allocationSize(value.synonyms) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(LookUpResponse value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterSequenceTextTranslation.write(
        value.translations, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.word, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.tip, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalSequenceWordTag.write(
        value.tags, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalSequenceWordDefinition.write(
        value.definitions, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalSequenceWordPronunciation.write(
        value.pronunciations, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalSequenceWordImage.write(
        value.images, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalSequenceWordPhrase.write(
        value.phrases, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalSequenceWordTense.write(
        value.tenses, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalSequenceWordSentence.write(
        value.sentences, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalSequenceWordEtymology.write(
        value.etymology, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalSequenceWordSynonym.write(
        value.synonyms, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(LookUpResponse value) {
    return FfiConverterSequenceTextTranslation.allocationSize(
            value.translations) +
        FfiConverterOptionalString.allocationSize(value.word) +
        FfiConverterOptionalString.allocationSize(value.tip) +
        FfiConverterOptionalSequenceWordTag.allocationSize(value.tags) +
        FfiConverterOptionalSequenceWordDefinition.allocationSize(
            value.definitions) +
        FfiConverterOptionalSequenceWordPronunciation.allocationSize(
            value.pronunciations) +
        FfiConverterOptionalSequenceWordImage.allocationSize(value.images) +
        FfiConverterOptionalSequenceWordPhrase.allocationSize(value.phrases) +
        FfiConverterOptionalSequenceWordTense.allocationSize(value.tenses) +
        FfiConverterOptionalSequenceWordSentence.allocationSize(
            value.sentences) +
        FfiConverterOptionalSequenceWordEtymology.allocationSize(
            value.etymology) +
        FfiConverterOptionalSequenceWordSynonym.allocationSize(value.synonyms) +
        0;
  }
}

class RecognizeTextRequest {
  final String? imagePath;
  final String? base64Image;
  RecognizeTextRequest({
    this.imagePath,
    this.base64Image,
  });
}

class FfiConverterRecognizeTextRequest {
  static RecognizeTextRequest lift(RustBuffer buf) {
    return FfiConverterRecognizeTextRequest.read(buf.asUint8List()).value;
  }

  static LiftRetVal<RecognizeTextRequest> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final imagePath_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final imagePath = imagePath_lifted.value;
    new_offset += imagePath_lifted.bytesRead;
    final base64Image_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final base64Image = base64Image_lifted.value;
    new_offset += base64Image_lifted.bytesRead;
    return LiftRetVal(
        RecognizeTextRequest(
          imagePath: imagePath,
          base64Image: base64Image,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(RecognizeTextRequest value) {
    final total_length =
        FfiConverterOptionalString.allocationSize(value.imagePath) +
            FfiConverterOptionalString.allocationSize(value.base64Image) +
            0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(RecognizeTextRequest value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterOptionalString.write(
        value.imagePath, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.base64Image, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(RecognizeTextRequest value) {
    return FfiConverterOptionalString.allocationSize(value.imagePath) +
        FfiConverterOptionalString.allocationSize(value.base64Image) +
        0;
  }
}

class RecognizeTextResponse {
  final String text;
  final List<TextRecognition>? recognitions;
  RecognizeTextResponse({
    required this.text,
    this.recognitions,
  });
}

class FfiConverterRecognizeTextResponse {
  static RecognizeTextResponse lift(RustBuffer buf) {
    return FfiConverterRecognizeTextResponse.read(buf.asUint8List()).value;
  }

  static LiftRetVal<RecognizeTextResponse> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final text_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final text = text_lifted.value;
    new_offset += text_lifted.bytesRead;
    final recognitions_lifted =
        FfiConverterOptionalSequenceTextRecognition.read(
            Uint8List.view(buf.buffer, new_offset));
    final recognitions = recognitions_lifted.value;
    new_offset += recognitions_lifted.bytesRead;
    return LiftRetVal(
        RecognizeTextResponse(
          text: text,
          recognitions: recognitions,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(RecognizeTextResponse value) {
    final total_length = FfiConverterString.allocationSize(value.text) +
        FfiConverterOptionalSequenceTextRecognition.allocationSize(
            value.recognitions) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(RecognizeTextResponse value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterString.write(
        value.text, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalSequenceTextRecognition.write(
        value.recognitions, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(RecognizeTextResponse value) {
    return FfiConverterString.allocationSize(value.text) +
        FfiConverterOptionalSequenceTextRecognition.allocationSize(
            value.recognitions) +
        0;
  }
}

class RecognizedRect {
  final double x;
  final double y;
  final double width;
  final double height;
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;
  RecognizedRect({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.top,
    this.right,
    this.bottom,
    this.left,
  });
}

class FfiConverterRecognizedRect {
  static RecognizedRect lift(RustBuffer buf) {
    return FfiConverterRecognizedRect.read(buf.asUint8List()).value;
  }

  static LiftRetVal<RecognizedRect> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final x_lifted =
        FfiConverterDouble64.read(Uint8List.view(buf.buffer, new_offset));
    final x = x_lifted.value;
    new_offset += x_lifted.bytesRead;
    final y_lifted =
        FfiConverterDouble64.read(Uint8List.view(buf.buffer, new_offset));
    final y = y_lifted.value;
    new_offset += y_lifted.bytesRead;
    final width_lifted =
        FfiConverterDouble64.read(Uint8List.view(buf.buffer, new_offset));
    final width = width_lifted.value;
    new_offset += width_lifted.bytesRead;
    final height_lifted =
        FfiConverterDouble64.read(Uint8List.view(buf.buffer, new_offset));
    final height = height_lifted.value;
    new_offset += height_lifted.bytesRead;
    final top_lifted = FfiConverterOptionalDouble64.read(
        Uint8List.view(buf.buffer, new_offset));
    final top = top_lifted.value;
    new_offset += top_lifted.bytesRead;
    final right_lifted = FfiConverterOptionalDouble64.read(
        Uint8List.view(buf.buffer, new_offset));
    final right = right_lifted.value;
    new_offset += right_lifted.bytesRead;
    final bottom_lifted = FfiConverterOptionalDouble64.read(
        Uint8List.view(buf.buffer, new_offset));
    final bottom = bottom_lifted.value;
    new_offset += bottom_lifted.bytesRead;
    final left_lifted = FfiConverterOptionalDouble64.read(
        Uint8List.view(buf.buffer, new_offset));
    final left = left_lifted.value;
    new_offset += left_lifted.bytesRead;
    return LiftRetVal(
        RecognizedRect(
          x: x,
          y: y,
          width: width,
          height: height,
          top: top,
          right: right,
          bottom: bottom,
          left: left,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(RecognizedRect value) {
    final total_length = FfiConverterDouble64.allocationSize(value.x) +
        FfiConverterDouble64.allocationSize(value.y) +
        FfiConverterDouble64.allocationSize(value.width) +
        FfiConverterDouble64.allocationSize(value.height) +
        FfiConverterOptionalDouble64.allocationSize(value.top) +
        FfiConverterOptionalDouble64.allocationSize(value.right) +
        FfiConverterOptionalDouble64.allocationSize(value.bottom) +
        FfiConverterOptionalDouble64.allocationSize(value.left) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(RecognizedRect value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterDouble64.write(
        value.x, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterDouble64.write(
        value.y, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterDouble64.write(
        value.width, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterDouble64.write(
        value.height, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalDouble64.write(
        value.top, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalDouble64.write(
        value.right, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalDouble64.write(
        value.bottom, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalDouble64.write(
        value.left, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(RecognizedRect value) {
    return FfiConverterDouble64.allocationSize(value.x) +
        FfiConverterDouble64.allocationSize(value.y) +
        FfiConverterDouble64.allocationSize(value.width) +
        FfiConverterDouble64.allocationSize(value.height) +
        FfiConverterOptionalDouble64.allocationSize(value.top) +
        FfiConverterOptionalDouble64.allocationSize(value.right) +
        FfiConverterOptionalDouble64.allocationSize(value.bottom) +
        FfiConverterOptionalDouble64.allocationSize(value.left) +
        0;
  }
}

class TextDetection {
  final String detectedLanguage;
  final String text;
  TextDetection({
    required this.detectedLanguage,
    required this.text,
  });
}

class FfiConverterTextDetection {
  static TextDetection lift(RustBuffer buf) {
    return FfiConverterTextDetection.read(buf.asUint8List()).value;
  }

  static LiftRetVal<TextDetection> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final detectedLanguage_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final detectedLanguage = detectedLanguage_lifted.value;
    new_offset += detectedLanguage_lifted.bytesRead;
    final text_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final text = text_lifted.value;
    new_offset += text_lifted.bytesRead;
    return LiftRetVal(
        TextDetection(
          detectedLanguage: detectedLanguage,
          text: text,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(TextDetection value) {
    final total_length =
        FfiConverterString.allocationSize(value.detectedLanguage) +
            FfiConverterString.allocationSize(value.text) +
            0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(TextDetection value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterString.write(
        value.detectedLanguage, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(
        value.text, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(TextDetection value) {
    return FfiConverterString.allocationSize(value.detectedLanguage) +
        FfiConverterString.allocationSize(value.text) +
        0;
  }
}

class TextRecognition {
  final String text;
  final RecognizedRect? recognizedRect;
  TextRecognition({
    required this.text,
    this.recognizedRect,
  });
}

class FfiConverterTextRecognition {
  static TextRecognition lift(RustBuffer buf) {
    return FfiConverterTextRecognition.read(buf.asUint8List()).value;
  }

  static LiftRetVal<TextRecognition> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final text_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final text = text_lifted.value;
    new_offset += text_lifted.bytesRead;
    final recognizedRect_lifted = FfiConverterOptionalRecognizedRect.read(
        Uint8List.view(buf.buffer, new_offset));
    final recognizedRect = recognizedRect_lifted.value;
    new_offset += recognizedRect_lifted.bytesRead;
    return LiftRetVal(
        TextRecognition(
          text: text,
          recognizedRect: recognizedRect,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(TextRecognition value) {
    final total_length = FfiConverterString.allocationSize(value.text) +
        FfiConverterOptionalRecognizedRect.allocationSize(
            value.recognizedRect) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(TextRecognition value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterString.write(
        value.text, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalRecognizedRect.write(
        value.recognizedRect, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(TextRecognition value) {
    return FfiConverterString.allocationSize(value.text) +
        FfiConverterOptionalRecognizedRect.allocationSize(
            value.recognizedRect) +
        0;
  }
}

class TextTranslation {
  final String? detectedSourceLanguage;
  final String text;
  final String? audioUrl;
  TextTranslation({
    this.detectedSourceLanguage,
    required this.text,
    this.audioUrl,
  });
}

class FfiConverterTextTranslation {
  static TextTranslation lift(RustBuffer buf) {
    return FfiConverterTextTranslation.read(buf.asUint8List()).value;
  }

  static LiftRetVal<TextTranslation> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final detectedSourceLanguage_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final detectedSourceLanguage = detectedSourceLanguage_lifted.value;
    new_offset += detectedSourceLanguage_lifted.bytesRead;
    final text_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final text = text_lifted.value;
    new_offset += text_lifted.bytesRead;
    final audioUrl_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final audioUrl = audioUrl_lifted.value;
    new_offset += audioUrl_lifted.bytesRead;
    return LiftRetVal(
        TextTranslation(
          detectedSourceLanguage: detectedSourceLanguage,
          text: text,
          audioUrl: audioUrl,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(TextTranslation value) {
    final total_length = FfiConverterOptionalString.allocationSize(
            value.detectedSourceLanguage) +
        FfiConverterString.allocationSize(value.text) +
        FfiConverterOptionalString.allocationSize(value.audioUrl) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(TextTranslation value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterOptionalString.write(
        value.detectedSourceLanguage, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(
        value.text, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.audioUrl, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(TextTranslation value) {
    return FfiConverterOptionalString.allocationSize(
            value.detectedSourceLanguage) +
        FfiConverterString.allocationSize(value.text) +
        FfiConverterOptionalString.allocationSize(value.audioUrl) +
        0;
  }
}

class TranslateRequest {
  final String? sourceLanguage;
  final String? targetLanguage;
  final String text;
  TranslateRequest({
    this.sourceLanguage,
    this.targetLanguage,
    required this.text,
  });
}

class FfiConverterTranslateRequest {
  static TranslateRequest lift(RustBuffer buf) {
    return FfiConverterTranslateRequest.read(buf.asUint8List()).value;
  }

  static LiftRetVal<TranslateRequest> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final sourceLanguage_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final sourceLanguage = sourceLanguage_lifted.value;
    new_offset += sourceLanguage_lifted.bytesRead;
    final targetLanguage_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final targetLanguage = targetLanguage_lifted.value;
    new_offset += targetLanguage_lifted.bytesRead;
    final text_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final text = text_lifted.value;
    new_offset += text_lifted.bytesRead;
    return LiftRetVal(
        TranslateRequest(
          sourceLanguage: sourceLanguage,
          targetLanguage: targetLanguage,
          text: text,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(TranslateRequest value) {
    final total_length =
        FfiConverterOptionalString.allocationSize(value.sourceLanguage) +
            FfiConverterOptionalString.allocationSize(value.targetLanguage) +
            FfiConverterString.allocationSize(value.text) +
            0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(TranslateRequest value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterOptionalString.write(
        value.sourceLanguage, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.targetLanguage, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(
        value.text, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(TranslateRequest value) {
    return FfiConverterOptionalString.allocationSize(value.sourceLanguage) +
        FfiConverterOptionalString.allocationSize(value.targetLanguage) +
        FfiConverterString.allocationSize(value.text) +
        0;
  }
}

class TranslateResponse {
  final List<TextTranslation> translations;
  TranslateResponse({
    required this.translations,
  });
}

class FfiConverterTranslateResponse {
  static TranslateResponse lift(RustBuffer buf) {
    return FfiConverterTranslateResponse.read(buf.asUint8List()).value;
  }

  static LiftRetVal<TranslateResponse> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final translations_lifted = FfiConverterSequenceTextTranslation.read(
        Uint8List.view(buf.buffer, new_offset));
    final translations = translations_lifted.value;
    new_offset += translations_lifted.bytesRead;
    return LiftRetVal(
        TranslateResponse(
          translations: translations,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(TranslateResponse value) {
    final total_length =
        FfiConverterSequenceTextTranslation.allocationSize(value.translations) +
            0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(TranslateResponse value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterSequenceTextTranslation.write(
        value.translations, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(TranslateResponse value) {
    return FfiConverterSequenceTextTranslation.allocationSize(
            value.translations) +
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

class WordDefinition {
  final String? type;
  final String? name;
  final List<String>? values;
  WordDefinition({
    this.type,
    this.name,
    this.values,
  });
}

class FfiConverterWordDefinition {
  static WordDefinition lift(RustBuffer buf) {
    return FfiConverterWordDefinition.read(buf.asUint8List()).value;
  }

  static LiftRetVal<WordDefinition> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final type_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final type = type_lifted.value;
    new_offset += type_lifted.bytesRead;
    final name_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final name = name_lifted.value;
    new_offset += name_lifted.bytesRead;
    final values_lifted = FfiConverterOptionalSequenceString.read(
        Uint8List.view(buf.buffer, new_offset));
    final values = values_lifted.value;
    new_offset += values_lifted.bytesRead;
    return LiftRetVal(
        WordDefinition(
          type: type,
          name: name,
          values: values,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(WordDefinition value) {
    final total_length = FfiConverterOptionalString.allocationSize(value.type) +
        FfiConverterOptionalString.allocationSize(value.name) +
        FfiConverterOptionalSequenceString.allocationSize(value.values) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(WordDefinition value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterOptionalString.write(
        value.type, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.name, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalSequenceString.write(
        value.values, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(WordDefinition value) {
    return FfiConverterOptionalString.allocationSize(value.type) +
        FfiConverterOptionalString.allocationSize(value.name) +
        FfiConverterOptionalSequenceString.allocationSize(value.values) +
        0;
  }
}

class WordEtymology {
  final String? origin;
  final List<String>? root;
  WordEtymology({
    this.origin,
    this.root,
  });
}

class FfiConverterWordEtymology {
  static WordEtymology lift(RustBuffer buf) {
    return FfiConverterWordEtymology.read(buf.asUint8List()).value;
  }

  static LiftRetVal<WordEtymology> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final origin_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final origin = origin_lifted.value;
    new_offset += origin_lifted.bytesRead;
    final root_lifted = FfiConverterOptionalSequenceString.read(
        Uint8List.view(buf.buffer, new_offset));
    final root = root_lifted.value;
    new_offset += root_lifted.bytesRead;
    return LiftRetVal(
        WordEtymology(
          origin: origin,
          root: root,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(WordEtymology value) {
    final total_length =
        FfiConverterOptionalString.allocationSize(value.origin) +
            FfiConverterOptionalSequenceString.allocationSize(value.root) +
            0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(WordEtymology value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterOptionalString.write(
        value.origin, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalSequenceString.write(
        value.root, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(WordEtymology value) {
    return FfiConverterOptionalString.allocationSize(value.origin) +
        FfiConverterOptionalSequenceString.allocationSize(value.root) +
        0;
  }
}

class WordImage {
  final String url;
  WordImage({
    required this.url,
  });
}

class FfiConverterWordImage {
  static WordImage lift(RustBuffer buf) {
    return FfiConverterWordImage.read(buf.asUint8List()).value;
  }

  static LiftRetVal<WordImage> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final url_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final url = url_lifted.value;
    new_offset += url_lifted.bytesRead;
    return LiftRetVal(
        WordImage(
          url: url,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(WordImage value) {
    final total_length = FfiConverterString.allocationSize(value.url) + 0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(WordImage value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterString.write(
        value.url, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(WordImage value) {
    return FfiConverterString.allocationSize(value.url) + 0;
  }
}

class WordPhrase {
  final String text;
  final List<String> translations;
  WordPhrase({
    required this.text,
    required this.translations,
  });
}

class FfiConverterWordPhrase {
  static WordPhrase lift(RustBuffer buf) {
    return FfiConverterWordPhrase.read(buf.asUint8List()).value;
  }

  static LiftRetVal<WordPhrase> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final text_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final text = text_lifted.value;
    new_offset += text_lifted.bytesRead;
    final translations_lifted =
        FfiConverterSequenceString.read(Uint8List.view(buf.buffer, new_offset));
    final translations = translations_lifted.value;
    new_offset += translations_lifted.bytesRead;
    return LiftRetVal(
        WordPhrase(
          text: text,
          translations: translations,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(WordPhrase value) {
    final total_length = FfiConverterString.allocationSize(value.text) +
        FfiConverterSequenceString.allocationSize(value.translations) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(WordPhrase value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterString.write(
        value.text, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterSequenceString.write(
        value.translations, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(WordPhrase value) {
    return FfiConverterString.allocationSize(value.text) +
        FfiConverterSequenceString.allocationSize(value.translations) +
        0;
  }
}

class WordPronunciation {
  final String? type;
  final String? phoneticSymbol;
  final String? audioUrl;
  WordPronunciation({
    this.type,
    this.phoneticSymbol,
    this.audioUrl,
  });
}

class FfiConverterWordPronunciation {
  static WordPronunciation lift(RustBuffer buf) {
    return FfiConverterWordPronunciation.read(buf.asUint8List()).value;
  }

  static LiftRetVal<WordPronunciation> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final type_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final type = type_lifted.value;
    new_offset += type_lifted.bytesRead;
    final phoneticSymbol_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final phoneticSymbol = phoneticSymbol_lifted.value;
    new_offset += phoneticSymbol_lifted.bytesRead;
    final audioUrl_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final audioUrl = audioUrl_lifted.value;
    new_offset += audioUrl_lifted.bytesRead;
    return LiftRetVal(
        WordPronunciation(
          type: type,
          phoneticSymbol: phoneticSymbol,
          audioUrl: audioUrl,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(WordPronunciation value) {
    final total_length = FfiConverterOptionalString.allocationSize(value.type) +
        FfiConverterOptionalString.allocationSize(value.phoneticSymbol) +
        FfiConverterOptionalString.allocationSize(value.audioUrl) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(WordPronunciation value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterOptionalString.write(
        value.type, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.phoneticSymbol, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.audioUrl, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(WordPronunciation value) {
    return FfiConverterOptionalString.allocationSize(value.type) +
        FfiConverterOptionalString.allocationSize(value.phoneticSymbol) +
        FfiConverterOptionalString.allocationSize(value.audioUrl) +
        0;
  }
}

class WordSentence {
  final String text;
  final List<String> translations;
  WordSentence({
    required this.text,
    required this.translations,
  });
}

class FfiConverterWordSentence {
  static WordSentence lift(RustBuffer buf) {
    return FfiConverterWordSentence.read(buf.asUint8List()).value;
  }

  static LiftRetVal<WordSentence> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final text_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final text = text_lifted.value;
    new_offset += text_lifted.bytesRead;
    final translations_lifted =
        FfiConverterSequenceString.read(Uint8List.view(buf.buffer, new_offset));
    final translations = translations_lifted.value;
    new_offset += translations_lifted.bytesRead;
    return LiftRetVal(
        WordSentence(
          text: text,
          translations: translations,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(WordSentence value) {
    final total_length = FfiConverterString.allocationSize(value.text) +
        FfiConverterSequenceString.allocationSize(value.translations) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(WordSentence value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterString.write(
        value.text, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterSequenceString.write(
        value.translations, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(WordSentence value) {
    return FfiConverterString.allocationSize(value.text) +
        FfiConverterSequenceString.allocationSize(value.translations) +
        0;
  }
}

class WordSynonym {
  final String? type;
  final String word;
  final List<String>? definitions;
  WordSynonym({
    this.type,
    required this.word,
    this.definitions,
  });
}

class FfiConverterWordSynonym {
  static WordSynonym lift(RustBuffer buf) {
    return FfiConverterWordSynonym.read(buf.asUint8List()).value;
  }

  static LiftRetVal<WordSynonym> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final type_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final type = type_lifted.value;
    new_offset += type_lifted.bytesRead;
    final word_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final word = word_lifted.value;
    new_offset += word_lifted.bytesRead;
    final definitions_lifted = FfiConverterOptionalSequenceString.read(
        Uint8List.view(buf.buffer, new_offset));
    final definitions = definitions_lifted.value;
    new_offset += definitions_lifted.bytesRead;
    return LiftRetVal(
        WordSynonym(
          type: type,
          word: word,
          definitions: definitions,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(WordSynonym value) {
    final total_length = FfiConverterOptionalString.allocationSize(value.type) +
        FfiConverterString.allocationSize(value.word) +
        FfiConverterOptionalSequenceString.allocationSize(value.definitions) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(WordSynonym value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterOptionalString.write(
        value.type, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterString.write(
        value.word, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalSequenceString.write(
        value.definitions, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(WordSynonym value) {
    return FfiConverterOptionalString.allocationSize(value.type) +
        FfiConverterString.allocationSize(value.word) +
        FfiConverterOptionalSequenceString.allocationSize(value.definitions) +
        0;
  }
}

class WordTag {
  final String name;
  WordTag({
    required this.name,
  });
}

class FfiConverterWordTag {
  static WordTag lift(RustBuffer buf) {
    return FfiConverterWordTag.read(buf.asUint8List()).value;
  }

  static LiftRetVal<WordTag> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final name_lifted =
        FfiConverterString.read(Uint8List.view(buf.buffer, new_offset));
    final name = name_lifted.value;
    new_offset += name_lifted.bytesRead;
    return LiftRetVal(
        WordTag(
          name: name,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(WordTag value) {
    final total_length = FfiConverterString.allocationSize(value.name) + 0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(WordTag value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterString.write(
        value.name, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(WordTag value) {
    return FfiConverterString.allocationSize(value.name) + 0;
  }
}

class WordTense {
  final String? type;
  final String? name;
  final List<String>? values;
  WordTense({
    this.type,
    this.name,
    this.values,
  });
}

class FfiConverterWordTense {
  static WordTense lift(RustBuffer buf) {
    return FfiConverterWordTense.read(buf.asUint8List()).value;
  }

  static LiftRetVal<WordTense> read(Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    final type_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final type = type_lifted.value;
    new_offset += type_lifted.bytesRead;
    final name_lifted =
        FfiConverterOptionalString.read(Uint8List.view(buf.buffer, new_offset));
    final name = name_lifted.value;
    new_offset += name_lifted.bytesRead;
    final values_lifted = FfiConverterOptionalSequenceString.read(
        Uint8List.view(buf.buffer, new_offset));
    final values = values_lifted.value;
    new_offset += values_lifted.bytesRead;
    return LiftRetVal(
        WordTense(
          type: type,
          name: name,
          values: values,
        ),
        new_offset - buf.offsetInBytes);
  }

  static RustBuffer lower(WordTense value) {
    final total_length = FfiConverterOptionalString.allocationSize(value.type) +
        FfiConverterOptionalString.allocationSize(value.name) +
        FfiConverterOptionalSequenceString.allocationSize(value.values) +
        0;
    final buf = Uint8List(total_length);
    write(value, buf);
    return toRustBuffer(buf);
  }

  static int write(WordTense value, Uint8List buf) {
    int new_offset = buf.offsetInBytes;
    new_offset += FfiConverterOptionalString.write(
        value.type, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalString.write(
        value.name, Uint8List.view(buf.buffer, new_offset));
    new_offset += FfiConverterOptionalSequenceString.write(
        value.values, Uint8List.view(buf.buffer, new_offset));
    return new_offset - buf.offsetInBytes;
  }

  static int allocationSize(WordTense value) {
    return FfiConverterOptionalString.allocationSize(value.type) +
        FfiConverterOptionalString.allocationSize(value.name) +
        FfiConverterOptionalSequenceString.allocationSize(value.values) +
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

enum ProviderCapability {
  dictionary,
  ocr,
  translation,
  ;
}

class FfiConverterProviderCapability {
  static LiftRetVal<ProviderCapability> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    switch (index) {
      case 1:
        return LiftRetVal(
          ProviderCapability.dictionary,
          4,
        );
      case 2:
        return LiftRetVal(
          ProviderCapability.ocr,
          4,
        );
      case 3:
        return LiftRetVal(
          ProviderCapability.translation,
          4,
        );
      default:
        throw UniffiInternalError(UniffiInternalError.unexpectedEnumCase,
            "Unable to determine enum variant");
    }
  }

  static ProviderCapability lift(RustBuffer buffer) {
    return FfiConverterProviderCapability.read(buffer.asUint8List()).value;
  }

  static RustBuffer lower(ProviderCapability input) {
    return toRustBuffer(createUint8ListFromInt(input.index + 1));
  }

  static int allocationSize(ProviderCapability _value) {
    return 4;
  }

  static int write(ProviderCapability value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.index + 1);
    return 4;
  }
}

enum ProviderType {
  baidu,
  caiyun,
  deepL,
  google,
  iciba,
  tencent,
  youdao,
  system,
  ;
}

class FfiConverterProviderType {
  static LiftRetVal<ProviderType> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    switch (index) {
      case 1:
        return LiftRetVal(
          ProviderType.baidu,
          4,
        );
      case 2:
        return LiftRetVal(
          ProviderType.caiyun,
          4,
        );
      case 3:
        return LiftRetVal(
          ProviderType.deepL,
          4,
        );
      case 4:
        return LiftRetVal(
          ProviderType.google,
          4,
        );
      case 5:
        return LiftRetVal(
          ProviderType.iciba,
          4,
        );
      case 6:
        return LiftRetVal(
          ProviderType.tencent,
          4,
        );
      case 7:
        return LiftRetVal(
          ProviderType.youdao,
          4,
        );
      case 8:
        return LiftRetVal(
          ProviderType.system,
          4,
        );
      default:
        throw UniffiInternalError(UniffiInternalError.unexpectedEnumCase,
            "Unable to determine enum variant");
    }
  }

  static ProviderType lift(RustBuffer buffer) {
    return FfiConverterProviderType.read(buffer.asUint8List()).value;
  }

  static RustBuffer lower(ProviderType input) {
    return toRustBuffer(createUint8ListFromInt(input.index + 1));
  }

  static int allocationSize(ProviderType _value) {
    return 4;
  }

  static int write(ProviderType value, Uint8List buf) {
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

enum SettingsChange {
  general,
  appearance,
  shortcuts,
  advanced,
  providers,
  ;
}

class FfiConverterSettingsChange {
  static LiftRetVal<SettingsChange> read(Uint8List buf) {
    final index = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    switch (index) {
      case 1:
        return LiftRetVal(
          SettingsChange.general,
          4,
        );
      case 2:
        return LiftRetVal(
          SettingsChange.appearance,
          4,
        );
      case 3:
        return LiftRetVal(
          SettingsChange.shortcuts,
          4,
        );
      case 4:
        return LiftRetVal(
          SettingsChange.advanced,
          4,
        );
      case 5:
        return LiftRetVal(
          SettingsChange.providers,
          4,
        );
      default:
        throw UniffiInternalError(UniffiInternalError.unexpectedEnumCase,
            "Unable to determine enum variant");
    }
  }

  static SettingsChange lift(RustBuffer buffer) {
    return FfiConverterSettingsChange.read(buffer.asUint8List()).value;
  }

  static RustBuffer lower(SettingsChange input) {
    return toRustBuffer(createUint8ListFromInt(input.index + 1));
  }

  static int allocationSize(SettingsChange _value) {
    return 4;
  }

  static int write(SettingsChange value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.index + 1);
    return 4;
  }
}

abstract class RuntimeApiServerInterface {
  ApiServerInfo info();
  void stop();
}

final _RuntimeApiServerFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) =>
      uniffi_beyondtranslate_runtime_fn_free_runtimeapiserver(ptr, status));
});

class RuntimeApiServer implements RuntimeApiServerInterface {
  late final Pointer<Void> _ptr;
  RuntimeApiServer._(this._ptr) {
    _RuntimeApiServerFinalizer.attach(this, _ptr, detach: this);
  }
  factory RuntimeApiServer.lift(Pointer<Void> ptr) {
    return RuntimeApiServer._(ptr);
  }
  static Pointer<Void> lower(RuntimeApiServer value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall((status) =>
        uniffi_beyondtranslate_runtime_fn_clone_runtimeapiserver(_ptr, status));
  }

  static int allocationSize(RuntimeApiServer value) {
    return 8;
  }

  static LiftRetVal<RuntimeApiServer> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(RuntimeApiServer.lift(pointer), 8);
  }

  static int write(RuntimeApiServer value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _RuntimeApiServerFinalizer.detach(this);
    rustCall((status) =>
        uniffi_beyondtranslate_runtime_fn_free_runtimeapiserver(_ptr, status));
  }

  ApiServerInfo info() {
    return rustCallWithLifter(
        (status) =>
            uniffi_beyondtranslate_runtime_fn_method_runtimeapiserver_info(
                uniffiClonePointer(), status),
        FfiConverterApiServerInfo.lift,
        null);
  }

  void stop() {
    return rustCall((status) {
      uniffi_beyondtranslate_runtime_fn_method_runtimeapiserver_stop(
          uniffiClonePointer(), status);
    }, null);
  }
}

abstract class RuntimeInterface {
  RuntimeDictionary dictionary({
    required String providerId,
  });
  List<LanguageInfo> listAppLanguages();
  List<LanguageInfo> listLanguages();
  RuntimeOcr ocr({
    required String providerId,
  });
  RuntimePermission permission();
  RuntimeSettings settings();
  RuntimeApiServer startApiServer({
    required String host,
    required int port,
  });
  RuntimeTextExtractor textExtractor();
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

  List<LanguageInfo> listAppLanguages() {
    return rustCallWithLifter(
        (status) =>
            uniffi_beyondtranslate_runtime_fn_method_runtime_list_app_languages(
                uniffiClonePointer(), status),
        FfiConverterSequenceLanguageInfo.lift,
        null);
  }

  List<LanguageInfo> listLanguages() {
    return rustCallWithLifter(
        (status) =>
            uniffi_beyondtranslate_runtime_fn_method_runtime_list_languages(
                uniffiClonePointer(), status),
        FfiConverterSequenceLanguageInfo.lift,
        null);
  }

  RuntimeOcr ocr({
    required String providerId,
  }) {
    return rustCallWithLifter(
        (status) => uniffi_beyondtranslate_runtime_fn_method_runtime_ocr(
            uniffiClonePointer(), FfiConverterString.lower(providerId), status),
        RuntimeOcr.lift,
        runtimeExceptionErrorHandler);
  }

  RuntimePermission permission() {
    return rustCallWithLifter(
        (status) => uniffi_beyondtranslate_runtime_fn_method_runtime_permission(
            uniffiClonePointer(), status),
        RuntimePermission.lift,
        null);
  }

  RuntimeSettings settings() {
    return rustCallWithLifter(
        (status) => uniffi_beyondtranslate_runtime_fn_method_runtime_settings(
            uniffiClonePointer(), status),
        RuntimeSettings.lift,
        null);
  }

  RuntimeApiServer startApiServer({
    required String host,
    required int port,
  }) {
    return rustCallWithLifter(
        (status) =>
            uniffi_beyondtranslate_runtime_fn_method_runtime_start_api_server(
                uniffiClonePointer(),
                FfiConverterString.lower(host),
                FfiConverterUInt16.lower(port),
                status),
        RuntimeApiServer.lift,
        runtimeExceptionErrorHandler);
  }

  RuntimeTextExtractor textExtractor() {
    return rustCallWithLifter(
        (status) =>
            uniffi_beyondtranslate_runtime_fn_method_runtime_text_extractor(
                uniffiClonePointer(), status),
        RuntimeTextExtractor.lift,
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
      FfiConverterLookUpResponse.lift,
      runtimeExceptionErrorHandler,
    );
  }
}

abstract class RuntimeOcrInterface {
  Future<RecognizeTextResponse> recognizeText({
    required RecognizeTextRequest request,
  });
}

final _RuntimeOcrFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) =>
      uniffi_beyondtranslate_runtime_fn_free_runtimeocr(ptr, status));
});

class RuntimeOcr implements RuntimeOcrInterface {
  late final Pointer<Void> _ptr;
  RuntimeOcr._(this._ptr) {
    _RuntimeOcrFinalizer.attach(this, _ptr, detach: this);
  }
  factory RuntimeOcr.lift(Pointer<Void> ptr) {
    return RuntimeOcr._(ptr);
  }
  static Pointer<Void> lower(RuntimeOcr value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall((status) =>
        uniffi_beyondtranslate_runtime_fn_clone_runtimeocr(_ptr, status));
  }

  static int allocationSize(RuntimeOcr value) {
    return 8;
  }

  static LiftRetVal<RuntimeOcr> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(RuntimeOcr.lift(pointer), 8);
  }

  static int write(RuntimeOcr value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _RuntimeOcrFinalizer.detach(this);
    rustCall((status) =>
        uniffi_beyondtranslate_runtime_fn_free_runtimeocr(_ptr, status));
  }

  Future<RecognizeTextResponse> recognizeText({
    required RecognizeTextRequest request,
  }) {
    return uniffiRustCallAsync(
      () => uniffi_beyondtranslate_runtime_fn_method_runtimeocr_recognize_text(
        uniffiClonePointer(),
        FfiConverterRecognizeTextRequest.lower(request),
      ),
      ffi_beyondtranslate_runtime_rust_future_poll_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_complete_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_free_rust_buffer,
      FfiConverterRecognizeTextResponse.lift,
      runtimeExceptionErrorHandler,
    );
  }
}

abstract class RuntimePermissionInterface {
  Future<bool> isAccessibilityPermissionGranted();
  Future<bool> isScreenRecordingPermissionGranted();
  Future<void> requestAccessibilityPermission({
    required bool onlyOpenSystemSettings,
  });
  Future<void> requestScreenRecordingPermission({
    required bool onlyOpenSystemSettings,
  });
}

final _RuntimePermissionFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) =>
      uniffi_beyondtranslate_runtime_fn_free_runtimepermission(ptr, status));
});

class RuntimePermission implements RuntimePermissionInterface {
  late final Pointer<Void> _ptr;
  RuntimePermission._(this._ptr) {
    _RuntimePermissionFinalizer.attach(this, _ptr, detach: this);
  }
  factory RuntimePermission.lift(Pointer<Void> ptr) {
    return RuntimePermission._(ptr);
  }
  static Pointer<Void> lower(RuntimePermission value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall((status) =>
        uniffi_beyondtranslate_runtime_fn_clone_runtimepermission(
            _ptr, status));
  }

  static int allocationSize(RuntimePermission value) {
    return 8;
  }

  static LiftRetVal<RuntimePermission> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(RuntimePermission.lift(pointer), 8);
  }

  static int write(RuntimePermission value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _RuntimePermissionFinalizer.detach(this);
    rustCall((status) =>
        uniffi_beyondtranslate_runtime_fn_free_runtimepermission(_ptr, status));
  }

  Future<bool> isAccessibilityPermissionGranted() {
    return uniffiRustCallAsync(
      () =>
          uniffi_beyondtranslate_runtime_fn_method_runtimepermission_is_accessibility_permission_granted(
        uniffiClonePointer(),
      ),
      ffi_beyondtranslate_runtime_rust_future_poll_i8,
      ffi_beyondtranslate_runtime_rust_future_complete_i8,
      ffi_beyondtranslate_runtime_rust_future_free_i8,
      FfiConverterBool.lift,
      null,
    );
  }

  Future<bool> isScreenRecordingPermissionGranted() {
    return uniffiRustCallAsync(
      () =>
          uniffi_beyondtranslate_runtime_fn_method_runtimepermission_is_screen_recording_permission_granted(
        uniffiClonePointer(),
      ),
      ffi_beyondtranslate_runtime_rust_future_poll_i8,
      ffi_beyondtranslate_runtime_rust_future_complete_i8,
      ffi_beyondtranslate_runtime_rust_future_free_i8,
      FfiConverterBool.lift,
      null,
    );
  }

  Future<void> requestAccessibilityPermission({
    required bool onlyOpenSystemSettings,
  }) {
    return uniffiRustCallAsync(
      () =>
          uniffi_beyondtranslate_runtime_fn_method_runtimepermission_request_accessibility_permission(
        uniffiClonePointer(),
        FfiConverterBool.lower(onlyOpenSystemSettings),
      ),
      ffi_beyondtranslate_runtime_rust_future_poll_void,
      ffi_beyondtranslate_runtime_rust_future_complete_void,
      ffi_beyondtranslate_runtime_rust_future_free_void,
      (_) {},
      null,
    );
  }

  Future<void> requestScreenRecordingPermission({
    required bool onlyOpenSystemSettings,
  }) {
    return uniffiRustCallAsync(
      () =>
          uniffi_beyondtranslate_runtime_fn_method_runtimepermission_request_screen_recording_permission(
        uniffiClonePointer(),
        FfiConverterBool.lower(onlyOpenSystemSettings),
      ),
      ffi_beyondtranslate_runtime_rust_future_poll_void,
      ffi_beyondtranslate_runtime_rust_future_complete_void,
      ffi_beyondtranslate_runtime_rust_future_free_void,
      (_) {},
      null,
    );
  }
}

abstract class RuntimeSettingsInterface {
  Future<ProviderConfigEntry?> deleteProvider({
    required String providerId,
  });
  Future<String> generateProviderId({
    required String providerType,
  });
  Future<List<TranslationTarget>> getActiveTranslationTargets({
    required List<TranslationTarget> targets,
    required String? detectedLanguage,
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
  Future<ShortcutSettings> resetShortcuts();
  SettingsSubscription subscribe();
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

  Future<String> generateProviderId({
    required String providerType,
  }) {
    return uniffiRustCallAsync(
      () =>
          uniffi_beyondtranslate_runtime_fn_method_runtimesettings_generate_provider_id(
        uniffiClonePointer(),
        FfiConverterString.lower(providerType),
      ),
      ffi_beyondtranslate_runtime_rust_future_poll_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_complete_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_free_rust_buffer,
      FfiConverterString.lift,
      runtimeExceptionErrorHandler,
    );
  }

  Future<List<TranslationTarget>> getActiveTranslationTargets({
    required List<TranslationTarget> targets,
    required String? detectedLanguage,
  }) {
    return uniffiRustCallAsync(
      () =>
          uniffi_beyondtranslate_runtime_fn_method_runtimesettings_get_active_translation_targets(
        uniffiClonePointer(),
        FfiConverterSequenceTranslationTarget.lower(targets),
        FfiConverterOptionalString.lower(detectedLanguage),
      ),
      ffi_beyondtranslate_runtime_rust_future_poll_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_complete_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_free_rust_buffer,
      FfiConverterSequenceTranslationTarget.lift,
      null,
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

  Future<ShortcutSettings> resetShortcuts() {
    return uniffiRustCallAsync(
      () =>
          uniffi_beyondtranslate_runtime_fn_method_runtimesettings_reset_shortcuts(
        uniffiClonePointer(),
      ),
      ffi_beyondtranslate_runtime_rust_future_poll_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_complete_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_free_rust_buffer,
      FfiConverterShortcutSettings.lift,
      runtimeExceptionErrorHandler,
    );
  }

  SettingsSubscription subscribe() {
    return rustCallWithLifter(
        (status) =>
            uniffi_beyondtranslate_runtime_fn_method_runtimesettings_subscribe(
                uniffiClonePointer(), status),
        SettingsSubscription.lift,
        null);
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

abstract class RuntimeTextExtractorInterface {
  Future<String> extractFromClipboard();
  Future<String> extractFromScreenCapture();
  Future<String> extractFromScreenSelection();
}

final _RuntimeTextExtractorFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) =>
      uniffi_beyondtranslate_runtime_fn_free_runtimetextextractor(ptr, status));
});

class RuntimeTextExtractor implements RuntimeTextExtractorInterface {
  late final Pointer<Void> _ptr;
  RuntimeTextExtractor._(this._ptr) {
    _RuntimeTextExtractorFinalizer.attach(this, _ptr, detach: this);
  }
  factory RuntimeTextExtractor.lift(Pointer<Void> ptr) {
    return RuntimeTextExtractor._(ptr);
  }
  static Pointer<Void> lower(RuntimeTextExtractor value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall((status) =>
        uniffi_beyondtranslate_runtime_fn_clone_runtimetextextractor(
            _ptr, status));
  }

  static int allocationSize(RuntimeTextExtractor value) {
    return 8;
  }

  static LiftRetVal<RuntimeTextExtractor> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(RuntimeTextExtractor.lift(pointer), 8);
  }

  static int write(RuntimeTextExtractor value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _RuntimeTextExtractorFinalizer.detach(this);
    rustCall((status) =>
        uniffi_beyondtranslate_runtime_fn_free_runtimetextextractor(
            _ptr, status));
  }

  Future<String> extractFromClipboard() {
    return uniffiRustCallAsync(
      () =>
          uniffi_beyondtranslate_runtime_fn_method_runtimetextextractor_extract_from_clipboard(
        uniffiClonePointer(),
      ),
      ffi_beyondtranslate_runtime_rust_future_poll_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_complete_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_free_rust_buffer,
      FfiConverterString.lift,
      runtimeExceptionErrorHandler,
    );
  }

  Future<String> extractFromScreenCapture() {
    return uniffiRustCallAsync(
      () =>
          uniffi_beyondtranslate_runtime_fn_method_runtimetextextractor_extract_from_screen_capture(
        uniffiClonePointer(),
      ),
      ffi_beyondtranslate_runtime_rust_future_poll_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_complete_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_free_rust_buffer,
      FfiConverterString.lift,
      runtimeExceptionErrorHandler,
    );
  }

  Future<String> extractFromScreenSelection() {
    return uniffiRustCallAsync(
      () =>
          uniffi_beyondtranslate_runtime_fn_method_runtimetextextractor_extract_from_screen_selection(
        uniffiClonePointer(),
      ),
      ffi_beyondtranslate_runtime_rust_future_poll_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_complete_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_free_rust_buffer,
      FfiConverterString.lift,
      runtimeExceptionErrorHandler,
    );
  }
}

abstract class RuntimeTranslationInterface {
  Future<DetectLanguageResponse> detectLanguage({
    required DetectLanguageRequest request,
  });
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

  Future<DetectLanguageResponse> detectLanguage({
    required DetectLanguageRequest request,
  }) {
    return uniffiRustCallAsync(
      () =>
          uniffi_beyondtranslate_runtime_fn_method_runtimetranslation_detect_language(
        uniffiClonePointer(),
        FfiConverterDetectLanguageRequest.lower(request),
      ),
      ffi_beyondtranslate_runtime_rust_future_poll_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_complete_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_free_rust_buffer,
      FfiConverterDetectLanguageResponse.lift,
      runtimeExceptionErrorHandler,
    );
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
      FfiConverterTranslateResponse.lift,
      runtimeExceptionErrorHandler,
    );
  }
}

abstract class SettingsSubscriptionInterface {
  Future<SettingsChange?> next();
}

final _SettingsSubscriptionFinalizer = Finalizer<Pointer<Void>>((ptr) {
  rustCall((status) =>
      uniffi_beyondtranslate_runtime_fn_free_settingssubscription(ptr, status));
});

class SettingsSubscription implements SettingsSubscriptionInterface {
  late final Pointer<Void> _ptr;
  SettingsSubscription._(this._ptr) {
    _SettingsSubscriptionFinalizer.attach(this, _ptr, detach: this);
  }
  factory SettingsSubscription.lift(Pointer<Void> ptr) {
    return SettingsSubscription._(ptr);
  }
  static Pointer<Void> lower(SettingsSubscription value) {
    return value.uniffiClonePointer();
  }

  Pointer<Void> uniffiClonePointer() {
    return rustCall((status) =>
        uniffi_beyondtranslate_runtime_fn_clone_settingssubscription(
            _ptr, status));
  }

  static int allocationSize(SettingsSubscription value) {
    return 8;
  }

  static LiftRetVal<SettingsSubscription> read(Uint8List buf) {
    final handle = buf.buffer.asByteData(buf.offsetInBytes).getInt64(0);
    final pointer = Pointer<Void>.fromAddress(handle);
    return LiftRetVal(SettingsSubscription.lift(pointer), 8);
  }

  static int write(SettingsSubscription value, Uint8List buf) {
    final handle = lower(value);
    buf.buffer.asByteData(buf.offsetInBytes).setInt64(0, handle.address);
    return 8;
  }

  void dispose() {
    _SettingsSubscriptionFinalizer.detach(this);
    rustCall((status) =>
        uniffi_beyondtranslate_runtime_fn_free_settingssubscription(
            _ptr, status));
  }

  Future<SettingsChange?> next() {
    return uniffiRustCallAsync(
      () => uniffi_beyondtranslate_runtime_fn_method_settingssubscription_next(
        uniffiClonePointer(),
      ),
      ffi_beyondtranslate_runtime_rust_future_poll_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_complete_rust_buffer,
      ffi_beyondtranslate_runtime_rust_future_free_rust_buffer,
      FfiConverterOptionalSettingsChange.lift,
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

class FfiConverterDouble64 {
  static double lift(double value) => value;
  static LiftRetVal<double> read(Uint8List buf) {
    return LiftRetVal(
        buf.buffer.asByteData(buf.offsetInBytes).getFloat64(0), 8);
  }

  static double lower(double value) => value;
  static int allocationSize([double value = 0]) {
    return 8;
  }

  static int write(double value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setFloat64(0, value);
    return FfiConverterDouble64.allocationSize();
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

class FfiConverterOptionalDouble64 {
  static double? lift(RustBuffer buf) {
    return FfiConverterOptionalDouble64.read(buf.asUint8List()).value;
  }

  static LiftRetVal<double?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterDouble64.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<double?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([double? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterDouble64.allocationSize(value) + 1;
  }

  static RustBuffer lower(double? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalDouble64.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalDouble64.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(double? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterDouble64.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
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

class FfiConverterOptionalRecognizedRect {
  static RecognizedRect? lift(RustBuffer buf) {
    return FfiConverterOptionalRecognizedRect.read(buf.asUint8List()).value;
  }

  static LiftRetVal<RecognizedRect?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterRecognizedRect.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<RecognizedRect?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([RecognizedRect? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterRecognizedRect.allocationSize(value) + 1;
  }

  static RustBuffer lower(RecognizedRect? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalRecognizedRect.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalRecognizedRect.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(RecognizedRect? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterRecognizedRect.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

class FfiConverterOptionalSequenceString {
  static List<String>? lift(RustBuffer buf) {
    return FfiConverterOptionalSequenceString.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<String>?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterSequenceString.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<List<String>?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([List<String>? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterSequenceString.allocationSize(value) + 1;
  }

  static RustBuffer lower(List<String>? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalSequenceString.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalSequenceString.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(List<String>? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterSequenceString.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

class FfiConverterOptionalSequenceTextDetection {
  static List<TextDetection>? lift(RustBuffer buf) {
    return FfiConverterOptionalSequenceTextDetection.read(buf.asUint8List())
        .value;
  }

  static LiftRetVal<List<TextDetection>?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterSequenceTextDetection.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<List<TextDetection>?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([List<TextDetection>? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterSequenceTextDetection.allocationSize(value) + 1;
  }

  static RustBuffer lower(List<TextDetection>? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length =
        FfiConverterOptionalSequenceTextDetection.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalSequenceTextDetection.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(List<TextDetection>? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterSequenceTextDetection.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

class FfiConverterSequenceTextDetection {
  static List<TextDetection> lift(RustBuffer buf) {
    return FfiConverterSequenceTextDetection.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<TextDetection>> read(Uint8List buf) {
    List<TextDetection> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret =
          FfiConverterTextDetection.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<TextDetection> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterTextDetection.write(
          value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<TextDetection> value) {
    return value
            .map((l) => FfiConverterTextDetection.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<TextDetection> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalSequenceTextRecognition {
  static List<TextRecognition>? lift(RustBuffer buf) {
    return FfiConverterOptionalSequenceTextRecognition.read(buf.asUint8List())
        .value;
  }

  static LiftRetVal<List<TextRecognition>?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterSequenceTextRecognition.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<List<TextRecognition>?>(
        result.value, result.bytesRead + 1);
  }

  static int allocationSize([List<TextRecognition>? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterSequenceTextRecognition.allocationSize(value) + 1;
  }

  static RustBuffer lower(List<TextRecognition>? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length =
        FfiConverterOptionalSequenceTextRecognition.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalSequenceTextRecognition.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(List<TextRecognition>? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterSequenceTextRecognition.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

class FfiConverterSequenceTextRecognition {
  static List<TextRecognition> lift(RustBuffer buf) {
    return FfiConverterSequenceTextRecognition.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<TextRecognition>> read(Uint8List buf) {
    List<TextRecognition> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret =
          FfiConverterTextRecognition.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<TextRecognition> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterTextRecognition.write(
          value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<TextRecognition> value) {
    return value
            .map((l) => FfiConverterTextRecognition.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<TextRecognition> value) {
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

class FfiConverterOptionalSequenceWordDefinition {
  static List<WordDefinition>? lift(RustBuffer buf) {
    return FfiConverterOptionalSequenceWordDefinition.read(buf.asUint8List())
        .value;
  }

  static LiftRetVal<List<WordDefinition>?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterSequenceWordDefinition.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<List<WordDefinition>?>(
        result.value, result.bytesRead + 1);
  }

  static int allocationSize([List<WordDefinition>? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterSequenceWordDefinition.allocationSize(value) + 1;
  }

  static RustBuffer lower(List<WordDefinition>? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length =
        FfiConverterOptionalSequenceWordDefinition.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalSequenceWordDefinition.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(List<WordDefinition>? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterSequenceWordDefinition.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

class FfiConverterSequenceWordDefinition {
  static List<WordDefinition> lift(RustBuffer buf) {
    return FfiConverterSequenceWordDefinition.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<WordDefinition>> read(Uint8List buf) {
    List<WordDefinition> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret =
          FfiConverterWordDefinition.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<WordDefinition> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterWordDefinition.write(
          value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<WordDefinition> value) {
    return value
            .map((l) => FfiConverterWordDefinition.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<WordDefinition> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalSequenceWordEtymology {
  static List<WordEtymology>? lift(RustBuffer buf) {
    return FfiConverterOptionalSequenceWordEtymology.read(buf.asUint8List())
        .value;
  }

  static LiftRetVal<List<WordEtymology>?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterSequenceWordEtymology.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<List<WordEtymology>?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([List<WordEtymology>? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterSequenceWordEtymology.allocationSize(value) + 1;
  }

  static RustBuffer lower(List<WordEtymology>? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length =
        FfiConverterOptionalSequenceWordEtymology.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalSequenceWordEtymology.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(List<WordEtymology>? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterSequenceWordEtymology.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

class FfiConverterSequenceWordEtymology {
  static List<WordEtymology> lift(RustBuffer buf) {
    return FfiConverterSequenceWordEtymology.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<WordEtymology>> read(Uint8List buf) {
    List<WordEtymology> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret =
          FfiConverterWordEtymology.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<WordEtymology> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterWordEtymology.write(
          value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<WordEtymology> value) {
    return value
            .map((l) => FfiConverterWordEtymology.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<WordEtymology> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalSequenceWordImage {
  static List<WordImage>? lift(RustBuffer buf) {
    return FfiConverterOptionalSequenceWordImage.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<WordImage>?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterSequenceWordImage.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<List<WordImage>?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([List<WordImage>? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterSequenceWordImage.allocationSize(value) + 1;
  }

  static RustBuffer lower(List<WordImage>? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalSequenceWordImage.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalSequenceWordImage.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(List<WordImage>? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterSequenceWordImage.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

class FfiConverterSequenceWordImage {
  static List<WordImage> lift(RustBuffer buf) {
    return FfiConverterSequenceWordImage.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<WordImage>> read(Uint8List buf) {
    List<WordImage> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret =
          FfiConverterWordImage.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<WordImage> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterWordImage.write(
          value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<WordImage> value) {
    return value
            .map((l) => FfiConverterWordImage.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<WordImage> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalSequenceWordPhrase {
  static List<WordPhrase>? lift(RustBuffer buf) {
    return FfiConverterOptionalSequenceWordPhrase.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<WordPhrase>?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterSequenceWordPhrase.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<List<WordPhrase>?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([List<WordPhrase>? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterSequenceWordPhrase.allocationSize(value) + 1;
  }

  static RustBuffer lower(List<WordPhrase>? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalSequenceWordPhrase.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalSequenceWordPhrase.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(List<WordPhrase>? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterSequenceWordPhrase.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

class FfiConverterSequenceWordPhrase {
  static List<WordPhrase> lift(RustBuffer buf) {
    return FfiConverterSequenceWordPhrase.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<WordPhrase>> read(Uint8List buf) {
    List<WordPhrase> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret =
          FfiConverterWordPhrase.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<WordPhrase> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterWordPhrase.write(
          value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<WordPhrase> value) {
    return value
            .map((l) => FfiConverterWordPhrase.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<WordPhrase> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalSequenceWordPronunciation {
  static List<WordPronunciation>? lift(RustBuffer buf) {
    return FfiConverterOptionalSequenceWordPronunciation.read(buf.asUint8List())
        .value;
  }

  static LiftRetVal<List<WordPronunciation>?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterSequenceWordPronunciation.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<List<WordPronunciation>?>(
        result.value, result.bytesRead + 1);
  }

  static int allocationSize([List<WordPronunciation>? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterSequenceWordPronunciation.allocationSize(value) + 1;
  }

  static RustBuffer lower(List<WordPronunciation>? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length =
        FfiConverterOptionalSequenceWordPronunciation.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalSequenceWordPronunciation.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(List<WordPronunciation>? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterSequenceWordPronunciation.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

class FfiConverterSequenceWordPronunciation {
  static List<WordPronunciation> lift(RustBuffer buf) {
    return FfiConverterSequenceWordPronunciation.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<WordPronunciation>> read(Uint8List buf) {
    List<WordPronunciation> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterWordPronunciation.read(
          Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<WordPronunciation> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterWordPronunciation.write(
          value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<WordPronunciation> value) {
    return value
            .map((l) => FfiConverterWordPronunciation.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<WordPronunciation> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalSequenceWordSentence {
  static List<WordSentence>? lift(RustBuffer buf) {
    return FfiConverterOptionalSequenceWordSentence.read(buf.asUint8List())
        .value;
  }

  static LiftRetVal<List<WordSentence>?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterSequenceWordSentence.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<List<WordSentence>?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([List<WordSentence>? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterSequenceWordSentence.allocationSize(value) + 1;
  }

  static RustBuffer lower(List<WordSentence>? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length =
        FfiConverterOptionalSequenceWordSentence.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalSequenceWordSentence.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(List<WordSentence>? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterSequenceWordSentence.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

class FfiConverterSequenceWordSentence {
  static List<WordSentence> lift(RustBuffer buf) {
    return FfiConverterSequenceWordSentence.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<WordSentence>> read(Uint8List buf) {
    List<WordSentence> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret =
          FfiConverterWordSentence.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<WordSentence> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterWordSentence.write(
          value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<WordSentence> value) {
    return value
            .map((l) => FfiConverterWordSentence.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<WordSentence> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalSequenceWordSynonym {
  static List<WordSynonym>? lift(RustBuffer buf) {
    return FfiConverterOptionalSequenceWordSynonym.read(buf.asUint8List())
        .value;
  }

  static LiftRetVal<List<WordSynonym>?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterSequenceWordSynonym.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<List<WordSynonym>?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([List<WordSynonym>? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterSequenceWordSynonym.allocationSize(value) + 1;
  }

  static RustBuffer lower(List<WordSynonym>? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length =
        FfiConverterOptionalSequenceWordSynonym.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalSequenceWordSynonym.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(List<WordSynonym>? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterSequenceWordSynonym.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

class FfiConverterSequenceWordSynonym {
  static List<WordSynonym> lift(RustBuffer buf) {
    return FfiConverterSequenceWordSynonym.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<WordSynonym>> read(Uint8List buf) {
    List<WordSynonym> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret =
          FfiConverterWordSynonym.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<WordSynonym> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterWordSynonym.write(
          value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<WordSynonym> value) {
    return value
            .map((l) => FfiConverterWordSynonym.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<WordSynonym> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalSequenceWordTag {
  static List<WordTag>? lift(RustBuffer buf) {
    return FfiConverterOptionalSequenceWordTag.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<WordTag>?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterSequenceWordTag.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<List<WordTag>?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([List<WordTag>? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterSequenceWordTag.allocationSize(value) + 1;
  }

  static RustBuffer lower(List<WordTag>? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalSequenceWordTag.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalSequenceWordTag.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(List<WordTag>? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterSequenceWordTag.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

class FfiConverterSequenceWordTag {
  static List<WordTag> lift(RustBuffer buf) {
    return FfiConverterSequenceWordTag.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<WordTag>> read(Uint8List buf) {
    List<WordTag> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterWordTag.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<WordTag> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterWordTag.write(
          value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<WordTag> value) {
    return value
            .map((l) => FfiConverterWordTag.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<WordTag> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalSequenceWordTense {
  static List<WordTense>? lift(RustBuffer buf) {
    return FfiConverterOptionalSequenceWordTense.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<WordTense>?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterSequenceWordTense.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<List<WordTense>?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([List<WordTense>? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterSequenceWordTense.allocationSize(value) + 1;
  }

  static RustBuffer lower(List<WordTense>? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalSequenceWordTense.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalSequenceWordTense.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(List<WordTense>? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterSequenceWordTense.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

class FfiConverterSequenceWordTense {
  static List<WordTense> lift(RustBuffer buf) {
    return FfiConverterSequenceWordTense.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<WordTense>> read(Uint8List buf) {
    List<WordTense> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret =
          FfiConverterWordTense.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<WordTense> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterWordTense.write(
          value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<WordTense> value) {
    return value
            .map((l) => FfiConverterWordTense.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<WordTense> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterOptionalSettingsChange {
  static SettingsChange? lift(RustBuffer buf) {
    return FfiConverterOptionalSettingsChange.read(buf.asUint8List()).value;
  }

  static LiftRetVal<SettingsChange?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterSettingsChange.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<SettingsChange?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([SettingsChange? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterSettingsChange.allocationSize(value) + 1;
  }

  static RustBuffer lower(SettingsChange? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalSettingsChange.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalSettingsChange.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(SettingsChange? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterSettingsChange.write(
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

class FfiConverterOptionalUInt16 {
  static int? lift(RustBuffer buf) {
    return FfiConverterOptionalUInt16.read(buf.asUint8List()).value;
  }

  static LiftRetVal<int?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterUInt16.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<int?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([int? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterUInt16.allocationSize(value) + 1;
  }

  static RustBuffer lower(int? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalUInt16.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalUInt16.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(int? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterUInt16.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

class FfiConverterOptionalUInt64 {
  static int? lift(RustBuffer buf) {
    return FfiConverterOptionalUInt64.read(buf.asUint8List()).value;
  }

  static LiftRetVal<int?> read(Uint8List buf) {
    if (ByteData.view(buf.buffer, buf.offsetInBytes).getInt8(0) == 0) {
      return LiftRetVal(null, 1);
    }
    final result = FfiConverterUInt64.read(
        Uint8List.view(buf.buffer, buf.offsetInBytes + 1));
    return LiftRetVal<int?>(result.value, result.bytesRead + 1);
  }

  static int allocationSize([int? value]) {
    if (value == null) {
      return 1;
    }
    return FfiConverterUInt64.allocationSize(value) + 1;
  }

  static RustBuffer lower(int? value) {
    if (value == null) {
      return toRustBuffer(Uint8List.fromList([0]));
    }
    final length = FfiConverterOptionalUInt64.allocationSize(value);
    final Pointer<Uint8> frameData = calloc<Uint8>(length);
    final buf = frameData.asTypedList(length);
    FfiConverterOptionalUInt64.write(value, buf);
    final bytes = calloc<ForeignBytes>();
    bytes.ref.len = length;
    bytes.ref.data = frameData;
    return RustBuffer.fromBytes(bytes.ref);
  }

  static int write(int? value, Uint8List buf) {
    if (value == null) {
      buf[0] = 0;
      return 1;
    }
    buf[0] = 1;
    return FfiConverterUInt64.write(
            value, Uint8List.view(buf.buffer, buf.offsetInBytes + 1)) +
        1;
  }
}

class FfiConverterUInt64 {
  static int lift(int value) => value;
  static LiftRetVal<int> read(Uint8List buf) {
    return LiftRetVal(buf.buffer.asByteData(buf.offsetInBytes).getUint64(0), 8);
  }

  static int lower(int value) {
    if (value < 0) {
      throw ArgumentError("Value out of range for u64: " + value.toString());
    }
    return value;
  }

  static int allocationSize([int value = 0]) {
    return 8;
  }

  static int write(int value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setUint64(0, lower(value));
    return 8;
  }
}

class FfiConverterSequenceLanguageInfo {
  static List<LanguageInfo> lift(RustBuffer buf) {
    return FfiConverterSequenceLanguageInfo.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<LanguageInfo>> read(Uint8List buf) {
    List<LanguageInfo> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret =
          FfiConverterLanguageInfo.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<LanguageInfo> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterLanguageInfo.write(
          value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<LanguageInfo> value) {
    return value
            .map((l) => FfiConverterLanguageInfo.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<LanguageInfo> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
  }
}

class FfiConverterSequenceProviderCapability {
  static List<ProviderCapability> lift(RustBuffer buf) {
    return FfiConverterSequenceProviderCapability.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<ProviderCapability>> read(Uint8List buf) {
    List<ProviderCapability> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret = FfiConverterProviderCapability.read(
          Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<ProviderCapability> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterProviderCapability.write(
          value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<ProviderCapability> value) {
    return value
            .map((l) => FfiConverterProviderCapability.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<ProviderCapability> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
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

class FfiConverterSequenceTextTranslation {
  static List<TextTranslation> lift(RustBuffer buf) {
    return FfiConverterSequenceTextTranslation.read(buf.asUint8List()).value;
  }

  static LiftRetVal<List<TextTranslation>> read(Uint8List buf) {
    List<TextTranslation> res = [];
    final length = buf.buffer.asByteData(buf.offsetInBytes).getInt32(0);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < length; i++) {
      final ret =
          FfiConverterTextTranslation.read(Uint8List.view(buf.buffer, offset));
      offset += ret.bytesRead;
      res.add(ret.value);
    }
    return LiftRetVal(res, offset - buf.offsetInBytes);
  }

  static int write(List<TextTranslation> value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setInt32(0, value.length);
    int offset = buf.offsetInBytes + 4;
    for (var i = 0; i < value.length; i++) {
      offset += FfiConverterTextTranslation.write(
          value[i], Uint8List.view(buf.buffer, offset));
    }
    return offset - buf.offsetInBytes;
  }

  static int allocationSize(List<TextTranslation> value) {
    return value
            .map((l) => FfiConverterTextTranslation.allocationSize(l))
            .fold(0, (a, b) => a + b) +
        4;
  }

  static RustBuffer lower(List<TextTranslation> value) {
    final buf = Uint8List(allocationSize(value));
    write(value, buf);
    return toRustBuffer(buf);
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

class FfiConverterUInt16 {
  static int lift(int value) => value;
  static LiftRetVal<int> read(Uint8List buf) {
    return LiftRetVal(buf.buffer.asByteData(buf.offsetInBytes).getUint16(0), 2);
  }

  static int lower(int value) {
    if (value < 0 || value > 65535) {
      throw ArgumentError("Value out of range for u16: " + value.toString());
    }
    return value;
  }

  static int allocationSize([int value = 0]) {
    return 2;
  }

  static int write(int value, Uint8List buf) {
    buf.buffer.asByteData(buf.offsetInBytes).setUint16(0, lower(value));
    return 2;
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

  T remove(int handle) {
    final obj = maybeRemove(handle);
    if (obj == null) {
      throw UniffiInternalError(
          UniffiInternalError.unexpectedStaleHandle, "Handle not found");
    }
    return obj;
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

RecognizeTextRequest echoRecognizeTextRequest({
  required RecognizeTextRequest request,
}) {
  return rustCallWithLifter(
      (status) =>
          uniffi_beyondtranslate_runtime_fn_func_echo_recognize_text_request(
              FfiConverterRecognizeTextRequest.lower(request), status),
      FfiConverterRecognizeTextRequest.lift,
      null);
}

RecognizeTextResponse echoRecognizeTextResponse({
  required RecognizeTextResponse response,
}) {
  return rustCallWithLifter(
      (status) =>
          uniffi_beyondtranslate_runtime_fn_func_echo_recognize_text_response(
              FfiConverterRecognizeTextResponse.lower(response), status),
      FfiConverterRecognizeTextResponse.lift,
      null);
}

RecognizedRect echoRecognizedRect({
  required RecognizedRect rect,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_echo_recognized_rect(
          FfiConverterRecognizedRect.lower(rect), status),
      FfiConverterRecognizedRect.lift,
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

TextRecognition echoTextRecognition({
  required TextRecognition recognition,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_echo_text_recognition(
          FfiConverterTextRecognition.lower(recognition), status),
      FfiConverterTextRecognition.lift,
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

WordEtymology echoWordEtymology({
  required WordEtymology wordEtymology,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_echo_word_etymology(
          FfiConverterWordEtymology.lower(wordEtymology), status),
      FfiConverterWordEtymology.lift,
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

WordSynonym echoWordSynonym({
  required WordSynonym wordSynonym,
}) {
  return rustCallWithLifter(
      (status) => uniffi_beyondtranslate_runtime_fn_func_echo_word_synonym(
          FfiConverterWordSynonym.lower(wordSynonym), status),
      FfiConverterWordSynonym.lift,
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
external Pointer<Void> uniffi_beyondtranslate_runtime_fn_clone_runtimeapiserver(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external void uniffi_beyondtranslate_runtime_fn_free_runtimeapiserver(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer
    uniffi_beyondtranslate_runtime_fn_method_runtimeapiserver_info(
        Pointer<Void> ptr, Pointer<RustCallStatus> uniffiStatus);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external void uniffi_beyondtranslate_runtime_fn_method_runtimeapiserver_stop(
    Pointer<Void> ptr, Pointer<RustCallStatus> uniffiStatus);

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

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer
    uniffi_beyondtranslate_runtime_fn_method_runtime_list_app_languages(
        Pointer<Void> ptr, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer
    uniffi_beyondtranslate_runtime_fn_method_runtime_list_languages(
        Pointer<Void> ptr, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Pointer<Void> Function(Pointer<Void>, RustBuffer,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external Pointer<Void> uniffi_beyondtranslate_runtime_fn_method_runtime_ocr(
    Pointer<Void> ptr,
    RustBuffer provider_id,
    Pointer<RustCallStatus> uniffiStatus);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtime_permission(
        Pointer<Void> ptr, Pointer<RustCallStatus> uniffiStatus);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtime_settings(
        Pointer<Void> ptr, Pointer<RustCallStatus> uniffiStatus);

@Native<
    Pointer<Void> Function(Pointer<Void>, RustBuffer, Uint16,
        Pointer<RustCallStatus>)>(assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtime_start_api_server(
        Pointer<Void> ptr,
        RustBuffer host,
        int port,
        Pointer<RustCallStatus> uniffiStatus);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtime_text_extractor(
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

@Native<Pointer<Void> Function(Pointer<Void>, RustBuffer)>(
    assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtimedictionary_lookup(
        Pointer<Void> ptr, RustBuffer request);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external Pointer<Void> uniffi_beyondtranslate_runtime_fn_clone_runtimeocr(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external void uniffi_beyondtranslate_runtime_fn_free_runtimeocr(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<Pointer<Void> Function(Pointer<Void>, RustBuffer)>(
    assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtimeocr_recognize_text(
        Pointer<Void> ptr, RustBuffer request);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_clone_runtimepermission(
        Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external void uniffi_beyondtranslate_runtime_fn_free_runtimepermission(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<Pointer<Void> Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtimepermission_is_accessibility_permission_granted(
        Pointer<Void> ptr);

@Native<Pointer<Void> Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtimepermission_is_screen_recording_permission_granted(
        Pointer<Void> ptr);

@Native<Pointer<Void> Function(Pointer<Void>, Int8)>(assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtimepermission_request_accessibility_permission(
        Pointer<Void> ptr, int only_open_system_settings);

@Native<Pointer<Void> Function(Pointer<Void>, Int8)>(assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtimepermission_request_screen_recording_permission(
        Pointer<Void> ptr, int only_open_system_settings);

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

@Native<Pointer<Void> Function(Pointer<Void>, RustBuffer)>(
    assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtimesettings_generate_provider_id(
        Pointer<Void> ptr, RustBuffer provider_type);

@Native<Pointer<Void> Function(Pointer<Void>, RustBuffer, RustBuffer)>(
    assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtimesettings_get_active_translation_targets(
        Pointer<Void> ptr, RustBuffer targets, RustBuffer detected_language);

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

@Native<Pointer<Void> Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtimesettings_reset_shortcuts(
        Pointer<Void> ptr);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtimesettings_subscribe(
        Pointer<Void> ptr, Pointer<RustCallStatus> uniffiStatus);

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
    uniffi_beyondtranslate_runtime_fn_clone_runtimetextextractor(
        Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external void uniffi_beyondtranslate_runtime_fn_free_runtimetextextractor(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<Pointer<Void> Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtimetextextractor_extract_from_clipboard(
        Pointer<Void> ptr);

@Native<Pointer<Void> Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtimetextextractor_extract_from_screen_capture(
        Pointer<Void> ptr);

@Native<Pointer<Void> Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtimetextextractor_extract_from_screen_selection(
        Pointer<Void> ptr);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_clone_runtimetranslation(
        Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external void uniffi_beyondtranslate_runtime_fn_free_runtimetranslation(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<Pointer<Void> Function(Pointer<Void>, RustBuffer)>(
    assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtimetranslation_detect_language(
        Pointer<Void> ptr, RustBuffer request);

@Native<Pointer<Void> Function(Pointer<Void>, RustBuffer)>(
    assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_runtimetranslation_translate(
        Pointer<Void> ptr, RustBuffer request);

@Native<Pointer<Void> Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_clone_settingssubscription(
        Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<Void Function(Pointer<Void>, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external void uniffi_beyondtranslate_runtime_fn_free_settingssubscription(
    Pointer<Void> handle, Pointer<RustCallStatus> uniffiStatus);

@Native<Pointer<Void> Function(Pointer<Void>)>(assetId: _uniffiAssetId)
external Pointer<Void>
    uniffi_beyondtranslate_runtime_fn_method_settingssubscription_next(
        Pointer<Void> ptr);

@Native<Int32 Function(Int32, Int32, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external int uniffi_beyondtranslate_runtime_fn_func_add(
    int a, int b, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(RustBuffer, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_detect_language_request(
        RustBuffer request, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(RustBuffer, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_detect_language_response(
        RustBuffer response, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(RustBuffer, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer uniffi_beyondtranslate_runtime_fn_func_echo_language_pair(
    RustBuffer language_pair, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(RustBuffer, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer uniffi_beyondtranslate_runtime_fn_func_echo_look_up_request(
    RustBuffer request, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(RustBuffer, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_look_up_response(
        RustBuffer response, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(RustBuffer, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_recognize_text_request(
        RustBuffer request, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(RustBuffer, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_recognize_text_response(
        RustBuffer response, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(RustBuffer, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer uniffi_beyondtranslate_runtime_fn_func_echo_recognized_rect(
    RustBuffer rect, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(RustBuffer, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer uniffi_beyondtranslate_runtime_fn_func_echo_text_detection(
    RustBuffer text_detection, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(RustBuffer, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_text_recognition(
        RustBuffer recognition, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(RustBuffer, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_text_translation(
        RustBuffer text_translation, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(RustBuffer, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_translate_request(
        RustBuffer request, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(RustBuffer, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_translate_response(
        RustBuffer response, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(RustBuffer, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer uniffi_beyondtranslate_runtime_fn_func_echo_word_definition(
    RustBuffer word_definition, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(RustBuffer, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer uniffi_beyondtranslate_runtime_fn_func_echo_word_etymology(
    RustBuffer word_etymology, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(RustBuffer, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer uniffi_beyondtranslate_runtime_fn_func_echo_word_image(
    RustBuffer word_image, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(RustBuffer, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer uniffi_beyondtranslate_runtime_fn_func_echo_word_phrase(
    RustBuffer word_phrase, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(RustBuffer, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer
    uniffi_beyondtranslate_runtime_fn_func_echo_word_pronunciation(
        RustBuffer word_pronunciation, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(RustBuffer, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer uniffi_beyondtranslate_runtime_fn_func_echo_word_sentence(
    RustBuffer word_sentence, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(RustBuffer, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer uniffi_beyondtranslate_runtime_fn_func_echo_word_synonym(
    RustBuffer word_synonym, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(RustBuffer, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer uniffi_beyondtranslate_runtime_fn_func_echo_word_tag(
    RustBuffer word_tag, Pointer<RustCallStatus> uniffiStatus);

@Native<RustBuffer Function(RustBuffer, Pointer<RustCallStatus>)>(
    assetId: _uniffiAssetId)
external RustBuffer uniffi_beyondtranslate_runtime_fn_func_echo_word_tense(
    RustBuffer word_tense, Pointer<RustCallStatus> uniffiStatus);

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
external int
    uniffi_beyondtranslate_runtime_checksum_func_echo_recognize_text_request();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_func_echo_recognize_text_response();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_func_echo_recognized_rect();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_beyondtranslate_runtime_checksum_func_echo_text_detection();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_func_echo_text_recognition();

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
external int uniffi_beyondtranslate_runtime_checksum_func_echo_word_etymology();

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
external int uniffi_beyondtranslate_runtime_checksum_func_echo_word_synonym();

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
    uniffi_beyondtranslate_runtime_checksum_method_runtimeapiserver_info();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtimeapiserver_stop();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtime_dictionary();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtime_list_app_languages();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtime_list_languages();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_beyondtranslate_runtime_checksum_method_runtime_ocr();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtime_permission();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int uniffi_beyondtranslate_runtime_checksum_method_runtime_settings();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtime_start_api_server();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtime_text_extractor();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtime_translation();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtimedictionary_lookup();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtimeocr_recognize_text();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtimepermission_is_accessibility_permission_granted();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtimepermission_is_screen_recording_permission_granted();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtimepermission_request_accessibility_permission();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtimepermission_request_screen_recording_permission();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_delete_provider();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_generate_provider_id();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_get_active_translation_targets();

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
    uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_reset_shortcuts();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_subscribe();

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
    uniffi_beyondtranslate_runtime_checksum_method_runtimetextextractor_extract_from_clipboard();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtimetextextractor_extract_from_screen_capture();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtimetextextractor_extract_from_screen_selection();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtimetranslation_detect_language();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_runtimetranslation_translate();

@Native<Uint16 Function()>(assetId: _uniffiAssetId)
external int
    uniffi_beyondtranslate_runtime_checksum_method_settingssubscription_next();

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
      60740) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_detect_language_response() !=
      58261) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_language_pair() !=
      17145) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_look_up_request() !=
      38085) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_look_up_response() !=
      13954) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_recognize_text_request() !=
      29735) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_recognize_text_response() !=
      47790) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_recognized_rect() !=
      52548) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_text_detection() !=
      26624) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_text_recognition() !=
      44304) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_text_translation() !=
      22433) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_translate_request() !=
      15797) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_translate_response() !=
      60824) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_word_definition() !=
      13074) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_word_etymology() !=
      13993) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_word_image() != 48917) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_word_phrase() !=
      25809) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_word_pronunciation() !=
      34049) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_word_sentence() !=
      37267) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_word_synonym() !=
      27203) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_word_tag() != 60766) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_echo_word_tense() != 28625) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_greet() != 35598) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_func_version() != 42317) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimeapiserver_info() !=
      36460) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimeapiserver_stop() !=
      63804) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtime_dictionary() !=
      13965) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtime_list_app_languages() !=
      62628) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtime_list_languages() !=
      58600) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtime_ocr() != 40076) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtime_permission() !=
      10201) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtime_settings() !=
      37764) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtime_start_api_server() !=
      26599) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtime_text_extractor() !=
      21355) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtime_translation() !=
      36886) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimedictionary_lookup() !=
      64628) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimeocr_recognize_text() !=
      10575) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimepermission_is_accessibility_permission_granted() !=
      49819) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimepermission_is_screen_recording_permission_granted() !=
      57183) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimepermission_request_accessibility_permission() !=
      28036) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimepermission_request_screen_recording_permission() !=
      9096) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_delete_provider() !=
      20557) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_generate_provider_id() !=
      9759) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_get_active_translation_targets() !=
      22616) {
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
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_reset_shortcuts() !=
      46222) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimesettings_subscribe() !=
      44725) {
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
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimetextextractor_extract_from_clipboard() !=
      61343) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimetextextractor_extract_from_screen_capture() !=
      38083) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimetextextractor_extract_from_screen_selection() !=
      57900) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimetranslation_detect_language() !=
      29752) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_runtimetranslation_translate() !=
      61207) {
    throw UniffiInternalError.panicked("UniFFI API checksum mismatch");
  }
  if (uniffi_beyondtranslate_runtime_checksum_method_settingssubscription_next() !=
      20677) {
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
