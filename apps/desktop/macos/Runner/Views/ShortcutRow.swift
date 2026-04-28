import SwiftUI

struct ShortcutRow: View {
  let title: String
  let shortcut: ShortcutDisplay

  var body: some View {
    HStack {
      Text(title)
      Spacer()
      ShortcutCaps(shortcut: shortcut)
      Button("Record") {}
    }
  }
}

private struct ShortcutCaps: View {
  let shortcut: ShortcutDisplay

  var body: some View {
    HStack(spacing: 6) {
      ForEach(shortcut.parts.indices, id: \.self) { index in
        KeyCap(label: shortcut.parts[index])

        if index < shortcut.parts.count - 1 {
          Text("+")
            .foregroundStyle(.secondary)
        }
      }
    }
  }
}

private struct KeyCap: View {
  let label: String

  var body: some View {
    Text(label)
      .font(.system(size: 10, weight: .medium, design: .monospaced))
      .padding(.horizontal, 6)
      .padding(.vertical, 4)
      .background(
        RoundedRectangle(cornerRadius: 5, style: .continuous)
          .fill(Color(nsColor: .underPageBackgroundColor))
      )
      .overlay(
        RoundedRectangle(cornerRadius: 5, style: .continuous)
          .stroke(Color(nsColor: .separatorColor).opacity(0.55), lineWidth: 1)
      )
  }
}
