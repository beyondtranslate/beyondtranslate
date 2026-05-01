import FlutterMacOS
import Foundation

// MARK: - Response Payload Types
// Codable structs mirroring the Rust settings schema (serde rename applied).

struct AppearancePayload: Codable {
    let language: String
    let themeMode: String
}

struct ShortcutPayload: Codable {
    let toggleApp: String
}

struct AdvancedPayload: Codable {
    let launchAtLogin: Bool
    let proxy: String
}

struct ProviderEntryPayload: Codable {
    let id: String
    let type: String
    let configYaml: String
}

// MARK: - Protocol

/// All methods are @MainActor because FlutterMethodChannel must be
/// called on the main thread.
@MainActor
protocol SettingsService: AnyObject {
    func getAppearance() async throws -> AppearancePayload
    func updateAppearance(language: String?, themeMode: String?) async throws -> AppearancePayload

    func getShortcuts() async throws -> ShortcutPayload
    func updateShortcuts(toggleApp: String?) async throws -> ShortcutPayload

    func getAdvanced() async throws -> AdvancedPayload
    func updateAdvanced(launchAtLogin: Bool?, proxy: String?) async throws -> AdvancedPayload

    func listProviders() async throws -> [ProviderEntryPayload]
    func updateProvider(id: String, configYaml: String) async throws -> ProviderEntryPayload
    func deleteProvider(id: String) async throws -> ProviderEntryPayload?
}

// MARK: - Channel Implementation

@MainActor
final class ChannelSettingsService: SettingsService {
    private let channel: FlutterMethodChannel

    init(messenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(
            name: "beyondtranslate/native_settings",
            binaryMessenger: messenger
        )
    }

    func getAppearance() async throws -> AppearancePayload {
        try decode(from: try await invoke("settings.getAppearance"))
    }

    func updateAppearance(language: String?, themeMode: String?) async throws -> AppearancePayload {
        try decode(
            from: try await invoke(
                "settings.updateAppearance",
                arguments: compact(["language": language, "themeMode": themeMode])
            ))
    }

    func getShortcuts() async throws -> ShortcutPayload {
        try decode(from: try await invoke("settings.getShortcuts"))
    }

    func updateShortcuts(toggleApp: String?) async throws -> ShortcutPayload {
        try decode(
            from: try await invoke(
                "settings.updateShortcuts",
                arguments: compact(["toggleApp": toggleApp])
            ))
    }

    func getAdvanced() async throws -> AdvancedPayload {
        try decode(from: try await invoke("settings.getAdvanced"))
    }

    func updateAdvanced(launchAtLogin: Bool?, proxy: String?) async throws -> AdvancedPayload {
        try decode(
            from: try await invoke(
                "settings.updateAdvanced",
                arguments: compact(["launchAtLogin": launchAtLogin, "proxy": proxy])
            ))
    }

    func listProviders() async throws -> [ProviderEntryPayload] {
        try decode(from: try await invoke("settings.listProviders"))
    }

    func updateProvider(id: String, configYaml: String) async throws -> ProviderEntryPayload {
        try decode(
            from: try await invoke(
                "settings.updateProvider",
                arguments: ["id": id, "configYaml": configYaml]
            ))
    }

    func deleteProvider(id: String) async throws -> ProviderEntryPayload? {
        guard let result = try await invoke("settings.deleteProvider", arguments: ["id": id]) else {
            return nil
        }
        return try decode(from: result)
    }

    // MARK: - Private Helpers

    /// Calls a Flutter method and suspends until the result arrives.
    /// Must already be on the main thread (guaranteed by @MainActor).
    private func invoke(_ method: String, arguments: Any? = nil) async throws -> Any? {
        try await withCheckedThrowingContinuation { continuation in
            channel.invokeMethod(method, arguments: arguments) { result in
                if let error = result as? FlutterError {
                    continuation.resume(
                        throwing: SettingsServiceError.remote(
                            code: error.code,
                            message: error.message
                        ))
                } else if FlutterMethodNotImplemented.isEqual(result) {
                    continuation.resume(throwing: SettingsServiceError.notImplemented(method))
                } else {
                    continuation.resume(returning: result)
                }
            }
        }
    }

    /// Decodes a JSON-compatible `Any?` value returned by the channel into `T`.
    private func decode<T: Decodable>(from value: Any?) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: value as Any)
        return try JSONDecoder().decode(T.self, from: data)
    }

    /// Strips nil values so only the fields being updated are sent over the channel.
    /// The Dart/Rust side treats absent keys as "no change" for Patch types.
    private func compact(_ dict: [String: Any?]) -> [String: Any] {
        dict.compactMapValues { $0 }
    }
}

// MARK: - Errors

enum SettingsServiceError: LocalizedError {
    case notImplemented(String)
    case decodingFailed(Error)
    case remote(code: String, message: String?)

    var errorDescription: String? {
        switch self {
        case .notImplemented(let method):
            return "Method not implemented: \(method)"
        case .decodingFailed(let error):
            return "Failed to decode settings response: \(error)"
        case .remote(let code, let message):
            return "[\(code)] \(message ?? "unknown error")"
        }
    }
}

// MARK: - Preview Mock

#if DEBUG
    final class MockSettingsService: SettingsService {
        func getAppearance() async throws -> AppearancePayload {
            AppearancePayload(language: "en", themeMode: "light")
        }
        func updateAppearance(language: String?, themeMode: String?) async throws
            -> AppearancePayload
        {
            AppearancePayload(language: language ?? "en", themeMode: themeMode ?? "light")
        }
        func getShortcuts() async throws -> ShortcutPayload {
            ShortcutPayload(toggleApp: "Control+Option+Space")
        }
        func updateShortcuts(toggleApp: String?) async throws -> ShortcutPayload {
            ShortcutPayload(toggleApp: toggleApp ?? "")
        }
        func getAdvanced() async throws -> AdvancedPayload {
            AdvancedPayload(launchAtLogin: false, proxy: "")
        }
        func updateAdvanced(launchAtLogin: Bool?, proxy: String?) async throws -> AdvancedPayload {
            AdvancedPayload(launchAtLogin: launchAtLogin ?? false, proxy: proxy ?? "")
        }
        func listProviders() async throws -> [ProviderEntryPayload] { [] }
        func updateProvider(id: String, configYaml: String) async throws -> ProviderEntryPayload {
            ProviderEntryPayload(id: id, type: "unknown", configYaml: configYaml)
        }
        func deleteProvider(id: String) async throws -> ProviderEntryPayload? { nil }
    }
#endif
