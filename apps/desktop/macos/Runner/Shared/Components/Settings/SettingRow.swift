import SwiftUI

struct SettingRow: View {
  let title: String
  let detail: String
  var actionTitle = "Manage"
  var action: () -> Void = {}

  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        Text(title)
        Text(detail)
          .font(.system(size: 12))
          .foregroundStyle(.secondary)
      }

      Spacer()

      Button(actionTitle, action: action)
    }
  }
}

struct ShortcutSettingRow: View {
  let title: String
  let shortcut: ShortcutDisplay
  var action: () -> Void = {}

  var body: some View {
    HStack {
      Text(title)
      Spacer()

      HStack(spacing: 4) {
        Button(action: action) {
          Text(shortcut.displayText)
            .font(.system(size: 14, design: .monospaced))
            .foregroundStyle(.primary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .frame(minWidth: 80)
            .background(
              RoundedRectangle(cornerRadius: 4)
                .fill(Color(nsColor: .controlBackgroundColor))
            )
            .overlay(
              RoundedRectangle(cornerRadius: 4)
                .stroke(Color(nsColor: .separatorColor), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)

        Button(action: {
          // 这里只是 UI 展示，暂不清除数据
        }) {
          Image(systemName: "xmark.circle.fill")
            .font(.system(size: 16))
            .foregroundStyle(.secondary)
        }
        .buttonStyle(.plain)
      }
    }
  }
}
