import AppKit
import FlutterMacOS

final class MacWindowAppearancePlugin: NSObject, FlutterPlugin {
  private static let backgroundIdentifier = NSUserInterfaceItemIdentifier("bt.windowBackground")
  private static let toolbarIdentifier = NSToolbar.Identifier("bt.windowToolbar")

  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "beyondtranslate/mac_window_appearance",
      binaryMessenger: registrar.messenger
    )
    registrar.addMethodCallDelegate(MacWindowAppearancePlugin(), channel: channel)
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "apply":
      Task { @MainActor in
        guard
          let arguments = call.arguments as? [String: Any],
          let title = arguments["title"] as? String
        else {
          result(
            FlutterError(
              code: "bad_args",
              message: "Expected window title.",
              details: nil
            ))
          return
        }

        Self.apply(title: title)
        result(nil)
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  @MainActor
  private static func apply(title: String) {
    guard let window = NSApp.windows.first(where: { $0.title == title }) else {
      return
    }

    window.isOpaque = false
    window.backgroundColor = .clear
    window.hasShadow = true
    configureToolbarWindow(window)
    clearFlutterViewBackground(in: window.contentViewController)
    installBackground(in: window)

    window.contentView?.wantsLayer = true
    window.contentView?.layer?.cornerRadius = 12.0
  }

  @MainActor
  private static func configureToolbarWindow(_ window: NSWindow) {
    window.styleMask.insert([.titled, .fullSizeContentView])
    window.titleVisibility = .hidden
    window.titlebarAppearsTransparent = true
    window.toolbarStyle = .unifiedCompact

    let toolbar = window.toolbar ?? NSToolbar(identifier: toolbarIdentifier)
    toolbar.showsBaselineSeparator = false
    toolbar.displayMode = .iconOnly
    toolbar.isVisible = true
    window.toolbar = toolbar
  }

  @MainActor
  private static func installBackground(in window: NSWindow) {
    guard let contentView = window.contentView else { return }

    contentView.subviews
      .filter { $0.identifier == backgroundIdentifier }
      .forEach { $0.removeFromSuperview() }

    let backgroundView = NSVisualEffectView(frame: contentView.bounds)
    backgroundView.identifier = backgroundIdentifier
    backgroundView.autoresizingMask = [.width, .height]
    backgroundView.blendingMode = .withinWindow
    backgroundView.material = .popover
    backgroundView.state = .active
    contentView.addSubview(backgroundView, positioned: .below, relativeTo: nil)
  }

  @MainActor
  private static func clearFlutterViewBackground(in viewController: NSViewController?) {
    guard let viewController else { return }

    if let flutterViewController = viewController as? FlutterViewController {
      flutterViewController.backgroundColor = .clear
    }

    for child in viewController.children {
      clearFlutterViewBackground(in: child)
    }
  }
}
