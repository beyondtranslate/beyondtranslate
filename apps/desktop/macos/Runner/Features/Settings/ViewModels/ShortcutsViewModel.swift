import SwiftUI
import beyondtranslate_runtime

@MainActor
final class ShortcutsViewModel: ObservableObject {
  @Published var toggleMiniTranslator: ShortcutDisplay
  @Published var extractSelection: ShortcutDisplay
  @Published var extractCapture: ShortcutDisplay
  @Published var extractClipboard: ShortcutDisplay
  @Published var translateInput: ShortcutDisplay
  @Published var recordingID: String?

  var isRecordingToggleMiniTranslator: Bool { recordingID == "toggleMiniTranslator" }
  var isRecordingExtractSelection: Bool { recordingID == "extractSelection" }
  var isRecordingExtractCapture: Bool { recordingID == "extractCapture" }
  var isRecordingExtractClipboard: Bool { recordingID == "extractClipboard" }
  var isRecordingTranslateInput: Bool { recordingID == "translateInput" }

  private let repository: SettingsRepository

  init(
    repository: SettingsRepository
  ) {
    self.repository = repository
    toggleMiniTranslator = ShortcutDisplay(parts: [])
    extractSelection = ShortcutDisplay(parts: [])
    extractCapture = ShortcutDisplay(parts: [])
    extractClipboard = ShortcutDisplay(parts: [])
    translateInput = ShortcutDisplay(parts: ["Control", "Shift", "Return"])
  }

  func startRecording(_ id: String) {
    recordingID = id
  }

  func stopRecording() {
    recordingID = nil
  }

  func load() async {
    do {
      apply(try await repository.getShortcuts())
    } catch {
      // Keep the local preview/default state when the Rust-backed settings cannot be loaded.
    }
  }

  func setToggleMiniTranslator(_ shortcut: ShortcutDisplay) {
    toggleMiniTranslator = shortcut
    Task {
      do {
        let updated = try await repository.updateShortcuts(
          .diff(toggleMiniTranslator: shortcut.rawValue))
        apply(updated)
      } catch {
        await load()
      }
    }
  }

  func clearToggleMiniTranslator() {
    setToggleMiniTranslator(ShortcutDisplay(parts: []))
  }

  func setExtractSelection(_ shortcut: ShortcutDisplay) {
    extractSelection = shortcut
    Task {
      do {
        let updated = try await repository.updateShortcuts(
          .diff(extractFromScreenSelection: shortcut.rawValue))
        apply(updated)
      } catch {
        await load()
      }
    }
  }

  func clearExtractSelection() {
    setExtractSelection(ShortcutDisplay(parts: []))
  }

  func setExtractCapture(_ shortcut: ShortcutDisplay) {
    extractCapture = shortcut
    Task {
      do {
        let updated = try await repository.updateShortcuts(
          .diff(extractFromScreenCapture: shortcut.rawValue))
        apply(updated)
      } catch {
        await load()
      }
    }
  }

  func clearExtractCapture() {
    setExtractCapture(ShortcutDisplay(parts: []))
  }

  func setExtractClipboard(_ shortcut: ShortcutDisplay) {
    extractClipboard = shortcut
    Task {
      do {
        let updated = try await repository.updateShortcuts(
          .diff(extractFromClipboard: shortcut.rawValue))
        apply(updated)
      } catch {
        await load()
      }
    }
  }

  func clearExtractClipboard() {
    setExtractClipboard(ShortcutDisplay(parts: []))
  }

  func setTranslateInput(_ shortcut: ShortcutDisplay) {
    translateInput = shortcut
  }

  func clearTranslateInput() {
    setTranslateInput(ShortcutDisplay(parts: []))
  }

  private func apply(_ settings: ShortcutSettings) {
    toggleMiniTranslator = ShortcutDisplay(rawValue: settings.toggleMiniTranslator)
    extractSelection = ShortcutDisplay(rawValue: settings.extractFromScreenSelection)
    extractCapture = ShortcutDisplay(rawValue: settings.extractFromScreenCapture)
    extractClipboard = ShortcutDisplay(rawValue: settings.extractFromClipboard)
  }
}
