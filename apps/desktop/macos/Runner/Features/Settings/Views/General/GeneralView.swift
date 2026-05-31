import SwiftUI
import beyondtranslate_runtime

struct GeneralView: View {
  @ObservedObject var viewModel: GeneralViewModel
  let onAddProvider: () -> Void
  @ObservedObject private var highlightCoordinator = SettingsHighlightCoordinator.shared
  @State private var showCommonLanguagesSheet = false

  var body: some View {
    // let hasDirectoryServices = !viewModel.dictionaryServiceOptions.isEmpty
    let hasTranslationServices = !viewModel.translationServiceOptions.isEmpty

    SettingsPage(title: LocaleKeys.settings.general.title.tr()) {
      Section {
        SettingToggle(
          LocaleKeys.settings.general.row.launchAtLogin.tr(),
          isOn: Binding(
            get: { viewModel.launchAtLogin },
            set: { viewModel.setLaunchAtLogin($0) }
          ))
        SettingToggle(
          LocaleKeys.settings.general.row.showInMenuBar.tr(),
          isOn: Binding(
            get: { viewModel.showInMenuBar },
            set: { viewModel.setShowInMenuBar($0) }
          ))
      }

      Section(LocaleKeys.settings.appearance.title.tr()) {
        SettingPicker(
          LocaleKeys.settings.appearance.section.appLanguage.tr(),
          selection: Binding(
            get: { viewModel.appLanguage },
            set: { viewModel.setAppLanguage($0) }
          )
        ) {
          ForEach(viewModel.languageOptions, id: \.code) { language in
            Text(language.localName).tag(language.code)
          }
        }
        .pickerStyle(.menu)

        SettingPicker(
          LocaleKeys.settings.appearance.section.themeMode.tr(),
          selection: Binding(
            get: { viewModel.themeMode },
            set: { viewModel.setThemeMode($0) }
          )
        ) {
          ForEach(viewModel.themeModeOptions) { option in
            Text(option.title).tag(option.mode)
          }
        }
        .pickerStyle(.menu)
      }

      Section(LocaleKeys.settings.general.section.ocr.tr()) {
        let hasOcrServices = !viewModel.ocrServiceOptions.isEmpty

        if hasOcrServices {
          SettingPicker(
            LocaleKeys.settings.general.row.defaultOcrService.tr(),
            selection: Binding(
              get: { viewModel.validDefaultOcrService },
              set: { viewModel.setDefaultOcrService($0) }
            )
          ) {
            Text(LocaleKeys.settings.general.option.none.tr()).tag("")
            ForEach(viewModel.ocrServiceOptions) { option in
              Text(option.name).tag(option.id)
            }
          }
          .pickerStyle(.menu)
        } else {
          ServiceUnavailableSettingRow(
            title: LocaleKeys.settings.general.row.defaultOcrService.tr(),
            onAddProvider: onAddProvider
          )
        }

        SettingToggle(
          LocaleKeys.settings.general.row.autoCopyDetectedText.tr(),
          isOn: $viewModel.autoCopyDetectedText)
      }

      // Section(LocaleKeys.settings.general.section.directory.tr()) {
      //   if hasDirectoryServices {
      //     SettingPicker(
      //       LocaleKeys.settings.general.row.defaultDirectoryService.tr(),
      //       selection: Binding(
      //         get: { viewModel.validDefaultDirectoryService },
      //         set: { viewModel.setDefaultDirectoryService($0) }
      //       )
      //     ) {
      //       Text(LocaleKeys.settings.general.option.none.tr()).tag("")
      //       ForEach(viewModel.dictionaryServiceOptions) { option in
      //         Text(option.name).tag(option.id)
      //       }
      //     }
      //     .pickerStyle(.menu)
      //   } else {
      //     ServiceUnavailableSettingRow(
      //       title: LocaleKeys.settings.general.row.defaultDirectoryService.tr(),
      //       onAddProvider: onAddProvider
      //     )
      //   }
      // }

      Section(LocaleKeys.settings.general.section.translation.tr()) {
        if hasTranslationServices {
          SettingPicker(
            LocaleKeys.settings.general.row.defaultTranslationService.tr(),
            selection: Binding(
              get: { viewModel.validDefaultTranslationService },
              set: { viewModel.setDefaultTranslationService($0) }
            )
          ) {
            Text(LocaleKeys.settings.general.option.none.tr()).tag("")
            ForEach(viewModel.translationServiceOptions) { option in
              Text(option.name).tag(option.id)
            }
          }
          .pickerStyle(.menu)
        } else {
          ServiceUnavailableSettingRow(
            title: LocaleKeys.settings.general.row.defaultTranslationService.tr(),
            onAddProvider: onAddProvider
          )
        }

        SettingToggle(
          LocaleKeys.settings.general.row.doubleClickCopyResult.tr(),
          isOn: $viewModel.doubleClickCopyResult
        )
        .disabled(!hasTranslationServices)
      }

      Section {
        CommonLanguagesRow(
          commonLanguageInfos: viewModel.commonLanguageInfos,
          onEdit: { showCommonLanguagesSheet = true }
        )
      }

      translationTargetsSection

      Section(LocaleKeys.settings.general.section.input.tr()) {
        SettingPicker("", selection: $viewModel.inputSubmitMode) {
          ForEach(InputSubmitMode.allCases) { mode in
            Text(mode.title).tag(mode)
          }
        }
        .labelsHidden()
        .pickerStyle(.radioGroup)
      }
    }
    .task {
      await viewModel.load()
    }
    .onChange(of: highlightCoordinator.pendingShowCommonLanguages) { newValue in
      handleShowCommonLanguages(newValue)
    }
    .onChange(of: highlightCoordinator.pendingShowAddTarget) { newValue in
      handleShowAddTarget(newValue)
    }
    .sheet(isPresented: $viewModel.showAddTargetSheet) {
      TranslationTargetEditorSheet(
        title: LocaleKeys.settings.general.editor.addTargetTitle.tr(),
        source: "auto",
        target: "zh-Hans",
        supportedLanguages: viewModel.supportedLanguages,
        commonLanguages: viewModel.commonLanguages,
        onSave: { source, target in
          viewModel.addTranslationTarget(source: source, target: target)
          viewModel.showAddTargetSheet = false
        },
        onCancel: { viewModel.showAddTargetSheet = false }
      )
    }
    .sheet(isPresented: viewModel.showEditTargetSheet) {
      if let target = viewModel.editingTarget {
        TranslationTargetEditorSheet(
          title: LocaleKeys.settings.general.editor.editTargetTitle.tr(),
          source: target.source,
          target: target.target,
          supportedLanguages: viewModel.supportedLanguages,
          commonLanguages: viewModel.commonLanguages,
          showDelete: true,
          onSave: { source, targetLang in
            if let idx = viewModel.translationTargets.firstIndex(where: { $0.id == target.id }) {
              viewModel.removeTranslationTarget(at: idx)
              viewModel.addTranslationTarget(source: source, target: targetLang)
            }
            viewModel.editingTarget = nil
          },
          onDelete: {
            if let idx = viewModel.translationTargets.firstIndex(where: { $0.id == target.id }) {
              viewModel.removeTranslationTarget(at: idx)
            }
            viewModel.editingTarget = nil
          },
          onCancel: { viewModel.editingTarget = nil }
        )
      }
    }
    .sheet(isPresented: $showCommonLanguagesSheet) {
      CommonLanguagesEditorSheet(
        allLanguages: viewModel.supportedLanguages,
        commonLanguages: $viewModel.commonLanguages,
        onSave: { languages in
          viewModel.setCommonLanguages(languages)
          showCommonLanguagesSheet = false
        },
        onCancel: { showCommonLanguagesSheet = false }
      )
    }
  }

