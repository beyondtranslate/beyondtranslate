import Foundation

protocol SettingsRepository {
  func loadSettings() -> AppSettings
  func saveSettings(_ settings: AppSettings)
}

final class UserDefaultsSettingsRepository: SettingsRepository {
  private let userDefaults: UserDefaults

  init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
  }

  func loadSettings() -> AppSettings {
    AppSettings()
  }

  func saveSettings(_ settings: AppSettings) {
    _ = userDefaults
    // Persistence mapping will live here when settings are wired to storage.
  }
}
