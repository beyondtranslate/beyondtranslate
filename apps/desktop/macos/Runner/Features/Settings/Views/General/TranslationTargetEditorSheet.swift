import SwiftUI
import beyondtranslate_runtime

// MARK: - Translation Target Editor Sheet

struct TranslationTargetEditorSheet: View {
  let title: String
  @State var source: String
  @State var target: String
  let supportedLanguages: [LanguageInfo]
  var showDelete = false
  let onSave: (String, String) -> Void
  var onDelete: (() -> Void)? = nil
  let onCancel: () -> Void

  var body: some View {
    VStack(spacing: 0) {
      // Header
      HStack {
        Text(title)
          .font(.system(size: 16, weight: .semibold))
        Spacer()
      }
      .padding(.horizontal, 20)
      .padding(.top, 20)
      .padding(.bottom, 12)

      Divider()

      // Form
      Form {
        Section {
          languagePicker(
            label: LocaleKeys.settings.general.editor.row.sourceLanguage.tr(),
            selection: $source,
            showAutoDetect: true
          )
          languagePicker(
            label: LocaleKeys.settings.general.editor.row.targetLanguage.tr(),
            selection: $target,
            showAutoDetect: false
          )
        }
      }
      .formStyle(.grouped)
      .fixedSize(horizontal: false, vertical: true)

      Divider()

      // Bottom bar
      HStack(spacing: 8) {
        if showDelete, let onDelete {
          Button(role: .destructive) {
            onDelete()
          } label: {
            Text(LocaleKeys.common.ui.button.delete.tr())
          }
        }

        Spacer()

        Button(LocaleKeys.common.ui.button.cancel.tr()) {
          onCancel()
        }
        .keyboardShortcut(.cancelAction)

        Button(LocaleKeys.common.ui.button.save.tr()) {
          onSave(source, target)
        }
        .keyboardShortcut(.defaultAction)
        .disabled(source == target)
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 16)
    }
    .frame(width: 420)
    .fixedSize(horizontal: false, vertical: true)
  }

  @ViewBuilder
  private func languagePicker(label: String, selection: Binding<String>, showAutoDetect: Bool)
    -> some View
  {
    Picker(label, selection: selection) {
      if showAutoDetect {
        Text(LocaleKeys.miniTranslator.language.autoDetect.tr())
          .tag("auto")
      }
      ForEach(supportedLanguages, id: \.code) { lang in
        HStack(spacing: 8) {
          Text(lang.localName)
            .font(.system(size: 13))
          Text(lang.code)
            .font(.system(size: 11, design: .monospaced))
            .foregroundStyle(.secondary)
        }
        .tag(lang.code)
      }
    }
  }
}
