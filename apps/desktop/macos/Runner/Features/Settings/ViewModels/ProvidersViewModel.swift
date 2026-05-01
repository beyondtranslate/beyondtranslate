import SwiftUI

final class ProvidersViewModel: ObservableObject {
  @Published var traditionalProviders: [ProviderItem]
  @Published var llmProviders: [ProviderItem]

  init(settings: ProviderSettings = ProviderSettings()) {
    traditionalProviders = settings.traditionalProviders
    llmProviders = settings.llmProviders
  }

  func toggleProvider(_ providerID: UUID, in listKind: ProviderListKind, isEnabled: Bool) {
    switch listKind {
    case .traditional:
      guard let index = traditionalProviders.firstIndex(where: { $0.id == providerID }) else { return }
      traditionalProviders[index].isEnabled = isEnabled
    case .llm:
      guard let index = llmProviders.firstIndex(where: { $0.id == providerID }) else { return }
      llmProviders[index].isEnabled = isEnabled
    }
  }

  func saveProvider(_ draft: ProviderDraft) {
    let capabilities: [ProviderCapability] =
      draft.listKind == .traditional
      ? [.translation, .dictionary]
      : [.chatCompletion]

    let item = ProviderItem(
      id: draft.providerID ?? UUID(),
      name: draft.name,
      endpoint: draft.endpoint,
      apiKeyHeader: draft.apiKeyHeader,
      description: draft.description,
      listKind: draft.listKind,
      hosting: draft.hosting,
      capabilities: capabilities,
      isEnabled: true
    )

    switch draft.listKind {
    case .traditional:
      upsert(item, into: &traditionalProviders)
    case .llm:
      upsert(item, into: &llmProviders)
    }
  }

  private func upsert(_ item: ProviderItem, into items: inout [ProviderItem]) {
    if let index = items.firstIndex(where: { $0.id == item.id }) {
      items[index] = item
    } else {
      items.append(item)
    }
  }
}
