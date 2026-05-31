import SwiftUI

/// Placeholder sheet for adding a new service.
/// Will be implemented with actual service configuration UI later.
struct ServiceEditorSheet: View {
  let onCancel: () -> Void

  var body: some View {
    VStack(spacing: 16) {
      Image(systemName: "sparkles")
        .font(.system(size: 36))
        .foregroundStyle(.secondary)
        .padding(.top, 24)

      Text(LocaleKeys.settings.services.editor.comingSoon.tr())
        .font(.headline)

      Text(LocaleKeys.settings.services.editor.comingSoonDescription.tr())
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
        .fixedSize(horizontal: false, vertical: true)
        .padding(.horizontal, 32)

      Spacer()

      HStack {
        Spacer()
        Button(LocaleKeys.common.ui.button.ok.tr()) {
          onCancel()
        }
        .keyboardShortcut(.defaultAction)
      }
      .padding(.horizontal, 20)
      .padding(.bottom, 16)
    }
    .frame(width: 360, height: 220)
  }
}
