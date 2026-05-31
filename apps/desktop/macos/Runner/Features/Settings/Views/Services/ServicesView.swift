import SwiftUI
import beyondtranslate_runtime

// MARK: - Navigation Destinations

private enum ServicesNavigation: Hashable {
  case providerDetail(String)
  case createProvider(ProviderConfigEntry)
}

struct ServicesView: View {
  @ObservedObject var viewModel: ServicesViewModel

  @State private var showServiceEditorSheet = false
  @State private var showTypePicker = false
  @State private var navPath: [ServicesNavigation] = []

  var body: some View {
    NavigationStack(path: $navPath) {
      SettingsPage(title: LocaleKeys.settings.services.title.tr()) {
        // ── Translation Services ──────────────────────────────────
        Section {
          if viewModel.translationServices.isEmpty {
            EmptyServicesRow()
          } else {
            ForEach(viewModel.translationServices) { service in
              ServiceRowView(
                service: service,
                provider: viewModel.providers.first { $0.id == service.providerId }
              )
            }
          }

          HStack {
            Spacer()
            Button(LocaleKeys.settings.services.button.addService.tr()) {
              showServiceEditorSheet = true
            }
          }
        } header: {
          TranslationSectionHeader()
        }

        // ── OCR Services ──────────────────────────────────────────
        Section {
          if viewModel.ocrServices.isEmpty {
            EmptyServicesRow()
          } else {
            ForEach(viewModel.ocrServices) { service in
              ServiceRowView(
                service: service,
                provider: viewModel.providers.first { $0.id == service.providerId }
              )
            }
          }

          HStack {
            Spacer()
            Button(LocaleKeys.settings.services.button.addService.tr()) {
              showServiceEditorSheet = true
            }
          }
        } header: {
          OcrSectionHeader()
        }

        // ── Provider List ─────────────────────────────────────────
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

          HStack {
            Spacer()
            Button(LocaleKeys.settings.providers.button.add.tr()) {
              showTypePicker = true
            }
          }
        } header: {
          ProviderListHeader()
        }
      }
      .navigationDestination(for: ServicesNavigation.self) { dest in
        switch dest {
        case .providerDetail(let providerID):
          if let provider = viewModel.providers.first(where: { $0.id == providerID }),
            let providersVM = viewModel.providersVM
          {
            ProviderDetailView(provider: provider, viewModel: providersVM)
          }
        case .createProvider(let entry):
          if let providersVM = viewModel.providersVM {
            ProviderDetailView(
              provider: entry,
              viewModel: providersVM,
              isCreating: true
            )
          }
        }
      }
    }
    .onReceive(viewModel.$pendingPresentProviderEditorSheetID) { id in
      guard let id, viewModel.consumePresentProviderEditorSheet(id) else { return }
      showTypePicker = true
    }
    .sheet(isPresented: $showServiceEditorSheet) {
      ServiceEditorSheet(
        onCancel: {
          showServiceEditorSheet = false
        }
      )
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
            navPath.append(ServicesNavigation.createProvider(entry))
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

// MARK: - Section Headers

private struct TranslationSectionHeader: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(LocaleKeys.settings.providers.capability.translation.tr())

      Text(LocaleKeys.settings.providers.section.servicesDescription.tr())
        .font(.footnote)
        .textCase(nil)
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)
    }
  }
}

private struct OcrSectionHeader: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(LocaleKeys.settings.providers.capability.ocr.tr())

      Text(LocaleKeys.settings.providers.section.servicesDescription.tr())
        .font(.footnote)
        .textCase(nil)
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)
    }
  }
}

private struct ProviderListHeader: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(LocaleKeys.settings.providers.title.tr())

      Text(LocaleKeys.settings.providers.intro.body.tr())
        .font(.footnote)
        .textCase(nil)
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)
    }
  }
}

// MARK: - Provider Row (NavigationLink → ProviderDetailView)

private struct ProviderRow: View {
  let provider: ProviderConfigEntry
  let onDelete: () -> Void

  @State private var showDeleteConfirm = false

  var body: some View {
    NavigationLink(value: ServicesNavigation.providerDetail(provider.id)) {
      HStack(spacing: 14) {
        ProviderTypeIcon(providerType: provider.type)

        Text(provider.type.displayName)
          .font(.system(size: 13))
          .foregroundStyle(.primary)

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

// MARK: - Empty states

private struct EmptyServicesRow: View {
  var body: some View {
    HStack(spacing: 14) {
      Image(systemName: "bolt.horizontal.circle")
        .font(.system(size: 16))
        .foregroundStyle(.tertiary)
        .frame(width: 20, height: 20)
      Text(LocaleKeys.settings.providers.item.noServices.tr())
        .font(.system(size: 13))
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)
      Spacer()
    }
  }
}

private struct EmptyProviderRow: View {
  var body: some View {
    HStack(spacing: 14) {
      Image(systemName: "square.stack.3d.up.slash")
        .font(.system(size: 16))
        .foregroundStyle(.tertiary)
        .frame(width: 20, height: 20)
      Text(LocaleKeys.settings.providers.item.empty.tr())
        .font(.system(size: 13))
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)
      Spacer()
    }
  }
}
