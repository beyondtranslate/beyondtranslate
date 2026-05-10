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
}

extension InputSubmitMode: Identifiable, CaseIterable {
  public static var allCases: [InputSubmitMode] { [.enter, .commandEnter] }
  public var id: String { String(describing: self) }
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
    showMenuBar: Bool? = nil,
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
      showMenuBar: showMenuBar,
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
    toggleApp: String? = nil,
    hideApp: String? = nil,
    extractFromScreenSelection: String? = nil,
    extractFromScreenCapture: String? = nil,
    extractFromClipboard: String? = nil
  ) -> ShortcutSettingsPatch {
    ShortcutSettingsPatch(
      toggleApp: toggleApp,
      hideApp: hideApp,
      extractFromScreenSelection: extractFromScreenSelection,
      extractFromScreenCapture: extractFromScreenCapture,
      extractFromClipboard: extractFromClipboard
    )
  }
}
