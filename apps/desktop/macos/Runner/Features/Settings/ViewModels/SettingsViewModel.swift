import SwiftUI

final class SettingsViewModel: ObservableObject {
  let general: GeneralViewModel
  let appearance: AppearanceViewModel
  let shortcuts: ShortcutsViewModel
  let providers: ProvidersViewModel
  let advanced: AdvancedViewModel

  private let repository: SettingsRepository
  private let settingsService: SettingsService?

  init(
    repository: SettingsRepository = UserDefaultsSettingsRepository(),
    settingsService: SettingsService? = nil
  ) {
    self.repository = repository
    self.settingsService = settingsService

    let settings = repository.loadSettings()
    general = GeneralViewModel(settings: settings.general)
    appearance = AppearanceViewModel(settings: settings.appearance)
    shortcuts = ShortcutsViewModel(settings: settings.shortcuts)
    providers = ProvidersViewModel(settings: settings.providers)
    advanced = AdvancedViewModel(settings: settings.advanced)
  }
}
