import Foundation

enum SettingsSection: String, CaseIterable, Identifiable {
  case general
  case appearance
  case shortcuts
  case providers
  case advanced

  var id: String { rawValue }

  var title: String {
    switch self {
    case .general: return "General"
    case .appearance: return "Appearance"
    case .shortcuts: return "Shortcuts"
    case .providers: return "Providers"
    case .advanced: return "Advanced"
    }
  }

  var icon: String {
    switch self {
    case .general: return "gearshape"
    case .appearance: return "paintbrush"
    case .shortcuts: return "keyboard"
    case .providers: return "server.rack"
    case .advanced: return "slider.horizontal.3"
    }
  }
}

enum TranslationMode: String, CaseIterable, Identifiable {
  case manual
  case auto

  var id: String { rawValue }

  var title: String {
    switch self {
    case .manual: return "Manual"
    case .auto: return "Auto"
    }
  }
}

enum InputSubmitMode: String, CaseIterable, Identifiable {
  case enter
  case commandEnter

  var id: String { rawValue }

  var title: String {
    switch self {
    case .enter: return "Submit with Enter"
    case .commandEnter: return "Submit with Command + Enter"
    }
  }
}

enum AppThemeMode: String, CaseIterable, Identifiable {
  case light
  case dark
  case system

  var id: String { rawValue }

  var title: String {
    switch self {
    case .light: return "Light"
    case .dark: return "Dark"
    case .system: return "System"
    }
  }
}

struct TranslationTargetItem: Identifiable {
  let id = UUID()
  let source: String
  let target: String
}

struct ShortcutDisplay {
  let parts: [String]
}

enum ProviderListKind: String, Identifiable, CaseIterable {
  case traditional
  case llm

  var id: String { rawValue }

  var title: String {
    switch self {
    case .traditional: return "Translation Providers"
    case .llm: return "LLM Providers"
    }
  }

  var addTitle: String {
    switch self {
    case .traditional: return "Add Translation Provider"
    case .llm: return "Add Model Provider"
    }
  }

  var emptyDescription: String {
    switch self {
    case .traditional:
      return "Wrap translation and dictionary services into reusable providers."
    case .llm:
      return "Configure hosted or local model endpoints for future AI features."
    }
  }
}

enum ProviderHostingOption: String, CaseIterable, Identifiable {
  case internetHosted
  case locallyHosted

  var id: String { rawValue }

  var title: String {
    switch self {
    case .internetHosted: return "Internet Hosted"
    case .locallyHosted: return "Locally Hosted"
    }
  }
}

enum ProviderCapability: String, CaseIterable, Identifiable {
  case translation
  case dictionary
  case chatCompletion
  case embeddings

  var id: String { rawValue }

  var title: String {
    switch self {
    case .translation: return "Translation"
    case .dictionary: return "Dictionary"
    case .chatCompletion: return "Chat"
    case .embeddings: return "Embeddings"
    }
  }
}

struct ProviderItem: Identifiable {
  let id: UUID
  var name: String
  var endpoint: String
  var apiKeyHeader: String
  var description: String
  var listKind: ProviderListKind
  var hosting: ProviderHostingOption
  var capabilities: [ProviderCapability]
  var isEnabled: Bool
}

struct ProviderDraft: Identifiable {
  let id = UUID()
  let providerID: UUID?
  let listKind: ProviderListKind
  var name: String
  var endpoint: String
  var apiKey: String
  var apiKeyHeader: String
  var description: String
  var hosting: ProviderHostingOption

  var title: String {
    providerID == nil ? listKind.addTitle : "Edit Provider"
  }

  static func new(listKind: ProviderListKind) -> ProviderDraft {
    ProviderDraft(
      providerID: nil,
      listKind: listKind,
      name: listKind == .traditional ? "My Provider" : "My Model Provider",
      endpoint: "https://api.host.com",
      apiKey: "",
      apiKeyHeader: "x-api-key",
      description: "My Account",
      hosting: .internetHosted
    )
  }

  static func edit(item: ProviderItem) -> ProviderDraft {
    ProviderDraft(
      providerID: item.id,
      listKind: item.listKind,
      name: item.name,
      endpoint: item.endpoint,
      apiKey: "",
      apiKeyHeader: item.apiKeyHeader,
      description: item.description,
      hosting: item.hosting
    )
  }
}
