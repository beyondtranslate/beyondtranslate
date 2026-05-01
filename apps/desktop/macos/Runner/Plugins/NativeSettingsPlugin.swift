import AppKit
import FlutterMacOS
import SwiftUI

final class NativeSettingsPlugin: NSObject, FlutterPlugin {
    static let channelName = "beyondtranslate/native_settings"

    private let channel: FlutterMethodChannel

    private init(channel: FlutterMethodChannel) {
        self.channel = channel
        super.init()
    }

    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: channelName,
            binaryMessenger: registrar.messenger
        )
        let instance = NativeSettingsPlugin(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "showSettings":
            Task { @MainActor in
                SettingsWindowController.shared.showWindow(settingsPlugin: self)
                result(nil)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    @MainActor
    func getAppearance() async throws -> AppearanceSettings {
        try decode(from: try await invoke("settings.getAppearance"))
    }

    @MainActor
    func updateAppearance(_ patch: AppearanceSettingsPatch) async throws -> AppearanceSettings {
        try decode(
            from: try await invoke(
                "settings.updateAppearance",
                arguments: encodePatch(patch)
            ))
    }

    @MainActor
    func getShortcuts() async throws -> ShortcutSettings {
        try decode(from: try await invoke("settings.getShortcuts"))
    }

    @MainActor
    func updateShortcuts(_ patch: ShortcutSettingsPatch) async throws -> ShortcutSettings {
        try decode(
            from: try await invoke(
                "settings.updateShortcuts",
                arguments: encodePatch(patch)
            ))
    }

    @MainActor
    func getAdvanced() async throws -> AdvancedSettings {
        try decode(from: try await invoke("settings.getAdvanced"))
    }

    @MainActor
    func updateAdvanced(_ patch: AdvancedSettingsPatch) async throws -> AdvancedSettings {
        try decode(
            from: try await invoke(
                "settings.updateAdvanced",
                arguments: encodePatch(patch)
            ))
    }

    @MainActor
    private func invoke(_ method: String, arguments: Any? = nil) async throws -> Any? {
        try await withCheckedThrowingContinuation { continuation in
            channel.invokeMethod(method, arguments: arguments) { result in
                if let error = result as? FlutterError {
                    continuation.resume(
                        throwing: NativeSettingsError.remote(
                            code: error.code,
                            message: error.message
                        ))
                } else if FlutterMethodNotImplemented.isEqual(result) {
                    continuation.resume(throwing: NativeSettingsError.notImplemented(method))
                } else {
                    continuation.resume(returning: result)
                }
            }
        }
    }

    @MainActor
    private func decode<T: Decodable>(from value: Any?) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: value as Any)
        return try JSONDecoder().decode(T.self, from: data)
    }

    /// Nil fields are omitted so Rust patch types treat them as "no change".
    @MainActor
    private func encodePatch<T: Encodable>(_ patch: T) throws -> [String: Any] {
        let data = try JSONEncoder().encode(patch)
        guard let object = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return [:]
        }
        return object
    }
}

enum NativeSettingsError: LocalizedError {
    case notImplemented(String)
    case remote(code: String, message: String?)

    var errorDescription: String? {
        switch self {
        case .notImplemented(let method):
            return "Method not implemented: \(method)"
        case .remote(let code, let message):
            return "[\(code)] \(message ?? "unknown error")"
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
    func showWindow(settingsPlugin: NativeSettingsPlugin) {
        guard let window else { return }

        window.contentViewController = NSHostingController(
            rootView: SettingsView(settingsPlugin: settingsPlugin)
        )
        window.center()
        NSApp.activate(ignoringOtherApps: true)
        window.makeKeyAndOrderFront(nil)
    }

    func windowWillClose(_ notification: Notification) {
        window?.orderOut(nil)
    }
}
