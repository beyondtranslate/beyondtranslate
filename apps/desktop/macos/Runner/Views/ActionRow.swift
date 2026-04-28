import SwiftUI

struct ActionRow: View {
  let title: String
  let detail: String

  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        Text(title)
        Text(detail)
          .font(.system(size: 12))
          .foregroundStyle(.secondary)
      }

      Spacer()

      Button("Manage") {}
    }
  }
}
