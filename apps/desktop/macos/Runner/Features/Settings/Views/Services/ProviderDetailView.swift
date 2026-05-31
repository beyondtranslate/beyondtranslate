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
  @State private var showAddModelSheet = false

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

      // ── Models (LLM only, skip fetching when creating) ─────────
      if isLlm {
        Section(LocaleKeys.settings.providers.detail.section.models.tr()) {
          if !isCreating && isLoadingModels {
            HStack(spacing: 10) {
              ProgressView()
                .controlSize(.small)
              Text(LocaleKeys.settings.providers.detail.models.loading.tr())
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
            }
          } else if !isCreating, let error = modelsLoadError {
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
          } else if !isCreating && fetchedModels.isEmpty && enabledModels.isEmpty {
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

          HStack {
            Spacer()
            Button(LocaleKeys.settings.providers.detail.models.add.tr()) {
              showAddModelSheet = true
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

      // ── Bottom Actions ──────────────────────────────────────────
      Section {
        HStack(spacing: 8) {
          if !currentProvider.type.configFields.isEmpty {
            Button {
            } label: {
              Image(systemName: "questionmark.circle")
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .help(LocaleKeys.settings.providers.editor.tooltip.help.tr())
          }

          if !isCreating {
            Button(role: .destructive) {
              showDeleteConfirm = true
            } label: {
              Text(LocaleKeys.settings.providers.deleteDialog.title.tr())
            }
            .buttonStyle(.bordered)
            .tint(.red)
          }

          Spacer()

          Button(
            isCreating
              ? LocaleKeys.common.ui.button.add.tr()
              : LocaleKeys.common.ui.button.save.tr()
          ) {
            saveChanges()
            if isCreating { dismiss() }
          }
          .buttonStyle(.borderedProminent)
          .disabled(!canSave || (!isCreating && !hasChanges))
        }
        .padding(.vertical, 4)
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
    .sheet(isPresented: $showAddModelSheet) {
      AddModelSheet { modelName in
        addModel(modelName)
        showAddModelSheet = false
      } onCancel: {
        showAddModelSheet = false
      }
      .frame(width: 360)
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

// MARK: - Add Model Sheet

private struct AddModelSheet: View {
  let onAdd: (String) -> Void
  let onCancel: () -> Void

  @State private var modelName = ""
  @FocusState private var isFocused: Bool

  var body: some View {
    VStack(spacing: 0) {
      Text(LocaleKeys.settings.providers.detail.models.addTitle.tr())
        .font(.headline)
        .padding(.top, 20)
        .padding(.bottom, 16)

      TextField(
        "",
        text: $modelName,
        prompt: Text(LocaleKeys.settings.providers.detail.models.addPlaceholder.tr())
      )
      .textFieldStyle(.roundedBorder)
      .focused($isFocused)
      .padding(.horizontal, 20)

      HStack(spacing: 8) {
        Spacer()

        Button(LocaleKeys.common.ui.button.cancel.tr()) {
          onCancel()
        }
        .keyboardShortcut(.cancelAction)

        Button(LocaleKeys.common.ui.button.add.tr()) {
          let trimmed = modelName.trimmingCharacters(in: .whitespaces)
          guard !trimmed.isEmpty else { return }
          onAdd(trimmed)
        }
        .keyboardShortcut(.defaultAction)
        .disabled(modelName.trimmingCharacters(in: .whitespaces).isEmpty)
      }
      .padding(.horizontal, 20)
      .padding(.top, 16)
      .padding(.bottom, 20)
    }
    .onAppear {
      isFocused = true
    }
  }
}
