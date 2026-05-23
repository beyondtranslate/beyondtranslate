import SwiftUI
import beyondtranslate_runtime

struct ProvidersView: View {
  @ObservedObject var viewModel: ProvidersViewModel
  @State private var showEditorSheet = false
  @State private var editingProvider: ProviderConfigEntry?

  private var isCreating: Bool { editingProvider == nil }

  var body: some View {
    NavigationStack {
      SettingsPage(title: LocaleKeys.settings.providers.title.tr()) {
        Section {
          ProviderIntroRow()
        }

        Section {
          if viewModel.providers.isEmpty {
            EmptyProviderRow()
          } else {
            ForEach(viewModel.providers) { provider in
              ProviderRow(
                provider: provider,
                onEdit: {
                  editingProvider = provider
                  showEditorSheet = true
                },
                onDelete: { viewModel.deleteProvider(provider.id) }
              )
            }
          }
        } footer: {
          HStack {
            Spacer()
            Button(LocaleKeys.settings.providers.button.add.tr()) {
              editingProvider = nil
              showEditorSheet = true
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
      editingProvider = nil
      showEditorSheet = true
    }
    .sheet(isPresented: $showEditorSheet) {
      ProviderEditorSheet(
        draft: editingProvider,
        isCreating: isCreating,
        onGenerateProviderId: { providerType in
          await viewModel.generateProviderId(for: providerType)
        },
        onSave: { updatedDraft in
          showEditorSheet = false
          viewModel.saveProvider(updatedDraft)
        },
        onDelete: { providerID in
          showEditorSheet = false
          viewModel.deleteProvider(providerID)
        },
        onCancel: {
          showEditorSheet = false
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
      Button(LocaleKeys.common.ui.button.ok.tr()) { viewModel.errorMessage = nil }
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
        ProviderTypeIcon(providerType: provider.type)

        VStack(alignment: .leading, spacing: 3) {
          Text(provider.type.displayName)
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
      Button(LocaleKeys.common.ui.button.edit.tr(), action: onEdit)

      Divider()

      Button(LocaleKeys.common.ui.button.delete.tr(), role: .destructive) {
        showDeleteConfirm = true
      }
    }
    .confirmationDialog(
      LocaleKeys.settings.providers.deleteDialog.title.tr(provider.name),
      isPresented: $showDeleteConfirm,
      titleVisibility: .visible
    ) {
      Button(
        LocaleKeys.common.ui.button.delete.tr(), role: .destructive, action: onDelete)
      Button(LocaleKeys.common.ui.button.cancel.tr(), role: .cancel) {}
    } message: {
      Text(LocaleKeys.settings.providers.deleteDialog.message.tr())
    }
  }
}

// MARK: - Empty state

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
        .frame(width: 22, height: 22)
        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
    } else {
      ZStack {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
          .fill(Color.accentColor.opacity(0.15))
        Image(systemName: "server.rack")
          .font(.system(size: 12, weight: .medium))
          .foregroundStyle(Color.accentColor)
      }
      .frame(width: 22, height: 22)
    }
  }
}
