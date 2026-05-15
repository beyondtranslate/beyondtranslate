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
        HStack(spacing: 14) {
          ProviderTypeIcon(providerType: currentProvider.type)
            .frame(width: 40, height: 40)

          Text(currentProvider.name)
            .font(.system(size: 15, weight: .semibold))

          Spacer()

          Toggle(
            "",
            isOn: Binding(
              get: { viewModel.isProviderEnabled(currentProvider.id) },
              set: { viewModel.toggleProvider(currentProvider.id, isEnabled: $0) }
            )
          )
          .toggleStyle(.switch)
          .labelsHidden()

          Button {
            draft = currentProvider
          } label: {
            Image(systemName: "info.circle")
              .font(.system(size: 18))
              .foregroundStyle(.secondary)
          }
          .buttonStyle(.plain)
          .help(LocaleKeys.settings.providers.detail.tooltip.edit.tr())
        }
        .padding(.vertical, 4)
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
        Text(capability.displayName)
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
