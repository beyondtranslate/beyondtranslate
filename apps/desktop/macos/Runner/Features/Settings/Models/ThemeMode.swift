import SwiftUI

enum ThemeMode: String, CaseIterable, Identifiable {
  case light
  case dark
  case system

  var id: String { rawValue }

  var title: String {
    switch self {
    case .light: return LocaleKeys.common.themeMode.light.tr()
    case .dark: return LocaleKeys.common.themeMode.dark.tr()
    case .system: return LocaleKeys.common.themeMode.system.tr()
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
