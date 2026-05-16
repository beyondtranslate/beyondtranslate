import AppKit
import Carbon
import SwiftUI

struct ShortcutRecorderView: View {
  let shortcut: ShortcutDisplay
  let onShortcutRecorded: ((ShortcutDisplay) -> Void)?
  let onClear: (() -> Void)?

  @State private var isRecording = false
  @State private var focusRequest = 0

  init(
    shortcut: ShortcutDisplay,
    onShortcutRecorded: ((ShortcutDisplay) -> Void)? = nil,
    onClear: (() -> Void)? = nil
  ) {
    self.shortcut = shortcut
    self.onShortcutRecorded = onShortcutRecorded
    self.onClear = onClear
  }

  var body: some View {
    ZStack {
      Button(action: beginRecording) {
        RoundedRectangle(cornerRadius: 13)
          .fill(Color(nsColor: .textBackgroundColor))
          .overlay(
            RoundedRectangle(cornerRadius: 13)
              .stroke(borderColor, lineWidth: isRecording ? 1.5 : 1)
          )
      }
      .buttonStyle(.plain)

      Text(displayText)
        .foregroundStyle(textColor)
        .lineLimit(1)
        .truncationMode(.middle)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, shortcut.parts.isEmpty ? 8 : 24)
        .allowsHitTesting(false)

      if !shortcut.parts.isEmpty {
        HStack {
          Spacer(minLength: 0)
          Button(action: clearShortcut) {
            Image(systemName: "xmark.circle.fill")
              .font(.system(size: 12, weight: .medium))
              .foregroundStyle(Color(nsColor: .secondaryLabelColor))
          }
          .buttonStyle(.plain)
          .help("Clear")
          .padding(.trailing, 6)
        }
      }

      ShortcutKeyCaptureView(
        isRecording: $isRecording,
        focusRequest: focusRequest,
        onShortcutRecorded: { shortcut in
          onShortcutRecorded?(shortcut)
        },
        onClear: {
          onClear?()
        }
      )
      .allowsHitTesting(false)
    }
    .frame(height: 26)
  }

  private var displayText: String {
    if !shortcut.parts.isEmpty {
      return ShortcutSymbolFormatter.displayText(for: shortcut)
    }
    return isRecording ? "Press Shortcut" : "Record Shortcut"
  }

  private var textColor: Color {
    if !shortcut.parts.isEmpty {
      return Color(nsColor: .labelColor)
    }
    return Color(nsColor: .placeholderTextColor)
  }

  private var borderColor: Color {
    if isRecording {
      return .accentColor
    }
    return Color(nsColor: .separatorColor)
  }

  private func beginRecording() {
    isRecording = true
    focusRequest += 1
  }

  private func clearShortcut() {
    isRecording = false
    onClear?()
  }
}

private struct ShortcutKeyCaptureView: NSViewRepresentable {
  @Binding var isRecording: Bool

  let focusRequest: Int
  let onShortcutRecorded: (ShortcutDisplay) -> Void
  let onClear: () -> Void

  func makeNSView(context: Context) -> ShortcutKeyCaptureNSView {
    ShortcutKeyCaptureNSView(frame: .zero)
  }

  func updateNSView(_ nsView: ShortcutKeyCaptureNSView, context: Context) {
    context.coordinator.parent = self
    nsView.onShortcutRecorded = { shortcut in
      context.coordinator.record(shortcut)
    }
    nsView.onClear = {
      context.coordinator.clear()
    }
    nsView.onCancel = {
      context.coordinator.cancel()
    }
    nsView.onFocusChange = { focused in
      context.coordinator.setFocused(focused)
    }

    if isRecording {
      DispatchQueue.main.async {
        guard nsView.window != nil else { return }
        if nsView.window?.firstResponder !== nsView {
          nsView.window?.makeFirstResponder(nsView)
        }
      }
    } else if nsView.window?.firstResponder === nsView {
      DispatchQueue.main.async {
        nsView.window?.makeFirstResponder(nil)
      }
    }
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }

  final class Coordinator {
    var parent: ShortcutKeyCaptureView

