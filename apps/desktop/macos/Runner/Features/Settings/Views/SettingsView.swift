import SwiftUI

struct SettingsView: View {
  @State private var selectedSection: SettingsSection? = .general
  @StateObject private var viewModel: SettingsViewModel

  init(settingsService: SettingsService? = nil) {
    _viewModel = StateObject(wrappedValue: SettingsViewModel(settingsService: settingsService))
  }

  var body: some View {
    NavigationSplitView {
      List(SettingsSection.allCases, selection: $selectedSection) { section in
        Label(section.title, systemImage: section.icon)
          .tag(section)
      }
      .navigationTitle("Settings")
      .navigationSplitViewColumnWidth(min: 180, ideal: 210)
    } detail: {
      if let selectedSection {
        SettingsSectionDetailView(section: selectedSection, viewModel: viewModel)
      } else {
        SettingsEmptyStateView()
      }
    }
    .frame(minWidth: 720, minHeight: 480)
  }
}

private struct SettingsSectionDetailView: View {
  let section: SettingsSection
  @ObservedObject var viewModel: SettingsViewModel

  var body: some View {
    switch section {
    case .general:
      GeneralView(viewModel: viewModel.general)
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
      Text("Select a Category")
        .font(.headline)
      Text("Choose a settings section from the sidebar.")
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
