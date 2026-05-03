import SwiftUI

@MainActor
final class GeneralViewModel: ObservableObject {
  // Local-only settings (not yet backed by Rust)
  @Published var defaultOcrEngine: String
  @Published var autoCopyDetectedText: Bool
  @Published var defaultTranslateEngine: String
  @Published var translationMode: TranslationMode
  @Published var defaultDetectLanguageEngine: String
  @Published var translationTargets: [TranslationTargetItem]
  @Published var inputSubmitMode: InputSubmitMode
  @Published var doubleClickCopyResult: Bool

  // Rust-backed settings
  @Published var launchAtLogin: Bool
  @Published var showMenuBar: Bool

  private let repository: SettingsRepository

  init(settings: GeneralLocalSettings = GeneralLocalSettings(), repository: SettingsRepository) {
    defaultOcrEngine = settings.defaultOcrEngine
    autoCopyDetectedText = settings.autoCopyDetectedText
    defaultTranslateEngine = settings.defaultTranslateEngine
    translationMode = settings.translationMode
    defaultDetectLanguageEngine = settings.defaultDetectLanguageEngine
    translationTargets = settings.translationTargets
    inputSubmitMode = settings.inputSubmitMode
    doubleClickCopyResult = settings.doubleClickCopyResult

    launchAtLogin = false
    showMenuBar = true
    self.repository = repository
  }

  func load() async {
    do {
      apply(try await repository.getGeneral())
    } catch {
      // Keep the local preview/default state when the Rust-backed settings cannot be loaded.
    }
  }

  func setLaunchAtLogin(_ value: Bool) {
    launchAtLogin = value
    Task {
      do {
        let updated = try await repository.updateGeneral(
          GeneralSettingsPatch(launchAtLogin: value, showMenuBar: nil)
        )
        apply(updated)
      } catch {
        await load()
      }
    }
  }

  func setShowMenuBar(_ value: Bool) {
    showMenuBar = value
    Task {
      do {
        let updated = try await repository.updateGeneral(
          GeneralSettingsPatch(launchAtLogin: nil, showMenuBar: value)
        )
        apply(updated)
      } catch {
        await load()
      }
    }
  }

  private func apply(_ settings: GeneralSettings) {
    launchAtLogin = settings.launchAtLogin
    showMenuBar = settings.showMenuBar
  }
}
