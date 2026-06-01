import AppKit
import SwiftUI
import beyondtranslate_runtime

// MARK: - Provider Type Icon

struct ProviderTypeIcon: View {
  let providerType: ProviderType

  private var iconImage: NSImage? {
    let iconFileName = "\(providerType.wireValue).png"
    let flutterAssetsURL = Bundle.main.bundleURL
      .appendingPathComponent("Contents/Frameworks/App.framework/Resources/flutter_assets")
      .appendingPathComponent("resources/images/ai_provider_icons")
      .appendingPathComponent(iconFileName)
    return NSImage(contentsOf: flutterAssetsURL)
  }

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 5, style: .continuous)
        .fill(Color.accentColor.opacity(0.15))

      if let nsImage = iconImage {
        Image(nsImage: nsImage)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .padding(3)
      } else {
        Image(systemName: "server.rack")
          .font(.system(size: 11, weight: .medium))
          .foregroundStyle(Color.accentColor)
      }
    }
    .frame(width: 20, height: 20)
  }
}
