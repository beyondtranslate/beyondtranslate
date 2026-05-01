import SwiftUI

final class AdvancedViewModel: ObservableObject {
  @Published var launchAtStartup: Bool

  init(settings: AdvancedSettings = AdvancedSettings()) {
    launchAtStartup = settings.launchAtStartup
  }
}
