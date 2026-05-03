import SwiftUI

struct ServiceOption: Identifiable, Hashable {
  let id: String
  let name: String
}

@MainActor
final class GeneralViewModel: ObservableObject {
  // Rust-backed settings
  @Published var launchAtLogin: Bool
  @Published var showMenuBar: Bool
  @Published var defaultOcrService: String
  @Published var autoCopyDetectedText: Bool
  @Published var defaultDirectoryService: String
  @Published var defaultTranslationService: String
  @Published var translationMode: TranslationMode
  @Published var translationTargets: [TranslationTarget]
  @Published var inputSubmitMode: InputSubmitMode
  @Published var doubleClickCopyResult: Bool

  // Runtime providers
  @Published var providers: [ProviderConfigEntry] = []

  private let repository: SettingsRepository

  init(repository: SettingsRepository) {
    launchAtLogin = false
    showMenuBar = true
    defaultOcrService = ""
    autoCopyDetectedText = true
    defaultDirectoryService = ""
    defaultTranslationService = ""
    translationMode = .auto
    translationTargets = []
    inputSubmitMode = .enter
    doubleClickCopyResult = true
    self.repository = repository
  }

  func load() async {
    do {
      apply(try await repository.getGeneral())
    } catch {
      // Keep defaults when Rust-backed settings cannot be loaded.
    }

    do {
      providers = try await repository.listProviders()
    } catch {
      // Keep existing providers on error.
    }
  }

  // Directory service options: {provider-id}+dictionary
  var dictionaryServiceOptions: [ServiceOption] {
    providers
      .filter { $0.capabilities.contains("dictionary") }
      .map { ServiceOption(id: "\($0.id)+dictionary", name: $0.id) }
  }

  // Translation service options: {provider-id}+translation
  var translationServiceOptions: [ServiceOption] {
    providers
      .filter { $0.capabilities.contains("translation") }
      .map { ServiceOption(id: "\($0.id)+translation", name: $0.id) }
  }

  func setLaunchAtLogin(_ value: Bool) {
    launchAtLogin = value
    Task { await persist(GeneralSettingsPatch(launchAtLogin: value)) }
  }

  func setShowMenuBar(_ value: Bool) {
    showMenuBar = value
    Task { await persist(GeneralSettingsPatch(showMenuBar: value)) }
  }

  func setDefaultOcrService(_ value: String) {
    defaultOcrService = value
    Task { await persist(GeneralSettingsPatch(defaultOcrService: value)) }
  }

  func setAutoCopyDetectedText(_ value: Bool) {
    autoCopyDetectedText = value
    Task { await persist(GeneralSettingsPatch(autoCopyDetectedText: value)) }
  }

  func setDefaultDirectoryService(_ value: String) {
    defaultDirectoryService = value
    Task { await persist(GeneralSettingsPatch(defaultDirectoryService: value)) }
  }

  func setDefaultTranslationService(_ value: String) {
    defaultTranslationService = value
    Task { await persist(GeneralSettingsPatch(defaultTranslationService: value)) }
  }

  func setTranslationMode(_ value: TranslationMode) {
    translationMode = value
    Task { await persist(GeneralSettingsPatch(translationMode: value)) }
  }

  func setInputSubmitMode(_ value: InputSubmitMode) {
    inputSubmitMode = value
    Task { await persist(GeneralSettingsPatch(inputSubmitMode: value)) }
  }

  func setDoubleClickCopyResult(_ value: Bool) {
    doubleClickCopyResult = value
    Task { await persist(GeneralSettingsPatch(doubleClickCopyResult: value)) }
  }

  private func persist(_ patch: GeneralSettingsPatch) async {
    do {
      apply(try await repository.updateGeneral(patch))
    } catch {
      await load()
    }
  }

  private func apply(_ settings: GeneralSettings) {
    launchAtLogin = settings.launchAtLogin
    showMenuBar = settings.showMenuBar
    defaultOcrService = settings.defaultOcrService
    autoCopyDetectedText = settings.autoCopyDetectedText
    defaultDirectoryService = settings.defaultDirectoryService
    defaultTranslationService = settings.defaultTranslationService
    translationMode = settings.translationMode
    translationTargets = settings.translationTargets
    inputSubmitMode = settings.inputSubmitMode
    doubleClickCopyResult = settings.doubleClickCopyResult
  }
}
