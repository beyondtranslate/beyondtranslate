import SwiftUI
import beyondtranslate_runtime

@MainActor
final class ShortcutsViewModel: ObservableObject {
  @Published var toggleMiniTranslator: ShortcutDisplay
  @Published var extractTextFromScreenSelection: ShortcutDisplay
  @Published var extractTextFromScreenCapture: ShortcutDisplay
  @Published var extractTextFromClipboard: ShortcutDisplay
  @Published var translateInputContent: ShortcutDisplay
  @Published var recordingID: String?

  var isRecordingToggleMiniTranslator: Bool { recordingID == "toggleMiniTranslator" }
  var isRecordingExtractTextFromScreenSelection: Bool {
    recordingID == "extractTextFromScreenSelection"
  }
  var isRecordingExtractTextFromScreenCapture: Bool {
    recordingID == "extractTextFromScreenCapture"
  }
  var isRecordingExtractTextFromClipboard: Bool { recordingID == "extractTextFromClipboard" }
  var isRecordingTranslateInputContent: Bool { recordingID == "translateInputContent" }

  private let repository: SettingsRepository

  init(
    repository: SettingsRepository
  ) {
    self.repository = repository
    toggleMiniTranslator = ShortcutDisplay(parts: [])
    extractTextFromScreenSelection = ShortcutDisplay(parts: [])
    extractTextFromScreenCapture = ShortcutDisplay(parts: [])
    extractTextFromClipboard = ShortcutDisplay(parts: [])
    translateInputContent = ShortcutDisplay(parts: ["Option", "Z"])
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

  func setExtractTextFromScreenSelection(_ shortcut: ShortcutDisplay) {
    extractTextFromScreenSelection = shortcut
    Task {
      do {
        let updated = try await repository.updateShortcuts(
          .diff(extractTextFromScreenSelection: shortcut.rawValue))
        apply(updated)
      } catch {
        await load()
      }
    }
  }

  func clearExtractTextFromScreenSelection() {
    setExtractTextFromScreenSelection(ShortcutDisplay(parts: []))
  }

  func setExtractTextFromScreenCapture(_ shortcut: ShortcutDisplay) {
    extractTextFromScreenCapture = shortcut
    Task {
      do {
        let updated = try await repository.updateShortcuts(
          .diff(extractTextFromScreenCapture: shortcut.rawValue))
        apply(updated)
      } catch {
        await load()
      }
    }
  }

  func clearExtractTextFromScreenCapture() {
    setExtractTextFromScreenCapture(ShortcutDisplay(parts: []))
  }

  func setExtractTextFromClipboard(_ shortcut: ShortcutDisplay) {
    extractTextFromClipboard = shortcut
    Task {
      do {
        let updated = try await repository.updateShortcuts(
          .diff(extractTextFromClipboard: shortcut.rawValue))
        apply(updated)
      } catch {
        await load()
      }
    }
  }

  func clearExtractTextFromClipboard() {
    setExtractTextFromClipboard(ShortcutDisplay(parts: []))
  }

  func setTranslateInputContent(_ shortcut: ShortcutDisplay) {
    translateInputContent = shortcut
    Task {
      do {
        let updated = try await repository.updateShortcuts(
          .diff(translateInputContent: shortcut.rawValue))
        apply(updated)
      } catch {
        await load()
      }
    }
  }

  func clearTranslateInputContent() {
    setTranslateInputContent(ShortcutDisplay(parts: []))
  }

  private func apply(_ settings: ShortcutSettings) {
    toggleMiniTranslator = ShortcutDisplay(rawValue: settings.toggleMiniTranslator)
    extractTextFromScreenSelection = ShortcutDisplay(
      rawValue: settings.extractTextFromScreenSelection)
    extractTextFromScreenCapture = ShortcutDisplay(rawValue: settings.extractTextFromScreenCapture)
    extractTextFromClipboard = ShortcutDisplay(rawValue: settings.extractTextFromClipboard)
    translateInputContent = ShortcutDisplay(rawValue: settings.translateInputContent)
  }
}
