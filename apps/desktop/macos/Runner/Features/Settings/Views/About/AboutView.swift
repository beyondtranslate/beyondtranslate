import SwiftUI

struct AboutView: View {
  @StateObject private var viewModel: AboutViewModel
  @State private var isCopied = false
  @State private var copyTask: Task<Void, Never>?

  init() {
    _viewModel = StateObject(wrappedValue: AboutViewModel())
  }

  var body: some View {
    SettingsPage(title: LocaleKeys.settings.about.title.tr()) {
      Section {
        VStack(spacing: 8) {
          Image(nsImage: NSApplication.shared.applicationIconImage)
            .resizable()
            .frame(width: 64, height: 64)

          Text("Beyond Translate")
            .font(.title2)
            .fontWeight(.semibold)

          Text(viewModel.fullVersionString)
            .foregroundStyle(.secondary)

          Button(
            action: {
              viewModel.copyVersionInfo()
              isCopied = true
              copyTask?.cancel()
              copyTask = Task {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                guard !Task.isCancelled else { return }
                isCopied = false
              }
            },
            label: {
              Label(
                isCopied
                  ? LocaleKeys.common.ui.feedback.copied.tr()
                  : LocaleKeys.settings.about.copyVersionInfo.tr(),
                systemImage: isCopied ? "checkmark" : "doc.on.doc"
              )
            }
          )
          .buttonStyle(.plain)
          .foregroundColor(.accentColor)
          .controlSize(.small)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
      }

      Section {
        HStack {
          VStack(alignment: .leading, spacing: 2) {
            Text(LocaleKeys.app.tray.contextMenu.checkForUpdates.tr())
              .font(.body)
            Text(LocaleKeys.settings.about.upToDate.tr())
              .font(.caption)
              .foregroundStyle(.secondary)
          }
          Spacer()
          Button(LocaleKeys.settings.about.checkAgain.tr()) {
            // TODO: Implement check for updates
          }
        }

        LinkRow(
          icon: "doc.text.magnifyingglass",
          title: LocaleKeys.settings.about.openChangelog.tr(),
          url: URL(string: "https://github.com/beyondtranslate/beyondtranslate/releases")!
        )
      }

      Section(LocaleKeys.settings.about.links.tr()) {
        LinkRow(
          icon: "globe",
          title: LocaleKeys.settings.about.website.tr(),
          url: URL(string: "https://beyondtranslate.com")!
        )
        LinkRow(
          icon: "link",
          title: LocaleKeys.settings.about.github.tr(),
          url: URL(string: "https://github.com/beyondtranslate/beyondtranslate")!
        )
        LinkRow(
          icon: "ant",
          title: LocaleKeys.settings.about.reportIssue.tr(),
          url: URL(string: "https://github.com/beyondtranslate/beyondtranslate/issues")!
        )
        HStack {
          Image(systemName: "doc.plaintext")
            .frame(width: 20)
          Text(LocaleKeys.settings.about.license.tr())
          Spacer()
          Text("AGPL-3.0")
            .foregroundStyle(.secondary)
        }
      }
    }
  }
}

private struct LinkRow: View {
  let icon: String
  let title: String
  let url: URL

  var body: some View {
    HStack {
      Image(systemName: icon)
        .frame(width: 20)
      Text(title)
      Spacer()
      Link(destination: url) {
        Image(systemName: "arrow.up.right.square")
          .foregroundStyle(.secondary)
      }
    }
  }
}

#if DEBUG
  struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        AboutView()
          .previewDisplayName("About - Light")

        AboutView()
          .preferredColorScheme(.dark)
          .previewDisplayName("About - Dark")
      }
      .frame(width: 720, height: 600)
    }
  }
#endif
