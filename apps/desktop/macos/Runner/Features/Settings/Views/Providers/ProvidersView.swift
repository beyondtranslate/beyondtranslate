import SwiftUI

struct ProvidersView: View {
  @ObservedObject var viewModel: ProvidersViewModel
  @State private var draft: ProviderDraft?

  var body: some View {
    SettingsPage(title: "Providers") {
      Section {
        Text(
          "Providers are configuration wrappers that can generate translation and dictionary services."
        )
        .font(.system(size: 12))
        .foregroundStyle(.secondary)
      }

      providerSection(providers: viewModel.providers)
    }
    .sheet(item: $draft) { item in
      ProviderEditorSheet(draft: item) { updatedDraft in
        viewModel.saveProvider(updatedDraft)
        draft = nil
      } onCancel: {
        draft = nil
      }
    }
    .alert(
      "Error",
      isPresented: Binding(
        get: { viewModel.errorMessage != nil },
        set: { if !$0 { viewModel.errorMessage = nil } }
      )
    ) {
      Button("OK") { viewModel.errorMessage = nil }
    } message: {
      if let msg = viewModel.errorMessage {
        Text(msg)
      }
    }
  }

  @ViewBuilder
  private func providerSection(providers: [ProviderItem]) -> some View {
    Section {
      if viewModel.isLoading {
        HStack {
          Spacer()
          ProgressView()
          Spacer()
        }
        .padding(.vertical, 8)
      } else if providers.isEmpty {
        Text("No providers configured. Add one to enable translation services.")
          .foregroundStyle(.secondary)
      } else {
        ForEach(providers) { provider in
          ProviderRow(
            provider: provider,
            onEdit: {
              draft = .edit(item: provider)
            },
            onDelete: {
              viewModel.deleteProvider(provider.id)
            },
            onToggle: { isEnabled in
              viewModel.toggleProvider(provider.id, isEnabled: isEnabled)
            }
          )
        }
      }
    } header: {
      SettingSectionHeader(
        title: "Providers",
        buttonTitle: "Add Provider"
      ) {
        draft = .new()
      }
    }
  }
}

private struct ProviderRow: View {
  let provider: ProviderItem
  let onEdit: () -> Void
  let onDelete: () -> Void
  let onToggle: (Bool) -> Void

  @State private var showDeleteConfirm = false

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack(alignment: .firstTextBaseline, spacing: 12) {
        Image(systemName: "server.rack")
          .font(.system(size: 18))
          .foregroundStyle(Color.accentColor)

        VStack(alignment: .leading, spacing: 3) {
          HStack(spacing: 8) {
            Text(provider.name)
              .font(.headline)
            Text(provider.description)
              .font(.system(size: 11, weight: .medium))
              .foregroundStyle(.secondary)
          }
        }

        Spacer()

        Toggle(
          "",
          isOn: Binding(
            get: { provider.isEnabled },
            set: onToggle
          )
        )
        .labelsHidden()

        Button("Edit", action: onEdit)

        Button(role: .destructive) {
          showDeleteConfirm = true
        } label: {
          Image(systemName: "trash")
        }
        .buttonStyle(.borderless)
        .foregroundStyle(.secondary)
        .confirmationDialog(
          "Delete \"\(provider.name)\"?",
          isPresented: $showDeleteConfirm,
          titleVisibility: .visible
        ) {
          Button("Delete", role: .destructive, action: onDelete)
          Button("Cancel", role: .cancel) {}
        } message: {
          Text("This action cannot be undone.")
        }
      }

      if !provider.endpoint.isEmpty {
        HStack(spacing: 8) {
          Label(provider.endpoint, systemImage: "link")
            .font(.system(size: 12))
            .foregroundStyle(.secondary)
        }
      }

      if !provider.capabilities.isEmpty {
        HStack(spacing: 8) {
          ForEach(provider.capabilities) { capability in
            Text(capability.rawValue.capitalized)
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
    }
    .padding(.vertical, 6)
  }
}

private struct ProviderEditorSheet: View {
  @Environment(\.dismiss) private var dismiss
  @State var draft: ProviderDraft

  let onSave: (ProviderDraft) -> Void
  let onCancel: () -> Void

  private var canSave: Bool {
    guard !draft.backendID.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
      return false
    }
    return draft.providerType.configFields
      .filter { !$0.isOptional }
      .allSatisfy {
        !(draft.fields[$0.key] ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
          .isEmpty
      }
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      // Header
      VStack(alignment: .leading, spacing: 4) {
        Text(draft.title)
          .font(.title2.weight(.semibold))
        Text("Configure a translation or dictionary provider.")
          .foregroundStyle(.secondary)
      }

      Form {
        // Provider ID (read-only when editing)
        LabeledContent {
          TextField("e.g. deepl-main", text: $draft.backendID)
            .disabled(draft.localID != nil)
        } label: {
          Text("Provider ID")
        }

        // Provider type picker
        Picker("Provider Type", selection: $draft.providerType) {
          ForEach(ProviderType.allCases) { type in
            Text(type.rawValue).tag(type)
          }
        }
        .disabled(draft.localID != nil)
        .onChange(of: draft.providerType) { _ in
          // Clear fields when type changes to avoid stale keys
          draft.fields = [:]
        }

        // Dynamic fields based on selected provider type
        ForEach(draft.providerType.configFields) { fieldDef in
          LabeledContent {
            if fieldDef.isSecret {
              SecureField(
                fieldDef.isOptional ? "Optional" : "Required",
                text: fieldBinding(fieldDef.key)
              )
            } else {
              TextField(
                fieldDef.placeholder.isEmpty
                  ? (fieldDef.isOptional ? "Optional" : "Required")
                  : fieldDef.placeholder,
                text: fieldBinding(fieldDef.key)
              )
            }
          } label: {
            HStack(spacing: 4) {
              Text(fieldDef.label)
              if fieldDef.isOptional {
                Text("(Optional)")
                  .font(.system(size: 11))
                  .foregroundStyle(.secondary)
              }
            }
          }
        }
      }
      .formStyle(.grouped)

      // Actions
      HStack {
        Spacer()
        Button("Cancel") {
          onCancel()
          dismiss()
        }
        Button(draft.localID == nil ? "Add" : "Save") {
          onSave(draft)
          dismiss()
        }
        .keyboardShortcut(.defaultAction)
        .disabled(!canSave)
      }
    }
    .padding(24)
    .frame(width: 480)
  }

  private func fieldBinding(_ key: String) -> Binding<String> {
    Binding(
      get: { draft.fields[key] ?? "" },
      set: { draft.fields[key] = $0 }
    )
  }
}
