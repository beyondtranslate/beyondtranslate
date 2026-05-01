import SwiftUI

@MainActor
final class AdvancedViewModel: ObservableObject {
  @Published var launchAtStartup: Bool
  @Published var proxy: String

  private let settingsPlugin: NativeSettingsPlugin?

  init(
    settings: AdvancedSettingsState = AdvancedSettingsState(),
    settingsPlugin: NativeSettingsPlugin? = nil
  ) {
    self.settingsPlugin = settingsPlugin
    launchAtStartup = settings.launchAtStartup
    proxy = ""
  }

  func load() async {
    guard let settingsPlugin else { return }
    do {
      apply(try await settingsPlugin.getAdvanced())
    } catch {
      // Keep the local preview/default state when the Rust-backed settings cannot be loaded.
    }
  }

  func setLaunchAtStartup(_ value: Bool) {
    launchAtStartup = value
    guard let settingsPlugin else { return }
    Task {
      do {
        let updated = try await settingsPlugin.updateAdvanced(
          AdvancedSettingsPatch(launchAtLogin: value, proxy: nil)
        )
        apply(updated)
      } catch {
        await load()
      }
    }
  }

  func setProxy(_ value: String) {
    proxy = value
    guard let settingsPlugin else { return }
    Task {
      do {
        let updated = try await settingsPlugin.updateAdvanced(
          AdvancedSettingsPatch(launchAtLogin: nil, proxy: value)
        )
        apply(updated)
      } catch {
        await load()
      }
    }
  }

  private func apply(_ settings: AdvancedSettings) {
    launchAtStartup = settings.launchAtLogin
    proxy = settings.proxy
  }
}
