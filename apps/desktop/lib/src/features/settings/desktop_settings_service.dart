import '../../rust/domain/settings.dart';
import '../../services/runtime.dart';

class DesktopSettingsService {
  DesktopSettingsService._();

  static final DesktopSettingsService instance = DesktopSettingsService._();

  Future<String> get settingsFilePath async {
    return runtime.settingsFilePath;
  }

  Future<RustSettingsDto> getSettings() async {
    return runtime.settings.get();
  }

  Future<String> getSettingsJson() async {
    return runtime.settings.getJson();
  }

  Future<RustSettingsDto> setTheme(String theme) async {
    return runtime.settings.setTheme(theme);
  }

  Future<RustSettingsDto> setLanguage(String language) async {
    return runtime.settings.setLanguage(language);
  }
}

final desktopSettingsService = DesktopSettingsService.instance;
