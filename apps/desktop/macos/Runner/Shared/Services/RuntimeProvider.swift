import Foundation
import beyondtranslate_runtime
import os

/// Process-wide accessor for the Rust [Runtime] used by native (Swift) code.
///
/// The Rust runtime maintains a single shared instance per `data_dir`, so
/// the [Runtime] returned here references the **same** in-memory settings
/// and engine state as the [Runtime] held on the Flutter side. Updates from
/// either binding are immediately visible to the other on the next read.
enum RuntimeProvider {
  static let shared: Runtime = {
    let dataDir = applicationSupportDirectory()
    let settingsPath = (dataDir as NSString).appendingPathComponent("settings.json")
    os_log("[RuntimeProvider] dataDir: %{public}@", dataDir)
    os_log("[RuntimeProvider] settings.json: %{public}@", settingsPath)
    do {
      return try Runtime(dataDir: dataDir)
    } catch {
      fatalError("Failed to initialise beyondtranslate Runtime: \(error)")
    }
  }()

  /// Mirrors `path_provider`'s `getApplicationSupportDirectory()` on macOS:
  /// `~/Library/Application Support/<bundle-id>`.
  private static func applicationSupportDirectory() -> String {
    let basePath =
      NSSearchPathForDirectoriesInDomains(
        .applicationSupportDirectory, .userDomainMask, true
      ).first ?? NSTemporaryDirectory()
    let bundleId = Bundle.main.bundleIdentifier ?? "beyondtranslate"
    let dataDir = (basePath as NSString).appendingPathComponent(bundleId)
    try? FileManager.default.createDirectory(
      atPath: dataDir, withIntermediateDirectories: true
    )
    return dataDir
  }
}
