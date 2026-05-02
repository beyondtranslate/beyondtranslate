import SwiftUI

@MainActor
final class ProvidersViewModel: ObservableObject {
  @Published var providers: [ProviderItem] = []
  @Published var isLoading = false
  @Published var errorMessage: String?

  private let repository: SettingsRepository

  /// Maps backendID → stable local UUID so SwiftUI identity is preserved across reloads.
  private var stableIDs: [String: UUID] = [:]

  init(repository: SettingsRepository) {
    self.repository = repository
  }

  // MARK: - Load

  func load() async {
    isLoading = true
    defer { isLoading = false }
    do {
      let entries = try await repository.listProviders()
      let disabled = repository.disabledProviderIDs()
      providers = entries.map { entry in
        ProviderItem(
          id: stableID(for: entry.id),
          from: entry,
          isEnabled: !disabled.contains(entry.id)
        )
      }
    } catch {
      // Keep whatever state we have; errors are non-fatal for the list view.
      errorMessage = error.localizedDescription
    }
  }

  // MARK: - Toggle

  func toggleProvider(_ id: UUID, isEnabled: Bool) {
    guard let idx = providers.firstIndex(where: { $0.id == id }) else { return }
    let backendID = providers[idx].backendID
    providers[idx].isEnabled = isEnabled
    repository.setProviderEnabled(backendID, isEnabled: isEnabled)
  }

  // MARK: - Save (add or edit)

  func saveProvider(_ draft: ProviderDraft) {
    Task {
      do {
        _ = try await repository.updateProvider(
          id: draft.backendID,
          providerType: draft.providerType.rawValue,
          fields: draft.fields
        )
        await load()
      } catch {
        errorMessage = error.localizedDescription
      }
    }
  }

  // MARK: - Delete

  func deleteProvider(_ id: UUID) {
    guard let item = providers.first(where: { $0.id == id }) else { return }
    Task {
      do {
        _ = try await repository.deleteProvider(id: item.backendID)
        providers.removeAll { $0.id == id }
        // Clean up disabled state so re-adding the same ID starts fresh.
        repository.setProviderEnabled(item.backendID, isEnabled: true)
      } catch {
        errorMessage = error.localizedDescription
      }
    }
  }

  // MARK: - Private helpers

  private func stableID(for backendID: String) -> UUID {
    if let existing = stableIDs[backendID] { return existing }
    let new = UUID()
    stableIDs[backendID] = new
    return new
  }
}
