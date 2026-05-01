import SwiftUI

struct AppearanceView: View {
  @ObservedObject var viewModel: AppearanceViewModel

  var body: some View {
    SettingsPage(title: "Appearance") {
      Section("Interface") {
        SettingToggle("Show tray icon", isOn: $viewModel.showTrayIcon)
      }

      Section("Max Window Height") {
        SettingPicker("", selection: $viewModel.maxWindowHeight) {
          ForEach([700.0, 800.0, 900.0, 1000.0], id: \.self) { value in
            Text("\(Int(value))").tag(value)
          }
        }
        .labelsHidden()
        .pickerStyle(.radioGroup)
      }

      Section("Display Language") {
        SettingPicker("", selection: $viewModel.appLanguage) {
          ForEach(["English", "Chinese"], id: \.self) { language in
            Text(language).tag(language)
          }
        }
        .labelsHidden()
        .pickerStyle(.radioGroup)
      }

      Section("Theme Mode") {
        SettingPicker("", selection: $viewModel.themeMode) {
          ForEach(AppThemeMode.allCases) { mode in
            Text(mode.title).tag(mode)
          }
        }
        .labelsHidden()
        .pickerStyle(.radioGroup)
      }
    }
  }
}
