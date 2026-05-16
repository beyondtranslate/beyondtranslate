import SwiftUI
import beyondtranslate_runtime

@MainActor
final class SettingsHighlightCoordinator: ObservableObject {
  static let shared = SettingsHighlightCoordinator()

  @Published private(set) var pendingHighlightPermissionsSectionID: Int? = nil

  private init() {}

  func requestHighlightPermissionsSection() {
    pendingHighlightPermissionsSectionID = (pendingHighlightPermissionsSectionID ?? 0) + 1
  }

  func consumeHighlightPermissionsSection(_ id: Int) -> Bool {
    guard pendingHighlightPermissionsSectionID == id else { return false }
    pendingHighlightPermissionsSectionID = nil
    return true
  }
}

@MainActor
final class SettingsViewModel: ObservableObject {
  let general: GeneralViewModel
  let appearance: AppearanceViewModel
  let shortcuts: ShortcutsViewModel
  let providers: ProvidersViewModel
  let advanced: AdvancedViewModel

  private let repository: SettingsRepository

  /// Long-running task that consumes [`SettingsChange`] events from the
  /// shared Rust runtime so changes initiated by the Flutter side (or any
  /// other [`RuntimeSettings`] handle in this process) automatically
  /// refresh the relevant sub-view-model.
  private var changeListenerTask: Task<Void, Never>?

  init(repository: SettingsRepository? = nil) {
    let repository = repository ?? DefaultSettingsRepository()
    self.repository = repository

    general = GeneralViewModel(repository: repository)
    appearance = AppearanceViewModel(repository: repository)
    shortcuts = ShortcutsViewModel(repository: repository)
    providers = ProvidersViewModel(repository: repository)
    advanced = AdvancedViewModel(repository: repository)

    Task {
      await general.load()
      await appearance.load()
      await shortcuts.load()
      await providers.load()
      await advanced.load()
    }

    startListeningForChanges()
  }

  deinit {
    changeListenerTask?.cancel()
  }

  /// Subscribes to runtime [`SettingsChange`] events and reloads the
  /// affected sub-view-model on the main actor. Idempotent.
  private func startListeningForChanges() {
    guard changeListenerTask == nil else { return }
    let subscription = RuntimeProvider.shared.settings().subscribe()
    changeListenerTask = Task { [weak self] in
      while !Task.isCancelled {
        let change: SettingsChange?
        do {
          change = try await subscription.next()
        } catch {
          break
        }
        guard let change else { break }
        guard let self else { break }
        await self.handle(change: change)
      }
    }
  }

  private func handle(change: SettingsChange) async {
    switch change {
    case .general:
      await general.load()
    case .appearance:
      await appearance.load()
    case .shortcuts:
      await shortcuts.load()
    case .providers:
      // Silent refresh — operations are fast, and save/delete already update
      // the local array in-place. This refresh is only needed for cross-process
      // synchronization (e.g. changes from the Flutter side).
      await providers.load()
      // Translation/dictionary service pickers in General also depend on
      // the provider list, so refresh it as well.
      await general.load()
    case .advanced:
      await advanced.load()
    }
  }
}
