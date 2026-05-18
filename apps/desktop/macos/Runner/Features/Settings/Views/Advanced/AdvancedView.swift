import SwiftUI

struct AdvancedView: View {
  @ObservedObject var viewModel: AdvancedViewModel

  var body: some View {
    SettingsPage(title: LocaleKeys.settings.advanced.title.tr()) {
      Section {
        SettingToggle(
          LocaleKeys.settings.advanced.enable.tr(),
          isOn: Binding(
            get: { viewModel.apiServerEnabled },
            set: { viewModel.setApiServerEnabled($0) }
          )
        )

        if viewModel.apiServerEnabled {
          HStack {
            Text(LocaleKeys.settings.advanced.port.tr())
            Spacer()
            TextField(
              "",
              text: Binding(
                get: { String(viewModel.apiServerPort) },
                set: { viewModel.setApiServerPort($0) }
              )
            )
            .textFieldStyle(.roundedBorder)
            .multilineTextAlignment(.trailing)
            .frame(width: 72)
          }
        }
      } header: {
        Text(LocaleKeys.settings.advanced.apiServer.tr())
      } footer: {
        footer
      }
    }
  }

  @ViewBuilder
  private var footer: some View {
    if viewModel.apiServerEnabled, let apiServerURL {
      HStack(spacing: 0) {
        Text(runningAtPrefix)
        Link(apiServerURL.absoluteString, destination: apiServerURL)
      }
    } else {
      Text(LocaleKeys.settings.advanced.disabled.tr())
    }
  }

  private var apiServerURL: URL? {
    URL(string: "http://\(viewModel.apiServerHost):\(viewModel.apiServerPort)")
  }

  private var runningAtPrefix: String {
    let template = LocaleKeys.settings.advanced.runningAt.tr()
    return template.components(separatedBy: "{url}").first ?? ""
  }
}
