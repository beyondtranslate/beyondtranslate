import SwiftUI
import beyondtranslate_runtime

// MARK: - Common Languages Editor Sheet

struct CommonLanguagesEditorSheet: View {
  let allLanguages: [LanguageInfo]
  @Binding var commonLanguages: [String]
  let onSave: ([String]) -> Void
  let onCancel: () -> Void

  @State private var selected: Set<String> = []

  /// The default set of common language codes, matching the Dart-side defaults.
  private static let defaultLanguageCodes: [String] = [
    "en", "zh-Hans", "zh-Hant", "ja", "ko", "fr", "de", "es",
    "ru", "pt", "ar", "it",
  ]

  var body: some View {
    VStack(spacing: 0) {
      Text(LocaleKeys.settings.general.row.commonLanguagesHint.tr())
        .foregroundStyle(.primary)
        .multilineTextAlignment(.center)
        .padding(.top, 20)
        .padding(.bottom, 12)

      List(allLanguages, id: \.code) { lang in
        Toggle(
          isOn: Binding(
            get: { selected.contains(lang.code) },
            set: { isSelected in
              if isSelected {
                selected.insert(lang.code)
              } else {
                selected.remove(lang.code)
              }
            }
          )
        ) {
          HStack(spacing: 8) {
            Text(lang.localName)
              .font(.system(size: 13))
            Text(lang.code)
              .font(.system(size: 11, design: .monospaced))
              .foregroundStyle(.secondary)
          }
        }
        .toggleStyle(.checkbox)
      }
      .listStyle(.inset(alternatesRowBackgrounds: true))
      .frame(height: 360)
      .clipShape(RoundedRectangle(cornerRadius: 6))
      .overlay(
        RoundedRectangle(cornerRadius: 6)
          .stroke(Color(nsColor: .separatorColor), lineWidth: 1)
      )
      .padding(.horizontal, 20)

      HStack(spacing: 8) {
        Button(LocaleKeys.settings.general.row.commonLanguagesReset.tr()) {
          selected = Set(Self.defaultLanguageCodes)
        }
        .help(LocaleKeys.settings.general.row.commonLanguagesResetHelp.tr())

        Spacer()

        Button(LocaleKeys.common.ui.button.cancel.tr()) {
          onCancel()
        }
        .keyboardShortcut(.cancelAction)

        Button(LocaleKeys.common.ui.button.save.tr()) {
          onSave(Array(selected))
        }
        .keyboardShortcut(.defaultAction)
      }
      .padding(.horizontal, 20)
      .padding(.top, 12)
      .padding(.bottom, 16)
    }
    .frame(width: 380)
    .fixedSize(horizontal: false, vertical: true)
    .onAppear {
      selected = Set(commonLanguages)
    }
  }
}
