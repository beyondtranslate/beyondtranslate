import SwiftUI

struct ProviderDetailView: View {
  let provider: ProviderItem
  @ObservedObject var viewModel: ProvidersViewModel

  @Environment(\.dismiss) private var dismiss

  @State private var draft: ProviderDraft?
  @State private var pendingDismiss = false

  private var currentProvider: ProviderItem {
    viewModel.providers.first(where: { $0.id == provider.id }) ?? provider
  }

  var body: some View {
    SettingsPage(title: currentProvider.name) {
      // ── Header ──────────────────────────────────────────────────
      Section {
        HStack(spacing: 14) {
          ProviderTypeIcon(providerType: currentProvider.providerType)
            .frame(width: 40, height: 40)

          Text(currentProvider.name)
            .font(.system(size: 15, weight: .semibold))

          Spacer()

          Toggle(
            "",
            isOn: Binding(
              get: { currentProvider.isEnabled },
              set: { viewModel.toggleProvider(currentProvider.id, isEnabled: $0) }
            )
          )
          .toggleStyle(.switch)
          .labelsHidden()

          Button {
            draft = .edit(item: currentProvider)
          } label: {
            Image(systemName: "info.circle")
              .font(.system(size: 18))
              .foregroundStyle(.secondary)
          }
          .buttonStyle(.plain)
          .help("Edit provider")
        }
        .padding(.vertical, 4)
      }

      // ── Services ────────────────────────────────────────────────
      Section("Services") {
        if currentProvider.capabilities.isEmpty {
          Text("No services available.")
            .foregroundStyle(.secondary)
        } else {
          ForEach(currentProvider.capabilities, id: \.self) { capability in
            ProviderServiceRow(capability: capability)
          }
        }
      }
    }
    .sheet(
      item: $draft,
      onDismiss: {
        if pendingDismiss {
          pendingDismiss = false
          dismiss()
        }
      }
    ) { item in
      ProviderEditorSheet(
        draft: item,
        onSave: { updatedDraft in
          viewModel.saveProvider(updatedDraft)
          draft = nil
        },
        onDelete: { providerID in
          viewModel.deleteProvider(providerID)
          pendingDismiss = true
          draft = nil
        },
        onCancel: {
          draft = nil
        }
      )
    }
  }
}

// MARK: - Service Row

private struct ProviderServiceRow: View {
  let capability: ProviderCapability

  var body: some View {
    HStack(spacing: 14) {
      // Capability icon — mirrors ProviderTypeIcon style
      ZStack {
        RoundedRectangle(cornerRadius: 6, style: .continuous)
          .fill(capability.color.opacity(0.15))
        Image(systemName: capability.systemImage)
          .font(.system(size: 12, weight: .medium))
          .foregroundStyle(capability.color)
      }
      .frame(width: 28, height: 28)

      VStack(alignment: .leading, spacing: 3) {
        Text(capability.displayName)
          .font(.system(size: 13))
          .foregroundStyle(.primary)
        Text(capability.rawValue)
          .font(.system(size: 11))
          .foregroundStyle(.secondary)
      }

      Spacer()
    }
    .padding(.vertical, 2)
  }
}

// MARK: - ProviderCapability display helpers

extension ProviderCapability {
  var displayName: String {
    switch self {
    case .translation: return "Translation"
    case .dictionary: return "Dictionary"
    }
  }

  var systemImage: String {
    switch self {
    case .translation: return "character.bubble"
    case .dictionary: return "text.book.closed"
    }
  }

  var color: Color {
    switch self {
    case .translation: return .blue
    case .dictionary: return .orange
    }
  }
}
