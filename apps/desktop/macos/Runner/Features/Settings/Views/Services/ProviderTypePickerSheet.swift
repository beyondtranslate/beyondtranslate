import SwiftUI
import beyondtranslate_runtime

// MARK: - Provider Type Picker Sheet

struct ProviderTypePicker: View {
  @State private var localSelection: ProviderType.ID?

  let onNext: (ProviderType) -> Void
  let onCancel: () -> Void

  var body: some View {
    VStack(spacing: 0) {
      Text(LocaleKeys.settings.providers.editor.typePicker.prompt.tr())
        .foregroundStyle(.primary)
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 12)

      List(selection: $localSelection) {
        let llmProviders = ProviderType.llmProviders.filter { $0 != .system }
        let traditionalProviders = ProviderType.traditionalProviders

        ForEach(llmProviders, id: \.id) { type in
          ProviderTypeSelectionRow(type: type)
            .tag(type.id)
        }

        SectionHeader(
          title: LocaleKeys.settings.providers.editor.typePicker.sectionTraditional.tr())

        ForEach(traditionalProviders, id: \.id) { type in
          ProviderTypeSelectionRow(type: type)
            .tag(type.id)
        }
      }
      .listStyle(.inset(alternatesRowBackgrounds: true))
      .frame(height: 300)
      .clipShape(RoundedRectangle(cornerRadius: 6))
      .overlay(
        RoundedRectangle(cornerRadius: 6)
          .stroke(Color(nsColor: .separatorColor), lineWidth: 1)
      )
      .padding(.horizontal, 20)

      HStack(spacing: 8) {
        Spacer()

        Button(LocaleKeys.common.ui.button.cancel.tr()) {
          onCancel()
        }
        .keyboardShortcut(.cancelAction)

        Button(LocaleKeys.common.ui.button.continue.tr()) {
          guard let id = localSelection,
            let type =
              (ProviderType.llmProviders.filter { $0 != .system }
              + ProviderType.traditionalProviders).first(where: { $0.id == id })
          else { return }
          onNext(type)
        }
        .keyboardShortcut(.defaultAction)
        .disabled(localSelection == nil)
      }
      .padding(.horizontal, 20)
      .padding(.top, 12)
      .padding(.bottom, 16)
    }
  }
}

// MARK: - Sub-views

struct SectionHeader: View {
  let title: String

  var body: some View {
    Text(title)
      .font(.system(size: 11, weight: .medium))
      .foregroundStyle(.secondary)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.leading, 2)
      .padding(.top, 8)
      .padding(.bottom, 2)
  }
}

struct ProviderTypeSelectionRow: View {
  let type: ProviderType

  var body: some View {
    HStack(spacing: 8) {
      ProviderTypeIcon(providerType: type)

      Text(type.displayName)
        .font(.system(size: 13))
        .lineLimit(1)

      Spacer()
    }
    .padding(.vertical, 2)
  }
}
