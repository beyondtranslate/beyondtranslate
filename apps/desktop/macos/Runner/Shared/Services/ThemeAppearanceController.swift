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
    NSApp.appearance = mode.nsAppearance
  }
}
