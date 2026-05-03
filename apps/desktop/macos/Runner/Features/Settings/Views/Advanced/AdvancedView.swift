import SwiftUI

struct AdvancedView: View {
  @ObservedObject var viewModel: AdvancedViewModel

  var body: some View {
    SettingsPage(title: "Advanced") {
      Section("Advanced") {
        Text("No advanced settings available.")
          .foregroundStyle(.secondary)
      }
    }
  }
}
