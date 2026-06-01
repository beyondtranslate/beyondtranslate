import SwiftUI
import beyondtranslate_runtime

@MainActor
final class ServicesViewModel: ObservableObject {
  @Published var providers: [ProviderConfigEntry] = []
  @Published var services: [ServiceConfigEntry] = []
  @Published var errorMessage: String?
  @Published private(set) var pendingPresentProviderEditorSheetID: Int? = nil

  /// Translation services.
  var translationServices: [ServiceConfigEntry] {
    services.filter { $0.type == .translation }
  }

  /// OCR services.
  var ocrServices: [ServiceConfigEntry] {
    services.filter { $0.type == .ocr }
  }

  /// Shared ProvidersViewModel used for ProviderDetailView navigation.
  /// Set by the parent (SettingsViewModel) after both VMs are initialized.
  weak var providersVM: ProvidersViewModel?

  private let repository: SettingsRepository

  init(repository: SettingsRepository) {
    self.repository = repository
  }

  func load() async {
    do {
      providers = try await repository.listProviders()
        .sorted { lhs, rhs in
          switch (lhs.createdAt, rhs.createdAt) {
          case (let l?, let r?): return l < r
          case (nil, _): return false
          case (_?, nil): return true
          }
        }
      services = try await repository.listServices()
        .sorted { $0.id < $1.id }
    } catch {
      errorMessage = error.localizedDescription
    }
  }

  // MARK: - Provider actions (delegated to underlying repository)

  func requestPresentProviderEditorSheet() {
    pendingPresentProviderEditorSheetID = (pendingPresentProviderEditorSheetID ?? 0) + 1
  }

  func consumePresentProviderEditorSheet(_ id: Int) -> Bool {
    guard pendingPresentProviderEditorSheetID == id else { return false }
    pendingPresentProviderEditorSheetID = nil
    return true
  }

  func isProviderEnabled(_ id: String) -> Bool {
    !repository.disabledProviderIDs().contains(id)
  }

  func toggleProvider(_ id: String, isEnabled: Bool) {
    repository.setProviderEnabled(id, isEnabled: isEnabled)
    objectWillChange.send()
  }

  func generateProviderId(for providerType: ProviderType) async -> String {
    (try? await repository.generateProviderId(providerType: providerType)) ?? providerType.wireValue
  }

  func saveProvider(_ entry: ProviderConfigEntry) {
    Task {
      do {
        try await repository.updateProvider(
          id: entry.id,
          providerType: entry.type,
          fields: entry.fields
        )
        await load()
      } catch {
        errorMessage = error.localizedDescription
      }
    }
  }

  func deleteProvider(_ id: String) {
    Task {
      do {
        _ = try await repository.deleteProvider(id: id)
        await load()
        repository.setProviderEnabled(id, isEnabled: true)
      } catch {
        errorMessage = error.localizedDescription
      }
    }
  }
}
