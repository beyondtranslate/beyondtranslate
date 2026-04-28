import SwiftUI

final class SettingsViewModel: ObservableObject {
  @Published var defaultOcrEngine = "Built-in OCR"
  @Published var autoCopyDetectedText = true

  @Published var defaultTranslateEngine = "OpenAI"
  @Published var translationMode: TranslationMode = .auto
  @Published var defaultDetectLanguageEngine = "Google Translate"
  @Published var translationTargets: [TranslationTargetItem] = [
    TranslationTargetItem(source: "English", target: "Chinese"),
    TranslationTargetItem(source: "Japanese", target: "Chinese")
  ]
  @Published var inputSubmitMode: InputSubmitMode = .enter
  @Published var doubleClickCopyResult = true

  @Published var showTrayIcon = true
  @Published var maxWindowHeight: Double = 800
  @Published var appLanguage = "English"
  @Published var themeMode: AppThemeMode = .system

  @Published var shortcutShowOrHide = ShortcutDisplay(parts: ["Control", "Option", "Space"])
  @Published var shortcutHide = ShortcutDisplay(parts: ["Escape"])
  @Published var shortcutExtractSelection = ShortcutDisplay(parts: ["Control", "Shift", "1"])
  @Published var shortcutExtractCapture = ShortcutDisplay(parts: ["Control", "Shift", "2"])
  @Published var shortcutExtractClipboard = ShortcutDisplay(parts: ["Control", "Shift", "3"])
  @Published var shortcutTranslateInput = ShortcutDisplay(parts: ["Control", "Shift", "Return"])

  @Published var launchAtStartup = false

  @Published var traditionalProviders: [ProviderItem] = [
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

  @Published var llmProviders: [ProviderItem] = [
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

  func toggleProvider(_ providerID: UUID, in listKind: ProviderListKind, isEnabled: Bool) {
    switch listKind {
    case .traditional:
      guard let index = traditionalProviders.firstIndex(where: { $0.id == providerID }) else { return }
      traditionalProviders[index].isEnabled = isEnabled
    case .llm:
      guard let index = llmProviders.firstIndex(where: { $0.id == providerID }) else { return }
      llmProviders[index].isEnabled = isEnabled
    }
  }

  func saveProvider(_ draft: ProviderDraft) {
    let capabilities: [ProviderCapability] =
      draft.listKind == .traditional
      ? [.translation, .dictionary]
      : [.chatCompletion]

    let item = ProviderItem(
      id: draft.providerID ?? UUID(),
      name: draft.name,
      endpoint: draft.endpoint,
      apiKeyHeader: draft.apiKeyHeader,
      description: draft.description,
      listKind: draft.listKind,
      hosting: draft.hosting,
      capabilities: capabilities,
      isEnabled: true
    )

    switch draft.listKind {
    case .traditional:
      upsert(item, into: &traditionalProviders)
    case .llm:
      upsert(item, into: &llmProviders)
    }
  }

  private func upsert(_ item: ProviderItem, into items: inout [ProviderItem]) {
    if let index = items.firstIndex(where: { $0.id == item.id }) {
      items[index] = item
    } else {
      items.append(item)
    }
  }
}
