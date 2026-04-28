import SwiftUI

struct SettingsPage<Content: View>: View {
  let title: String
  let content: Content

  init(title: String, @ViewBuilder content: () -> Content) {
    self.title = title
    self.content = content()
  }

  var body: some View {
    Form {
      content
    }
    .formStyle(.grouped)
    .navigationTitle(title)
  }
}
