import SwiftUI

@MainActor
final class ShortcutsViewModel: ObservableObject {
  @Published var showOrHide: ShortcutDisplay
  @Published var hide: ShortcutDisplay
  @Published var extractSelection: ShortcutDisplay
  @Published var extractCapture: ShortcutDisplay
  @Published var extractClipboard: ShortcutDisplay
  @Published var translateInput: ShortcutDisplay

  private let repository: SettingsRepository

  init(
    repository: SettingsRepository
  ) {
    self.repository = repository
    showOrHide = ShortcutDisplay(parts: [])
    hide = ShortcutDisplay(parts: [])
    extractSelection = ShortcutDisplay(parts: [])
    extractCapture = ShortcutDisplay(parts: [])
    extractClipboard = ShortcutDisplay(parts: [])
    translateInput = ShortcutDisplay(parts: ["Control", "Shift", "Return"])
  }

  func load() async {
    do {
      apply(try await repository.getShortcuts())
    } catch {
      // Keep the local preview/default state when the Rust-backed settings cannot be loaded.
    }
  }

  func setShowOrHide(_ shortcut: ShortcutDisplay) {
    showOrHide = shortcut
    Task {
      do {
        let updated = try await repository.updateShortcuts(
          ShortcutSettingsPatch(
            toggleApp: shortcut.rawValue,
            hideApp: nil,
            extractFromScreenSelection: nil,
            extractFromScreenCapture: nil,
            extractFromClipboard: nil
          )
        )
        apply(updated)
      } catch {
        await load()
      }
    }
  }

  private func apply(_ settings: ShortcutSettings) {
    showOrHide = ShortcutDisplay(rawValue: settings.toggleApp)
    hide = ShortcutDisplay(rawValue: settings.hideApp)
    extractSelection = ShortcutDisplay(rawValue: settings.extractFromScreenSelection)
    extractCapture = ShortcutDisplay(rawValue: settings.extractFromScreenCapture)
    extractClipboard = ShortcutDisplay(rawValue: settings.extractFromClipboard)
  }
}
