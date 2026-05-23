import SwiftUI
import beyondtranslate_runtime

@MainActor
final class AppearanceViewModel: ObservableObject {
  @Published var appLanguage: String
  @Published var themeMode: ThemeMode
  @Published private(set) var themeModeOptions: [ThemeModeOption]
  @Published private(set) var languageOptions: [LanguageInfo] = []

  private let repository: SettingsRepository
  private let runtime: Runtime

  init(repository: SettingsRepository, runtime: Runtime = RuntimeProvider.shared) {
    self.repository = repository
    self.runtime = runtime
    appLanguage = "en"
    themeMode = .system
    themeModeOptions = Self.localizedThemeModeOptions()
    languageOptions = runtime.listAppLanguages()
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
    themeModeOptions = Self.localizedThemeModeOptions()
    Task {
      do {
        let updated = try await repository.updateAppearance(.diff(language: value))
        apply(updated)
      } catch {
        await load()
      }
    }
  }

  func setThemeMode(_ value: ThemeMode) {
    themeMode = value
    ThemeAppearanceController.apply(value)
    Task {
      do {
        let updated = try await repository.updateAppearance(.diff(themeMode: value.rawValue))
        apply(updated)
      } catch {
        await load()
      }
    }
  }

  private func apply(_ settings: AppearanceSettings) {
    appLanguage = settings.language
    AppLocale.shared.setLocale(appLanguage)
    themeModeOptions = Self.localizedThemeModeOptions()
    let mode = ThemeMode(rawValue: settings.themeMode) ?? .system
    themeMode = mode
    ThemeAppearanceController.apply(mode)
  }

  private static func localizedThemeModeOptions() -> [ThemeModeOption] {
    ThemeMode.allCases.map { mode in
      ThemeModeOption(mode: mode, title: mode.title)
    }
  }
}

struct ThemeModeOption: Identifiable {
  let mode: ThemeMode
  let title: String

  var id: String {
    "\(mode.rawValue)-\(title)"
  }
}
