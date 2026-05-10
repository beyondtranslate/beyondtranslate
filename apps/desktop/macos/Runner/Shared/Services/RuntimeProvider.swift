import Foundation
import beyondtranslate_runtime

/// Process-wide accessor for the Rust [Runtime] used by native (Swift) code.
///
/// Note: The Flutter side maintains its own [Runtime] instance pointing at
/// the same on-disk `settings.json`. Settings written through this provider
/// are persisted, but changes will only be reflected in the Flutter cache
/// after the next reload on the Flutter side.
enum RuntimeProvider {
  static let shared: Runtime = {
    do {
      return try Runtime(dataDir: applicationSupportDirectory())
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
