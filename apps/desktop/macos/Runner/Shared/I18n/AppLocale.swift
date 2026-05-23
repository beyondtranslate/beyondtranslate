import Combine
import Foundation

final class AppLocale: ObservableObject {
  static let shared = AppLocale()

  static let userDefaultsKey = "macSettings.appearance.language"

  @Published private(set) var languageCode: String

  private init(userDefaults: UserDefaults = .standard) {
    languageCode = Self.normalize(
      userDefaults.string(forKey: Self.userDefaultsKey)
        ?? Locale.preferredLanguages.first
        ?? Locale.current.identifier
    )
  }

  func setLocale(_ languageCode: String, userDefaults: UserDefaults = .standard) {
    let languageCode = Self.normalize(languageCode)
    userDefaults.set(languageCode, forKey: Self.userDefaultsKey)
    userDefaults.set([languageCode], forKey: "AppleLanguages")

    guard self.languageCode != languageCode else { return }
    self.languageCode = languageCode
  }

  func localizedString(_ key: String) -> String {
    guard
      let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
      let bundle = Bundle(path: path)
    else {
      return Bundle.main.localizedString(forKey: key, value: nil, table: nil)
    }
    return bundle.localizedString(forKey: key, value: nil, table: nil)
  }

  private static func normalize(_ languageCode: String) -> String {
    let languageCode = languageCode.lowercased()
    if languageCode.hasPrefix("en") { return "en" }
    if languageCode.hasPrefix("zh") {
      if languageCode.contains("hant") || languageCode.contains("tw") || languageCode.contains("hk")
        || languageCode.contains("mo")
      {
        return "zh-Hant"
      }
      return "zh-Hans"
    }
    if languageCode.hasPrefix("ja") { return "ja" }
    if languageCode.hasPrefix("es") { return "es" }
    if languageCode.hasPrefix("ko") { return "ko" }
    if languageCode.hasPrefix("fr") { return "fr" }
    return languageCode
  }
}
