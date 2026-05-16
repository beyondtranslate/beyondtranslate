import AppKit
import Carbon
import ObjectiveC
import SwiftUI

// MARK: - Closure storage via associated objects

private var onShortcutRecordedKey: UInt8 = 0
private var onClearKey: UInt8 = 0

extension ShortcutRecorderNSView {
  fileprivate var onShortcutRecorded: ((ShortcutDisplay) -> Void)? {
    get { objc_getAssociatedObject(self, &onShortcutRecordedKey) as? (ShortcutDisplay) -> Void }
    set {
      objc_setAssociatedObject(
        self, &onShortcutRecordedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }

  fileprivate var onClear: (() -> Void)? {
    get { objc_getAssociatedObject(self, &onClearKey) as? () -> Void }
    set {
      objc_setAssociatedObject(self, &onClearKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}

// MARK: - NSSearchField Subclass (Recording Logic)

final class ShortcutRecorderNSView: NSSearchField, NSSearchFieldDelegate {
  private var eventMonitor: Any?
  private var isRecording = false
  private var cancelButtonCell: NSButtonCell?

  private static let functionKeyNames: [Int: String] = [
    kVK_F1: "F1", kVK_F2: "F2", kVK_F3: "F3", kVK_F4: "F4",
    kVK_F5: "F5", kVK_F6: "F6", kVK_F7: "F7", kVK_F8: "F8",
    kVK_F9: "F9", kVK_F10: "F10", kVK_F11: "F11", kVK_F12: "F12",
    kVK_F13: "F13", kVK_F14: "F14", kVK_F15: "F15", kVK_F16: "F16",
    kVK_F17: "F17", kVK_F18: "F18", kVK_F19: "F19", kVK_F20: "F20",
  ]

  private static let fallbackKeyMap: [Int: String] = [
    kVK_ANSI_A: "A", kVK_ANSI_B: "B", kVK_ANSI_C: "C",
    kVK_ANSI_D: "D", kVK_ANSI_E: "E", kVK_ANSI_F: "F",
    kVK_ANSI_G: "G", kVK_ANSI_H: "H", kVK_ANSI_I: "I",
    kVK_ANSI_J: "J", kVK_ANSI_K: "K", kVK_ANSI_L: "L",
    kVK_ANSI_M: "M", kVK_ANSI_N: "N", kVK_ANSI_O: "O",
    kVK_ANSI_P: "P", kVK_ANSI_Q: "Q", kVK_ANSI_R: "R",
    kVK_ANSI_S: "S", kVK_ANSI_T: "T", kVK_ANSI_U: "U",
    kVK_ANSI_V: "V", kVK_ANSI_W: "W", kVK_ANSI_X: "X",
    kVK_ANSI_Y: "Y", kVK_ANSI_Z: "Z",
    kVK_ANSI_0: "0", kVK_ANSI_1: "1", kVK_ANSI_2: "2",
    kVK_ANSI_3: "3", kVK_ANSI_4: "4", kVK_ANSI_5: "5",
    kVK_ANSI_6: "6", kVK_ANSI_7: "7", kVK_ANSI_8: "8",
    kVK_ANSI_9: "9",
    kVK_ANSI_Grave: "`", kVK_ANSI_Minus: "-", kVK_ANSI_Equal: "=",
    kVK_ANSI_LeftBracket: "[", kVK_ANSI_RightBracket: "]",
    kVK_ANSI_Backslash: "\\", kVK_ANSI_Semicolon: ";",
    kVK_ANSI_Quote: "'", kVK_ANSI_Comma: ",", kVK_ANSI_Period: ".",
    kVK_ANSI_Slash: "/",
    kVK_Space: "Space",
    kVK_Return: "Return", kVK_Tab: "Tab",
    kVK_Delete: "Delete", kVK_ForwardDelete: "DeleteForward",
    kVK_Escape: "Escape",
    kVK_Home: "Home", kVK_End: "End",
    kVK_PageUp: "PageUp", kVK_PageDown: "PageDown",
    kVK_UpArrow: "UpArrow", kVK_DownArrow: "DownArrow",
    kVK_LeftArrow: "LeftArrow", kVK_RightArrow: "RightArrow",
    kVK_Help: "Help",
    kVK_ANSI_Keypad0: "Keypad0", kVK_ANSI_Keypad1: "Keypad1",
    kVK_ANSI_Keypad2: "Keypad2", kVK_ANSI_Keypad3: "Keypad3",
    kVK_ANSI_Keypad4: "Keypad4", kVK_ANSI_Keypad5: "Keypad5",
    kVK_ANSI_Keypad6: "Keypad6", kVK_ANSI_Keypad7: "Keypad7",
    kVK_ANSI_Keypad8: "Keypad8", kVK_ANSI_Keypad9: "Keypad9",
    kVK_ANSI_KeypadClear: "KeypadClear",
    kVK_ANSI_KeypadDecimal: "KeypadDecimal",
    kVK_ANSI_KeypadDivide: "KeypadDivide",
    kVK_ANSI_KeypadEnter: "KeypadEnter",
    kVK_ANSI_KeypadEquals: "KeypadEquals",
    kVK_ANSI_KeypadMinus: "KeypadMinus",
    kVK_ANSI_KeypadMultiply: "KeypadMultiply",
    kVK_ANSI_KeypadPlus: "KeypadPlus",
  ]

  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    configureView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    stopRecording()
  }

  private func configureView() {
    delegate = self
    placeholderString = "Record Shortcut"
    alignment = .center
    (cell as? NSSearchFieldCell)?.searchButtonCell = nil
    wantsLayer = true
    font = .monospacedSystemFont(ofSize: 13, weight: .regular)

    cancelButtonCell = (cell as? NSSearchFieldCell)?.cancelButtonCell
    (cell as? NSSearchFieldCell)?.cancelButtonCell = nil
  }

  override func cancelOperation(_ sender: Any?) {
    if !isRecording {
      clearShortcut()
    }
  }

  func setShortcut(_ shortcut: ShortcutDisplay?) {
    if let shortcut, !shortcut.parts.isEmpty {
      stringValue = shortcut.displayText
      placeholderString = ""
      (cell as? NSSearchFieldCell)?.cancelButtonCell = cancelButtonCell
    } else {
      stringValue = ""
      placeholderString = "Record Shortcut"
      (cell as? NSSearchFieldCell)?.cancelButtonCell = nil
    }
  }

  // MARK: - First Responder

  override func becomeFirstResponder() -> Bool {
    guard window != nil else { return false }
    guard super.becomeFirstResponder() else { return false }

    isRecording = true
    placeholderString = "Press Shortcut"
    stringValue = ""
    (cell as? NSSearchFieldCell)?.cancelButtonCell = nil

    eventMonitor = NSEvent.addLocalMonitorForEvents(matching: [
      .keyDown, .leftMouseUp, .rightMouseUp,
    ]) { [weak self] event in
      self?.handleEvent(event)
    }

    return true
  }

  override func resignFirstResponder() -> Bool {
    stopRecording()
    return super.resignFirstResponder()
  }

  private func stopRecording() {
    guard isRecording else { return }
    isRecording = false

    if let monitor = eventMonitor {
      NSEvent.removeMonitor(monitor)
      eventMonitor = nil
    }

    if stringValue.isEmpty {
      placeholderString = "Record Shortcut"
    }
  }

  // MARK: - Event Handling

  private func handleEvent(_ event: NSEvent) -> NSEvent? {
    if event.type == .leftMouseUp || event.type == .rightMouseUp {
      let clickPoint = convert(event.locationInWindow, from: nil)
      if !bounds.insetBy(dx: -3, dy: -3).contains(clickPoint) {
        abortRecording()
        return event
      }
      return nil
    }

    guard event.type == .keyDown else { return nil }

    if event.modifierFlags.isSubset(of: [.shift, .function]) || event.modifierFlags.isEmpty {
      switch event.specialKey {
      case .tab:
        abortRecording()
        return event
      case .delete, .deleteForward, .backspace:
        clearShortcut()
        return nil
      default:
        break
      }

      if event.keyCode == kVK_Escape {
        abortRecording()
        return nil
      }
    }

    let hasNonShiftModifier = !event.modifierFlags.subtracting([.shift, .function]).isEmpty
    let isFunctionKey = Self.functionKeyNames.keys.contains(Int(event.keyCode))

    guard
      hasNonShiftModifier || isFunctionKey,
      let shortcut = shortcutFromEvent(event)
    else {
      NSSound.beep()
      return nil
    }

    stringValue = shortcut.displayText
    placeholderString = ""
    onShortcutRecorded?(shortcut)
    abortRecording()

    return nil
  }

  private func abortRecording() {
    if stringValue.isEmpty {
      placeholderString = "Record Shortcut"
    }
    window?.makeFirstResponder(nil)
  }

  private func clearShortcut() {
    stringValue = ""
    onClear?()
    window?.makeFirstResponder(nil)
  }

  // MARK: - NSSearchFieldDelegate

  func controlTextDidChange(_ obj: Notification) {
    if !isRecording {
      stringValue = ""
    }
  }

  func controlTextDidEndEditing(_ obj: Notification) {
    stopRecording()
  }

  // MARK: - Shortcut Conversion

  private func shortcutFromEvent(_ event: NSEvent) -> ShortcutDisplay? {
    let flags = event.modifierFlags
    var parts: [String] = []

    if flags.contains(.control) { parts.append("Control") }
    if flags.contains(.option) { parts.append("Option") }
    if flags.contains(.shift) { parts.append("Shift") }
    if flags.contains(.command) { parts.append("Command") }

    if let specialKey = event.specialKey, let name = specialKeyName(specialKey) {
      parts.append(name)
    } else if let keyName = keyCodeToName(Int(event.keyCode)) {
      parts.append(keyName)
    } else {
      return nil
    }

    return ShortcutDisplay(parts: parts)
  }

  private func specialKeyName(_ specialKey: NSEvent.SpecialKey) -> String? {
    switch specialKey {
    case .backspace: return "Delete"
    case .tab: return "Tab"
    case .delete: return "DeleteForward"
    case .enter: return "Enter"
    case .carriageReturn: return "Return"
    case .newline: return "Return"
    case .upArrow: return "UpArrow"
    case .downArrow: return "DownArrow"
    case .leftArrow: return "LeftArrow"
    case .rightArrow: return "RightArrow"
    case .home: return "Home"
    case .end: return "End"
    case .pageUp: return "PageUp"
    case .pageDown: return "PageDown"
    case .help: return "Help"
    default:
      return nil
    }
  }

  private func keyCodeToName(_ keyCode: Int) -> String? {
    if let name = Self.functionKeyNames[keyCode] { return name }

    guard
      let source = TISCopyCurrentASCIICapableKeyboardLayoutInputSource()?.takeRetainedValue(),
      let layoutDataPointer = TISGetInputSourceProperty(source, kTISPropertyUnicodeKeyLayoutData)
    else {
      return Self.fallbackKeyMap[keyCode]
    }

    let layoutData = unsafeBitCast(layoutDataPointer, to: CFData.self)
    let keyLayout = unsafeBitCast(
      CFDataGetBytePtr(layoutData), to: UnsafePointer<UCKeyboardLayout>.self)
    var deadKeyState: UInt32 = 0
    let maxLength = 4
    var length = 0
    var chars = [UniChar](repeating: 0, count: maxLength)

    let error = UCKeyTranslate(
      keyLayout,
      UInt16(keyCode),
      UInt16(kUCKeyActionDisplay),
      0,
      UInt32(LMGetKbdType()),
      OptionBits(kUCKeyTranslateNoDeadKeysBit),
      &deadKeyState,
      maxLength,
      &length,
      &chars
    )

    if error == noErr, length > 0 {
      let char = String(utf16CodeUnits: chars, count: length)
      if char.count == 1, char.first!.isASCII {
        return char.uppercased()
      }
    }

    return Self.fallbackKeyMap[keyCode]
  }
}

// MARK: - NSViewRepresentable

struct ShortcutRecorderView: NSViewRepresentable {
  let shortcut: ShortcutDisplay
  let onShortcutRecorded: ((ShortcutDisplay) -> Void)?
  let onClear: (() -> Void)?

  init(
    shortcut: ShortcutDisplay,
    onShortcutRecorded: ((ShortcutDisplay) -> Void)? = nil,
    onClear: (() -> Void)? = nil
  ) {
    self.shortcut = shortcut
    self.onShortcutRecorded = onShortcutRecorded
    self.onClear = onClear
  }

  func makeNSView(context: Context) -> ShortcutRecorderNSView {
    let nsView = ShortcutRecorderNSView(frame: .zero)
    nsView.setShortcut(shortcut)
    // Store closures directly on the NSView instance via associated objects.
    // These are set ONCE here and NEVER overwritten in updateNSView,
    // guaranteeing the closures stay bound to the correct NSView.
    nsView.onShortcutRecorded = onShortcutRecorded
    nsView.onClear = onClear
    return nsView
  }

  func updateNSView(_ nsView: ShortcutRecorderNSView, context: Context) {
    nsView.setShortcut(shortcut)
    // Intentionally do NOT update the closures here.
    // The closures are set once in makeNSView and remain valid for the
    // lifetime of the NSView. This avoids any SwiftUI identity confusion.
  }
}
