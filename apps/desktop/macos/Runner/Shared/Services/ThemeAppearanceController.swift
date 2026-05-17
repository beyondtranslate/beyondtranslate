import AppKit
import SwiftUI

@MainActor
enum ThemeAppearanceController {
  static let userDefaultsKey = "macSettings.appearance.themeMode"

  static func applySavedPreference(userDefaults: UserDefaults = .standard) {
    apply(rawValue: userDefaults.string(forKey: userDefaultsKey))
  }

  static func apply(rawValue: String?) {
    apply(ThemeMode(rawValue: rawValue ?? "") ?? .system)
  }

  static func apply(_ mode: ThemeMode) {
    switch mode {
    case .light:
      NSApp.appearance = NSAppearance(named: .aqua)
    case .dark:
      NSApp.appearance = NSAppearance(named: .darkAqua)
    case .system:
      // Clear the app-level appearance override so the system
      // appearance (light/dark from System Settings) takes effect.
      // macOS caches the override, so we must also clear each
      // window's appearance to force a full re-evaluation.
      NSApp.appearance = nil
      for window in NSApp.windows {
        window.appearance = nil
      }
    }
  }
}
