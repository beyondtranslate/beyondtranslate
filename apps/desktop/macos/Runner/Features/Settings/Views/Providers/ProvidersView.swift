import SwiftUI

struct ProvidersView: View {
  @ObservedObject var viewModel: ProvidersViewModel
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
      SettingSectionHeader(
        title: listKind.title,
        buttonTitle: listKind.addTitle
      ) {
        draft = .new(listKind: listKind)
      }
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

      SettingPicker("", selection: $draft.hosting) {
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
