import SwiftUI

final class GeneralViewModel: ObservableObject {
  @Published var defaultOcrEngine: String
  @Published var autoCopyDetectedText: Bool
  @Published var defaultTranslateEngine: String
  @Published var translationMode: TranslationMode
  @Published var defaultDetectLanguageEngine: String
  @Published var translationTargets: [TranslationTargetItem]
  @Published var inputSubmitMode: InputSubmitMode
  @Published var doubleClickCopyResult: Bool

  init(settings: GeneralSettings = GeneralSettings()) {
    defaultOcrEngine = settings.defaultOcrEngine
    autoCopyDetectedText = settings.autoCopyDetectedText
    defaultTranslateEngine = settings.defaultTranslateEngine
    translationMode = settings.translationMode
    defaultDetectLanguageEngine = settings.defaultDetectLanguageEngine
    translationTargets = settings.translationTargets
    inputSubmitMode = settings.inputSubmitMode
    doubleClickCopyResult = settings.doubleClickCopyResult
  }
}
