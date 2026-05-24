import SwiftUI
import beyondtranslate_runtime

struct GeneralView: View {
  @ObservedObject var viewModel: GeneralViewModel
  let onAddProvider: () -> Void
  @ObservedObject private var highlightCoordinator = SettingsHighlightCoordinator.shared
  @State private var showCommonLanguagesSheet = false

  var body: some View {
    let hasDirectoryServices = !viewModel.dictionaryServiceOptions.isEmpty
    let hasTranslationServices = !viewModel.translationServiceOptions.isEmpty

    SettingsPage(title: LocaleKeys.settings.general.title.tr()) {
      Section {
        SettingToggle(
          LocaleKeys.settings.general.row.launchAtStartup.tr(),
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

      Section(LocaleKeys.settings.general.section.directory.tr()) {
        if hasDirectoryServices {
          SettingPicker(
            LocaleKeys.settings.general.row.defaultDirectoryService.tr(),
            selection: Binding(
              get: { viewModel.validDefaultDirectoryService },
              set: { viewModel.setDefaultDirectoryService($0) }
            )
          ) {
            Text(LocaleKeys.settings.general.option.none.tr()).tag("")
            ForEach(viewModel.dictionaryServiceOptions) { option in
              Text(option.name).tag(option.id)
            }
          }
          .pickerStyle(.menu)
        } else {
          ServiceUnavailableSettingRow(
            title: LocaleKeys.settings.general.row.defaultDirectoryService.tr(),
            onAddProvider: onAddProvider
          )
        }
      }

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

        CommonLanguagesRow(
          count: viewModel.commonLanguages.count,
          total: viewModel.supportedLanguages.count,
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
        title: LocaleKeys.settings.general.button.addTarget.tr(),
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
          title: LocaleKeys.common.ui.button.edit.tr(),
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

        ForEach(viewModel.translationTargets) { item in
          TranslationTargetRow(item: item) {
            viewModel.editingTarget = item
          }
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

  var body: some View {
    Button(action: onEdit) {
      HStack(spacing: 8) {
        Text(sourceTitle)
        Image(systemName: "arrow.right")
          .font(.system(size: 11, weight: .semibold))
          .foregroundStyle(.secondary)
        Text(localizedLanguageName(item.target))

        Spacer()

        Image(systemName: "exclamationmark.circle")
          .foregroundStyle(.secondary)
          .imageScale(.medium)

        Toggle("", isOn: .constant(true))
          .labelsHidden()
          .allowsHitTesting(false)
      }
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
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
  let count: Int
  let total: Int
  let onEdit: () -> Void

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(LocaleKeys.settings.general.row.commonLanguages.tr())
          .font(.system(size: 13))
        Text("\(count) / \(total)")
          .font(.system(size: 11))
          .foregroundStyle(.secondary)
      }
      Spacer()
      Button(LocaleKeys.common.ui.button.edit.tr()) {
        onEdit()
      }
      .buttonStyle(.link)
    }
    .padding(.vertical, 2)
  }
}

private func localizedLanguageName(_ code: String) -> String {
  let key = "common.language." + code.lowercased().replacingOccurrences(of: "-", with: "_")
  return LocaleKey(key).tr()
}
