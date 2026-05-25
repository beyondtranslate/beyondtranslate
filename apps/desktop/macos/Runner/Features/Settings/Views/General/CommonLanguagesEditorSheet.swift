import SwiftUI
import beyondtranslate_runtime

struct CommonLanguagesEditorSheet: View {
  let allLanguages: [LanguageInfo]
  @Binding var commonLanguages: [String]
  let onSave: ([String]) -> Void
  let onCancel: () -> Void

  @State private var orderedCodes: [String]
  @State private var searchText: String = ""
  @State private var isSearchExpanded = false

  private static let defaultLanguageCodes: [String] = [
    "en", "zh-Hans", "zh-Hant", "ja", "ko", "fr", "de", "es",
    "ru", "pt", "ar", "it",
  ]

  private var allDict: [String: LanguageInfo] {
    Dictionary(uniqueKeysWithValues: allLanguages.map { ($0.code, $0) })
  }

  private var selectedLanguageInfos: [LanguageInfo] {
    let dict = allDict
    return orderedCodes.compactMap { dict[$0] }
  }

  private var filteredLanguages: [LanguageInfo] {
    let sorted = allLanguages.sorted {
      $0.code.localizedCompare($1.code) == .orderedAscending
    }
    if searchText.isEmpty { return sorted }
    return sorted.filter {
      $0.localName.localizedCaseInsensitiveContains(searchText)
        || $0.code.localizedCaseInsensitiveContains(searchText)
    }
  }

  init(
    allLanguages: [LanguageInfo],
    commonLanguages: Binding<[String]>,
    onSave: @escaping ([String]) -> Void,
    onCancel: @escaping () -> Void
  ) {
    self.allLanguages = allLanguages
    self._commonLanguages = commonLanguages
    self.onSave = onSave
    self.onCancel = onCancel
    self._orderedCodes = State(initialValue: commonLanguages.wrappedValue)
  }

