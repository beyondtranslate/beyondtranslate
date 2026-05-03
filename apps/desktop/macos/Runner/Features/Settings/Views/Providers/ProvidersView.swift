import SwiftUI

struct ProvidersView: View {
  @ObservedObject var viewModel: ProvidersViewModel
  @State private var draft: ProviderDraft?

  var body: some View {
    NavigationStack {
      SettingsPage(title: "Providers") {
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
                onEdit: { draft = .edit(item: provider) },
                onDelete: { viewModel.deleteProvider(provider.id) }
              )
            }
          }
        } footer: {
          HStack {
            Spacer()
            Button("Add a Provider...") {
              draft = .new()
            }
          }
        }
      }
      .navigationDestination(for: UUID.self) { providerID in
        if let provider = viewModel.providers.first(where: { $0.id == providerID }) {
          ProviderDetailView(provider: provider, viewModel: viewModel)
        }
      }
    }
    .sheet(item: $draft) { item in
      ProviderEditorSheet(draft: item) { updatedDraft in
        viewModel.saveProvider(updatedDraft)
        draft = nil
      } onDelete: { providerID in
        viewModel.deleteProvider(providerID)
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
}

// MARK: - Intro Row

private struct ProviderIntroRow: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text("Choose the translation and dictionary providers used by the app.")
        .fixedSize(horizontal: false, vertical: true)

      Text(
        "Providers you add may process the text you send, so only connect services you trust."
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
  let provider: ProviderItem
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
          ForEach(provider.capabilities, id: \.self) { cap in
            ProviderCapabilityTag(capability: cap)
          }
        }
      }
      .contentShape(Rectangle())
      .padding(.vertical, 2)
    }
    .contextMenu {
      Button("Edit", action: onEdit)

      Divider()

      Button("Delete", role: .destructive) {
        showDeleteConfirm = true
      }
    }
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
}

// MARK: - Loading / Empty states

private struct LoadingProviderRow: View {
  var body: some View {
    HStack(spacing: 14) {
      ProgressView()
      Text("Loading providers...")
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
      Text("No providers configured. Add one to enable translation services.")
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
    let iconFileName = "\(providerType.rawValue).png"
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
  @Environment(\.dismiss) private var dismiss
  @State var draft: ProviderDraft

  let onSave: (ProviderDraft) -> Void
  let onDelete: (UUID) -> Void
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
    VStack(spacing: 0) {
      Form {
        // Header — provider icon, name, hosting type
        Section {
          ProviderEditorHeader(draft: draft)
        }

        // Show Provider ID and Type picker only when creating a new provider
        if draft.localID == nil {
          Section {
            TextField(text: $draft.backendID, prompt: Text("e.g. deepl-main")) {
              Text("Provider ID")
            }

            Picker("Provider Type", selection: $draft.providerType) {
              ForEach(ProviderType.allCases) { type in
                Text(type.displayName).tag(type)
              }
            }
            .onChange(of: draft.providerType) { _ in
              draft.fields = [:]
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
        .help("Help")

        // Destructive delete — bordered pill with red tint
        if let localID = draft.localID {
          Button(role: .destructive) {
            onDelete(localID)
            dismiss()
          } label: {
            Text("Delete Provider")
          }
          .buttonStyle(.bordered)
          .tint(.red)
        }

        Spacer()

        Button("Cancel") {
          onCancel()
          dismiss()
        }
        .keyboardShortcut(.cancelAction)

        Button(draft.localID == nil ? "Add" : "Save") {
          onSave(draft)
          dismiss()
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
}

// MARK: - Editor sub-views

struct ProviderEditorHeader: View {
  let draft: ProviderDraft

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

// MARK: - ProviderDraft helpers

extension ProviderDraft {
  fileprivate var displayName: String {
    let trimmedID = backendID.trimmingCharacters(in: .whitespacesAndNewlines)
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
    case .youdao: return [.dictionary, .translation]
    }
  }

  var displayName: String {
    switch self {
    case .baidu: return "Baidu"
    case .caiyun: return "Caiyun"
    case .deepL: return "DeepL"
    case .google: return "Google"
    case .iciba: return "iCiba"
    case .tencent: return "Tencent"
    case .youdao: return "Youdao"
    }
  }

  fileprivate var hostingDescription: String {
    let caps = defaultCapabilities
    let hasTranslation = caps.contains(.translation)
    let hasDictionary = caps.contains(.dictionary)
    switch (hasTranslation, hasDictionary) {
    case (true, true): return "Provides dictionary lookup and text translation"
    case (true, false): return "Provides text translation between languages"
    case (false, true): return "Provides dictionary lookup and word definitions"
    default: return "Provides translation services"
    }
  }
}
