import AppKit
import SwiftUI
import beyondtranslate_runtime

enum SettingsSection: String, CaseIterable, Identifiable {
  case general
  case appearance
  case shortcuts
  case providers
  case advanced

  var id: String { rawValue }

  var title: String {
    switch self {
    case .general: return LocaleKeys.settings.general.title.tr()
    case .appearance: return LocaleKeys.settings.appearance.title.tr()
    case .shortcuts: return LocaleKeys.settings.shortcuts.title.tr()
    case .providers: return LocaleKeys.settings.providers.title.tr()
    case .advanced: return LocaleKeys.settings.advanced.title.tr()
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

extension TranslationMode {
  var title: String {
    switch self {
    case .auto: return LocaleKeys.translation.mode.auto.tr()
    case .manual: return LocaleKeys.translation.mode.manual.tr()
    }
  }
}

extension InputSubmitMode {
  var title: String {
    switch self {
    case .enter: return LocaleKeys.settings.general.row.submitWithEnter.tr()
    case .commandEnter:
      return LocaleKeys.settings.general.row.submitWithMetaEnterMac.tr()
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
    case .light: return LocaleKeys.theme.mode.light.tr()
    case .dark: return LocaleKeys.theme.mode.dark.tr()
    case .system: return LocaleKeys.theme.mode.system.tr()
    }
  }

  var colorScheme: ColorScheme? {
    switch self {
    case .light: return .light
    case .dark: return .dark
    case .system: return nil
    }
  }

  var nsAppearance: NSAppearance? {
    switch self {
    case .light:
      return NSAppearance(named: .aqua)
    case .dark:
      return NSAppearance(named: .darkAqua)
    case .system:
      return nil
    }
  }
}

@MainActor
enum ThemeAppearanceController {
  static let userDefaultsKey = "macSettings.appearance.themeMode"

  static func applySavedPreference(userDefaults: UserDefaults = .standard) {
    apply(rawValue: userDefaults.string(forKey: userDefaultsKey))
  }

  static func apply(rawValue: String?) {
    apply(AppThemeMode(rawValue: rawValue ?? "") ?? .system)
  }

  static func apply(_ mode: AppThemeMode) {
    NSApp.appearance = mode.nsAppearance
  }
}

struct ShortcutDisplay {
  let parts: [String]

  init(parts: [String]) {
    self.parts = parts
  }

  init(rawValue: String) {
    let parsed =
      rawValue
      .split(separator: "+")
      .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
      .filter { !$0.isEmpty }
    parts = parsed
  }

  var rawValue: String {
    parts.joined(separator: "+")
  }

  var displayText: String {
    parts.joined(separator: "")
  }
}

extension ProviderConfigEntry: Identifiable {}

extension ProviderConfigEntry {
  static func newProvider() -> ProviderConfigEntry {
    ProviderConfigEntry(id: "my-provider", type: ProviderType.deepL.wireValue, fields: [:], capabilities: [])
  }

  var providerType: ProviderType {
    ProviderType.fromWire(type) ?? .deepL
  }

  var name: String {
    id
  }

  var endpoint: String {
    fields["baseUrl"] ?? ""
  }

  var providerCapabilities: [ProviderCapability] {
    capabilities.compactMap { ProviderCapability.fromWire($0) }
  }
}
