import SwiftUI

struct SettingToggle: View {
  let title: String
  @Binding var isOn: Bool

  init(_ title: String, isOn: Binding<Bool>) {
    self.title = title
    _isOn = isOn
  }

  var body: some View {
    Toggle(title, isOn: $isOn)
  }
}
