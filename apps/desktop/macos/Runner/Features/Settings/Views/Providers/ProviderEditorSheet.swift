import SwiftUI
import beyondtranslate_runtime

// MARK: - Provider Editor Sheet (Two-Step Flow)

struct ProviderEditorSheet: View {
  @State var draft: ProviderConfigEntry?
  @State private var showConfigEditor = false

  let isCreating: Bool
  let onGenerateProviderId: ((ProviderType) async -> String)?
  let onSave: (ProviderConfigEntry) -> Void
  let onDelete: (String) -> Void
  let onCancel: () -> Void

  init(
    draft: ProviderConfigEntry? = nil,
    isCreating: Bool,
    onGenerateProviderId: ((ProviderType) async -> String)? = nil,
    onSave: @escaping (ProviderConfigEntry) -> Void,
    onDelete: @escaping (String) -> Void,
    onCancel: @escaping () -> Void
  ) {
    self._draft = State(initialValue: draft)
    self.isCreating = isCreating
    self.onGenerateProviderId = onGenerateProviderId
    self.onSave = onSave
    self.onDelete = onDelete
    self.onCancel = onCancel
  }

  var body: some View {
    Group {
      if isCreating && !showConfigEditor {
        ProviderTypePicker(
          onNext: { selectedType in
            if let onGenerateProviderId = onGenerateProviderId {
              Task {
                let id = await onGenerateProviderId(selectedType)
                draft = ProviderConfigEntry(
                  id: id, type: selectedType, fields: [:], capabilities: [], createdAt: nil)
                showConfigEditor = true
              }
            } else {
              showConfigEditor = true
            }
          },
          onCancel: onCancel
        )
        .frame(width: 420)

      } else if let draft = draft {
        ProviderConfigEditor(
          draft: Binding(
            get: { draft },
            set: { self.draft = $0 }
          ),
          isCreating: isCreating,
          onSave: { onSave(draft) },
          onDelete: { providerID in onDelete(providerID) },
          onCancel: onCancel
        )
        .frame(width: 500)
      }
    }
    .onAppear {
      showConfigEditor = false
    }
  }
}

// MARK: - Step 1: Provider Type Picker

struct ProviderTypePicker: View {
  @State private var localSelection: ProviderType.ID?

  let onNext: (ProviderType) -> Void
  let onCancel: () -> Void

  var body: some View {
    VStack(spacing: 0) {
      Text(LocaleKeys.settings.providers.editor.typePicker.prompt.tr())
        .foregroundStyle(.primary)
        .multilineTextAlignment(.center)
        .padding(.top, 20)
        .padding(.bottom, 12)

      List(ProviderType.allCases, selection: $localSelection) { type in
        ProviderTypeSelectionRow(type: type)
          .tag(type.id)
      }
      .listStyle(.inset(alternatesRowBackgrounds: true))
      .frame(height: 280)
      .clipShape(RoundedRectangle(cornerRadius: 6))
      .overlay(
        RoundedRectangle(cornerRadius: 6)
          .stroke(Color(nsColor: .separatorColor), lineWidth: 1)
      )
      .padding(.horizontal, 20)

      HStack(spacing: 8) {
        Spacer()

        Button(LocaleKeys.common.button.cancel.tr()) {
          onCancel()
        }
        .keyboardShortcut(.cancelAction)

        Button(LocaleKeys.common.button.continue.tr()) {
          guard let id = localSelection,
            let type = ProviderType.allCases.first(where: { $0.id == id })
          else { return }
          onNext(type)
        }
        .keyboardShortcut(.defaultAction)
        .disabled(localSelection == nil)
      }
      .padding(.horizontal, 20)
      .padding(.top, 12)
      .padding(.bottom, 16)
    }
  }
}

struct ProviderTypeSelectionRow: View {
  let type: ProviderType

  var body: some View {
    HStack(spacing: 8) {
      ProviderTypeIcon(providerType: type)

      Text(type.displayName)
        .font(.system(size: 13))
        .lineLimit(1)

      Spacer()
    }
    .padding(.vertical, 2)
  }
}

// MARK: - Step 2: Provider Config

struct ProviderConfigEditor: View {
  @Binding var draft: ProviderConfigEntry

  let isCreating: Bool
  let onSave: () -> Void
  let onDelete: (String) -> Void
  let onCancel: () -> Void

  private var canSave: Bool {
    guard !draft.id.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
      return false
    }
    return draft.type.configFields
      .filter { !$0.isOptional }
      .allSatisfy {
        !(draft.fields[$0.key] ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
          .isEmpty
      }
  }

