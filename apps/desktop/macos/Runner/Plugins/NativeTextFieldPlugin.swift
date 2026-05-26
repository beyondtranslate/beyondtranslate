import AppKit
import FlutterMacOS

final class NativeTextFieldPlugin: NSObject {
  static let viewType = "beyondtranslate/native_text_field"

  static func register(with registrar: FlutterPluginRegistrar) {
    registrar.register(
      NativeTextFieldFactory(messenger: registrar.messenger),
      withId: viewType
    )
  }
}

private final class NativeTextFieldFactory: NSObject, FlutterPlatformViewFactory {
  private let messenger: FlutterBinaryMessenger

  init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
    super.init()
  }

  func create(
    withViewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> NSView {
    NativeTextFieldView(
      viewId: viewId,
      messenger: messenger,
      arguments: args as? [String: Any]
    )
  }

  func createArgsCodec() -> (FlutterMessageCodec & NSObjectProtocol)? {
    FlutterStandardMessageCodec.sharedInstance()
  }
}

private final class NativeTextFieldView: NSView, NSTextFieldDelegate, NSTextViewDelegate {
  private let channel: FlutterMethodChannel
  private let padding: NSEdgeInsets
  private let isMultiline: Bool
  private let obscureText: Bool
  private let submitOnEnter: Bool
  private let placeholder: String
  private let textStyle: NativeTextStyle
  private let placeholderStyle: NativeTextStyle

  private var textField: NSTextField?
  private var textView: NSTextView?
  private var scrollView: NSScrollView?
  private var placeholderLabel: NSTextField?
  private var isUpdatingFromFlutter = false
  private var lastReportedContentHeight: CGFloat = 0

  init(
    viewId: Int64,
    messenger: FlutterBinaryMessenger,
    arguments: [String: Any]?
  ) {
    let args = arguments ?? [:]
    channel = FlutterMethodChannel(
      name: "beyondtranslate/native_text_field/\(viewId)",
      binaryMessenger: messenger
    )
    padding = NativeTextFieldView.decodePadding(args["padding"])
    obscureText = args["obscureText"] as? Bool ?? false
    submitOnEnter = args["submitOnEnter"] as? Bool ?? false
    let maxLines = NativeTextFieldView.decodeInt(args["maxLines"]) ?? 1
    isMultiline = !obscureText && maxLines != 1
    placeholder = args["placeholder"] as? String ?? ""
    textStyle = NativeTextStyle(arguments: args["style"] as? [String: Any])
    placeholderStyle = NativeTextStyle(
      arguments: args["placeholderStyle"] as? [String: Any]
    )

    super.init(frame: .zero)

    wantsLayer = true
    layer?.backgroundColor = NSColor.clear.cgColor
    setupInput(initialText: args["text"] as? String ?? "")
    applyEditableState(
      enabled: args["enabled"] as? Bool ?? true,
      readOnly: args["readOnly"] as? Bool ?? false
    )
    setupChannel()

    if args["autofocus"] as? Bool == true {
      DispatchQueue.main.async { [weak self] in
        self?.focus()
      }
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layout() {
    super.layout()
    let inputFrame = NSRect(
      x: bounds.minX + padding.left,
      y: bounds.minY + padding.bottom,
      width: max(0, bounds.width - padding.left - padding.right),
      height: max(0, bounds.height - padding.top - padding.bottom)
    )
    textField?.frame = inputFrame
    scrollView?.frame = inputFrame
    placeholderLabel?.frame = inputFrame
    updateTextContainerSize(width: inputFrame.width)
    reportContentHeightIfNeeded()
  }

  override func mouseDown(with event: NSEvent) {
    channel.invokeMethod("tapped", arguments: nil)
    focus()
    super.mouseDown(with: event)
  }

  func controlTextDidBeginEditing(_ obj: Notification) {
    channel.invokeMethod("focused", arguments: nil)
  }

  func controlTextDidEndEditing(_ obj: Notification) {
    channel.invokeMethod("blurred", arguments: nil)
  }

  func controlTextDidChange(_ obj: Notification) {
    guard !isUpdatingFromFlutter else { return }
    channel.invokeMethod("changed", arguments: currentText())
  }

  func textDidBeginEditing(_ notification: Notification) {
    updatePlaceholderVisibility()
    channel.invokeMethod("focused", arguments: nil)
  }

  func textDidEndEditing(_ notification: Notification) {
    updatePlaceholderVisibility()
    channel.invokeMethod("blurred", arguments: nil)
  }

  func textDidChange(_ notification: Notification) {
    updatePlaceholderVisibility()
    reportContentHeightIfNeeded()
    guard !isUpdatingFromFlutter else { return }
    channel.invokeMethod("changed", arguments: currentText())
  }

  func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
    guard commandSelector == #selector(NSResponder.insertNewline(_:)), submitOnEnter else {
      return false
    }
    channel.invokeMethod("submitted", arguments: currentText())
    return true
  }

