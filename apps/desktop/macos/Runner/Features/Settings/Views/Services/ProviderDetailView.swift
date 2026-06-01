import SwiftUI
import beyondtranslate_runtime

// MARK: - Provider Detail View (Edit / Create)

struct ProviderDetailView: View {
  let provider: ProviderConfigEntry
  @ObservedObject var viewModel: ProvidersViewModel
  var isCreating: Bool = false

  @Environment(\.dismiss) private var dismiss

  @State private var editedFields: [String: String] = [:]
  @State private var editedId: String = ""
  @State private var hasChanges = false
  @State private var showDeleteConfirm = false
  @State private var fetchedModels: [String] = []
  @State private var isLoadingModels = false
  @State private var modelsLoadError: String?
  @State private var hasLoadedModels = false
  private var currentProvider: ProviderConfigEntry {
    viewModel.providers.first(where: { $0.id == provider.id }) ?? provider
  }

  private var currentServices: [ServiceConfigEntry] {
    viewModel.services.filter { $0.providerId == currentProvider.id }
  }

  private var providerType: ProviderType { currentProvider.type }

  private var configFields: [ProviderConfigField] { providerType.configFields }

  private var isLlm: Bool { providerType.isLlm }

  private var canSave: Bool {
    let id = isCreating ? editedId : currentProvider.id
    guard !id.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
      return false
    }
    return
      configFields
      .filter { !$0.isOptional }
      .allSatisfy {
        !(editedFields[$0.key] ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
      }
  }

  /// Models that are currently selected/active for this provider.
  private var enabledModels: Set<String> {
    let defaultModel = editedFields["defaultModel"] ?? ""
    let extras = (editedFields["models"] ?? "")
      .split(separator: ",")
      .map { $0.trimmingCharacters(in: .whitespaces) }
      .filter { !$0.isEmpty }
    var result: Set<String> = []
    if !defaultModel.isEmpty { result.insert(defaultModel) }
    result.formUnion(extras)
    return result
  }

  /// All model identifiers merged from both fetched API results and enabled set.
  private var allModels: [String] {
    let enabled = enabledModels
    var ordered = Array(enabled).sorted()
    for m in fetchedModels where !enabled.contains(m) && !ordered.contains(m) {
      ordered.append(m)
    }
    return ordered
  }

  var body: some View {
    SettingsPage(title: provider.type.displayName) {
      // ── Provider ID ────────────────────────────────────────────
      Section {
        if isCreating {
          TextField(
            text: $editedId,
            prompt: Text(LocaleKeys.settings.providers.editor.placeholder.id.tr())
          ) {
            Text(LocaleKeys.settings.providers.editor.row.id.tr())
          }
          .onChange(of: editedId) { _ in hasChanges = true }
        } else {
          HStack {
            Text(LocaleKeys.settings.providers.editor.row.id.tr())
            Spacer()
            Text(currentProvider.id)
              .foregroundStyle(.secondary)
              .lineLimit(1)
          }
        }
      }

      // ── Config Fields ─────────────────────────────────────────
      let nonModelFields = configFields.filter { $0.key != "defaultModel" && $0.key != "models" }
      if !nonModelFields.isEmpty {
        Section(LocaleKeys.settings.providers.detail.section.configuration.tr()) {
          ForEach(nonModelFields) { fieldDef in
            ProviderFieldRow(fieldDef: fieldDef, text: fieldBinding(fieldDef.key))
          }
        }
      }

      // ── Models (LLM only, existing providers only) ────────────
      if isLlm && !isCreating {
        Section(LocaleKeys.settings.providers.detail.section.models.tr()) {
          if isLoadingModels {
            HStack(spacing: 10) {
              ProgressView()
                .controlSize(.small)
              Text(LocaleKeys.settings.providers.detail.models.loading.tr())
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
            }
          } else if let error = modelsLoadError {
            VStack(alignment: .leading, spacing: 10) {
              Label(error, systemImage: "exclamationmark.triangle")
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
                .labelStyle(.titleAndIcon)

              Button(LocaleKeys.settings.providers.detail.models.retry.tr()) {
                Task { await fetchModels() }
              }
              .controlSize(.small)
            }
          } else if fetchedModels.isEmpty && enabledModels.isEmpty {
            HStack(spacing: 8) {
              Image(systemName: "sparkle.magnifyingglass")
                .font(.system(size: 14))
                .foregroundStyle(.tertiary)
              Text(LocaleKeys.settings.providers.detail.models.empty.tr())
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
            }
          } else {
            ForEach(allModels, id: \.self) { model in
              ModelRow(
                model: model,
                isEnabled: enabledModels.contains(model),
                isDefault: editedFields["defaultModel"] == model,
                onToggle: { isOn in
                  if isOn { addModel(model) } else { removeModel(model) }
                }
              )
            }
          }
        }
      }

      // ── Services (only for existing providers) ─────────────────
      if !isCreating {
        Section(LocaleKeys.settings.providers.section.services.tr()) {
          if currentServices.isEmpty {
            Text(LocaleKeys.settings.providers.item.noServices.tr())
              .foregroundStyle(.secondary)
          } else {
            ForEach(currentServices) { service in
              ServiceRowView(
                service: service,
                provider: currentProvider
              )
            }
          }
        }
      }

    }
    .toolbar {
      if !isCreating {
        ToolbarItem(placement: .automatic) {
          Button(role: .destructive) {
            showDeleteConfirm = true
          } label: {
            Text(LocaleKeys.common.ui.button.delete.tr())
          }
        }
      }

      ToolbarItem(placement: .primaryAction) {
        Button(
          isCreating
            ? LocaleKeys.common.ui.button.add.tr()
            : LocaleKeys.common.ui.button.save.tr()
        ) {
          saveChanges()
          if isCreating { dismiss() }
        }
        .disabled(!canSave || (!isCreating && !hasChanges))
      }
    }
    .onAppear {
      editedFields = currentProvider.fields
      editedId = currentProvider.id
      if !isCreating && isLlm && !hasLoadedModels {
        Task { await fetchModels() }
      }
    }
    .onChange(of: currentProvider) { newProvider in
      editedFields = newProvider.fields
    }
    .confirmationDialog(
      LocaleKeys.settings.providers.deleteDialog.title.tr(currentProvider.type.displayName),
      isPresented: $showDeleteConfirm,
      titleVisibility: .visible
    ) {
      Button(LocaleKeys.common.ui.button.delete.tr(), role: .destructive) {
        viewModel.deleteProvider(currentProvider.id)
        dismiss()
      }
      Button(LocaleKeys.common.ui.button.cancel.tr(), role: .cancel) {}
    } message: {
      Text(LocaleKeys.settings.providers.deleteDialog.message.tr())
    }
  }

