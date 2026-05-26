import SwiftUI
import beyondtranslate_runtime

struct ServiceOption: Identifiable, Hashable {
  let id: String
  let name: String
}

@MainActor
final class GeneralViewModel: ObservableObject {
  // Rust-backed settings
  @Published var launchAtLogin: Bool
  @Published var showInMenuBar: Bool
  @Published var defaultOcrService: String
  @Published var autoCopyDetectedText: Bool
  @Published var defaultDirectoryService: String
  @Published var defaultTranslationService: String
  @Published var translationTargets: [TranslationTarget]
  @Published var inputSubmitMode: InputSubmitMode
  @Published var doubleClickCopyResult: Bool
  @Published var commonLanguages: [String]

  // Runtime providers
  @Published var providers: [ProviderConfigEntry] = []

  // Sheet state
  @Published var showAddTargetSheet = false
  @Published var editingTarget: TranslationTarget? = nil

  // Supported languages
  var supportedLanguages: [LanguageInfo] {
    RuntimeProvider.shared.listLanguages()
  }

  /// Language codes that are marked as "common" (shown at top level).
  /// The order is preserved from settings; unsupported codes are dropped.
  var commonLanguageInfos: [LanguageInfo] {
    let allDict = Dictionary(uniqueKeysWithValues: supportedLanguages.map { ($0.code, $0) })
    return commonLanguages.compactMap { allDict[$0] }
  }

  /// Language codes NOT marked as common (shown in the "More..." section).
  var otherLanguageInfos: [LanguageInfo] {
    let all = supportedLanguages
    let codeSet = Set(commonLanguages)
    return all.filter { !codeSet.contains($0.code) }
  }

  var showEditTargetSheet: Binding<Bool> {
    Binding(
      get: { self.editingTarget != nil },
      set: { if !$0 { self.editingTarget = nil } }
    )
  }

  private let repository: SettingsRepository

  init(repository: SettingsRepository) {
    launchAtLogin = false
    showInMenuBar = true
    defaultOcrService = ""
    autoCopyDetectedText = true
    defaultDirectoryService = ""
    defaultTranslationService = ""
    translationTargets = []
    inputSubmitMode = .enter
    doubleClickCopyResult = true
    commonLanguages = []
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

  // Ocr service options.
  var ocrServiceOptions: [ServiceOption] {
    providers
      .filter { $0.capabilities.contains(.ocr) }
      .map { ServiceOption(id: $0.id, name: $0.id) }
  }

  var validDefaultOcrService: String {
    isDefaultOcrServiceValid ? defaultOcrService : ""
  }

  // Directory service options.
  var dictionaryServiceOptions: [ServiceOption] {
    providers
      .filter { $0.capabilities.contains(.dictionary) }
      .map { ServiceOption(id: $0.id, name: $0.id) }
  }

  var validDefaultDirectoryService: String {
    isDefaultDirectoryServiceValid ? defaultDirectoryService : ""
  }

  // Translation service options.
  var translationServiceOptions: [ServiceOption] {
    providers
      .filter { $0.capabilities.contains(.translation) }
      .map { ServiceOption(id: $0.id, name: $0.id) }
  }

  var validDefaultTranslationService: String {
    isDefaultTranslationServiceValid ? defaultTranslationService : ""
  }

  private var isDefaultOcrServiceValid: Bool {
    defaultOcrService.isEmpty
      || ocrServiceOptions.contains { $0.id == defaultOcrService }
  }

  private var isDefaultDirectoryServiceValid: Bool {
    defaultDirectoryService.isEmpty
      || dictionaryServiceOptions.contains { $0.id == defaultDirectoryService }
  }

  private var isDefaultTranslationServiceValid: Bool {
    defaultTranslationService.isEmpty
      || translationServiceOptions.contains { $0.id == defaultTranslationService }
  }

  func setLaunchAtLogin(_ value: Bool) {
    launchAtLogin = value
    Task { await persist(.diff(launchAtLogin: value)) }
  }

  func setShowInMenuBar(_ value: Bool) {
    showInMenuBar = value
    Task { await persist(.diff(showInMenuBar: value)) }
  }

  func setDefaultOcrService(_ value: String) {
    let providerID = Self.providerID(fromServiceID: value)
    defaultOcrService = providerID
    Task { await persist(.diff(defaultOcrService: providerID)) }
  }

  func setAutoCopyDetectedText(_ value: Bool) {
    autoCopyDetectedText = value
    Task { await persist(.diff(autoCopyDetectedText: value)) }
  }

  func setDefaultDirectoryService(_ value: String) {
    let providerID = Self.providerID(fromServiceID: value)
    defaultDirectoryService = providerID
    Task { await persist(.diff(defaultDirectoryService: providerID)) }
  }

  func setDefaultTranslationService(_ value: String) {
    let providerID = Self.providerID(fromServiceID: value)
    defaultTranslationService = providerID
    Task { await persist(.diff(defaultTranslationService: providerID)) }
  }

  func setInputSubmitMode(_ value: InputSubmitMode) {
    inputSubmitMode = value
    Task { await persist(.diff(inputSubmitMode: value)) }
  }

  func setDoubleClickCopyResult(_ value: Bool) {
    doubleClickCopyResult = value
    Task { await persist(.diff(doubleClickCopyResult: value)) }
  }

  func addTranslationTarget(source: String, target: String) {
    let newTarget = TranslationTarget(source: source, target: target, enabled: true)
    translationTargets.append(newTarget)
    Task { await persist(.diff(translationTargets: translationTargets)) }
  }

  func removeTranslationTarget(at index: Int) {
    guard translationTargets.indices.contains(index) else { return }
    translationTargets.remove(at: index)
    Task { await persist(.diff(translationTargets: translationTargets)) }
  }

  func toggleTranslationTargetEnabled(at index: Int) {
    guard translationTargets.indices.contains(index) else { return }
    translationTargets[index].enabled.toggle()
    Task { await persist(.diff(translationTargets: translationTargets)) }
  }

  func setCommonLanguages(_ languages: [String]) {
    commonLanguages = languages
    Task { await persist(.diff(commonLanguages: languages)) }
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
    showInMenuBar = settings.showInMenuBar
    defaultOcrService = Self.providerID(fromServiceID: settings.defaultOcrService)
    autoCopyDetectedText = settings.autoCopyDetectedText
    defaultDirectoryService = Self.providerID(fromServiceID: settings.defaultDirectoryService)
    defaultTranslationService = Self.providerID(fromServiceID: settings.defaultTranslationService)
    translationTargets = settings.translationTargets
    inputSubmitMode = settings.inputSubmitMode
    doubleClickCopyResult = settings.doubleClickCopyResult
    commonLanguages = settings.commonLanguages
  }

  private static func providerID(fromServiceID serviceID: String) -> String {
    for suffix in ["+translation", "+dictionary", "+ocr"] {
      if serviceID.hasSuffix(suffix) {
        return String(serviceID.dropLast(suffix.count))
      }
    }
    return serviceID
  }
}