  private func setupInput(initialText: String) {
    if isMultiline {
      setupTextView(initialText: initialText)
    } else {
      setupTextField(initialText: initialText)
    }
  }

  private func setupTextField(initialText: String) {
    let field: NSTextField = obscureText ? NSSecureTextField() : NSTextField()
    field.stringValue = initialText
    field.placeholderString = placeholder
    field.isBordered = false
    field.isBezeled = false
    field.drawsBackground = false
    field.focusRingType = .none
    field.delegate = self
    field.target = self
    field.action = #selector(submitTextField)
    field.font = textStyle.font
    field.textColor = textStyle.color
    field.placeholderAttributedString = NSAttributedString(
      string: placeholder,
      attributes: [
        .font: placeholderStyle.font,
        .foregroundColor: placeholderStyle.color,
      ]
    )
    addSubview(field)
    textField = field
  }

  private func setupTextView(initialText: String) {
    let scroll = NSScrollView()
    scroll.drawsBackground = false
    scroll.borderType = .noBorder
    scroll.hasVerticalScroller = false
    scroll.hasHorizontalScroller = false
    scroll.autohidesScrollers = true

    let view = NSTextView()
    view.string = initialText
    view.delegate = self
    view.drawsBackground = false
    view.isRichText = false
    view.importsGraphics = false
    view.allowsUndo = true
    view.isVerticallyResizable = true
    view.isHorizontallyResizable = false
    view.minSize = .zero
    view.maxSize = NSSize(
      width: CGFloat.greatestFiniteMagnitude,
      height: CGFloat.greatestFiniteMagnitude
    )
    view.textContainerInset = .zero
    view.textContainer?.lineFragmentPadding = 0
    view.font = textStyle.font
    view.textColor = textStyle.color
    view.insertionPointColor = NSColor.controlAccentColor
    scroll.documentView = view

    let label = PassthroughTextField(labelWithString: placeholder)
    label.font = placeholderStyle.font
    label.textColor = placeholderStyle.color
    label.backgroundColor = .clear
    label.isBordered = false
    label.isEditable = false
    label.isSelectable = false

    addSubview(scroll)
    addSubview(label)
    scrollView = scroll
    textView = view
    placeholderLabel = label
    updatePlaceholderVisibility()
    reportContentHeightIfNeeded()
  }

