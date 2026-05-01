import SwiftUI

struct AdvancedView: View {
  @ObservedObject var viewModel: AdvancedViewModel

  var body: some View {
    SettingsPage(title: "Advanced") {
      Section("Advanced") {
        SettingToggle("Launch at startup", isOn: $viewModel.launchAtStartup)
      }
    }
  }
}
