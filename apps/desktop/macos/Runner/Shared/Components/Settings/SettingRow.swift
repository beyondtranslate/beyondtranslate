import SwiftUI

struct SettingRow: View {
  let title: String
  let detail: String
  var actionTitle = LocaleKeys.common.button.manage.tr()
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
  let onShortcutRecorded: ((ShortcutDisplay) -> Void)?
  let onClear: (() -> Void)?

  var body: some View {
    HStack {
      Text(title)
      Spacer()

      ShortcutRecorderView(
        shortcut: shortcut,
        onShortcutRecorded: onShortcutRecorded,
        onClear: onClear
      )
      .frame(width: 132)
    }
  }
}
