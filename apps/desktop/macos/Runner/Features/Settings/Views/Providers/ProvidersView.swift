import SwiftUI
import beyondtranslate_runtime

struct ProvidersView: View {
  @ObservedObject var viewModel: ProvidersViewModel
  @State private var draft: ProviderConfigEntry?
  @State private var isCreatingDraft = false

  var body: some View {
    NavigationStack {
      SettingsPage(title: LocaleKeys.settings.providers.title.tr()) {
        Section {
          ProviderIntroRow()
        }

        Section {
          if viewModel.isLoading {
            LoadingProviderRow()
          } else if viewModel.providers.isEmpty {
            EmptyProviderRow()
          } else {
            ForEach(viewModel.providers) { provider in
              ProviderRow(
                provider: provider,
                onEdit: {
                  isCreatingDraft = false
                  draft = provider
                },
                onDelete: { viewModel.deleteProvider(provider.id) }
              )
            }
          }
        } footer: {
          HStack {
            Spacer()
            Button(LocaleKeys.settings.providers.button.add.tr()) {
              isCreatingDraft = true
              draft = .newProvider()
            }
          }
        }
      }
      .navigationDestination(for: String.self) { providerID in
        if let provider = viewModel.providers.first(where: { $0.id == providerID }) {
          ProviderDetailView(provider: provider, viewModel: viewModel)
        }
      }
    }
    .onReceive(viewModel.$pendingPresentProviderEditorSheetID) { id in
      guard let id, viewModel.consumePresentProviderEditorSheet(id) else { return }
      isCreatingDraft = true
      draft = .newProvider()
    }
    .sheet(item: $draft) { item in
      ProviderEditorSheet(
        draft: item,
        isCreating: isCreatingDraft,
        onSave: { updatedDraft in
          draft = nil
          viewModel.saveProvider(updatedDraft)
        },
        onDelete: { providerID in
          draft = nil
          viewModel.deleteProvider(providerID)
        },
        onCancel: {
          draft = nil
        }
      )
    }
    .alert(
      LocaleKeys.settings.providers.alert.error.tr(),
      isPresented: Binding(
        get: { viewModel.errorMessage != nil },
        set: { if !$0 { viewModel.errorMessage = nil } }
      )
    ) {
      Button(LocaleKeys.common.button.ok.tr()) { viewModel.errorMessage = nil }
    } message: {
      if let msg = viewModel.errorMessage {
        Text(msg)
      }
    }
  }

}

// MARK: - Intro Row

private struct ProviderIntroRow: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(LocaleKeys.settings.providers.intro.body.tr())
        .fixedSize(horizontal: false, vertical: true)

      Text(
        LocaleKeys.settings.providers.intro.warning.tr()
      )
      .foregroundStyle(.secondary)
      .fixedSize(horizontal: false, vertical: true)
    }
    .padding(.top, -6)
    .padding(.bottom, 2)
  }
}

// MARK: - Provider Row  (NavigationLink → ProviderDetailView)

private struct ProviderRow: View {
  let provider: ProviderConfigEntry
  let onEdit: () -> Void
  let onDelete: () -> Void

  @State private var showDeleteConfirm = false

  var body: some View {
    NavigationLink(value: provider.id) {
      HStack(spacing: 14) {
        ProviderTypeIcon(providerType: provider.providerType)

        VStack(alignment: .leading, spacing: 3) {
          Text(provider.name)
            .font(.system(size: 13))
            .foregroundStyle(.primary)

          if !provider.endpoint.isEmpty {
            Text(provider.endpoint)
              .font(.system(size: 11))
              .foregroundStyle(.secondary)
              .lineLimit(1)
          }
        }

        Spacer()

        // Capability tags
        HStack(spacing: 4) {
          ForEach(provider.providerCapabilities, id: \.self) { cap in
            ProviderCapabilityTag(capability: cap)
          }
        }
      }
      .contentShape(Rectangle())
      .padding(.vertical, 2)
    }
    .contextMenu {
      Button(LocaleKeys.common.button.edit.tr(), action: onEdit)

      Divider()

      Button(LocaleKeys.common.button.delete.tr(), role: .destructive) {
        showDeleteConfirm = true
      }
    }
    .confirmationDialog(
      LocaleKeys.settings.providers.dialog.deleteConfirm.tr(provider.name),
      isPresented: $showDeleteConfirm,
      titleVisibility: .visible
    ) {
      Button(
        LocaleKeys.common.button.delete.tr(), role: .destructive, action: onDelete)
      Button(LocaleKeys.common.button.cancel.tr(), role: .cancel) {}
    } message: {
      Text(LocaleKeys.settings.providers.dialog.deleteMessage.tr())
    }
  }
}

// MARK: - Loading / Empty states

private struct LoadingProviderRow: View {
  var body: some View {
    HStack(spacing: 14) {
      ProgressView()
      Text(LocaleKeys.settings.providers.item.loading.tr())
        .font(.system(size: 13))
        .foregroundStyle(.secondary)
      Spacer()
    }
  }
}

