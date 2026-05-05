import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeMode;

import '../rust/domain/settings.dart';
import 'runtime.dart' as runtime_service;

/// App-wide settings cache backed by the Rust runtime.
///
/// All settings persisted across app launches are owned by the Rust runtime
/// (`runtime.settings()`). This store provides a Flutter-friendly facade:
///
///   * loads the current snapshot at startup ([init])
///   * exposes synchronous getters for use in `build` methods
///   * notifies listeners whenever a value changes
///
/// It intentionally does **not** hold any data that does not exist in the
/// runtime. Anything UI-only (e.g. window sizing) should live elsewhere.
class SettingsStore extends ChangeNotifier {
  SettingsStore._();

  static final SettingsStore instance = SettingsStore._();

  GeneralSettings _general = const GeneralSettings(
    launchAtLogin: false,
    showMenuBar: true,
    defaultOcrService: '',
    autoCopyDetectedText: true,
    defaultDirectoryService: '',
    defaultTranslationService: '',
    translationMode: TranslationMode.manual,
    translationTargets: [],
    inputSubmitMode: InputSubmitMode.enter,
    doubleClickCopyResult: true,
  );
  AppearanceSettings _appearance = const AppearanceSettings(
    language: 'zh',
    themeMode: 'system',
  );
  ShortcutSettings _shortcuts = const ShortcutSettings(
    toggleApp: '',
    hideApp: '',
    extractFromScreenSelection: '',
    extractFromScreenCapture: '',
    extractFromClipboard: '',
  );
  List<ProviderConfigEntry> _providers = const [];

  GeneralSettings get general => _general;
  AppearanceSettings get appearance => _appearance;
  ShortcutSettings get shortcuts => _shortcuts;
  List<ProviderConfigEntry> get providers => List.unmodifiable(_providers);

  String get appLanguage => _appearance.language;
  ThemeMode get themeMode {
    switch (_appearance.themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  TranslationMode get translationMode => _general.translationMode;
  InputSubmitMode get inputSubmitMode => _general.inputSubmitMode;
  bool get autoCopyDetectedText => _general.autoCopyDetectedText;
  bool get doubleClickCopyResult => _general.doubleClickCopyResult;
  String get defaultOcrService => _general.defaultOcrService;
  String get defaultTranslationService => _general.defaultTranslationService;
  String get defaultDirectoryService => _general.defaultDirectoryService;

  Future<void> init() async {
    await Future.wait([
      reloadGeneral(),
      reloadAppearance(),
      reloadShortcuts(),
      reloadProviders(),
    ]);
  }

  Future<void> reloadGeneral() async {
    final settings = runtime_service.runtime.settings();
    try {
      _general = await settings.getGeneral();
      notifyListeners();
    } catch (_) {
      // keep cached defaults
    }
  }

  Future<void> reloadAppearance() async {
    final settings = runtime_service.runtime.settings();
    try {
      _appearance = await settings.getAppearance();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> reloadShortcuts() async {
    final settings = runtime_service.runtime.settings();
    try {
      _shortcuts = await settings.getShortcuts();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> reloadProviders() async {
    final settings = runtime_service.runtime.settings();
    try {
      _providers = await settings.listProviders();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> updateGeneral(GeneralSettingsPatch patch) async {
    final settings = runtime_service.runtime.settings();
    _general = await settings.updateGeneral(patch);
    notifyListeners();
  }

  Future<void> updateAppearance(AppearanceSettingsPatch patch) async {
    final settings = runtime_service.runtime.settings();
    _appearance = await settings.updateAppearance(patch);
    notifyListeners();
  }

  Future<void> updateShortcuts(ShortcutSettingsPatch patch) async {
    final settings = runtime_service.runtime.settings();
    _shortcuts = await settings.updateShortcuts(patch);
    notifyListeners();
  }
}

/// Singleton accessor.
final settingsStore = SettingsStore.instance;