  private func setupChannel() {
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self else {
        result(nil)
        return
      }

      switch call.method {
      case "setText":
        self.setText(call.arguments as? String ?? "")
        result(nil)
      case "focus":
        self.focus()
        result(nil)
      case "blur":
        self.window?.makeFirstResponder(nil)
        result(nil)
      case "setEditableState":
        let args = call.arguments as? [String: Any] ?? [:]
        self.applyEditableState(
          enabled: args["enabled"] as? Bool ?? true,
          readOnly: args["readOnly"] as? Bool ?? false
        )
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func applyEditableState(enabled: Bool, readOnly: Bool) {
    let editable = enabled && !readOnly
    textField?.isEnabled = enabled
    textField?.isEditable = editable
    textView?.isEditable = editable
    textView?.isSelectable = enabled
  }

  private func setText(_ text: String) {
    guard currentText() != text else {
      reportContentHeightIfNeeded()
      return
    }
    isUpdatingFromFlutter = true
    textField?.stringValue = text
    textView?.string = text
    updatePlaceholderVisibility()
    reportContentHeightIfNeeded()
    isUpdatingFromFlutter = false
  }

  private func focus() {
    if let textField {
      window?.makeFirstResponder(textField)
    } else if let textView {
      window?.makeFirstResponder(textView)
      updatePlaceholderVisibility()
    }
  }

  private func currentText() -> String {
    if let textField {
      return textField.stringValue
    }
    return textView?.string ?? ""
  }

  private func updatePlaceholderVisibility() {
    let hasMarkedText = textView?.hasMarkedText() ?? false
    placeholderLabel?.isHidden = !currentText().isEmpty || hasMarkedText
  }

  private func updateTextContainerSize(width: CGFloat) {
    guard let textView else { return }
    textView.textContainer?.containerSize = NSSize(
      width: max(0, width),
      height: CGFloat.greatestFiniteMagnitude
    )
    textView.textContainer?.widthTracksTextView = false
  }

  private func reportContentHeightIfNeeded() {
    guard isMultiline, let textView, let layoutManager = textView.layoutManager else {
      return
    }
    guard let textContainer = textView.textContainer else { return }

    layoutManager.ensureLayout(for: textContainer)
    let usedRect = layoutManager.usedRect(for: textContainer)
    let contentHeight = ceil(max(textStyle.font.ascender - textStyle.font.descender, usedRect.height))
    guard abs(contentHeight - lastReportedContentHeight) >= 0.5 else { return }

    lastReportedContentHeight = contentHeight
    channel.invokeMethod("contentHeightChanged", arguments: Double(contentHeight))
  }

  @objc private func submitTextField() {
    channel.invokeMethod("submitted", arguments: currentText())
  }

  private static func decodePadding(_ value: Any?) -> NSEdgeInsets {
    guard let args = value as? [String: Any] else {
      return NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    return NSEdgeInsets(
      top: CGFloat(decodeDouble(args["top"]) ?? 0),
      left: CGFloat(decodeDouble(args["left"]) ?? 0),
      bottom: CGFloat(decodeDouble(args["bottom"]) ?? 0),
      right: CGFloat(decodeDouble(args["right"]) ?? 0)
    )
  }

  private static func decodeInt(_ value: Any?) -> Int? {
    if let int = value as? Int { return int }
    return (value as? NSNumber)?.intValue
  }

  private static func decodeDouble(_ value: Any?) -> Double? {
    if let double = value as? Double { return double }
    return (value as? NSNumber)?.doubleValue
  }
}

private final class PassthroughTextField: NSTextField {
  override func hitTest(_ point: NSPoint) -> NSView? {
    nil
  }
}

private struct NativeTextStyle {
  let font: NSFont
  let color: NSColor

  init(arguments: [String: Any]?) {
    let args = arguments ?? [:]
    let fontSize = CGFloat(NativeTextStyle.decodeDouble(args["fontSize"]) ?? 14)
    if let family = args["fontFamily"] as? String,
       let customFont = NSFont(name: family, size: fontSize)
    {
      font = customFont
    } else {
      font = NSFont.systemFont(ofSize: fontSize)
    }
    color = NativeTextStyle.decodeColor(args["color"]) ?? NSColor.labelColor
  }

  private static func decodeColor(_ value: Any?) -> NSColor? {
    guard let number = value as? NSNumber else { return nil }
    let argb = number.uint32Value
    let alpha = CGFloat((argb >> 24) & 0xff) / 255
    let red = CGFloat((argb >> 16) & 0xff) / 255
    let green = CGFloat((argb >> 8) & 0xff) / 255
    let blue = CGFloat(argb & 0xff) / 255
    return NSColor(
      calibratedRed: red,
      green: green,
      blue: blue,
      alpha: alpha
    )
  }

  private static func decodeDouble(_ value: Any?) -> Double? {
    if let double = value as? Double { return double }
    return (value as? NSNumber)?.doubleValue
  }
}
