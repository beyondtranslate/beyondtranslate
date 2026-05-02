import SwiftUI

struct AppearanceView: View {
  @ObservedObject var viewModel: AppearanceViewModel

  var body: some View {
    SettingsPage(title: "Appearance") {
      Section("Interface") {
        SettingToggle("Show tray icon", isOn: $viewModel.showTrayIcon)
      }

      Section("Display Language") {
        SettingPicker(
          "",
          selection: Binding(
            get: { viewModel.appLanguage },
            set: { viewModel.setAppLanguage($0) }
          )
        ) {
          ForEach(["English", "Chinese"], id: \.self) { language in
            Text(language).tag(language)
          }
        }
        .labelsHidden()
        .pickerStyle(.radioGroup)
      }

      Section("Theme Mode") {
        SettingPicker(
          "",
          selection: Binding(
            get: { viewModel.themeMode },
            set: { viewModel.setThemeMode($0) }
          )
        ) {
          ForEach(AppThemeMode.allCases) { mode in
            Text(mode.title).tag(mode)
          }
        }
        .labelsHidden()
        .pickerStyle(.radioGroup)
      }
    }
    .preferredColorScheme(viewModel.themeMode.colorScheme)
  }
}
