import AppKit
import SwiftUI
import beyondtranslate_runtime

// MARK: - Navigation Destinations

private enum ProvidersNavigation: Hashable {
  case detail(String)
  case create(ProviderConfigEntry)
}

struct ProvidersView: View {
  @ObservedObject var viewModel: ProvidersViewModel
  @State private var showTypePicker = false
  @State private var navPath: [ProvidersNavigation] = []

  var body: some View {
    NavigationStack(path: $navPath) {
      SettingsPage(title: LocaleKeys.settings.providers.title.tr()) {
        Section {
          ProviderIntroRow()
        }

        Section {
          if viewModel.providers.filter({ $0.id != "system" }).isEmpty {
            EmptyProviderRow()
          } else {
            ForEach(viewModel.providers.filter { $0.id != "system" }) { provider in
              ProviderRow(
                provider: provider,
                onDelete: { viewModel.deleteProvider(provider.id) }
              )
            }
          }
        }

        Section {
          ProviderServicesList(
            providers: viewModel.providers,
            services: viewModel.services
          )
        } header: {
          ProviderServicesHeader()
        }
      }
      .navigationDestination(for: ProvidersNavigation.self) { dest in
        switch dest {
        case .detail(let providerID):
          if let provider = viewModel.providers.first(where: { $0.id == providerID }) {
            ProviderDetailView(provider: provider, viewModel: viewModel)
          }
        case .create(let entry):
          ProviderDetailView(
            provider: entry,
            viewModel: viewModel,
            isCreating: true
          )
        }
      }
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          Button {
            showTypePicker = true
          } label: {
            Image(systemName: "plus")
          }
          .help(LocaleKeys.settings.providers.button.add.tr())
        }
      }
    }
    .onReceive(viewModel.$pendingPresentProviderEditorSheetID) { id in
      guard let id, viewModel.consumePresentProviderEditorSheet(id) else { return }
      showTypePicker = true
    }
    .sheet(isPresented: $showTypePicker) {
      ProviderTypePicker(
        onNext: { selectedType in
          Task {
            let id = await viewModel.generateProviderId(for: selectedType)
            let entry = ProviderConfigEntry(
              id: id, type: selectedType, fields: [:], createdAt: nil
            )
            showTypePicker = false
            navPath.append(ProvidersNavigation.create(entry))
          }
        },
        onCancel: { showTypePicker = false }
      )
      .frame(width: 420)
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
      .font(.system(size: 12))
      .foregroundStyle(.secondary)
      .fixedSize(horizontal: false, vertical: true)
    }
  }
}

// MARK: - Provider Row  (NavigationLink → ProviderDetailView)

private struct ProviderRow: View {
  let provider: ProviderConfigEntry
  let onDelete: () -> Void

  @State private var showDeleteConfirm = false

  var body: some View {
    NavigationLink(value: ProvidersNavigation.detail(provider.id)) {
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
      }
      .contentShape(Rectangle())
    }
    .contextMenu {
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

// MARK: - Services

private struct ProviderServicesHeader: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(LocaleKeys.settings.providers.section.services.tr())

      Text(LocaleKeys.settings.providers.section.servicesDescription.tr())
        .font(.footnote)
        .textCase(nil)
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)
    }
  }
}

private struct ProviderServicesList: View {
  let providers: [ProviderConfigEntry]
  let services: [ServiceConfigEntry]

  var body: some View {
    if services.isEmpty {
      EmptyServicesRow()
    } else {
      ForEach(services) { service in
        ServiceRowView(
          service: service,
          provider: providers.first { $0.id == service.providerId }
        )
      }
    }
  }
}

private struct EmptyServicesRow: View {
  private static let iconSize: CGFloat = 20

  var body: some View {
    HStack(spacing: 14) {
      Image(systemName: "bolt.horizontal.circle")
        .font(.system(size: 16))
        .foregroundStyle(.tertiary)
        .frame(width: Self.iconSize, height: Self.iconSize)
      Text(LocaleKeys.settings.providers.item.noServices.tr())
        .font(.system(size: 13))
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)
      Spacer()
    }
  }
}

// MARK: - Empty state

private struct EmptyProviderRow: View {
  private static let iconSize: CGFloat = 20

  var body: some View {
    HStack(spacing: 14) {
      Image(systemName: "square.stack.3d.up.slash")
        .font(.system(size: 16))
        .foregroundStyle(.tertiary)
        .frame(width: Self.iconSize, height: Self.iconSize)
      Text(LocaleKeys.settings.providers.item.empty.tr())
        .font(.system(size: 13))
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)
      Spacer()
    }
  }
}

// MARK: - Provider Type Icon

struct ProviderTypeIcon: View {
  let providerType: ProviderType

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 5, style: .continuous)
        .fill(Color.accentColor.opacity(0.15))
      Image(systemName: "server.rack")
        .font(.system(size: 11, weight: .medium))
        .foregroundStyle(Color.accentColor)
    }
    .frame(width: 20, height: 20)
  }
}
