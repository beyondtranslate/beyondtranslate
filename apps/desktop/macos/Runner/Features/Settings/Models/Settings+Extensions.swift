import Foundation
import beyondtranslate_runtime

// MARK: - Identifiable / CaseIterable conformance for runtime enums

extension InputSubmitMode: Identifiable, CaseIterable {
  public static var allCases: [InputSubmitMode] { [.enter, .commandEnter] }
  public var id: String { String(describing: self) }

  var title: String {
    switch self {
    case .enter: return LocaleKeys.settings.general.row.submitWithEnter.tr()
    case .commandEnter:
      return LocaleKeys.settings.general.row.submitWithMetaEnterMac.tr()
    }
  }
}

extension TranslationTarget: Identifiable {
  public var id: String { "\(source)->\(target)" }
}

// MARK: - Patch convenience factories
//
// uniffi-generated `*SettingsPatch` types require every field at the
// memberwise initializer, which is noisy for single-field updates. The
// `diff(...)` factories default everything to `nil` so callers only need
// to specify the field(s) they actually want to change.

extension GeneralSettingsPatch {
  static func diff(
    launchAtLogin: Bool? = nil,
    showInMenuBar: Bool? = nil,
    defaultOcrService: String? = nil,
    autoCopyDetectedText: Bool? = nil,
    defaultDirectoryService: String? = nil,
    defaultTranslationService: String? = nil,
    translationTargets: [TranslationTarget]? = nil,
    inputSubmitMode: InputSubmitMode? = nil,
    doubleClickCopyResult: Bool? = nil,
    commonLanguages: [String]? = nil
  ) -> GeneralSettingsPatch {
    GeneralSettingsPatch(
      launchAtLogin: launchAtLogin,
      showInMenuBar: showInMenuBar,
      defaultOcrService: defaultOcrService,
      autoCopyDetectedText: autoCopyDetectedText,
      defaultDirectoryService: defaultDirectoryService,
      defaultTranslationService: defaultTranslationService,
      translationTargets: translationTargets,
      inputSubmitMode: inputSubmitMode,
      doubleClickCopyResult: doubleClickCopyResult,
      commonLanguages: commonLanguages
    )
  }
}

extension AppearanceSettingsPatch {
  static func diff(
    language: String? = nil,
    themeMode: String? = nil
  ) -> AppearanceSettingsPatch {
    AppearanceSettingsPatch(language: language, themeMode: themeMode)
  }
}

extension ShortcutSettingsPatch {
  static func diff(
    toggleMiniTranslator: String? = nil,
    extractTextFromScreenSelection: String? = nil,
    extractTextFromScreenCapture: String? = nil,
    extractTextFromClipboard: String? = nil,
    translateInputContent: String? = nil
  ) -> ShortcutSettingsPatch {
    ShortcutSettingsPatch(
      toggleMiniTranslator: toggleMiniTranslator,
      extractTextFromScreenSelection: extractTextFromScreenSelection,
      extractTextFromScreenCapture: extractTextFromScreenCapture,
      extractTextFromClipboard: extractTextFromClipboard,
      translateInputContent: translateInputContent
    )
  }
}

// MARK: - ProviderType

extension ProviderType: CaseIterable {
  public static var allCases: [ProviderType] {
    [
      .anthropic, .baidu, .caiyun, .deepL, .google, .iciba, .ollama, .openAi, .system, .tencent,
      .youdao,
    ]
  }
}

extension ProviderType: Identifiable {
  public var id: String {
    String(describing: self)
  }
}

extension ProviderType {
  /// The wire string used by the Rust backend ("baidu", "deepl", …).
  var wireValue: String {
    switch self {
    case .anthropic: return "anthropic"
    case .baidu: return "baidu"
    case .caiyun: return "caiyun"
    case .deepL: return "deepl"
    case .google: return "google"
    case .iciba: return "iciba"
    case .openAi: return "openai"
    case .ollama: return "ollama"
    case .system: return "system"
    case .tencent: return "tencent"
    case .youdao: return "youdao"
    }
  }

