import SwiftUI
import beyondtranslate_runtime

/// A unified row that displays a service with a colored type icon, name,
/// type label, and an enable/disable toggle.
///
/// Used in both the Services settings page and the Provider detail page.
struct ServiceRowView: View {
  let service: ServiceConfigEntry
  let provider: ProviderConfigEntry?

  @State private var isEnabled = true

  var body: some View {
    HStack(spacing: 10) {
      // Colored icon based on service type
      ZStack {
        RoundedRectangle(cornerRadius: 5, style: .continuous)
          .fill(serviceTypeColor.opacity(0.15))
        Image(systemName: serviceTypeSystemImage)
          .font(.system(size: 11, weight: .medium))
          .foregroundStyle(serviceTypeColor)
      }
      .frame(width: 20, height: 20)

      Text(serviceName)
        .font(.system(size: 13))
        .foregroundStyle(.primary)
        .lineLimit(1)

      Spacer()

      Toggle("", isOn: $isEnabled)
        .labelsHidden()
        .toggleStyle(.switch)
    }
  }

  // MARK: - Service Type Helpers

  private var serviceName: String {
    let name = service.name.isEmpty ? service.id : service.name
    return "\(name) · \(serviceTypeDisplayName)"
  }

  private var serviceTypeColor: Color {
    switch service.type {
    case .translation: return .blue
    case .ocr: return .green
    case .llm: return .purple
    default: return .gray
    }
  }

  private var serviceTypeSystemImage: String {
    switch service.type {
    case .translation: return "character.bubble"
    case .ocr: return "text.viewfinder"
    case .llm: return "sparkles"
    default: return "questionmark"
    }
  }

  private var serviceTypeDisplayName: String {
    switch service.type {
    case .translation:
      return LocaleKeys.settings.providers.capability.translation.tr()
    case .ocr:
      return LocaleKeys.settings.providers.capability.ocr.tr()
    case .llm:
      return "AI"
    default:
      return ""
    }
  }
}
