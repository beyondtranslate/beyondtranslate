import SwiftUI

struct AdvancedView: View {
  @ObservedObject var viewModel: AdvancedViewModel

  var body: some View {
    SettingsPage(title: "Advanced") {
      Section("Advanced") {
        SettingToggle(
          "Launch at startup",
          isOn: Binding(
            get: { viewModel.launchAtLogin },
            set: { viewModel.setlaunchAtLogin($0) }
          ))
      }
    }
  }
}
