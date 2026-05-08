import SwiftUI

@MainActor
final class AppearanceViewModel: ObservableObject {
  @Published var appLanguage: String
  @Published var themeMode: AppThemeMode
  @Published private(set) var themeModeOptions: [ThemeModeOption]

  private let repository: SettingsRepository

  init(repository: SettingsRepository) {
    self.repository = repository
    appLanguage = "en"
    themeMode = .system
    themeModeOptions = Self.localizedThemeModeOptions()
    ThemeAppearanceController.apply(.system)
  }

  func load() async {
    do {
      apply(try await repository.getAppearance())
    } catch {
      // Keep the local preview/default state when the Rust-backed settings cannot be loaded.
    }
  }

  func setAppLanguage(_ value: String) {
    appLanguage = value
    AppLocale.shared.setLocale(value)
    refreshLocalizedOptions()
    Task {
      do {
        let updated = try await repository.updateAppearance(
          AppearanceSettingsPatch(language: value, themeMode: nil)
        )
        apply(updated)
      } catch {
        await load()
      }
    }
  }

  func setThemeMode(_ value: AppThemeMode) {
    themeMode = value
    ThemeAppearanceController.apply(value)
    Task {
      do {
        let updated = try await repository.updateAppearance(
          AppearanceSettingsPatch(language: nil, themeMode: value.rawValue)
        )
        apply(updated)
      } catch {
        await load()
      }
    }
  }

  private func apply(_ settings: AppearanceSettings) {
    appLanguage = languageCode(from: settings.language)
    AppLocale.shared.setLocale(appLanguage)
    refreshLocalizedOptions()
    let mode = AppThemeMode(rawValue: settings.themeMode) ?? .system
    themeMode = mode
    ThemeAppearanceController.apply(mode)
  }

  private func languageCode(from value: String) -> String {
    value.hasPrefix("zh") ? "zh" : "en"
  }

  private func refreshLocalizedOptions() {
    themeModeOptions = Self.localizedThemeModeOptions()
  }

  private static func localizedThemeModeOptions() -> [ThemeModeOption] {
    AppThemeMode.allCases.map { mode in
      ThemeModeOption(mode: mode, title: mode.title)
    }
  }
}

struct ThemeModeOption: Identifiable {
  let mode: AppThemeMode
  let title: String

  var id: String {
    "\(mode.rawValue)-\(title)"
  }
}
