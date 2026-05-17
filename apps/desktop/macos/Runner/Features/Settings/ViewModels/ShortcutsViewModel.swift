import SwiftUI
import beyondtranslate_runtime
import os

@MainActor
final class ShortcutsViewModel: ObservableObject {
  @Published var toggleMiniTranslator: String
  @Published var extractTextFromScreenSelection: String
  @Published var extractTextFromScreenCapture: String
  @Published var extractTextFromClipboard: String
  @Published var translateInputContent: String
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
  private let logger = Logger(
    subsystem: Bundle.main.bundleIdentifier ?? "BeyondTranslate",
    category: "ShortcutsSettings"
  )

  init(
    repository: SettingsRepository
  ) {
    self.repository = repository
    toggleMiniTranslator = ""
    extractTextFromScreenSelection = ""
    extractTextFromScreenCapture = ""
    extractTextFromClipboard = ""
    translateInputContent = ""
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
      // Keep the current local state when Rust-backed settings cannot be loaded.
    }
  }

  func setToggleMiniTranslator(_ shortcut: String) {
    toggleMiniTranslator = shortcut
    saveShortcut(
      id: "toggleMiniTranslator",
      patch: .diff(toggleMiniTranslator: shortcut)
    )
  }

  func clearToggleMiniTranslator() {
    setToggleMiniTranslator("")
  }

  func setExtractTextFromScreenSelection(_ shortcut: String) {
    extractTextFromScreenSelection = shortcut
    saveShortcut(
      id: "extractTextFromScreenSelection",
      patch: .diff(extractTextFromScreenSelection: shortcut)
    )
  }

  func clearExtractTextFromScreenSelection() {
    setExtractTextFromScreenSelection("")
  }

  func setExtractTextFromScreenCapture(_ shortcut: String) {
    extractTextFromScreenCapture = shortcut
    saveShortcut(
      id: "extractTextFromScreenCapture",
      patch: .diff(extractTextFromScreenCapture: shortcut)
    )
  }

  func clearExtractTextFromScreenCapture() {
    setExtractTextFromScreenCapture("")
  }

  func setExtractTextFromClipboard(_ shortcut: String) {
    extractTextFromClipboard = shortcut
    saveShortcut(
      id: "extractTextFromClipboard",
      patch: .diff(extractTextFromClipboard: shortcut)
    )
  }

  func clearExtractTextFromClipboard() {
    setExtractTextFromClipboard("")
  }

  func setTranslateInputContent(_ shortcut: String) {
    translateInputContent = shortcut
    saveShortcut(
      id: "translateInputContent",
      patch: .diff(translateInputContent: shortcut)
    )
  }

  func clearTranslateInputContent() {
    setTranslateInputContent("")
  }

  func resetToDefaultShortcuts() {
    Task { [weak self] in
      guard let self else { return }
      do {
        apply(try await repository.resetShortcuts())
      } catch {
        logger.error(
          "Failed to reset shortcuts: \(String(describing: error), privacy: .public)"
        )
        await load()
      }
    }
  }

  private func saveShortcut(id: String, patch: ShortcutSettingsPatch) {
    Task { [weak self] in
      guard let self else { return }
      do {
        let updated = try await repository.updateShortcuts(patch)
        apply(updated)
      } catch {
        logger.error(
          "Failed to save shortcut \(id, privacy: .public): \(String(describing: error), privacy: .public)"
        )
        await load()
      }
    }
  }

  private func apply(_ settings: ShortcutSettings) {
    toggleMiniTranslator = settings.toggleMiniTranslator
    extractTextFromScreenSelection = settings.extractTextFromScreenSelection
    extractTextFromScreenCapture = settings.extractTextFromScreenCapture
    extractTextFromClipboard = settings.extractTextFromClipboard
    translateInputContent = settings.translateInputContent
  }
}
