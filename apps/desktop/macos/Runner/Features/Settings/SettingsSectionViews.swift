import SwiftUI

struct GeneralSettingsView: View {
  @ObservedObject var viewModel: SettingsViewModel

  var body: some View {
    SettingsPage(title: "General") {
      Section("Extract Text") {
        Picker("Default detect text engine", selection: $viewModel.defaultOcrEngine) {
          ForEach(["Built-in OCR", "Tesseract", "Youdao OCR"], id: \.self) { item in
            Text(item).tag(item)
          }
        }
        .pickerStyle(.menu)

        Toggle("Auto copy detected text", isOn: $viewModel.autoCopyDetectedText)
      }

      Section("Translate") {
        Picker("Default translate engine", selection: $viewModel.defaultTranslateEngine) {
          ForEach(["OpenAI", "Google Translate", "DeepL", "Youdao"], id: \.self) { item in
            Text(item).tag(item)
          }
        }
        .pickerStyle(.menu)
      }

      Section("Translation Mode") {
        Picker("", selection: $viewModel.translationMode) {
          ForEach(TranslationMode.allCases) { mode in
            Text(mode.title).tag(mode)
          }
        }
        .labelsHidden()
        .pickerStyle(.radioGroup)
      }

      if viewModel.translationMode == .auto {
        Section("Default Detect Language Engine") {
          Picker("Engine", selection: $viewModel.defaultDetectLanguageEngine) {
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
        Picker("", selection: $viewModel.inputSubmitMode) {
          ForEach(InputSubmitMode.allCases) { mode in
            Text(mode.title).tag(mode)
          }
        }
        .labelsHidden()
        .pickerStyle(.radioGroup)
      }

      Section("Double Click Copy Result") {
        Toggle(
          "Double click to copy translation result",
          isOn: $viewModel.doubleClickCopyResult
        )
      }

      Section("Service Integration") {
        ActionRow(
          title: "Text Translation",
          detail: "OpenAI, Google Translate, DeepL, Youdao"
        )

        ActionRow(
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

struct AppearanceSettingsView: View {
  @ObservedObject var viewModel: SettingsViewModel

  var body: some View {
    SettingsPage(title: "Appearance") {
      Section("Interface") {
        Toggle("Show tray icon", isOn: $viewModel.showTrayIcon)
      }

      Section("Max Window Height") {
        Picker("", selection: $viewModel.maxWindowHeight) {
          ForEach([700.0, 800.0, 900.0, 1000.0], id: \.self) { value in
            Text("\(Int(value))").tag(value)
          }
        }
        .labelsHidden()
        .pickerStyle(.radioGroup)
      }

      Section("Display Language") {
        Picker("", selection: $viewModel.appLanguage) {
          ForEach(["English", "Chinese"], id: \.self) { language in
            Text(language).tag(language)
          }
        }
        .labelsHidden()
        .pickerStyle(.radioGroup)
      }

      Section("Theme Mode") {
        Picker("", selection: $viewModel.themeMode) {
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

struct ProvidersSettingsView: View {
  @ObservedObject var viewModel: SettingsViewModel
  @State private var draft: ProviderDraft?

  var body: some View {
    SettingsPage(title: "Providers") {
      Section {
        Text("Providers are configuration wrappers. Traditional providers can later generate translation and dictionary services, while LLM providers are reserved for model-based workflows.")
          .font(.system(size: 12))
          .foregroundStyle(.secondary)
      }

      providerSection(
        listKind: .traditional,
        providers: viewModel.traditionalProviders
      )

      providerSection(
        listKind: .llm,
        providers: viewModel.llmProviders
      )
    }
    .sheet(item: $draft) { item in
      ProviderEditorSheet(draft: item) { updatedDraft in
        viewModel.saveProvider(updatedDraft)
        draft = nil
      } onCancel: {
        draft = nil
      }
    }
  }

  @ViewBuilder
  private func providerSection(
    listKind: ProviderListKind,
    providers: [ProviderItem]
  ) -> some View {
    Section {
      if providers.isEmpty {
        Text(listKind.emptyDescription)
          .foregroundStyle(.secondary)
      } else {
        ForEach(providers) { provider in
          ProviderRow(
            provider: provider,
            onEdit: {
              draft = .edit(item: provider)
            },
            onToggle: { isEnabled in
              viewModel.toggleProvider(provider.id, in: listKind, isEnabled: isEnabled)
            }
          )
        }
      }
    } header: {
      ProviderSectionHeader(
        title: listKind.title,
        buttonTitle: listKind.addTitle
      ) {
        draft = .new(listKind: listKind)
      }
    }
  }
}

struct ShortcutSettingsView: View {
  @ObservedObject var viewModel: SettingsViewModel

  var body: some View {
    SettingsPage(title: "Shortcuts") {
      Section("Shortcuts") {
        ShortcutRow(title: "Show or Hide", shortcut: viewModel.shortcutShowOrHide)
        ShortcutRow(title: "Hide", shortcut: viewModel.shortcutHide)
      }

      Section("Extract Text") {
        ShortcutRow(title: "Extract text from selection", shortcut: viewModel.shortcutExtractSelection)
        ShortcutRow(title: "Extract text from capture", shortcut: viewModel.shortcutExtractCapture)
        ShortcutRow(title: "Extract text from clipboard", shortcut: viewModel.shortcutExtractClipboard)
      }

      Section("Input Assist Function") {
        ShortcutRow(title: "Translate input content", shortcut: viewModel.shortcutTranslateInput)
      }
    }
  }
}

private struct ProviderSectionHeader: View {
  let title: String
  let buttonTitle: String
  let onAdd: () -> Void

  var body: some View {
    HStack {
      Text(title)
      Spacer()
      Button(buttonTitle, action: onAdd)
    }
  }
}

private struct ProviderRow: View {
  let provider: ProviderItem
  let onEdit: () -> Void
  let onToggle: (Bool) -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack(alignment: .firstTextBaseline, spacing: 12) {
        Image(systemName: provider.listKind == .llm ? "brain.head.profile" : "globe")
          .font(.system(size: 18))
          .foregroundStyle(Color.accentColor)

        VStack(alignment: .leading, spacing: 3) {
          HStack(spacing: 8) {
            Text(provider.name)
              .font(.headline)
            Text(provider.hosting.title)
              .font(.system(size: 11, weight: .medium))
              .foregroundStyle(.secondary)
          }

          Text(provider.description)
            .font(.system(size: 12))
            .foregroundStyle(.secondary)
        }

        Spacer()

        Toggle("", isOn: Binding(
          get: { provider.isEnabled },
          set: onToggle
        ))
        .labelsHidden()

        Button("Edit", action: onEdit)
      }

      HStack(spacing: 8) {
        Label(provider.endpoint, systemImage: "link")
          .font(.system(size: 12))
          .foregroundStyle(.secondary)

        Text(provider.apiKeyHeader)
          .font(.system(size: 11, weight: .medium, design: .monospaced))
          .padding(.horizontal, 8)
          .padding(.vertical, 4)
          .background(
            Capsule(style: .continuous)
              .fill(Color(nsColor: .underPageBackgroundColor))
          )
      }

      HStack(spacing: 8) {
        ForEach(provider.capabilities) { capability in
          Text(capability.title)
            .font(.system(size: 11, weight: .medium))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
              Capsule(style: .continuous)
                .fill(Color.accentColor.opacity(0.12))
            )
        }
      }
    }
    .padding(.vertical, 6)
  }
}

private struct ProviderEditorSheet: View {
  @Environment(\.dismiss) private var dismiss
  @State var draft: ProviderDraft

  let onSave: (ProviderDraft) -> Void
  let onCancel: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      VStack(alignment: .leading, spacing: 4) {
        Text(draft.title)
          .font(.title2.weight(.semibold))
        Text("Enter the information for the provider.")
          .foregroundStyle(.secondary)
      }

      Picker("", selection: $draft.hosting) {
        ForEach(ProviderHostingOption.allCases) { option in
          Text(option.title).tag(option)
        }
      }
      .labelsHidden()
      .pickerStyle(.segmented)

      Form {
        TextField("Provider Name", text: $draft.name)
        TextField("URL", text: $draft.endpoint)
        SecureField("API Key (Optional)", text: $draft.apiKey)
        TextField("API Key Header", text: $draft.apiKeyHeader)
        TextField("Description", text: $draft.description)
      }
      .formStyle(.grouped)
      .frame(maxHeight: 260)

      HStack {
        Spacer()
        Button("Cancel") {
          onCancel()
          dismiss()
        }
        Button(draft.providerID == nil ? "Add" : "Save") {
          onSave(draft)
          dismiss()
        }
        .keyboardShortcut(.defaultAction)
      }
    }
    .padding(24)
    .frame(width: 560)
  }
}

struct AdvancedSettingsView: View {
  @ObservedObject var viewModel: SettingsViewModel

  var body: some View {
    SettingsPage(title: "Advanced") {
      Section("Advanced") {
        Toggle("Launch at startup", isOn: $viewModel.launchAtStartup)
      }
    }
  }
}
