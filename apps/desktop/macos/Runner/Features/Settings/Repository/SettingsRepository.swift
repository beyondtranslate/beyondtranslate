import Foundation
import beyondtranslate_runtime

@MainActor
protocol SettingsRepository {
  func getGeneral() async throws -> GeneralSettings
  func updateGeneral(_ patch: GeneralSettingsPatch) async throws -> GeneralSettings
  func getAppearance() async throws -> AppearanceSettings
  func updateAppearance(_ patch: AppearanceSettingsPatch) async throws -> AppearanceSettings
  func getShortcuts() async throws -> ShortcutSettings
  func updateShortcuts(_ patch: ShortcutSettingsPatch) async throws -> ShortcutSettings
  func getAdvanced() async throws -> AdvancedSettings
  func updateAdvanced(_ patch: AdvancedSettingsPatch) async throws -> AdvancedSettings
  func listProviders() async throws -> [ProviderConfigEntry]
  @discardableResult
  func updateProvider(
    id: String,
    providerType: String,
    fields: [String: String]
  ) async throws -> ProviderConfigEntry
  @discardableResult
  func deleteProvider(id: String) async throws -> ProviderConfigEntry?
  func disabledProviderIDs() -> Set<String>
  func setProviderEnabled(_ id: String, isEnabled: Bool)
}

@MainActor
final class DefaultSettingsRepository: SettingsRepository {
  private let settings: RuntimeSettings
  private var disabledProviders: Set<String> = []

  init(runtime: Runtime = RuntimeProvider.shared) {
    self.settings = runtime.settings()
  }

  func getGeneral() async throws -> GeneralSettings {
    try await settings.getGeneral()
  }

  func updateGeneral(_ patch: GeneralSettingsPatch) async throws -> GeneralSettings {
    try await settings.updateGeneral(patch: patch)
  }

  func getAppearance() async throws -> AppearanceSettings {
    try await settings.getAppearance()
  }

  func updateAppearance(_ patch: AppearanceSettingsPatch) async throws -> AppearanceSettings {
    try await settings.updateAppearance(patch: patch)
  }

  func getShortcuts() async throws -> ShortcutSettings {
    try await settings.getShortcuts()
  }

  func updateShortcuts(_ patch: ShortcutSettingsPatch) async throws -> ShortcutSettings {
    try await settings.updateShortcuts(patch: patch)
  }

  func getAdvanced() async throws -> AdvancedSettings {
    try await settings.getAdvanced()
  }

  func updateAdvanced(_ patch: AdvancedSettingsPatch) async throws -> AdvancedSettings {
    try await settings.updateAdvanced(patch: patch)
  }

  func listProviders() async throws -> [ProviderConfigEntry] {
    try await settings.listProviders()
  }

  func updateProvider(
    id: String,
    providerType: String,
    fields: [String: String]
  ) async throws -> ProviderConfigEntry {
    try await settings.updateProvider(
      providerId: id, providerType: providerType, fields: fields
    )
  }

  func deleteProvider(id: String) async throws -> ProviderConfigEntry? {
    try await settings.deleteProvider(providerId: id)
  }

  func disabledProviderIDs() -> Set<String> {
    disabledProviders
  }

  func setProviderEnabled(_ id: String, isEnabled: Bool) {
    if isEnabled {
      disabledProviders.remove(id)
    } else {
      disabledProviders.insert(id)
    }
  }
}
