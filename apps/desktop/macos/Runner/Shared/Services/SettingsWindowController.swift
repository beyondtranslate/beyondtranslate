import AppKit

@MainActor
final class SettingsWindowController {
  static let shared = SettingsWindowController()
  static let settingsWindowID = NSUserInterfaceItemIdentifier("AppSettings")

  private var isPresentationGateInstalled = false
  private var isPresentationUnlocked = false

  private init() {}

  func installPresentationGate() {
    guard !isPresentationGateInstalled else { return }
    isPresentationGateInstalled = true

    let originalSelector = #selector(NSWindow.order(_:relativeTo:))
    let replacementSelector = #selector(NSWindow.bt_settingsWindow_order(_:relativeTo:))

    guard
      let originalMethod = class_getInstanceMethod(NSWindow.self, originalSelector),
      let replacementMethod = class_getInstanceMethod(NSWindow.self, replacementSelector)
    else {
      NSLog("[SettingsWindowController] Failed to install NSWindow order interceptor.")
      return
    }

    method_exchangeImplementations(originalMethod, replacementMethod)
  }

  func showSettings() {
    NSApp.activate(ignoringOtherApps: true)

    guard let window = settingsWindow else {
      NSLog("[SettingsWindowController] AppSettings window not found.")
      return
    }

    prepareForPresentation(window)

    isPresentationUnlocked = true
    window.orderFrontRegardless()
    window.makeKeyAndOrderFront(nil)
    window.makeMain()
  }

  fileprivate func shouldSuppressPresentation(for window: NSWindow, order: NSWindow.OrderingMode)
    -> Bool
  {
    isShowing(order) && !isPresentationUnlocked && isSettingsWindow(window)
  }

  fileprivate func suppressPresentation(of window: NSWindow) {
    window.alphaValue = 0
    window.ignoresMouseEvents = true
    window.isOpaque = false
    window.backgroundColor = .clear
  }

  fileprivate func restorePresentationIfNeeded(for window: NSWindow, order: NSWindow.OrderingMode) {
    guard isShowing(order) && isPresentationUnlocked && isSettingsWindow(window) else {
      return
    }

    window.alphaValue = 1
    window.ignoresMouseEvents = false
    window.isOpaque = true
    window.backgroundColor = .windowBackgroundColor
  }

  private var settingsWindow: NSWindow? {
    NSApp.windows.first { isSettingsWindow($0) }
  }

  private func prepareForPresentation(_ window: NSWindow) {
    let targetSize = NSSize(width: 720, height: 540)
    window.minSize = targetSize

    let screen = targetScreen(for: window)
    if window.isVisible, let currentScreen = window.screen, currentScreen != screen {
      window.orderOut(nil)
    }

    if let visibleFrame = screen?.visibleFrame {
      let originX = visibleFrame.origin.x + (visibleFrame.width - targetSize.width) / 2
      let originY = visibleFrame.origin.y + (visibleFrame.height - targetSize.height) / 2
      let frame = NSRect(x: originX, y: originY, width: targetSize.width, height: targetSize.height)
      window.setFrame(frame, display: true, animate: false)
    } else {
      window.setFrame(NSRect(origin: .zero, size: targetSize), display: true, animate: false)
      window.center()
    }
  }

  private func targetScreen(for window: NSWindow) -> NSScreen? {
    let mouseLocation = NSEvent.mouseLocation
    return NSScreen.screens.first { NSMouseInRect(mouseLocation, $0.frame, false) }
      ?? window.screen
      ?? NSScreen.main
  }

  private func isSettingsWindow(_ window: NSWindow) -> Bool {
    window.identifier == Self.settingsWindowID
  }

  private func isShowing(_ order: NSWindow.OrderingMode) -> Bool {
    order != .out
  }
}

extension NSWindow {
  @objc fileprivate func bt_settingsWindow_order(
    _ place: NSWindow.OrderingMode, relativeTo otherWin: Int
  ) {
    let controller = SettingsWindowController.shared
    if controller.shouldSuppressPresentation(for: self, order: place) {
      controller.suppressPresentation(of: self)
      bt_settingsWindow_order(.out, relativeTo: 0)
      return
    }

    controller.restorePresentationIfNeeded(for: self, order: place)
    bt_settingsWindow_order(place, relativeTo: otherWin)
  }
}
