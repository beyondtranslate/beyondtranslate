import SwiftUI

@MainActor
final class AppearanceViewModel: ObservableObject {
  @Published var showTrayIcon: Bool
  @Published var maxWindowHeight: Double
  @Published var appLanguage: String
  @Published var themeMode: AppThemeMode

  private let settingsPlugin: NativeSettingsPlugin?

  init(
    settings: AppearanceSettingsState = AppearanceSettingsState(),
    settingsPlugin: NativeSettingsPlugin? = nil
  ) {
    self.settingsPlugin = settingsPlugin
    showTrayIcon = settings.showTrayIcon
    maxWindowHeight = settings.maxWindowHeight
    appLanguage = settings.appLanguage
    themeMode = settings.themeMode
  }

  func load() async {
    guard let settingsPlugin else { return }
    do {
      apply(try await settingsPlugin.getAppearance())
    } catch {
      // Keep the local preview/default state when the Rust-backed settings cannot be loaded.
    }
  }

  func setAppLanguage(_ value: String) {
    appLanguage = value
    guard let settingsPlugin else { return }
    Task {
      do {
        let updated = try await settingsPlugin.updateAppearance(
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
    guard let settingsPlugin else { return }
    Task {
      do {
        let updated = try await settingsPlugin.updateAppearance(
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
    themeMode = AppThemeMode(rawValue: settings.themeMode) ?? .system
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
