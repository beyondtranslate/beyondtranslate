import SwiftUI

@MainActor
final class AdvancedViewModel: ObservableObject {
  private let repository: SettingsRepository

  init(repository: SettingsRepository) {
    self.repository = repository
  }

  func load() async {
    do {
      _ = try await repository.getAdvanced()
    } catch {
      // No-op: AdvancedSettings is currently empty.
    }
  }
}
