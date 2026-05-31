import 'dart:async';

import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:nativeapi/nativeapi.dart';

import '../utils/language_util.dart';
import '../utils/platform_util.dart';
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
  SettingsStore._() {
    _launchAtLogin = LaunchAtLogin();
  }

  static final SettingsStore instance = SettingsStore._();
  late final LaunchAtLogin _launchAtLogin;

  /// Active subscription to runtime [SettingsChange] events. Started by
  /// [init] and stopped by [dispose]; while alive, every change made
  /// through any [Runtime] handle (Dart or Swift) triggers a reload of
  /// the affected section so this store always reflects the latest
  /// persisted state.
  SettingsSubscription? _subscription;
  bool _disposed = false;
  bool _didEnsureDefaultTranslationTarget = false;

  GeneralSettings _general = GeneralSettings(
    launchAtLogin: false,
    showInMenuBar: true,
    defaultOcrService: '',
    autoCopyDetectedText: true,
    defaultDirectoryService: '',
    defaultTranslationService: '',
    translationTargets: [],
    inputSubmitMode: InputSubmitMode.enter,
    doubleClickCopyResult: true,
    commonLanguages: defaultCommonLanguages(),
  );
  AppearanceSettings _appearance = AppearanceSettings(
    language: 'zh-Hans',
    themeMode: 'system',
  );
  ShortcutSettings _shortcuts = ShortcutSettings(
    toggleMiniTranslator: '',
    extractTextFromScreenSelection: '',
    extractTextFromScreenCapture: '',
    extractTextFromClipboard: '',
    translateInputContent: '',
  );
  AdvancedSettings _advanced = AdvancedSettings(
    apiServerEnabled: false,
    apiServerHost: '127.0.0.1',
    apiServerPort: 0,
  );
  List<ProviderConfigEntry> _providers = const [];
  List<ServiceConfigEntry> _services = const [];

  GeneralSettings get general => _general;
  AppearanceSettings get appearance => _appearance;
  ShortcutSettings get shortcuts => _shortcuts;
  AdvancedSettings get advanced => _advanced;
  List<ProviderConfigEntry> get providers => List.unmodifiable(_providers);
  List<ServiceConfigEntry> get services => List.unmodifiable(_services);

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
      reloadAdvanced(),
      reloadProviders(),
      reloadServices(),
    ]);
    _startListeningForChanges();
  }

  @override
  void dispose() {
    _disposed = true;
    _subscription = null;
    super.dispose();
  }

  /// Subscribes to runtime change events. Idempotent.
  void _startListeningForChanges() {
    if (_subscription != null) return;
    final subscription = runtime_service.runtime.settings().subscribe();
    _subscription = subscription;
    unawaited(_consumeChanges(subscription));
  }

  Future<void> _consumeChanges(SettingsSubscription subscription) async {
    while (!_disposed && identical(_subscription, subscription)) {
      SettingsChange? change;
      try {
        change = await subscription.next();
      } catch (error, stackTrace) {
        debugPrint('SettingsStore subscription error: $error\n$stackTrace');
        break;
      }
      if (change == null) break;
      switch (change) {
        case SettingsChange.general:
          await reloadGeneral();
        case SettingsChange.appearance:
          await reloadAppearance();
        case SettingsChange.shortcuts:
          await reloadShortcuts();
        case SettingsChange.providers:
          await Future.wait([reloadProviders(), reloadServices()]);
        case SettingsChange.advanced:
          await reloadAdvanced();
      }
    }
  }

  Future<void> reloadGeneral() async {
    final settings = runtime_service.runtime.settings();
    try {
      _general = await settings.getGeneral();
      if (!_didEnsureDefaultTranslationTarget &&
          _general.translationTargets.isEmpty) {
        _didEnsureDefaultTranslationTarget = true;
        _general = await settings.updateGeneral(
          patch: GeneralSettingsPatch(
            translationTargets: [
              TranslationTarget(
                source: kAutoSource,
                target: defaultTargetLanguage,
                enabled: true,
              ),
            ],
          ),
        );
      } else {
        _didEnsureDefaultTranslationTarget = true;
      }
      _applyLaunchAtLogin(_general.launchAtLogin);
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

  Future<void> reloadServices() async {
    final settings = runtime_service.runtime.settings();
    try {
      _services = await settings.listServices();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> reloadAdvanced() async {
    final settings = runtime_service.runtime.settings();
    try {
      _advanced = await settings.getAdvanced();
      await runtime_service.applyApiServerSettings(_advanced);
      notifyListeners();
    } catch (error, stackTrace) {
      debugPrint('Failed to reload advanced settings: $error\n$stackTrace');
    }
  }

  Future<void> updateGeneral(GeneralSettingsPatch patch) async {
    final settings = runtime_service.runtime.settings();
    _general = await settings.updateGeneral(patch: patch);
    if (patch.launchAtLogin != null) {
      _applyLaunchAtLogin(patch.launchAtLogin!);
    }
    notifyListeners();
  }

  /// Enables or disables the OS-level launch-at-login feature.
  ///
  /// Only applies on macOS and Windows. No-op on other platforms.
  void _applyLaunchAtLogin(bool value) {
    if (!kIsMacOS && !kIsWindows) return;
    if (value) {
      _launchAtLogin.enable();
    } else {
      _launchAtLogin.disable();
    }
  }

  Future<void> updateAppearance(AppearanceSettingsPatch patch) async {
    final settings = runtime_service.runtime.settings();
    _appearance = await settings.updateAppearance(patch: patch);
    notifyListeners();
  }

  Future<void> updateShortcuts(ShortcutSettingsPatch patch) async {
    final settings = runtime_service.runtime.settings();
    _shortcuts = await settings.updateShortcuts(patch: patch);
    notifyListeners();
  }

  Future<void> resetShortcuts() async {
    final settings = runtime_service.runtime.settings();
    _shortcuts = await settings.resetShortcuts();
    notifyListeners();
  }

  Future<void> updateAdvanced(AdvancedSettingsPatch patch) async {
    final settings = runtime_service.runtime.settings();
    _advanced = await settings.updateAdvanced(patch: patch);
    await runtime_service.applyApiServerSettings(_advanced);
    notifyListeners();
  }
}

/// Singleton accessor.
final settingsStore = SettingsStore.instance;
