import Foundation

struct AppSettings {
  var general = GeneralSettings()
  var appearance = AppearanceSettingsState()
  var shortcuts = ShortcutSettingsState()
  var providers = ProviderSettings()
  var advanced = AdvancedSettingsState()
}

struct GeneralSettings {
  var defaultOcrEngine = "Built-in OCR"
  var autoCopyDetectedText = true
  var defaultTranslateEngine = "OpenAI"
  var translationMode: TranslationMode = .auto
  var defaultDetectLanguageEngine = "Google Translate"
  var translationTargets: [TranslationTargetItem] = [
    TranslationTargetItem(source: "English", target: "Chinese"),
    TranslationTargetItem(source: "Japanese", target: "Chinese")
  ]
  var inputSubmitMode: InputSubmitMode = .enter
  var doubleClickCopyResult = true
}

struct AppearanceSettingsState {
  var showTrayIcon = true
  var maxWindowHeight: Double = 800
  var appLanguage = "English"
  var themeMode: AppThemeMode = .system
}

struct ShortcutSettingsState {
  var showOrHide = ShortcutDisplay(parts: ["Control", "Option", "Space"])
  var hide = ShortcutDisplay(parts: ["Escape"])
  var extractSelection = ShortcutDisplay(parts: ["Control", "Shift", "1"])
  var extractCapture = ShortcutDisplay(parts: ["Control", "Shift", "2"])
  var extractClipboard = ShortcutDisplay(parts: ["Control", "Shift", "3"])
  var translateInput = ShortcutDisplay(parts: ["Control", "Shift", "Return"])
}

struct ProviderSettings {
  var traditionalProviders: [ProviderItem] = [
    ProviderItem(
      id: UUID(),
      name: "Google Translate Wrapper",
      endpoint: "https://translate.googleapis.com",
      apiKeyHeader: "x-api-key",
      description: "Shared account for translation and dictionary fallback.",
      listKind: .traditional,
      hosting: .internetHosted,
      capabilities: [.translation, .dictionary],
      isEnabled: true
    ),
    ProviderItem(
      id: UUID(),
      name: "DeepL Team Gateway",
      endpoint: "https://api.deepl.com",
      apiKeyHeader: "Authorization",
      description: "Team-managed DeepL entrypoint for high-quality translation.",
      listKind: .traditional,
      hosting: .internetHosted,
      capabilities: [.translation],
      isEnabled: true
    ),
    ProviderItem(
      id: UUID(),
      name: "Youdao Suite",
      endpoint: "https://openapi.youdao.com",
      apiKeyHeader: "x-app-key",
      description: "Internal wrapper with dictionary enrichment.",
      listKind: .traditional,
      hosting: .internetHosted,
      capabilities: [.translation, .dictionary],
      isEnabled: false
    )
  ]

  var llmProviders: [ProviderItem] = [
    ProviderItem(
      id: UUID(),
      name: "OpenAI Responses",
      endpoint: "https://api.openai.com/v1",
      apiKeyHeader: "Authorization",
      description: "Primary hosted model endpoint for AI-assisted translation.",
      listKind: .llm,
      hosting: .internetHosted,
      capabilities: [.chatCompletion, .embeddings],
      isEnabled: true
    ),
    ProviderItem(
      id: UUID(),
      name: "Anthropic Claude",
      endpoint: "https://api.anthropic.com/v1",
      apiKeyHeader: "x-api-key",
      description: "Secondary hosted model provider.",
      listKind: .llm,
      hosting: .internetHosted,
      capabilities: [.chatCompletion],
      isEnabled: true
    ),
    ProviderItem(
      id: UUID(),
      name: "Local Ollama",
      endpoint: "http://127.0.0.1:11434",
      apiKeyHeader: "x-api-key",
      description: "On-device inference for development and offline use.",
      listKind: .llm,
      hosting: .locallyHosted,
      capabilities: [.chatCompletion, .embeddings],
      isEnabled: false
    )
  ]
}

struct AdvancedSettingsState {
  var launchAtStartup = false
}
