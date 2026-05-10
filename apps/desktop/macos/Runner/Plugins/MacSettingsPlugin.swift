import AppKit
import FlutterMacOS
import SwiftUI

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
        SettingsWindowController.shared.showWindow()
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
}

// MARK: - Settings Window Controller

@MainActor
private final class SettingsWindowController: NSWindowController, NSWindowDelegate {
  static let shared = SettingsWindowController()

  private init() {
    let window = NSWindow(
      contentRect: NSRect(x: 0, y: 0, width: 820, height: 560),
      styleMask: [.titled, .closable, .miniaturizable, .resizable],
      backing: .buffered,
      defer: false
    )
    window.title = "Settings"
    window.titleVisibility = .visible
    window.titlebarAppearsTransparent = true
    window.styleMask.insert(.fullSizeContentView)
    window.isReleasedWhenClosed = false
    window.minSize = NSSize(width: 720, height: 480)

    super.init(window: window)
    shouldCascadeWindows = true
    window.delegate = self
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) { nil }

  /// Creates a fresh SettingsView (and SettingsViewModel) each time the
  /// window is shown, so settings are always loaded from the current
  /// Rust state rather than a stale snapshot.
  func showWindow() {
    guard let window else { return }

    window.contentViewController = NSHostingController(rootView: SettingsView())
    window.center()
    NSApp.activate(ignoringOtherApps: true)
    window.makeKeyAndOrderFront(nil)
  }

  func windowWillClose(_ notification: Notification) {
    window?.orderOut(nil)
  }
}
