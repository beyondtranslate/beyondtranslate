import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
  let general: GeneralViewModel
  let appearance: AppearanceViewModel
  let shortcuts: ShortcutsViewModel
  let providers: ProvidersViewModel
  let advanced: AdvancedViewModel

  private let repository: SettingsRepository

  init(
    repository: SettingsRepository? = nil,
    settingsPlugin: NativeSettingsPlugin? = nil
  ) {
    let repository =
      repository ?? DefaultSettingsRepository(settingsPlugin)
    self.repository = repository

    let settings = repository.loadSettings()
    general = GeneralViewModel(settings: settings.general, repository: repository)
    appearance = AppearanceViewModel(settings: settings.appearance, repository: repository)
    shortcuts = ShortcutsViewModel(repository: repository)
    providers = ProvidersViewModel(repository: repository)
    advanced = AdvancedViewModel(repository: repository)

    Task {
      await general.load()
      await appearance.load()
      await shortcuts.load()
      await providers.load()
      await advanced.load()
    }
  }
}
