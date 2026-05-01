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
        SettingPicker("", selection: Binding(
          get: { viewModel.appLanguage },
          set: { viewModel.setAppLanguage($0) }
        )) {
          ForEach(["English", "Chinese"], id: \.self) { language in
            Text(language).tag(language)
          }
        }
        .labelsHidden()
        .pickerStyle(.radioGroup)
      }

      Section("Theme Mode") {
        SettingPicker("", selection: Binding(
          get: { viewModel.themeMode },
          set: { viewModel.setThemeMode($0) }
        )) {
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
