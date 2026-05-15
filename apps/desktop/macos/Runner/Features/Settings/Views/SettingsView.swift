import SwiftUI

enum SettingsSection: String, CaseIterable, Identifiable {
  case general
  case appearance
  case shortcuts
  case providers
  case advanced

  var id: String { rawValue }

  var title: String {
    switch self {
    case .general: return LocaleKeys.settings.general.title.tr()
    case .appearance: return LocaleKeys.settings.appearance.title.tr()
    case .shortcuts: return LocaleKeys.settings.shortcuts.title.tr()
    case .providers: return LocaleKeys.settings.providers.title.tr()
    case .advanced: return LocaleKeys.settings.advanced.title.tr()
    }
  }

  var icon: String {
    switch self {
    case .general: return "gearshape"
    case .appearance: return "paintbrush"
    case .shortcuts: return "keyboard"
    case .providers: return "server.rack"
    case .advanced: return "slider.horizontal.3"
    }
  }
}

struct SettingsView: View {
  @State private var selectedSection: SettingsSection? = .general
  @StateObject private var viewModel: SettingsViewModel
  @ObservedObject private var highlightCoordinator = SettingsHighlightCoordinator.shared
  @ObservedObject private var localization = AppLocale.shared

  init() {
    _viewModel = StateObject(wrappedValue: SettingsViewModel())
  }

  var body: some View {
    NavigationSplitView {
      List(SettingsSection.allCases, selection: $selectedSection) { section in
        Label(section.title, systemImage: section.icon)
          .tag(section)
      }
      .navigationTitle(LocaleKeys.settings.layout.title.tr())
      .navigationSplitViewColumnWidth(min: 180, ideal: 210)
    } detail: {
      if let selectedSection {
        SettingsSectionDetailView(
          section: selectedSection,
          viewModel: viewModel,
          selectedSection: $selectedSection
        )
      } else {
        SettingsEmptyStateView()
      }
    }
    .frame(minWidth: 720, minHeight: 480)
    .environment(\.locale, Locale(identifier: localization.languageCode))
    .onReceive(highlightCoordinator.$pendingHighlightPermissionsSectionID) { id in
      guard id != nil else { return }
      selectedSection = .general
    }
  }
}

private struct SettingsSectionDetailView: View {
  let section: SettingsSection
  @ObservedObject var viewModel: SettingsViewModel
  @Binding var selectedSection: SettingsSection?

  var body: some View {
    switch section {
    case .general:
      GeneralView(
        viewModel: viewModel.general,
        onAddProvider: {
          selectedSection = .providers
          viewModel.providers.requestPresentProviderEditorSheet()
        }
      )
    case .appearance:
      AppearanceView(viewModel: viewModel.appearance)
    case .shortcuts:
      ShortcutsView(viewModel: viewModel.shortcuts)
    case .providers:
      ProvidersView(viewModel: viewModel.providers)
    case .advanced:
      AdvancedView(viewModel: viewModel.advanced)
    }
  }
}

private struct SettingsEmptyStateView: View {
  var body: some View {
    VStack(spacing: 12) {
      Image(systemName: "sidebar.left")
        .font(.system(size: 28))
        .foregroundStyle(.secondary)
      Text(LocaleKeys.settings.layout.empty.title.tr())
        .font(.headline)
      Text(LocaleKeys.settings.layout.empty.message.tr())
        .foregroundStyle(.secondary)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

#if DEBUG
  struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        SettingsView()
          .previewDisplayName("Settings - Light")

        SettingsView()
          .preferredColorScheme(.dark)
          .previewDisplayName("Settings - Dark")
      }
      .frame(width: 980, height: 720)
    }
  }
#endif
