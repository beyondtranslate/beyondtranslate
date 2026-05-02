import SwiftUI

struct ShortcutsView: View {
  @ObservedObject var viewModel: ShortcutsViewModel

  var body: some View {
    SettingsPage(title: "Shortcuts") {
      Section("Shortcuts") {
        ShortcutSettingRow(title: "Show or Hide", shortcut: viewModel.showOrHide)
        ShortcutSettingRow(title: "Hide", shortcut: viewModel.hide)
      }

      Section("Extract Text") {
        ShortcutSettingRow(
          title: "Extract text from selection", shortcut: viewModel.extractSelection)
        ShortcutSettingRow(title: "Extract text from capture", shortcut: viewModel.extractCapture)
        ShortcutSettingRow(
          title: "Extract text from clipboard", shortcut: viewModel.extractClipboard)
      }

      Section("Input Assist Function") {
        ShortcutSettingRow(title: "Translate input content", shortcut: viewModel.translateInput)
      }
    }
  }
}
