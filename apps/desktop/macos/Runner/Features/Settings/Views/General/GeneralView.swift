import AppKit
import SwiftUI

struct GeneralView: View {
  @ObservedObject var viewModel: GeneralViewModel
  @ObservedObject private var highlightCoordinator = SettingsHighlightCoordinator.shared
  @State private var isPermissionsHighlighted = false
  @State private var lastHandledPermissionsHighlightID = 0

  var body: some View {
    SettingsPage(title: LocaleKeys.settings.general.title.tr()) {
      Section {
        SettingToggle(
          LocaleKeys.settings.preference.launchAtStartup.tr(),
          isOn: Binding(
            get: { viewModel.launchAtLogin },
            set: { viewModel.setLaunchAtLogin($0) }
          ))
        SettingToggle(
          LocaleKeys.settings.preference.showMenuBar.tr(),
          isOn: Binding(
            get: { viewModel.showMenuBar },
            set: { viewModel.setShowMenuBar($0) }
          ))
      }

      Section(LocaleKeys.settings.preference.permissions.tr()) {
        PermissionAccessRow(
          title: LocaleKeys.miniTranslator.limitedBanner.permission.screenCapture.tr(),
          isAllowed: viewModel.screenCaptureAllowed,
          onRequest: viewModel.requestScreenCaptureAccess
        )
        PermissionAccessRow(
          title: LocaleKeys.miniTranslator.limitedBanner.permission.screenSelection.tr(),
          isAllowed: viewModel.accessibilityAllowed,
          onRequest: viewModel.requestAccessibilityAccess
        )
      }
      .background(
        RoundedRectangle(cornerRadius: 8)
          .fill(isPermissionsHighlighted ? Color.accentColor.opacity(0.16) : Color.clear)
      )
      .overlay(
        RoundedRectangle(cornerRadius: 8)
          .stroke(
            isPermissionsHighlighted ? Color.accentColor.opacity(0.55) : Color.clear, lineWidth: 1)
      )

      Section(LocaleKeys.settings.preference.extractText.tr()) {
        SettingPicker(
          LocaleKeys.settings.preference.defaultExtractTextService.tr(),
          selection: Binding(
            get: { viewModel.defaultOcrService },
            set: { viewModel.setDefaultOcrService($0) }
          )
        ) {
          ForEach(ocrOptions, id: \.id) { item in
            Text(item.title).tag(item.id)
          }
        }
        .pickerStyle(.menu)

        SettingToggle(
          LocaleKeys.settings.preference.autoCopyDetectedText.tr(),
          isOn: $viewModel.autoCopyDetectedText)
      }

      Section(LocaleKeys.settings.preference.directory.tr()) {
        SettingPicker(
          LocaleKeys.settings.preference.defaultDirectoryService.tr(),
          selection: Binding(
            get: { viewModel.defaultDirectoryService },
            set: { viewModel.setDefaultDirectoryService($0) }
          )
        ) {
          if viewModel.dictionaryServiceOptions.isEmpty {
            Text(LocaleKeys.settings.option.noServicesAvailable.tr()).tag("")
          } else {
            Text(LocaleKeys.settings.option.none.tr()).tag("")
            ForEach(viewModel.dictionaryServiceOptions) { option in
              Text(option.name).tag(option.id)
            }
          }
        }
        .pickerStyle(.menu)
        .disabled(viewModel.dictionaryServiceOptions.isEmpty)
      }

      Section(LocaleKeys.settings.preference.translation.tr()) {
        SettingPicker(
          LocaleKeys.settings.preference.defaultTranslationService.tr(),
          selection: Binding(
            get: { viewModel.defaultTranslationService },
            set: { viewModel.setDefaultTranslationService($0) }
          )
        ) {
          if viewModel.translationServiceOptions.isEmpty {
            Text(LocaleKeys.settings.option.noServicesAvailable.tr()).tag("")
          } else {
            Text(LocaleKeys.settings.option.none.tr()).tag("")
            ForEach(viewModel.translationServiceOptions) { option in
              Text(option.name).tag(option.id)
            }
          }
        }
        .pickerStyle(.menu)
        .disabled(viewModel.translationServiceOptions.isEmpty)

        SettingPicker(
          LocaleKeys.settings.preference.translationMode.tr(),
          selection: Binding(
            get: { viewModel.translationMode },
            set: { viewModel.setTranslationMode($0) }
          )
        ) {
          ForEach(TranslationMode.allCases) { mode in
            Text(mode.title).tag(mode)
          }
        }
        .pickerStyle(.menu)

        SettingToggle(
          LocaleKeys.settings.preference.doubleClickCopyResult.tr(),
          isOn: $viewModel.doubleClickCopyResult
        )
      }

      if viewModel.translationMode == .auto {
        Section(LocaleKeys.settings.preference.translationTarget.tr()) {
          VStack(alignment: .leading, spacing: 10) {
            ForEach(viewModel.translationTargets) { item in
              HStack {
                Text(item.source)
                Image(systemName: "arrow.right")
                  .foregroundStyle(.secondary)
                Text(item.target)
                Spacer()
                Button(LocaleKeys.common.button.edit.tr()) {}
              }
            }

            Button(LocaleKeys.settings.preference.addTarget.tr()) {}
          }
        }
      }

      Section(LocaleKeys.settings.input.title.tr()) {
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
    .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification))
    { _ in
      viewModel.refreshPermissions()
    }
    .onAppear {
      handlePermissionsHighlight(highlightCoordinator.permissionsHighlightID)
    }
    .onReceive(highlightCoordinator.$permissionsHighlightID) { highlightID in
      handlePermissionsHighlight(highlightID)
    }
  }

  private var ocrOptions: [(id: String, title: String)] {
    [
      ("Built-in OCR", LocaleKeys.settings.option.builtInOcr.tr()),
      ("Tesseract", LocaleKeys.settings.option.tesseract.tr()),
      ("Youdao OCR", LocaleKeys.settings.option.youdaoOcr.tr()),
    ]
  }

  private func handlePermissionsHighlight(_ highlightID: Int) {
    guard highlightID > 0, highlightID > lastHandledPermissionsHighlightID else { return }

    lastHandledPermissionsHighlightID = highlightID
    withAnimation(.easeInOut(duration: 0.16)) {
      isPermissionsHighlighted = true
    }

    Task {
      try? await Task.sleep(nanoseconds: 1_600_000_000)
      guard lastHandledPermissionsHighlightID == highlightID else { return }
      withAnimation(.easeInOut(duration: 0.24)) {
        isPermissionsHighlighted = false
      }
    }
  }
}

private struct PermissionAccessRow: View {
  let title: String
  let isAllowed: Bool
  let onRequest: () -> Void

  var body: some View {
    HStack {
      Text(title)
      Spacer()

      if isAllowed {
        Text(LocaleKeys.settings.option.granted.tr())
          .foregroundStyle(.secondary)
      } else {
        Button(LocaleKeys.miniTranslator.limitedBanner.button.allow.tr(), action: onRequest)
      }
    }
  }
}
