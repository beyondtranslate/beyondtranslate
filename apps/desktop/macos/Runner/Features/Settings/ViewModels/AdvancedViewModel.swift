import SwiftUI

@MainActor
final class AdvancedViewModel: ObservableObject {
  @Published var launchAtLogin: Bool

  private let repository: SettingsRepository

  init(
    repository: SettingsRepository
  ) {
    self.repository = repository
    launchAtLogin = false
  }

  func load() async {
    do {
      apply(try await repository.getAdvanced())
    } catch {
      // Keep the local preview/default state when the Rust-backed settings cannot be loaded.
    }
  }

  func setlaunchAtLogin(_ value: Bool) {
    launchAtLogin = value
    Task {
      do {
        let updated = try await repository.updateAdvanced(
          AdvancedSettingsPatch(launchAtLogin: value)
        )
        apply(updated)
      } catch {
        await load()
      }
    }
  }

  private func apply(_ settings: AdvancedSettings) {
    launchAtLogin = settings.launchAtLogin
  }
}
