import SwiftUI

struct ShortcutsView: View {
  @ObservedObject var viewModel: ShortcutsViewModel

  var body: some View {
    SettingsPage(title: LocaleKeys.settings.shortcuts.title.tr()) {
      Section(LocaleKeys.settings.shortcut.section.tr()) {
        ShortcutSettingRow(
          title: LocaleKeys.settings.shortcut.showOrHide.tr(),
          shortcut: viewModel.showOrHide)
        ShortcutSettingRow(
          title: LocaleKeys.settings.shortcut.hide.tr(),
          shortcut: viewModel.hide)
      }

      Section(LocaleKeys.settings.shortcut.extractText.tr()) {
        ShortcutSettingRow(
          title: LocaleKeys.settings.shortcut.extractSelection.tr(),
          shortcut: viewModel.extractSelection)
        ShortcutSettingRow(
          title: LocaleKeys.settings.shortcut.extractCapture.tr(),
          shortcut: viewModel.extractCapture)
        ShortcutSettingRow(
          title: LocaleKeys.settings.shortcut.extractClipboard.tr(),
          shortcut: viewModel.extractClipboard)
      }

      Section(LocaleKeys.settings.shortcut.inputAssist.tr()) {
        ShortcutSettingRow(
          title: LocaleKeys.settings.shortcut.translateInput.tr(),
          shortcut: viewModel.translateInput)
      }
    }
  }
}