  var body: some View {
    VStack(spacing: 0) {
      Text(LocaleKeys.miniTranslator.language.manageCommonLanguages.tr())
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 12)

      HSplitView {
        // ── Left: Selected languages ──
        selectedPane

        // ── Right: All languages ──
        allLanguagesPane
      }
      .clipShape(RoundedRectangle(cornerRadius: 6))
      .overlay(
        RoundedRectangle(cornerRadius: 6)
          .stroke(Color(nsColor: .separatorColor), lineWidth: 1)
      )
      .padding(.horizontal, 20)

      // Bottom buttons
      HStack(spacing: 8) {
        Button(LocaleKeys.settings.general.row.commonLanguagesReset.tr()) {
          orderedCodes = Self.defaultLanguageCodes
        }
        .controlSize(.small)
        .help(LocaleKeys.settings.general.row.commonLanguagesResetHelp.tr())

        Spacer()

        Button(LocaleKeys.common.ui.button.cancel.tr()) { onCancel() }
          .keyboardShortcut(.cancelAction)
        Button(LocaleKeys.common.ui.button.save.tr()) { onSave(orderedCodes) }
          .keyboardShortcut(.defaultAction)
      }
      .padding(.horizontal, 20)
      .padding(.top, 12)
      .padding(.bottom, 16)
    }
    .frame(width: 560, height: 440)
    .fixedSize()
  }

  // MARK: - Left Pane

  @ViewBuilder
  private var selectedPane: some View {
    VStack(spacing: 6) {
      HStack {
        Text(LocaleKeys.settings.general.row.commonLanguages.tr())
          .font(.system(size: 12, weight: .medium))
          .foregroundStyle(.secondary)
        Text("(\(orderedCodes.count))")
          .font(.system(size: 11))
          .foregroundStyle(.tertiary)

        Spacer()

        Button {
          orderedCodes.sort()
        } label: {
          HStack(spacing: 3) {
            Image(systemName: "arrow.up.arrow.down")
              .imageScale(.small)
            Text(LocaleKeys.settings.general.row.commonLanguagesSort.tr())
          }
        }
        .buttonStyle(.link)
        .controlSize(.small)
      }
      .padding(.horizontal, 8)
      .padding(.top, 8)

      List {
        ForEach(orderedCodes, id: \.self) { code in
          if let lang = allDict[code] {
            HStack(spacing: 6) {
              Image(systemName: "line.horizontal.3")
                .foregroundStyle(.tertiary)
                .imageScale(.medium)
              Text(lang.localName)
                .font(.system(size: 12))
                .lineLimit(1)
              Spacer(minLength: 4)
              Text(lang.code)
                .font(.system(size: 10, design: .monospaced))
                .foregroundStyle(.tertiary)
              Button {
                orderedCodes.removeAll { $0 == code }
              } label: {
                Image(systemName: "xmark.circle.fill")
                  .foregroundStyle(.secondary)
                  .imageScale(.medium)
              }
              .buttonStyle(.plain)
            }
          }
        }
        .onMove { source, destination in
          orderedCodes.move(fromOffsets: source, toOffset: destination)
        }
        .onDelete { indexSet in
          orderedCodes.remove(atOffsets: indexSet)
        }
      }
      .listStyle(.inset(alternatesRowBackgrounds: true))
      .scrollIndicators(.automatic)
      .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
    }
    .frame(minWidth: 220, idealWidth: 250)
  }

  // MARK: - Right Pane

  @ViewBuilder
  private var allLanguagesPane: some View {
    VStack(spacing: 6) {
      // Header: Title + Search icon
      HStack(spacing: 6) {
        Text(LocaleKeys.settings.general.row.commonLanguagesAll.tr())
          .font(.system(size: 12, weight: .medium))
          .foregroundStyle(.secondary)

        Spacer()

        Button {
          withAnimation(.easeInOut(duration: 0.15)) {
            isSearchExpanded.toggle()
            if !isSearchExpanded {
              searchText = ""
            }
          }
        } label: {
          Image(systemName: "magnifyingglass")
            .foregroundStyle(isSearchExpanded ? Color(nsColor: .controlAccentColor) : .secondary)
            .imageScale(.small)
        }
        .buttonStyle(.plain)
        .help(LocaleKeys.settings.general.row.commonLanguagesSearch.tr())
      }
      .padding(.horizontal, 8)
      .padding(.top, 8)

      // Expandable search field
      if isSearchExpanded {
        HStack(spacing: 4) {
          Image(systemName: "magnifyingglass")
            .foregroundStyle(.secondary)
            .imageScale(.small)
          TextField(LocaleKeys.settings.general.row.commonLanguagesSearch.tr(), text: $searchText)
            .textFieldStyle(.plain)
            .font(.system(size: 12))
          if !searchText.isEmpty {
            Button {
              searchText = ""
            } label: {
              Image(systemName: "xmark.circle.fill")
                .foregroundStyle(.secondary)
                .imageScale(.small)
            }
            .buttonStyle(.plain)
          }
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 5)
        .background(Color(nsColor: .controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .overlay(
          RoundedRectangle(cornerRadius: 5)
            .stroke(Color(nsColor: .separatorColor), lineWidth: 1)
        )
        .padding(.horizontal, 8)
        .transition(.move(edge: .top).combined(with: .opacity))
      }

      List(filteredLanguages, id: \.code) { lang in
        Toggle(
          isOn: Binding(
            get: { orderedCodes.contains(lang.code) },
            set: { on in
              if on {
                if !orderedCodes.contains(lang.code) {
                  orderedCodes.append(lang.code)
                }
              } else {
                orderedCodes.removeAll { $0 == lang.code }
              }
            }
          )
        ) {
          HStack(spacing: 6) {
            Text(lang.localName)
              .font(.system(size: 12))
              .lineLimit(1)
            Spacer(minLength: 4)
            Text(lang.code)
              .font(.system(size: 10, design: .monospaced))
              .foregroundStyle(.tertiary)
          }
        }
        .toggleStyle(.checkbox)
      }
      .listStyle(.inset(alternatesRowBackgrounds: true))
      .scrollIndicators(.automatic)
      .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
    }
    .frame(minWidth: 220, idealWidth: 250)
  }
}
