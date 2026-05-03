import SwiftUI

struct GeneralView: View {
  @ObservedObject var viewModel: GeneralViewModel

  var body: some View {
    SettingsPage(title: "General") {
      Section("App") {
        SettingToggle(
          "Launch at login",
          isOn: Binding(
            get: { viewModel.launchAtLogin },
            set: { viewModel.setLaunchAtLogin($0) }
          ))
        SettingToggle(
          "Show menu bar",
          isOn: Binding(
            get: { viewModel.showMenuBar },
            set: { viewModel.setShowMenuBar($0) }
          ))
      }

      Section("Extract Text") {
        SettingPicker("Default detect text engine", selection: $viewModel.defaultOcrEngine) {
          ForEach(["Built-in OCR", "Tesseract", "Youdao OCR"], id: \.self) { item in
            Text(item).tag(item)
          }
        }
        .pickerStyle(.menu)

        SettingToggle("Auto copy detected text", isOn: $viewModel.autoCopyDetectedText)
      }

      Section("Translate") {
        SettingPicker(
          "Default translate engine", selection: $viewModel.defaultTranslateEngine
        ) {
          ForEach(["OpenAI", "Google Translate", "DeepL", "Youdao"], id: \.self) { item in
            Text(item).tag(item)
          }
        }
        .pickerStyle(.menu)
      }

      Section("Translation Mode") {
        SettingPicker("", selection: $viewModel.translationMode) {
          ForEach(TranslationMode.allCases) { mode in
            Text(mode.title).tag(mode)
          }
        }
        .labelsHidden()
        .pickerStyle(.radioGroup)
      }

      if viewModel.translationMode == .auto {
        Section("Default Detect Language Engine") {
          SettingPicker("Engine", selection: $viewModel.defaultDetectLanguageEngine) {
            ForEach(["Google Translate", "OpenAI", "Baidu"], id: \.self) { item in
              Text(item).tag(item)
            }
          }
          .pickerStyle(.menu)
        }

        Section("Translation Target") {
          VStack(alignment: .leading, spacing: 10) {
            ForEach(viewModel.translationTargets) { item in
              HStack {
                Text(item.source)
                Image(systemName: "arrow.right")
                  .foregroundStyle(.secondary)
                Text(item.target)
                Spacer()
                Button("Edit") {}
              }
            }

            Button("Add Target") {}
          }
        }
      }

      Section("Input Settings") {
        SettingPicker("", selection: $viewModel.inputSubmitMode) {
          ForEach(InputSubmitMode.allCases) { mode in
            Text(mode.title).tag(mode)
          }
        }
        .labelsHidden()
        .pickerStyle(.radioGroup)
      }

      Section("Double Click Copy Result") {
        SettingToggle(
          "Double click to copy translation result",
          isOn: $viewModel.doubleClickCopyResult
        )
      }

      Section("Service Integration") {
        SettingRow(
          title: "Text Translation",
          detail: "OpenAI, Google Translate, DeepL, Youdao"
        )

        SettingRow(
          title: "Text Detection",
          detail: "Built-in OCR, Tesseract, Youdao OCR"
        )
      }

      Section("Others") {
        Button("About Biyi") {}
      }

      Section("Application") {
        Button(action: {}) {
          Text("Exit App")
            .foregroundStyle(.red)
        }
      }
    }
  }
}
