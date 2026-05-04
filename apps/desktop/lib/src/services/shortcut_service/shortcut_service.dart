import 'package:hotkey_manager/hotkey_manager.dart';

abstract mixin class ShortcutListener {
  void onShortcutKeyDownShowOrHide();
  void onShortcutKeyDownHide();
  void onShortcutKeyDownExtractFromScreenSelection();
  void onShortcutKeyDownExtractFromScreenCapture();
  void onShortcutKeyDownExtractFromClipboard();
  void onShortcutKeyDownTranslateInputContent();
  void onShortcutKeyDownSubmitWithMateEnter();
}

/// Manages global hotkeys for the mini translator.
///
/// Shortcut bindings now live in the Rust runtime (see
/// `RuntimeSettings.getShortcuts`), but they are persisted as opaque strings
/// (e.g. `"Alt+Q"`) and not yet parsed into [HotKey] instances. Until that
/// pipeline is wired up, this service acts as a thin no-op that still exposes
/// the listener contract used by the rest of the app.
class ShortcutService {
  ShortcutService._();

  /// The shared instance of [ShortcutService].
  static final ShortcutService instance = ShortcutService._();

  ShortcutListener? _listener;

  void setListener(ShortcutListener? listener) {
    _listener = listener;
  }

  // Kept for API compatibility with call sites; the Rust runtime is the
  // source of truth for shortcut bindings, but no platform registration is
  // performed here yet.
  void start() async {
    await hotKeyManager.unregisterAll();
  }

  void stop() {
    hotKeyManager.unregisterAll();
  }

  // Hooks for tests / future direct invocation.
  void notifyShowOrHide() => _listener?.onShortcutKeyDownShowOrHide();
  void notifyHide() => _listener?.onShortcutKeyDownHide();
  void notifyExtractSelection() =>
      _listener?.onShortcutKeyDownExtractFromScreenSelection();
  void notifyExtractCapture() =>
      _listener?.onShortcutKeyDownExtractFromScreenCapture();
  void notifyExtractClipboard() =>
      _listener?.onShortcutKeyDownExtractFromClipboard();
  void notifyTranslateInputContent() =>
      _listener?.onShortcutKeyDownTranslateInputContent();
  void notifySubmitWithMetaEnter() =>
      _listener?.onShortcutKeyDownSubmitWithMateEnter();
}
