import SwiftUI

@MainActor
final class ShortcutsViewModel: ObservableObject {
  @Published var showOrHide: ShortcutDisplay
  @Published var hide: ShortcutDisplay
  @Published var extractSelection: ShortcutDisplay
  @Published var extractCapture: ShortcutDisplay
  @Published var extractClipboard: ShortcutDisplay
  @Published var translateInput: ShortcutDisplay

  private let settingsPlugin: NativeSettingsPlugin?

  init(
    settings: ShortcutSettingsState = ShortcutSettingsState(),
    settingsPlugin: NativeSettingsPlugin? = nil
  ) {
    self.settingsPlugin = settingsPlugin
    showOrHide = settings.showOrHide
    hide = settings.hide
    extractSelection = settings.extractSelection
    extractCapture = settings.extractCapture
    extractClipboard = settings.extractClipboard
    translateInput = settings.translateInput
  }

  func load() async {
    guard let settingsPlugin else { return }
    do {
      apply(try await settingsPlugin.getShortcuts())
    } catch {
      // Keep the local preview/default state when the Rust-backed settings cannot be loaded.
    }
  }

  func setShowOrHide(_ shortcut: ShortcutDisplay) {
    showOrHide = shortcut
    guard let settingsPlugin else { return }
    Task {
      do {
        let updated = try await settingsPlugin.updateShortcuts(
          ShortcutSettingsPatch(toggleApp: shortcut.rawValue)
        )
        apply(updated)
      } catch {
        await load()
      }
    }
  }

  private func apply(_ settings: ShortcutSettings) {
    showOrHide = ShortcutDisplay(rawValue: settings.toggleApp)
  }
}
