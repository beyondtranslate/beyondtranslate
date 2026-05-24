import SwiftUI
import beyondtranslate_runtime

// MARK: - Translation Target Editor Sheet

struct TranslationTargetEditorSheet: View {
  let title: String
  @State var source: String
  @State var target: String
  let supportedLanguages: [LanguageInfo]
  let commonLanguages: [String]
  var showDelete = false
  let onSave: (String, String) -> Void
  var onDelete: (() -> Void)? = nil
  let onCancel: () -> Void

  /// Language infos whose codes are in the `commonLanguages` set.
  private var commonLanguageInfos: [LanguageInfo] {
    let codeSet = Set(commonLanguages)
    return supportedLanguages.filter { codeSet.contains($0.code) }
  }

  /// Language infos whose codes are NOT in the `commonLanguages` set.
  private var otherLanguageInfos: [LanguageInfo] {
    let codeSet = Set(commonLanguages)
    return supportedLanguages.filter { !codeSet.contains($0.code) }
  }

  var body: some View {
    VStack(spacing: 0) {
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
        } header: {
          Text(title)
            .foregroundStyle(.primary)
            .fontWeight(.regular)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
      }
      .formStyle(.grouped)
      .fixedSize(horizontal: false, vertical: true)

      HStack(spacing: 8) {
        if showDelete, let onDelete {
          Button(role: .destructive) {
            onDelete()
          } label: {
            Text(LocaleKeys.common.ui.button.delete.tr())
          }
          .buttonStyle(.bordered)
          .tint(.red)
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
      .padding(.top, 12)
      .padding(.bottom, 16)
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

      // Common languages (no section header — shown first by default)
      if !commonLanguageInfos.isEmpty {
        ForEach(commonLanguageInfos, id: \.code) { lang in
          LanguageRow(lang: lang)
            .tag(lang.code)
        }
      }

      // Other languages grouped under "More languages..."
      if !otherLanguageInfos.isEmpty {
        Section(LocaleKeys.miniTranslator.language.moreLanguages.tr()) {
          ForEach(otherLanguageInfos, id: \.code) { lang in
            LanguageRow(lang: lang)
              .tag(lang.code)
          }
        }
      }
    }
  }

  @ViewBuilder
  private func LanguageRow(lang: LanguageInfo) -> some View {
    HStack(spacing: 8) {
      Text(lang.localName)
        .font(.system(size: 13))
      Text(lang.code)
        .font(.system(size: 11, design: .monospaced))
        .foregroundStyle(.secondary)
    }
  }
}