    init(parent: ShortcutKeyCaptureView) {
      self.parent = parent
    }

    func record(_ shortcut: ShortcutDisplay) {
      parent.isRecording = false
      parent.onShortcutRecorded(shortcut)
    }

    func clear() {
      parent.isRecording = false
      parent.onClear()
    }

    func cancel() {
      parent.isRecording = false
    }

    func setFocused(_ focused: Bool) {
      if !focused {
        parent.isRecording = false
      }
    }
  }
}

private final class ShortcutKeyCaptureNSView: NSView {
  var onShortcutRecorded: ((ShortcutDisplay) -> Void)?
  var onClear: (() -> Void)?
  var onCancel: (() -> Void)?
  var onFocusChange: ((Bool) -> Void)?

  override var acceptsFirstResponder: Bool {
    true
  }

  override func becomeFirstResponder() -> Bool {
    onFocusChange?(true)
    return true
  }

  override func resignFirstResponder() -> Bool {
    onFocusChange?(false)
    return true
  }

  override func cancelOperation(_ sender: Any?) {
    cancelRecording()
  }

  override func keyDown(with event: NSEvent) {
    if shouldCancel(event) {
      cancelRecording()
      return
    }

    if shouldClear(event) {
      onClear?()
      window?.makeFirstResponder(nil)
      return
    }

    guard ShortcutKeyConverter.isRecordable(event),
      let shortcut = ShortcutKeyConverter.shortcut(from: event)
    else {
      NSSound.beep()
      return
    }

    onShortcutRecorded?(shortcut)
    window?.makeFirstResponder(nil)
  }

  private func cancelRecording() {
    onCancel?()
    window?.makeFirstResponder(nil)
  }

  private func shouldCancel(_ event: NSEvent) -> Bool {
    event.keyCode == kVK_Escape
  }

  private func shouldClear(_ event: NSEvent) -> Bool {
    let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
    let hasModifier =
      flags.contains(.control) || flags.contains(.option) || flags.contains(.command)
      || flags.contains(.shift)

    guard !hasModifier else { return false }
    return event.specialKey == .delete || event.specialKey == .deleteForward
      || event.specialKey == .backspace
  }
}

private enum ShortcutKeyConverter {
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

  static func isRecordable(_ event: NSEvent) -> Bool {
    hasNonShiftModifier(event) || functionKeyNames.keys.contains(Int(event.keyCode))
  }

  static func shortcut(from event: NSEvent) -> ShortcutDisplay? {
    let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
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

  private static func hasNonShiftModifier(_ event: NSEvent) -> Bool {
    let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
    return flags.contains(.control) || flags.contains(.option) || flags.contains(.command)
  }

  private static func specialKeyName(_ specialKey: NSEvent.SpecialKey) -> String? {
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

  private static func keyCodeToName(_ keyCode: Int) -> String? {
    if let name = functionKeyNames[keyCode] { return name }

    guard
      let source = TISCopyCurrentASCIICapableKeyboardLayoutInputSource()?.takeRetainedValue(),
      let layoutDataPointer = TISGetInputSourceProperty(source, kTISPropertyUnicodeKeyLayoutData)
    else {
      return fallbackKeyMap[keyCode]
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

    return fallbackKeyMap[keyCode]
  }
}

private enum ShortcutSymbolFormatter {
  private static let symbols: [String: String] = [
    "Control": "⌃",
    "Option": "⌥",
    "Shift": "⇧",
    "Command": "⌘",
    "Return": "↩",
    "Enter": "⌤",
    "Tab": "⇥",
    "Delete": "⌫",
    "DeleteForward": "⌦",
    "Escape": "⎋",
    "Space": "Space",
    "UpArrow": "↑",
    "DownArrow": "↓",
    "LeftArrow": "←",
    "RightArrow": "→",
    "Home": "↖",
    "End": "↘",
    "PageUp": "⇞",
    "PageDown": "⇟",
    "Help": "?⃝",
  ]

  static func displayText(for shortcut: ShortcutDisplay) -> String {
    shortcut.parts.map { symbols[$0] ?? $0 }.joined()
  }
}
