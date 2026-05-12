import Foundation

struct ProviderConfigField: Identifiable {
  var id: String { key }
  let key: String
  let label: String
  let placeholder: String
  let isSecret: Bool
  let isOptional: Bool
}
