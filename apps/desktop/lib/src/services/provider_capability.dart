/// Represents a feature capability that a translation/dictionary provider
/// can support.
///
/// Capabilities are stored as strings in [ProviderConfigEntry.capabilities]
/// (serialised from Rust via serde). Use [ProviderCapability.name] to obtain
/// the string representation for comparison:
///
/// ```dart
/// if (provider.capabilities.contains(ProviderCapability.dictionary.name)) {
///   // provider supports dictionary look-up
/// }
/// ```
enum ProviderCapability {
  dictionary,
  translation,
}
