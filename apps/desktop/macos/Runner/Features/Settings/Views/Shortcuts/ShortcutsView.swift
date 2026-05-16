import SwiftUI

struct ShortcutsView: View {
  @ObservedObject var viewModel: ShortcutsViewModel

  var body: some View {
    SettingsPage(title: LocaleKeys.settings.shortcuts.title.tr()) {
      Section {
        ShortcutSettingRow(
          title: LocaleKeys.settings.shortcuts.row.toggleMiniTranslator.tr(),
          shortcut: viewModel.toggleMiniTranslator,
          onShortcutRecorded: { viewModel.setToggleMiniTranslator($0) },
          onClear: { viewModel.clearToggleMiniTranslator() }
        )
        .id("toggleMiniTranslator")
      }

      Section(LocaleKeys.settings.shortcuts.section.textExtraction.tr()) {
        ShortcutSettingRow(
          title: LocaleKeys.settings.shortcuts.row.extractTextFromScreenSelection.tr(),
          shortcut: viewModel.extractTextFromScreenSelection,
          onShortcutRecorded: { viewModel.setExtractTextFromScreenSelection($0) },
          onClear: { viewModel.clearExtractTextFromScreenSelection() }
        )
        .id("extractTextFromScreenSelection")
        ShortcutSettingRow(
          title: LocaleKeys.settings.shortcuts.row.extractTextFromScreenCapture.tr(),
          shortcut: viewModel.extractTextFromScreenCapture,
          onShortcutRecorded: { viewModel.setExtractTextFromScreenCapture($0) },
          onClear: { viewModel.clearExtractTextFromScreenCapture() }
        )
        .id("extractTextFromScreenCapture")
        ShortcutSettingRow(
          title: LocaleKeys.settings.shortcuts.row.extractTextFromClipboard.tr(),
          shortcut: viewModel.extractTextFromClipboard,
          onShortcutRecorded: { viewModel.setExtractTextFromClipboard($0) },
          onClear: { viewModel.clearExtractTextFromClipboard() }
        )
        .id("extractTextFromClipboard")
      }

      Section(LocaleKeys.settings.shortcuts.section.inputAssist.tr()) {
        ShortcutSettingRow(
          title: LocaleKeys.settings.shortcuts.row.translateInput.tr(),
          shortcut: viewModel.translateInputContent,
          onShortcutRecorded: { viewModel.setTranslateInputContent($0) },
          onClear: { viewModel.clearTranslateInputContent() }
        )
        .id("translateInputContent")
      }
    }
  }
}
