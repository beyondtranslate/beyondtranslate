import AppKit
import SwiftUI
import beyondtranslate_runtime

@MainActor
final class AdvancedViewModel: ObservableObject {
  @Published var apiServerEnabled: Bool
  @Published var apiServerHost: String
  @Published var apiServerPort: UInt16
  @Published var screenCaptureAllowed = false
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
    screenCaptureAllowed = CGPreflightScreenCaptureAccess()
    accessibilityAllowed = await RuntimeProvider.shared.textExtractor().isAccessAllowed()
  }

  func requestScreenCaptureAccess() {
    if !CGPreflightScreenCaptureAccess() {
      CGRequestScreenCaptureAccess()
    }
    openPrivacyPane("Privacy_ScreenCapture")
    Task { await refreshPermissions() }
  }

  func requestAccessibilityAccess() {
    Task {
      await RuntimeProvider.shared.textExtractor().requestAccess(onlyOpenPrefPane: false)
      openPrivacyPane("Privacy_Accessibility")
      await refreshPermissions()
    }
  }

  private func openPrivacyPane(_ anchor: String) {
    guard
      let url = URL(
        string: "x-apple.systempreferences:com.apple.preference.security?\(anchor)"
      )
    else {
      return
    }
    NSWorkspace.shared.open(url)
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
