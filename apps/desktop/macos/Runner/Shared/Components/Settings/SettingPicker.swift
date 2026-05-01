import SwiftUI

struct SettingPicker<Value: Hashable, Content: View>: View {
  let title: String
  @Binding var selection: Value
  let content: Content

  init(
    _ title: String,
    selection: Binding<Value>,
    @ViewBuilder content: () -> Content
  ) {
    self.title = title
    _selection = selection
    self.content = content()
  }

  var body: some View {
    Picker(title, selection: $selection) {
      content
    }
  }
}
