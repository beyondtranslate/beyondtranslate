import Foundation

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
  private let settingsPlugin: NativeSettingsPlugin?
  private var disabledProviders: Set<String> = []

  init(_ settingsPlugin: NativeSettingsPlugin? = nil) {
    self.settingsPlugin = settingsPlugin
  }

  func getGeneral() async throws -> GeneralSettings {
    try await plugin().getGeneral()
  }

  func updateGeneral(_ patch: GeneralSettingsPatch) async throws -> GeneralSettings {
    try await plugin().updateGeneral(patch)
  }

  func getAppearance() async throws -> AppearanceSettings {
    try await plugin().getAppearance()
  }

  func updateAppearance(_ patch: AppearanceSettingsPatch) async throws -> AppearanceSettings {
    try await plugin().updateAppearance(patch)
  }

  func getShortcuts() async throws -> ShortcutSettings {
    try await plugin().getShortcuts()
  }

  func updateShortcuts(_ patch: ShortcutSettingsPatch) async throws -> ShortcutSettings {
    try await plugin().updateShortcuts(patch)
  }

  func getAdvanced() async throws -> AdvancedSettings {
    try await plugin().getAdvanced()
  }

  func updateAdvanced(_ patch: AdvancedSettingsPatch) async throws -> AdvancedSettings {
    try await plugin().updateAdvanced(patch)
  }

  func listProviders() async throws -> [ProviderConfigEntry] {
    try await plugin().listProviders()
  }

  func updateProvider(
    id: String,
    providerType: String,
    fields: [String: String]
  ) async throws -> ProviderConfigEntry {
    try await plugin().updateProvider(id: id, providerType: providerType, fields: fields)
  }

  func deleteProvider(id: String) async throws -> ProviderConfigEntry? {
    try await plugin().deleteProvider(id: id)
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

  private func plugin() throws -> NativeSettingsPlugin {
    guard let settingsPlugin else {
      throw NativeSettingsError.notImplemented("settingsPlugin")
    }
    return settingsPlugin
  }
}
