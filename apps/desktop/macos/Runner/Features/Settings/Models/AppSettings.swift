import Foundation

struct AppSettings {
  var general = GeneralLocalSettings()
  var appearance = AppearanceSettingsState()
}

struct GeneralLocalSettings {
  var defaultOcrEngine = "Built-in OCR"
  var autoCopyDetectedText = true
  var defaultTranslateEngine = "OpenAI"
  var translationMode: TranslationMode = .auto
  var defaultDetectLanguageEngine = "Google Translate"
  var translationTargets: [TranslationTargetItem] = [
    TranslationTargetItem(source: "English", target: "Chinese"),
    TranslationTargetItem(source: "Japanese", target: "Chinese"),
  ]
  var inputSubmitMode: InputSubmitMode = .enter
  var doubleClickCopyResult = true
}

struct AppearanceSettingsState {
  var appLanguage = "English"
  var themeMode: AppThemeMode = .system
}
