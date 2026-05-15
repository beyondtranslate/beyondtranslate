struct ShortcutDisplay {
  let parts: [String]

  init(parts: [String]) {
    self.parts = parts
  }

  init(rawValue: String) {
    let parsed =
      rawValue
      .split(separator: "+")
      .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
      .filter { !$0.isEmpty }
    parts = parsed
  }

  var rawValue: String {
    parts.joined(separator: "+")
  }

  var displayText: String {
    parts.joined(separator: "")
  }
}