private struct EmptyProviderRow: View {
  var body: some View {
    HStack(spacing: 14) {
      Image(systemName: "square.stack.3d.up.slash")
        .font(.system(size: 20))
        .foregroundStyle(.tertiary)
        .frame(width: 28, height: 28)
      Text(LocaleKeys.settings.providers.item.empty.tr())
        .font(.system(size: 13))
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)
      Spacer()
    }
  }
}

// MARK: - Capability Tag

struct ProviderCapabilityTag: View {
  let capability: ProviderCapability

  var body: some View {
    Text(label)
      .font(.system(size: 10, weight: .medium))
      .foregroundStyle(color)
      .padding(.horizontal, 6)
      .padding(.vertical, 2)
      .background(
        Capsule()
          .fill(color.opacity(0.12))
      )
  }

  private var label: String {
    capability.displayName
  }

  private var color: Color {
    capability.color
  }
}

// MARK: - Provider Type Icon

struct ProviderTypeIcon: View {
  let providerType: ProviderType

  private var flutterAssetImage: NSImage? {
    let iconFileName = "\(providerType.wireValue).png"
    let flutterAssetsURL = Bundle.main.bundleURL
      .appendingPathComponent("Contents/Frameworks/App.framework/Resources/flutter_assets")
      .appendingPathComponent("resources/images/translation_engine_icons")
      .appendingPathComponent(iconFileName)
    return NSImage(contentsOf: flutterAssetsURL)
  }

  var body: some View {
    if let image = flutterAssetImage {
      Image(nsImage: image)
        .resizable()
        .interpolation(.high)
        .antialiased(true)
        .frame(width: 28, height: 28)
        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
    } else {
      ZStack {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
          .fill(Color.accentColor.opacity(0.15))
        Image(systemName: "server.rack")
          .font(.system(size: 12, weight: .medium))
          .foregroundStyle(Color.accentColor)
      }
      .frame(width: 28, height: 28)
    }
  }
}

// MARK: - Provider Editor Sheet

struct ProviderEditorSheet: View {
  @State var draft: ProviderConfigEntry

  let isCreating: Bool
  let onSave: (ProviderConfigEntry) -> Void
  let onDelete: (String) -> Void
  let onCancel: () -> Void

  private var canSave: Bool {
    guard !draft.id.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
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
    VStack(spacing: 0) {
      Form {
        // Header — provider icon, name, hosting type
        Section {
          ProviderEditorHeader(draft: draft)
        }

        // Show Provider ID and Type picker only when creating a new provider
        if isCreating {
          Section {
            TextField(
              text: $draft.id,
              prompt: Text(LocaleKeys.settings.providers.editor.placeholder.id.tr())
            ) {
              Text(LocaleKeys.settings.providers.editor.row.id.tr())
            }

            Picker(
              LocaleKeys.settings.providers.editor.row.type.tr(), selection: providerTypeBinding
            ) {
              ForEach(ProviderType.allCases) { type in
                Text(type.displayName).tag(type)
              }
            }
          }
        }

        // Required fields
        let requiredFields = draft.providerType.configFields.filter { !$0.isOptional }
        if !requiredFields.isEmpty {
          Section {
            ForEach(requiredFields) { fieldDef in
              ProviderFieldRow(fieldDef: fieldDef, text: fieldBinding(fieldDef.key))
            }
          }
        }

        // Optional fields
        let optionalFields = draft.providerType.configFields.filter { $0.isOptional }
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
          onSave(draft)
        }
        .keyboardShortcut(.defaultAction)
        .disabled(!canSave)
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 16)
    }
    .frame(width: 500)
  }

  private func fieldBinding(_ key: String) -> Binding<String> {
    Binding(
      get: { draft.fields[key] ?? "" },
      set: { draft.fields[key] = $0 }
    )
  }

  private var providerTypeBinding: Binding<ProviderType> {
    Binding(
      get: { draft.providerType },
      set: {
        draft.type = $0.wireValue
        draft.fields = [:]
      }
    )
  }
}

// MARK: - Editor sub-views

struct ProviderEditorHeader: View {
  let draft: ProviderConfigEntry

  var body: some View {
    HStack(spacing: 10) {
      ProviderTypeIcon(providerType: draft.providerType)
        .frame(width: 36, height: 36)

      VStack(alignment: .leading, spacing: 3) {
        Text(draft.displayName)
          .font(.system(size: 14, weight: .semibold))
          .foregroundStyle(.primary)

        Text(draft.providerType.hostingDescription)
          .font(.system(size: 13))
          .foregroundStyle(.secondary)
      }

      Spacer()
    }
    .padding(.vertical, 4)
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
    guard !trimmedID.isEmpty else { return providerType.displayName }
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
    case .system: return [.ocr]
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