  /// Provider-specific configuration fields (API keys, endpoints, etc.).
  var configFields: [ProviderConfigField] {
    switch self {
    case .anthropic:
      return [
        ProviderConfigField(
          key: "apiKey", label: "API Key", placeholder: "sk-ant-…", isSecret: true,
          isOptional: false),
        ProviderConfigField(
          key: "baseUrl", label: "Base URL", placeholder: "https://api.anthropic.com",
          isSecret: false, isOptional: true),
        ProviderConfigField(
          key: "defaultModel", label: "Default Model",
          placeholder: "claude-sonnet-4-20250514", isSecret: false, isOptional: true),
      ]
    case .baidu:
      return [
        ProviderConfigField(
          key: "appId", label: "App ID", placeholder: "", isSecret: false, isOptional: false),
        ProviderConfigField(
          key: "appKey", label: "App Key", placeholder: "", isSecret: true, isOptional: false),
        ProviderConfigField(
          key: "baseUrl", label: "Base URL", placeholder: "https://fanyi-api.baidu.com",
          isSecret: false, isOptional: true),
      ]
    case .caiyun:
      return [
        ProviderConfigField(
          key: "token", label: "Token", placeholder: "", isSecret: true, isOptional: false),
        ProviderConfigField(
          key: "requestId", label: "Request ID", placeholder: "", isSecret: false,
          isOptional: false),
        ProviderConfigField(
          key: "baseUrl", label: "Base URL", placeholder: "http://api.interpreter.caiyunai.com",
          isSecret: false, isOptional: true),
      ]
    case .deepL:
      return [
        ProviderConfigField(
          key: "appKey", label: "API Key", placeholder: "", isSecret: true, isOptional: false),
        ProviderConfigField(
          key: "baseUrl", label: "Base URL", placeholder: "https://api.deepl.com",
          isSecret: false, isOptional: true),
      ]
    case .google:
      return [
        ProviderConfigField(
          key: "appKey", label: "API Key", placeholder: "AIza…", isSecret: true,
          isOptional: false),
        ProviderConfigField(
          key: "baseUrl", label: "Base URL", placeholder: "https://translation.googleapis.com",
          isSecret: false, isOptional: true),
      ]
    case .iciba:
      return [
        ProviderConfigField(
          key: "appKey", label: "API Key", placeholder: "", isSecret: true, isOptional: false),
        ProviderConfigField(
          key: "baseUrl", label: "Base URL", placeholder: "", isSecret: false, isOptional: true),
      ]
    case .openAi:
      return [
        ProviderConfigField(
          key: "apiKey", label: "API Key", placeholder: "sk-…", isSecret: true,
          isOptional: false),
        ProviderConfigField(
          key: "baseUrl", label: "Base URL", placeholder: "https://api.openai.com",
          isSecret: false, isOptional: true),
        ProviderConfigField(
          key: "defaultModel", label: "Default Model", placeholder: "gpt-4o-mini",
          isSecret: false, isOptional: true),
      ]
    case .ollama:
      return [
        ProviderConfigField(
          key: "baseUrl", label: "Base URL", placeholder: "http://localhost:11434",
          isSecret: false, isOptional: true),
        ProviderConfigField(
          key: "defaultModel", label: "Default Model", placeholder: "llama3",
          isSecret: false, isOptional: true),
      ]
    case .tencent:
      return [
        ProviderConfigField(
          key: "secretId", label: "Secret ID", placeholder: "", isSecret: false,
          isOptional: false),
        ProviderConfigField(
          key: "secretKey", label: "Secret Key", placeholder: "", isSecret: true,
          isOptional: false),
        ProviderConfigField(
          key: "baseUrl", label: "Base URL", placeholder: "", isSecret: false, isOptional: true),
      ]
    case .youdao:
      return [
        ProviderConfigField(
          key: "appKey", label: "App Key", placeholder: "", isSecret: true, isOptional: false),
        ProviderConfigField(
          key: "appSecret", label: "App Secret", placeholder: "", isSecret: true,
          isOptional: false),
        ProviderConfigField(
          key: "baseUrl", label: "Base URL", placeholder: "https://openapi.youdao.com",
          isSecret: false, isOptional: true),
        ProviderConfigField(
          key: "pictureBaseUrl", label: "Picture Base URL",
          placeholder: "https://picdict.youdao.com", isSecret: false, isOptional: true),
      ]
    case .system:
      return []
    }
  }
}

extension ProviderConfigEntry: Identifiable {
  var name: String {
    id
  }

  var endpoint: String {
    fields["baseUrl"] ?? ""
  }
}

extension ProviderType {
  /// Whether this provider type is an LLM-based provider.
  var isLlm: Bool {
    switch self {
    case .anthropic, .openAi, .ollama, .system:
      return true
    case .baidu, .caiyun, .deepL, .google, .iciba, .tencent, .youdao:
      return false
    }
  }

  static var llmProviders: [ProviderType] {
    allCases.filter { $0.isLlm }
  }

  static var traditionalProviders: [ProviderType] {
    allCases.filter { !$0.isLlm }
  }

  var providerDescription: String {
    switch self {
    case .anthropic, .ollama, .openAi, .system, .youdao:
      return LocaleKeys.settings.providers.description.all.tr()
    case .baidu, .caiyun, .deepL, .google, .tencent:
      return LocaleKeys.settings.providers.description.translation.tr()
    case .iciba:
      return LocaleKeys.settings.providers.description.dictionary.tr()
    }
  }
}

// MARK: - Display names and descriptions

extension ProviderType {
  var displayName: String {
    switch self {
    case .anthropic: return LocaleKeys.common.provider.anthropic.tr()
    case .baidu: return LocaleKeys.common.provider.baidu.tr()
    case .caiyun: return LocaleKeys.common.provider.caiyun.tr()
    case .deepL: return LocaleKeys.common.provider.deepl.tr()
    case .google: return LocaleKeys.common.provider.google.tr()
    case .iciba: return LocaleKeys.common.provider.iciba.tr()
    case .ollama: return LocaleKeys.common.provider.ollama.tr()
    case .openAi: return LocaleKeys.common.provider.openai.tr()
    case .tencent: return LocaleKeys.common.provider.tencent.tr()
    case .system: return LocaleKeys.common.provider.system.tr()
    case .youdao: return LocaleKeys.common.provider.youdao.tr()
    }
  }

  /// Short description of the hosting/feature scope.
  var hostingDescription: String {
    switch self {
    case .anthropic, .ollama, .openAi, .system, .youdao:
      return LocaleKeys.settings.providers.description.all.tr()
    case .baidu, .caiyun, .deepL, .google, .tencent:
      return LocaleKeys.settings.providers.description.translation.tr()
    case .iciba:
      return LocaleKeys.settings.providers.description.dictionary.tr()
    }
  }
}

extension ServiceConfigEntry: Identifiable {}
