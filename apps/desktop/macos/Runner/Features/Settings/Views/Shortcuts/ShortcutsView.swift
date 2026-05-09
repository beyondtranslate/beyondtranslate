import SwiftUI

struct ShortcutsView: View {
  @ObservedObject var viewModel: ShortcutsViewModel

  var body: some View {
    SettingsPage(title: LocaleKeys.settings.shortcuts.title.tr()) {
      Section(LocaleKeys.settings.shortcuts.section.shortcuts.tr()) {
        ShortcutSettingRow(
          title: LocaleKeys.settings.shortcuts.row.showOrHide.tr(),
          shortcut: viewModel.showOrHide)
        ShortcutSettingRow(
          title: LocaleKeys.settings.shortcuts.row.hide.tr(),
          shortcut: viewModel.hide)
      }

      Section(LocaleKeys.settings.shortcuts.section.extractText.tr()) {
        ShortcutSettingRow(
          title: LocaleKeys.settings.shortcuts.row.extractSelection.tr(),
          shortcut: viewModel.extractSelection)
        ShortcutSettingRow(
          title: LocaleKeys.settings.shortcuts.row.extractCapture.tr(),
          shortcut: viewModel.extractCapture)
        ShortcutSettingRow(
          title: LocaleKeys.settings.shortcuts.row.extractClipboard.tr(),
          shortcut: viewModel.extractClipboard)
      }

      Section(LocaleKeys.settings.shortcuts.section.inputAssist.tr()) {
        ShortcutSettingRow(
          title: LocaleKeys.settings.shortcuts.row.translateInput.tr(),
          shortcut: viewModel.translateInput)
      }
    }
  }
}
