import Foundation
import beyondtranslate_runtime

// MARK: - Identifiable / CaseIterable conformance for runtime enums
//
// The uniffi-generated `TranslationMode` and `InputSubmitMode` are plain
// `case` enums (not `String`-backed). SwiftUI's `ForEach`/`Picker` need
// `Identifiable`, so we add it via extensions; `CaseIterable` lets us
// drive the picker from a static list.

extension TranslationMode: Identifiable, CaseIterable {
  public static var allCases: [TranslationMode] { [.auto, .manual] }
  public var id: String { String(describing: self) }

  var title: String {
    switch self {
    case .auto: return LocaleKeys.translation.mode.auto.tr()
    case .manual: return LocaleKeys.translation.mode.manual.tr()
    }
  }
}

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
    translationMode: TranslationMode? = nil,
    translationTargets: [TranslationTarget]? = nil,
    inputSubmitMode: InputSubmitMode? = nil,
    doubleClickCopyResult: Bool? = nil
  ) -> GeneralSettingsPatch {
    GeneralSettingsPatch(
      launchAtLogin: launchAtLogin,
      showInMenuBar: showInMenuBar,
      defaultOcrService: defaultOcrService,
      autoCopyDetectedText: autoCopyDetectedText,
      defaultDirectoryService: defaultDirectoryService,
      defaultTranslationService: defaultTranslationService,
      translationMode: translationMode,
      translationTargets: translationTargets,
      inputSubmitMode: inputSubmitMode,
      doubleClickCopyResult: doubleClickCopyResult
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

// MARK: - ProviderCapability

extension ProviderCapability: Identifiable {
  public var id: String {
    String(describing: self)
  }
}

// MARK: - ProviderType

extension ProviderType: CaseIterable {
  public static var allCases: [ProviderType] {
    [.baidu, .caiyun, .deepL, .google, .iciba, .system, .tencent, .youdao]
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
    case .baidu: return "baidu"
    case .caiyun: return "caiyun"
    case .deepL: return "deepl"
    case .google: return "google"
    case .iciba: return "iciba"
    case .system: return "system"
    case .tencent: return "tencent"
    case .youdao: return "youdao"
    }
  }

  /// Provider-specific configuration fields (API keys, endpoints, etc.).
  var configFields: [ProviderConfigField] {
    switch self {
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
