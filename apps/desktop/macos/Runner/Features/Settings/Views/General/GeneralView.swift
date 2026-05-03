import SwiftUI

struct GeneralView: View {
  @ObservedObject var viewModel: GeneralViewModel

  var body: some View {
    SettingsPage(title: "General") {
      Section {
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
        SettingPicker(
          "Default extract text service",
          selection: Binding(
            get: { viewModel.defaultOcrService },
            set: { viewModel.setDefaultOcrService($0) }
          )
        ) {
          ForEach(["Built-in OCR", "Tesseract", "Youdao OCR"], id: \.self) { item in
            Text(item).tag(item)
          }
        }
        .pickerStyle(.menu)

        SettingToggle("Auto copy detected text", isOn: $viewModel.autoCopyDetectedText)
      }

      Section("Directory") {
        SettingPicker(
          "Default directory service",
          selection: Binding(
            get: { viewModel.defaultDirectoryService },
            set: { viewModel.setDefaultDirectoryService($0) }
          )
        ) {
          if viewModel.dictionaryServiceOptions.isEmpty {
            Text("No services available").tag("")
          } else {
            Text("None").tag("")
            ForEach(viewModel.dictionaryServiceOptions) { option in
              Text(option.name).tag(option.id)
            }
          }
        }
        .pickerStyle(.menu)
        .disabled(viewModel.dictionaryServiceOptions.isEmpty)
      }

      Section("Translation") {
        SettingPicker(
          "Default translation service",
          selection: Binding(
            get: { viewModel.defaultTranslationService },
            set: { viewModel.setDefaultTranslationService($0) }
          )
        ) {
          if viewModel.translationServiceOptions.isEmpty {
            Text("No services available").tag("")
          } else {
            Text("None").tag("")
            ForEach(viewModel.translationServiceOptions) { option in
              Text(option.name).tag(option.id)
            }
          }
        }
        .pickerStyle(.menu)
        .disabled(viewModel.translationServiceOptions.isEmpty)

        SettingPicker(
          "Translation mode",
          selection: Binding(
            get: { viewModel.translationMode },
            set: { viewModel.setTranslationMode($0) }
          )
        ) {
          ForEach(TranslationMode.allCases) { mode in
            Text(mode.title).tag(mode)
          }
        }
        .pickerStyle(.menu)

        SettingToggle(
          "Double click to copy translation result",
          isOn: $viewModel.doubleClickCopyResult
        )
      }

      if viewModel.translationMode == .auto {
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
    }
    .task {
      await viewModel.load()
    }
  }
}
