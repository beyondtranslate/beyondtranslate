import SwiftUI

struct AppearanceView: View {
  @ObservedObject var viewModel: AppearanceViewModel
  @ObservedObject private var localization = AppLocale.shared

  var body: some View {
    SettingsPage(title: LocaleKeys.settings.appearance.title.tr()) {
      Section(LocaleKeys.settings.appearance.section.appLanguage.tr()) {
        SettingPicker(
          "",
          selection: Binding(
            get: { viewModel.appLanguage },
            set: { viewModel.setAppLanguage($0) }
          )
        ) {
          ForEach(languageOptions, id: \.id) { language in
            Text(language.title).tag(language.id)
          }
        }
        .labelsHidden()
        .pickerStyle(.radioGroup)
      }

      Section(LocaleKeys.settings.appearance.section.themeMode.tr()) {
        SettingPicker(
          "",
          selection: Binding(
            get: { viewModel.themeMode },
            set: { viewModel.setThemeMode($0) }
          )
        ) {
          ForEach(viewModel.themeModeOptions) { option in
            Text(option.title).tag(option.mode)
          }
        }
        .labelsHidden()
        .pickerStyle(.radioGroup)
      }
    }
    .environment(\.locale, Locale(identifier: localization.languageCode))
  }

  private var languageOptions: [(id: String, title: String)] {
    [
      ("en", LocaleKeys.settings.appearance.option.english.tr()),
      ("zh", LocaleKeys.settings.appearance.option.chinese.tr()),
    ]
  }
}
