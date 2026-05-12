import AppKit
import FlutterMacOS

final class MacSettingsPlugin: NSObject, FlutterPlugin {
  static let channelName = "beyondtranslate/mac_settings"
  private let settingsWindowID = NSUserInterfaceItemIdentifier("AppSettings")

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
        SettingsHighlightCoordinator.shared.highlightPermissions()
        result(nil)
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  @MainActor
  private func showSettings() {
    NSApp.activate(ignoringOtherApps: true)

    if let window = NSApp.windows.first(where: { $0.identifier == settingsWindowID }) {
      let targetSize = NSSize(width: 820, height: 560)
      window.minSize = NSSize(width: 720, height: 480)

      let mouseLocation = NSEvent.mouseLocation
      let targetScreen = NSScreen.screens.first { NSMouseInRect(mouseLocation, $0.frame, false) }
        ?? window.screen
        ?? NSScreen.main

      if
        window.isVisible,
        let currentScreen = window.screen,
        let resolvedTargetScreen = targetScreen,
        currentScreen != resolvedTargetScreen
      {
        window.orderOut(nil)
      }

      if let visibleFrame = targetScreen?.visibleFrame {
        let originX = visibleFrame.origin.x + (visibleFrame.width - targetSize.width) / 2
        let originY = visibleFrame.origin.y + (visibleFrame.height - targetSize.height) / 2
        let frame = NSRect(x: originX, y: originY, width: targetSize.width, height: targetSize.height)
        window.setFrame(frame, display: true, animate: false)
      } else {
        let frame = NSRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        window.setFrame(frame, display: true, animate: false)
        window.center()
      }

      window.orderFrontRegardless()
      window.makeKeyAndOrderFront(nil)
      window.makeMain()
    } else {
      NSLog("[MacSettingsPlugin] AppSettings window not found.")
    }
  }
}