  // MARK: - Field Binding

  private func fieldBinding(_ key: String) -> Binding<String> {
    Binding(
      get: { editedFields[key] ?? "" },
      set: {
        editedFields[key] = $0
        hasChanges = true
      }
    )
  }

  // MARK: - Fetch Models from API

  private func fetchModels() async {
    isLoadingModels = true
    modelsLoadError = nil
    hasLoadedModels = true

    let models = await viewModel.listModels(for: currentProvider.id)
    if models.isEmpty {
      modelsLoadError = LocaleKeys.settings.providers.detail.models.fetchError.tr()
    } else {
      fetchedModels = models
    }
    isLoadingModels = false
  }

  // MARK: - Model Management

  private func addModel(_ model: String) {
    if editedFields["defaultModel"]?.isEmpty ?? true {
      editedFields["defaultModel"] = model
    } else {
      let existing = editedFields["models"] ?? ""
      let items = existing.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
      if !items.contains(model) {
        editedFields["models"] = items.isEmpty ? model : "\(existing),\(model)"
      }
    }
    hasChanges = true
  }

  private func removeModel(_ model: String) {
    if editedFields["defaultModel"] == model {
      let existing = editedFields["models"] ?? ""
      let items = existing.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        .filter { !$0.isEmpty }
      if let first = items.first {
        editedFields["defaultModel"] = first
        editedFields["models"] = items.dropFirst().joined(separator: ",")
      } else {
        editedFields["defaultModel"] = ""
        editedFields["models"] = ""
      }
    } else {
      let existing = editedFields["models"] ?? ""
      let items = existing.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        .filter { $0 != model }
      editedFields["models"] = items.isEmpty ? "" : items.joined(separator: ",")
    }
    hasChanges = true
  }

  // MARK: - Save

  private func saveChanges() {
    var updatedEntry = isCreating ? provider : currentProvider
    if isCreating {
      updatedEntry = ProviderConfigEntry(
        id: editedId.trimmingCharacters(in: .whitespaces).isEmpty
          ? provider.id : editedId,
        type: provider.type,
        fields: editedFields,
        createdAt: nil
      )
    } else {
      updatedEntry = currentProvider
    }
    updatedEntry.fields = editedFields
    viewModel.saveProvider(updatedEntry)
    hasChanges = false
  }
}

// MARK: - Field Row

struct ProviderFieldRow: View {
  let fieldDef: ProviderConfigField
  let text: Binding<String>

  var body: some View {
    if fieldDef.isSecret {
      SecureField(text: text, prompt: promptText) {
        rowLabel
      }
    } else {
      TextField(text: text, prompt: promptText) {
        rowLabel
      }
    }
  }

  private var rowLabel: some View {
    HStack(spacing: 0) {
      if !fieldDef.isOptional {
        Text("*")
          .foregroundStyle(.red)
          .padding(.trailing, 2)
      }
      Text(fieldDef.label)
    }
  }

  private var promptText: Text? {
    fieldDef.placeholder.isEmpty ? nil : Text(fieldDef.placeholder)
  }
}

// MARK: - Model Row

private struct ModelRow: View {
  let model: String
  let isEnabled: Bool
  let isDefault: Bool
  let onToggle: (Bool) -> Void

  var body: some View {
    HStack(spacing: 8) {
      Text(model)
        .font(.system(size: 12))
        .lineLimit(1)

      if isDefault {
        Text(LocaleKeys.settings.providers.detail.models.defaultBadge.tr())
          .font(.system(size: 10, weight: .medium))
          .foregroundColor(.accentColor)
      }

      Spacer()

      Toggle(
        "",
        isOn: Binding(
          get: { isEnabled },
          set: { onToggle($0) }
        )
      )
      .toggleStyle(.switch)
      .labelsHidden()
      .controlSize(.small)
    }
    .padding(.vertical, 2)
  }
}
