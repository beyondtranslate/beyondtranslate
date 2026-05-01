import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
  let general: GeneralViewModel
  let appearance: AppearanceViewModel
  let shortcuts: ShortcutsViewModel
  let providers: ProvidersViewModel
  let advanced: AdvancedViewModel

  private let repository: SettingsRepository
  private let settingsPlugin: NativeSettingsPlugin?

  init(
    repository: SettingsRepository = UserDefaultsSettingsRepository(),
    settingsPlugin: NativeSettingsPlugin? = nil
  ) {
    self.repository = repository
    self.settingsPlugin = settingsPlugin

    let settings = repository.loadSettings()
    general = GeneralViewModel(settings: settings.general)
    appearance = AppearanceViewModel(settings: settings.appearance, settingsPlugin: settingsPlugin)
    shortcuts = ShortcutsViewModel(settings: settings.shortcuts, settingsPlugin: settingsPlugin)
    providers = ProvidersViewModel(settings: settings.providers)
    advanced = AdvancedViewModel(settings: settings.advanced, settingsPlugin: settingsPlugin)

    Task {
      await appearance.load()
      await shortcuts.load()
      await advanced.load()
    }
  }
}
