import SwiftUI

struct AdvancedView: View {
  @ObservedObject var viewModel: AdvancedViewModel

  var body: some View {
    SettingsPage(title: "Advanced") {
      Section("Advanced") {
        SettingToggle("Launch at startup", isOn: Binding(
          get: { viewModel.launchAtStartup },
          set: { viewModel.setLaunchAtStartup($0) }
        ))
      }

      Section("Proxy") {
        TextField("http://127.0.0.1:7890", text: Binding(
          get: { viewModel.proxy },
          set: { viewModel.setProxy($0) }
        ))
      }
    }
  }
}
