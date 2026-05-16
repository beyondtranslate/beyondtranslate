import SwiftUI
import beyondtranslate_runtime

struct ProviderDetailView: View {
  let provider: ProviderConfigEntry
  @ObservedObject var viewModel: ProvidersViewModel

  @Environment(\.dismiss) private var dismiss

  @State private var draft: ProviderConfigEntry?

  private var currentProvider: ProviderConfigEntry {
    viewModel.providers.first(where: { $0.id == provider.id }) ?? provider
  }

  var body: some View {
    SettingsPage(title: currentProvider.name) {
      // ── Header ──────────────────────────────────────────────────
      Section {
        HStack(spacing: 10) {
          ProviderTypeIcon(providerType: currentProvider.type)
            .frame(width: 28, height: 28)

          Text(currentProvider.name)
            .font(.system(size: 13, weight: .semibold))

          Spacer()

          Button {
            draft = currentProvider
          } label: {
            Image(systemName: "info.circle")
              .font(.system(size: 14))
              .foregroundStyle(.secondary)
          }
          .buttonStyle(.plain)
          .help(LocaleKeys.settings.providers.detail.tooltip.edit.tr())
        }
        .padding(.vertical, 2)
      }

      // ── Services ────────────────────────────────────────────────
      Section(LocaleKeys.settings.providers.section.services.tr()) {
        if currentProvider.capabilities.isEmpty {
          Text(LocaleKeys.settings.providers.item.noServices.tr())
            .foregroundStyle(.secondary)
        } else {
          ForEach(currentProvider.capabilities, id: \.self) { capability in
            ProviderServiceRow(capability: capability)
          }
        }
      }
    }
    .sheet(item: $draft) { item in
      ProviderEditorSheet(
        draft: item,
        isCreating: false,
        onSave: { updatedDraft in
          draft = nil
          viewModel.saveProvider(updatedDraft)
        },
        onDelete: { providerID in
          draft = nil
          viewModel.deleteProvider(providerID)
          dismiss()
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
    HStack(spacing: 10) {
      // Capability icon — mirrors ProviderTypeIcon style
      ZStack {
        RoundedRectangle(cornerRadius: 5, style: .continuous)
          .fill(capability.color.opacity(0.15))
        Image(systemName: capability.systemImage)
          .font(.system(size: 11, weight: .medium))
          .foregroundStyle(capability.color)
      }
      .frame(width: 22, height: 22)

      Text(capability.displayName)
        .font(.system(size: 12))

      Spacer()
    }
    .padding(.vertical, 1)
  }
}

// MARK: - ProviderCapability display helpers

extension ProviderCapability {
  var displayName: String {
    switch self {
    case .translation:
      return LocaleKeys.settings.providers.capability.translation.tr()
    case .dictionary: return LocaleKeys.settings.providers.capability.dictionary.tr()
    case .ocr: return LocaleKeys.settings.providers.capability.ocr.tr()
    }
  }

  var systemImage: String {
    switch self {
    case .translation: return "character.bubble"
    case .dictionary: return "text.book.closed"
    case .ocr: return "text.viewfinder"
    }
  }

  var color: Color {
    switch self {
    case .translation: return .blue
    case .dictionary: return .orange
    case .ocr: return .green
    }
  }
}
