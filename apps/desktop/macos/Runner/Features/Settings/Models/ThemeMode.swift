import SwiftUI

enum ThemeMode: String, CaseIterable, Identifiable {
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

}