  private func handleShowCommonLanguages(_ id: Int?) {
    guard let id, highlightCoordinator.consumeShowCommonLanguages(id) else { return }
    showCommonLanguagesSheet = true
  }

  private func handleShowAddTarget(_ id: Int?) {
    guard let id, highlightCoordinator.consumeShowAddTarget(id) else { return }
    viewModel.showAddTargetSheet = true
  }

  @ViewBuilder
  private var translationTargetsSection: some View {
    if !viewModel.translationServiceOptions.isEmpty {
      Section {
        TranslationTargetsHeaderRow()

        ForEach(Array(viewModel.translationTargets.enumerated()), id: \.element.id) { index, item in
          TranslationTargetRow(
            item: item,
            onEdit: { viewModel.editingTarget = item },
            onToggleEnabled: { viewModel.toggleTranslationTargetEnabled(at: index) }
          )
        }

        HStack {
          Spacer()
          Button(LocaleKeys.settings.general.button.addTarget.tr()) {
            viewModel.showAddTargetSheet = true
          }
        }
      }
    }
  }

}

private struct TranslationTargetsHeaderRow: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      Text(LocaleKeys.settings.general.section.translationTarget.tr())
        .font(.system(size: 13))
      Text(LocaleKey("settings.general.row.translation_target_hint").tr())
        .font(.system(size: 11))
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)
    }
    .padding(.vertical, 2)
  }
}

private struct TranslationTargetRow: View {
  let item: TranslationTarget
  let onEdit: () -> Void
  let onToggleEnabled: () -> Void

  var body: some View {
    HStack(spacing: 8) {
      Button(action: onEdit) {
        HStack(spacing: 8) {
          Text(sourceTitle)
          Image(systemName: "arrow.right")
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(.secondary)
          Text(localizedLanguageName(item.target))
          Spacer()
        }
        .contentShape(Rectangle())
      }
      .buttonStyle(.plain)

      Toggle(
        "",
        isOn: Binding(
          get: { item.enabled },
          set: { _ in onToggleEnabled() }
        )
      )
      .labelsHidden()
      .toggleStyle(.switch)
      .scaleEffect(0.85)
    }
  }

