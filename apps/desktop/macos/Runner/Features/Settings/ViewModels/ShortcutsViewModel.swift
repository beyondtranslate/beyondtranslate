import SwiftUI

final class ShortcutsViewModel: ObservableObject {
  @Published var showOrHide: ShortcutDisplay
  @Published var hide: ShortcutDisplay
  @Published var extractSelection: ShortcutDisplay
  @Published var extractCapture: ShortcutDisplay
  @Published var extractClipboard: ShortcutDisplay
  @Published var translateInput: ShortcutDisplay

  init(settings: ShortcutSettings = ShortcutSettings()) {
    showOrHide = settings.showOrHide
    hide = settings.hide
    extractSelection = settings.extractSelection
    extractCapture = settings.extractCapture
    extractClipboard = settings.extractClipboard
    translateInput = settings.translateInput
  }
}
