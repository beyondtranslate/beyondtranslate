import SwiftUI

@MainActor
final class AppearanceViewModel: ObservableObject {
  @Published var appLanguage: String
  @Published var themeMode: AppThemeMode

  private let repository: SettingsRepository

  init(
    settings: AppearanceSettingsState = AppearanceSettingsState(),
    repository: SettingsRepository
  ) {
    self.repository = repository
    appLanguage = settings.appLanguage
    themeMode = settings.themeMode
    ThemeAppearanceController.apply(settings.themeMode)
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
    Task {
      do {
        let updated = try await repository.updateAppearance(
          AppearanceSettingsPatch(language: rustLanguage(from: value), themeMode: nil)
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
    appLanguage = displayLanguage(from: settings.language)
    let mode = AppThemeMode(rawValue: settings.themeMode) ?? .system
    themeMode = mode
    ThemeAppearanceController.apply(mode)
  }

  private func rustLanguage(from displayLanguage: String) -> String {
    switch displayLanguage {
    case "Chinese":
      return "zh"
    case "English":
      return "en"
    default:
      return displayLanguage
    }
  }

  private func displayLanguage(from rustLanguage: String) -> String {
    switch rustLanguage {
    case "zh":
      return "Chinese"
    case "en":
      return "English"
    default:
      return rustLanguage
    }
  }
}
