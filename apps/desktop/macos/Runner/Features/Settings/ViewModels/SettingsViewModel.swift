import SwiftUI

@MainActor
final class SettingsHighlightCoordinator: ObservableObject {
  static let shared = SettingsHighlightCoordinator()

  @Published private(set) var permissionsHighlightID = 0

  private init() {}

  func highlightPermissions() {
    permissionsHighlightID += 1
  }
}

@MainActor
final class SettingsViewModel: ObservableObject {
  let general: GeneralViewModel
  let appearance: AppearanceViewModel
  let shortcuts: ShortcutsViewModel
  let providers: ProvidersViewModel
  let advanced: AdvancedViewModel

  private let repository: SettingsRepository

  init(repository: SettingsRepository? = nil) {
    let repository = repository ?? DefaultSettingsRepository()
    self.repository = repository

    general = GeneralViewModel(repository: repository)
    appearance = AppearanceViewModel(repository: repository)
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
