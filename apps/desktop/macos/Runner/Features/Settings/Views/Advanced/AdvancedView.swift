import SwiftUI

struct AdvancedView: View {
  @ObservedObject var viewModel: AdvancedViewModel

  var body: some View {
    SettingsPage(title: LocaleKeys.settings.advanced.title.tr()) {
      Section {
        Text(LocaleKeys.settings.advanced.empty.tr())
          .foregroundStyle(.secondary)
      }
    }
  }
}
