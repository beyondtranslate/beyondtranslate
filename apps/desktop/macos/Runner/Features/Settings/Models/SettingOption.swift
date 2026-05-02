import AppKit
import SwiftUI

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
  static let userDefaultsKey = "nativeSettings.appearance.themeMode"

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

struct TranslationTargetItem: Identifiable {
  let id = UUID()
  let source: String
  let target: String
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

struct ProviderItem: Identifiable {
  let id: UUID
  var backendID: String
  var providerType: ProviderType
  var name: String
  var endpoint: String
  var apiKeyHeader: String
  var description: String
  var hosting: ProviderHostingOption
  var capabilities: [ProviderCapability]
  var isEnabled: Bool
  var fields: [String: String]
}

extension ProviderItem {
  /// Creates a `ProviderItem` from a backend `ProviderConfigEntry`.
  init(id: UUID = UUID(), from entry: ProviderConfigEntry, isEnabled: Bool = true) {
    self.id = id
    self.backendID = entry.id
    self.providerType = ProviderType(rawValue: entry.type) ?? .deepL
    self.name = entry.id
    self.description = entry.type
    self.endpoint = entry.fields["baseUrl"] ?? ""
    self.apiKeyHeader = ""
    self.hosting = .internetHosted
    self.capabilities = entry.capabilities.compactMap { ProviderCapability(rawValue: $0) }
    self.isEnabled = isEnabled
    self.fields = entry.fields
  }
}

struct ProviderDraft: Identifiable {
  let id = UUID()
  /// `nil` for a new provider; the local UUID of the item being edited otherwise.
  let localID: UUID?
  /// The backend string identifier (e.g., "deepl-main").  Editable only when adding.
  var backendID: String
  /// The provider type, selected via a Picker.
  var providerType: ProviderType
  /// Type-specific config values keyed by provider field name (wire names, camelCase).
  var fields: [String: String]

  var title: String {
    localID == nil ? "Add Provider" : "Edit Provider"
  }

  static func new() -> ProviderDraft {
    ProviderDraft(localID: nil, backendID: "my-provider", providerType: .deepL, fields: [:])
  }

  static func edit(item: ProviderItem) -> ProviderDraft {
    ProviderDraft(
      localID: item.id,
      backendID: item.backendID,
      providerType: item.providerType,
      fields: item.fields
    )
  }
}
