import AppKit
import SwiftUI

struct AdvancedView: View {
  @ObservedObject var viewModel: AdvancedViewModel
  @ObservedObject private var highlightCoordinator = SettingsHighlightCoordinator.shared
  @State private var isPermissionsHighlighted = false
  @State private var permissionsHighlightGeneration = 0

  var body: some View {
    SettingsPage(title: LocaleKeys.settings.advanced.title.tr()) {
      Section(LocaleKeys.settings.general.section.permissions.tr()) {
        PermissionAccessRow(
          title: LocaleKeys.settings.general.row.screenCaptureAccess.tr(),
          isAllowed: viewModel.screenRecordingAllowed,
          onRequest: viewModel.requestScreenRecordingPermission
        )
        PermissionAccessRow(
          title: LocaleKeys.settings.general.row.screenSelectionAccess.tr(),
          isAllowed: viewModel.accessibilityAllowed,
          onRequest: viewModel.requestAccessibilityPermission
        )
      }
      .background(
        RoundedRectangle(cornerRadius: 6)
          .fill(isPermissionsHighlighted ? Color.accentColor.opacity(0.16) : Color.clear)
          .padding(.horizontal, -6)
          .padding(.vertical, -4)
      )
      .overlay(
        RoundedRectangle(cornerRadius: 6)
          .stroke(
            isPermissionsHighlighted ? Color.accentColor.opacity(0.55) : Color.clear,
            lineWidth: 1
          )
          .padding(.horizontal, -6)
          .padding(.vertical, -4)
      )

      Section {
        SettingToggle(
          LocaleKeys.settings.advanced.enable.tr(),
          isOn: Binding(
            get: { viewModel.apiServerEnabled },
            set: { viewModel.setApiServerEnabled($0) }
          )
        )

        if viewModel.apiServerEnabled {
          HStack {
            Text(LocaleKeys.settings.advanced.port.tr())
            Spacer()
            TextField(
              "",
              text: Binding(
                get: { String(viewModel.apiServerPort) },
                set: { viewModel.setApiServerPort($0) }
              )
            )
            .textFieldStyle(.roundedBorder)
            .multilineTextAlignment(.trailing)
            .frame(width: 72)
          }
        }
      } header: {
        Text(LocaleKeys.settings.advanced.apiServer.tr())
      } footer: {
        footer
      }
    }
    .task {
      await viewModel.load()
    }
    .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification))
    { _ in
      Task { await viewModel.refreshPermissions() }
    }
    .onAppear {
      handlePermissionsHighlight(highlightCoordinator.pendingHighlightPermissionsSectionID)
    }
    .onChange(of: highlightCoordinator.pendingHighlightPermissionsSectionID) { newValue in
      handlePermissionsHighlight(newValue)
    }
  }

  private func handlePermissionsHighlight(_ id: Int?) {
    guard let id, highlightCoordinator.consumeHighlightPermissionsSection(id) else { return }

    permissionsHighlightGeneration += 1
    let generation = permissionsHighlightGeneration

    withAnimation(.easeInOut(duration: 0.16)) {
      isPermissionsHighlighted = true
    }

    Task {
      try? await Task.sleep(nanoseconds: 1_600_000_000)
      guard generation == permissionsHighlightGeneration else { return }
      withAnimation(.easeInOut(duration: 0.24)) {
        isPermissionsHighlighted = false
      }
    }
  }

  @ViewBuilder
  private var footer: some View {
    if viewModel.apiServerEnabled, let apiServerURL {
      HStack(spacing: 0) {
        Text(runningAtPrefix)
        Link(apiServerURL.absoluteString, destination: apiServerURL)
      }
    } else {
      Text(LocaleKeys.settings.advanced.disabled.tr())
    }
  }

  private var apiServerURL: URL? {
    URL(string: "http://\(viewModel.apiServerHost):\(viewModel.apiServerPort)")
  }

  private var runningAtPrefix: String {
    let template = LocaleKeys.settings.advanced.runningAt.tr()
    return template.components(separatedBy: "{url}").first ?? ""
  }
}

private struct PermissionAccessRow: View {
  let title: String
  let isAllowed: Bool
  let onRequest: () -> Void

  var body: some View {
    HStack(alignment: .center) {
      Text(title)
      Spacer()

      ZStack(alignment: .trailing) {
        Button(action: {}) {
          Text(" ")
        }
        .opacity(0)
        .accessibilityHidden(true)
        .allowsHitTesting(false)

        if isAllowed {
          Text(LocaleKeys.settings.general.option.granted.tr())
            .foregroundStyle(.secondary)
        } else {
          Button(LocaleKeys.settings.general.button.grant.tr(), action: onRequest)
        }
      }
    }
  }
}
