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
          onClear: { viewModel.clearToggleMiniTranslator() })
      }

      Section(LocaleKeys.settings.shortcuts.section.extractText.tr()) {
        ShortcutSettingRow(
          title: LocaleKeys.settings.shortcuts.row.extractFromSelection.tr(),
          shortcut: viewModel.extractSelection,
          onShortcutRecorded: { viewModel.setExtractSelection($0) },
          onClear: { viewModel.clearExtractSelection() })
        ShortcutSettingRow(
          title: LocaleKeys.settings.shortcuts.row.extractFromCapture.tr(),
          shortcut: viewModel.extractCapture,
          onShortcutRecorded: { viewModel.setExtractCapture($0) },
          onClear: { viewModel.clearExtractCapture() })
        ShortcutSettingRow(
          title: LocaleKeys.settings.shortcuts.row.extractFromClipboard.tr(),
          shortcut: viewModel.extractClipboard,
          onShortcutRecorded: { viewModel.setExtractClipboard($0) },
          onClear: { viewModel.clearExtractClipboard() })
      }

      Section(LocaleKeys.settings.shortcuts.section.inputAssist.tr()) {
        ShortcutSettingRow(
          title: LocaleKeys.settings.shortcuts.row.translateInput.tr(),
          shortcut: viewModel.translateInput,
          onShortcutRecorded: { viewModel.setTranslateInput($0) },
          onClear: { viewModel.clearTranslateInput() })
      }
    }
  }
}
