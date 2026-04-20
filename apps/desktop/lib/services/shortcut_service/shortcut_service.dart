import '../services.dart';
import '../../utils/utils.dart';
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

class ShortcutService {
  ShortcutService._();

  /// The shared instance of [ShortcutService].
  static final ShortcutService instance = ShortcutService._();

  ShortcutListener? _listener;

  Configuration get _configuration => localDb.configuration;

  void setListener(ShortcutListener? listener) {
    _listener = listener;
  }

  void start() async {
    await hotKeyManager.unregisterAll();
    await hotKeyManager.register(
      _configuration.shortcutShowOrHide,
      keyDownHandler: (_) {
        _listener?.onShortcutKeyDownShowOrHide();
      },
    );
    await hotKeyManager.register(
      _configuration.shortcutExtractFromScreenSelection,
      keyDownHandler: (_) {
        _listener?.onShortcutKeyDownExtractFromScreenSelection();
      },
    );
    if (!kIsLinux) {
      await hotKeyManager.register(
        _configuration.shortcutExtractFromScreenCapture,
        keyDownHandler: (_) {
          _listener?.onShortcutKeyDownExtractFromScreenCapture();
        },
      );
    }
    await hotKeyManager.register(
      _configuration.shortcutExtractFromClipboard,
      keyDownHandler: (_) {
        _listener?.onShortcutKeyDownExtractFromClipboard();
      },
    );
    if (!kIsLinux) {
      await hotKeyManager.register(
        _configuration.shortcutTranslateInputContent,
        keyDownHandler: (_) {
          _listener?.onShortcutKeyDownTranslateInputContent();
        },
      );
    }
  }

  void stop() {
    hotKeyManager.unregisterAll();
  }
}
