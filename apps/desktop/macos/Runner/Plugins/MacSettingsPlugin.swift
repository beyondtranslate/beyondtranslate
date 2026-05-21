import FlutterMacOS

final class MacSettingsPlugin: NSObject, FlutterPlugin {
  static let channelName = "beyondtranslate/mac_settings"

  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: channelName,
      binaryMessenger: registrar.messenger
    )
    registrar.addMethodCallDelegate(MacSettingsPlugin(), channel: channel)
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "showSettings":
      Task { @MainActor in
        self.showSettings()
        result(nil)
      }
    case "highlightPermissions":
      Task { @MainActor in
        SettingsHighlightCoordinator.shared.requestHighlightPermissionsSection()
        result(nil)
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  @MainActor
  private func showSettings() {
    SettingsWindowController.shared.showSettings()
  }
}
