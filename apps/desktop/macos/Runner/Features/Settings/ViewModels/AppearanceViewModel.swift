import SwiftUI

final class AppearanceViewModel: ObservableObject {
  @Published var showTrayIcon: Bool
  @Published var maxWindowHeight: Double
  @Published var appLanguage: String
  @Published var themeMode: AppThemeMode

  init(settings: AppearanceSettings = AppearanceSettings()) {
    showTrayIcon = settings.showTrayIcon
    maxWindowHeight = settings.maxWindowHeight
    appLanguage = settings.appLanguage
    themeMode = settings.themeMode
  }
}