  var body: some View {
    VStack(spacing: 0) {
      Form {
        // Header — provider icon, name, hosting type
        Section {
          ProviderEditorHeader(draft: draft)
        }

        // Show Provider ID field only when creating a new provider
        if isCreating {
          Section {
            TextField(
              text: $draft.id,
              prompt: Text(LocaleKeys.settings.providers.editor.placeholder.id.tr())
            ) {
              Text(LocaleKeys.settings.providers.editor.row.id.tr())
            }
          }
        }

        // Required fields
        let requiredFields = draft.type.configFields.filter { !$0.isOptional }
        if !requiredFields.isEmpty {
          Section {
            ForEach(requiredFields) { fieldDef in
              ProviderFieldRow(fieldDef: fieldDef, text: fieldBinding(fieldDef.key))
            }
          }
        }

        // Optional fields
        let optionalFields = draft.type.configFields.filter { $0.isOptional }
        if !optionalFields.isEmpty {
          Section {
            ForEach(optionalFields) { fieldDef in
              ProviderFieldRow(fieldDef: fieldDef, text: fieldBinding(fieldDef.key))
            }
          }
        }
      }
      .formStyle(.grouped)

      Divider()

      HStack(spacing: 8) {
        // Help button — far left circle
        Button {
        } label: {
          Image(systemName: "questionmark.circle")
            .font(.system(size: 16))
            .foregroundStyle(.secondary)
        }
        .buttonStyle(.plain)
        .help(LocaleKeys.settings.providers.editor.tooltip.help.tr())

        // Destructive delete — bordered pill with red tint
        if !isCreating {
          Button(role: .destructive) {
            onDelete(draft.id)
          } label: {
            Text(LocaleKeys.settings.providers.dialog.deleteTitle.tr())
          }
          .buttonStyle(.bordered)
          .tint(.red)
        }

        Spacer()

        Button(LocaleKeys.common.button.cancel.tr()) {
          onCancel()
        }
        .keyboardShortcut(.cancelAction)

        Button(
          isCreating
            ? LocaleKeys.common.button.add.tr()
            : LocaleKeys.common.button.save.tr()
        ) {
          onSave()
        }
        .keyboardShortcut(.defaultAction)
        .disabled(!canSave)
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 16)
    }
  }

  private func fieldBinding(_ key: String) -> Binding<String> {
    Binding(
      get: { draft.fields[key] ?? "" },
      set: { draft.fields[key] = $0 }
    )
  }
}

// MARK: - Editor sub-views

struct ProviderEditorHeader: View {
  let draft: ProviderConfigEntry

  var body: some View {
    HStack(spacing: 10) {
      ProviderTypeIcon(providerType: draft.type)
        .frame(width: 28, height: 28)

      VStack(alignment: .leading, spacing: 3) {
        Text(draft.displayName)
          .font(.system(size: 14, weight: .semibold))
          .foregroundStyle(.primary)

        Text(draft.type.hostingDescription)
          .font(.system(size: 13))
          .foregroundStyle(.secondary)
      }

      Spacer()
    }
    .padding(.vertical, 2)
  }
}

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

// MARK: - Provider config helpers

extension ProviderConfigEntry {
  fileprivate var displayName: String {
    let trimmedID = id.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmedID.isEmpty else { return type.displayName }
    return
      trimmedID
      .split(whereSeparator: { $0 == "-" || $0 == "_" || $0 == "." })
      .map { part in
        let lowercased = part.lowercased()
        guard let first = lowercased.first else { return "" }
        return first.uppercased() + lowercased.dropFirst()
      }
      .joined(separator: " ")
  }
}

extension ProviderType {
  fileprivate var defaultCapabilities: [ProviderCapability] {
    switch self {
    case .baidu: return [.dictionary, .translation]
    case .caiyun: return [.translation]
    case .deepL: return [.translation]
    case .google: return [.dictionary, .translation]
    case .iciba: return [.dictionary]
    case .tencent: return [.translation]
    case .system: return [.dictionary, .ocr, .translation]
    case .youdao: return [.dictionary, .translation]
    }
  }

  var displayName: String {
    switch self {
    case .baidu: return LocaleKeys.provider.baidu.tr()
    case .caiyun: return LocaleKeys.provider.caiyun.tr()
    case .deepL: return LocaleKeys.provider.deepl.tr()
    case .google: return LocaleKeys.provider.google.tr()
    case .iciba: return LocaleKeys.provider.iciba.tr()
    case .tencent: return LocaleKeys.provider.tencent.tr()
    case .system: return LocaleKeys.provider.system.tr()
    case .youdao: return LocaleKeys.provider.youdao.tr()
    }
  }

  fileprivate var hostingDescription: String {
    let caps = defaultCapabilities
    let hasTranslation = caps.contains(.translation)
    let hasDictionary = caps.contains(.dictionary)
    switch (hasTranslation, hasDictionary) {
    case (true, true): return LocaleKeys.settings.providers.description.all.tr()
    case (true, false):
      return LocaleKeys.settings.providers.description.translation.tr()
    case (false, true):
      return LocaleKeys.settings.providers.description.dictionary.tr()
    default: return LocaleKeys.settings.providers.description.fallback.tr()
    }
  }
}