  private var sourceTitle: String {
    item.source == "auto"
      ? LocaleKeys.miniTranslator.language.autoDetect.tr()
      : localizedLanguageName(item.source)
  }
}

private struct ServiceUnavailableSettingRow: View {
  let title: String
  let onAddProvider: () -> Void

  var body: some View {
    HStack {
      Text(title)
      Spacer()
      Text(LocaleKeys.settings.general.option.noServicesAvailable.tr())
        .foregroundStyle(.secondary)
      Button(LocaleKeys.settings.general.button.addProvider.tr(), action: onAddProvider)
    }
  }
}

private struct CommonLanguagesRow: View {
  let commonLanguageInfos: [LanguageInfo]
  let onEdit: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      Text(LocaleKeys.settings.general.row.commonLanguages.tr())
        .font(.system(size: 13))
      Text(LocaleKeys.settings.general.row.commonLanguagesDescription.tr())
        .font(.system(size: 11))
        .foregroundStyle(.secondary)
        .fixedSize(horizontal: false, vertical: true)
    }
    .padding(.vertical, 2)

    if !commonLanguageInfos.isEmpty {
      WrappingTagsLayout(horizontalSpacing: 6, verticalSpacing: 6) {
        ForEach(commonLanguageInfos, id: \.code) { lang in
          CommonLanguageTag(title: lang.localName)
        }
      }
    } else {
      Text(LocaleKeys.settings.general.option.none.tr())
        .font(.system(size: 11))
        .foregroundStyle(.tertiary)
        .padding(.leading, 8)
    }

    HStack {
      Spacer()
      Button(LocaleKeys.settings.general.button.manageLanguages.tr()) {
        onEdit()
      }
    }
  }
}

private struct CommonLanguageTag: View {
  let title: String

  var body: some View {
    Text(title)
      .font(.system(size: 11, weight: .medium))
      .lineLimit(1)
      .fixedSize()
      .padding(.horizontal, 8)
      .padding(.vertical, 4)
      .foregroundStyle(Color(nsColor: .controlAccentColor))
      .background(Color(nsColor: .controlAccentColor).opacity(0.1))
      .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
      .overlay(
        RoundedRectangle(cornerRadius: 6, style: .continuous)
          .stroke(Color(nsColor: .controlAccentColor).opacity(0.2), lineWidth: 1)
      )
  }
}

private struct WrappingTagsLayout: Layout {
  var horizontalSpacing: CGFloat = 6
  var verticalSpacing: CGFloat = 6

  func sizeThatFits(
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout ()
  ) -> CGSize {
    let rows = arrangeSubviews(subviews, maxWidth: proposal.width)
    let width = proposal.width ?? rows.map(\.width).max() ?? 0
    let height =
      rows.reduce(CGFloat.zero) { total, row in
        total + row.height
      } + CGFloat(max(0, rows.count - 1)) * verticalSpacing

    return CGSize(width: width, height: height)
  }

  func placeSubviews(
    in bounds: CGRect,
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout ()
  ) {
    let rows = arrangeSubviews(subviews, maxWidth: bounds.width)
    var y = bounds.minY

    for row in rows {
      var x = bounds.minX

      for item in row.items {
        subviews[item.index].place(
          at: CGPoint(x: x, y: y),
          proposal: ProposedViewSize(item.size)
        )
        x += item.size.width + horizontalSpacing
      }

      y += row.height + verticalSpacing
    }
  }

  private func arrangeSubviews(_ subviews: Subviews, maxWidth proposedMaxWidth: CGFloat?) -> [Row] {
    let maxWidth = proposedMaxWidth ?? .greatestFiniteMagnitude
    var rows: [Row] = []
    var currentItems: [RowItem] = []
    var currentWidth: CGFloat = 0
    var currentHeight: CGFloat = 0

    for index in subviews.indices {
      let size = subviews[index].sizeThatFits(.unspecified)
      let nextWidth =
        currentItems.isEmpty
        ? size.width
        : currentWidth + horizontalSpacing + size.width

      if !currentItems.isEmpty && nextWidth > maxWidth {
        rows.append(Row(items: currentItems, width: currentWidth, height: currentHeight))
        currentItems = [RowItem(index: index, size: size)]
        currentWidth = size.width
        currentHeight = size.height
      } else {
        currentItems.append(RowItem(index: index, size: size))
        currentWidth = nextWidth
        currentHeight = max(currentHeight, size.height)
      }
    }

    if !currentItems.isEmpty {
      rows.append(Row(items: currentItems, width: currentWidth, height: currentHeight))
    }

    return rows
  }

  private struct Row {
    let items: [RowItem]
    let width: CGFloat
    let height: CGFloat
  }

  private struct RowItem {
    let index: Int
    let size: CGSize
  }
}

private func localizedLanguageName(_ code: String) -> String {
  let key = "common.language." + code.lowercased().replacingOccurrences(of: "-", with: "_")
  return LocaleKey(key).tr()
}
