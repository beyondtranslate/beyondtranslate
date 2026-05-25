import SwiftUI
import beyondtranslate_runtime

@MainActor
final class AdvancedViewModel: ObservableObject {
  @Published var apiServerEnabled: Bool
  @Published var apiServerHost: String
  @Published var apiServerPort: UInt16
  @Published var screenRecordingAllowed = false
  @Published var accessibilityAllowed = false

  private let repository: SettingsRepository

  init(repository: SettingsRepository) {
    self.repository = repository
    apiServerEnabled = false
    apiServerHost = "127.0.0.1"
    apiServerPort = 0
  }

  func load() async {
    await refreshPermissions()

    do {
      apply(try await repository.getAdvanced())
    } catch {
      // Keep defaults when the Rust-backed settings cannot be loaded.
    }
  }

  func refreshPermissions() async {
    let permission = RuntimeProvider.shared.permission()
    screenRecordingAllowed = await permission.isScreenRecordingPermissionGranted()
    accessibilityAllowed = await permission.isAccessibilityPermissionGranted()
  }

  func requestScreenRecordingPermission() {
    Task {
      await RuntimeProvider.shared.permission().requestScreenRecordingPermission(
        onlyOpenSystemSettings: false)
      await refreshPermissions()
    }
  }

  func requestAccessibilityPermission() {
    Task {
      await RuntimeProvider.shared.permission().requestAccessibilityPermission(
        onlyOpenSystemSettings: false)
      await refreshPermissions()
    }
  }

  func setApiServerEnabled(_ value: Bool) {
    apiServerEnabled = value
    update(
      AdvancedSettingsPatch(
        apiServerEnabled: value,
        apiServerHost: nil,
        apiServerPort: nil
      )
    )
  }

  func setApiServerHost(_ value: String) {
    let host = value.trimmingCharacters(in: .whitespacesAndNewlines)
    apiServerHost = host.isEmpty ? "127.0.0.1" : host
    update(
      AdvancedSettingsPatch(
        apiServerEnabled: nil,
        apiServerHost: apiServerHost,
        apiServerPort: nil
      )
    )
  }

  func setApiServerPort(_ value: String) {
    let port = UInt16(value.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
    apiServerPort = port
    update(
      AdvancedSettingsPatch(
        apiServerEnabled: nil,
        apiServerHost: nil,
        apiServerPort: port
      )
    )
  }

  private func update(_ patch: AdvancedSettingsPatch) {
    Task {
      do {
        apply(try await repository.updateAdvanced(patch))
      } catch {
        await load()
      }
    }
  }

  private func apply(_ settings: AdvancedSettings) {
    apiServerEnabled = settings.apiServerEnabled
    apiServerHost = settings.apiServerHost
    apiServerPort = settings.apiServerPort
  }
}
