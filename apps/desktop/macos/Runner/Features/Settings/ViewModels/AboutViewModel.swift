import AppKit
import Foundation
import beyondtranslate_runtime

@MainActor
final class AboutViewModel: ObservableObject {
  let appVersion: String
  let buildNumber: String

  init() {
    let versionStr = version()
    let bundleVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"

    appVersion = versionStr
    buildNumber = bundleVersion
  }

  var fullVersionString: String {
    LocaleKeys.settings.version.tr(appVersion, buildNumber)
  }

  func copyVersionInfo() {
    let info = "Beyond Translate \(fullVersionString)"
    NSPasteboard.general.clearContents()
    NSPasteboard.general.setString(info, forType: .string)
  }
}
