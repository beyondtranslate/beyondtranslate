import SwiftUI

struct SettingSectionHeader: View {
  let title: String
  let buttonTitle: String
  let onAdd: () -> Void

  var body: some View {
    HStack {
      Text(title)
      Spacer()
      Button(buttonTitle, action: onAdd)
    }
  }
}

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
