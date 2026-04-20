// ignore_for_file: implementation_imports, invalid_use_of_internal_member

import 'dart:io';
import 'dart:ui' show Size;

import 'package:collection/collection.dart';
import 'package:flutter/src/widgets/_window.dart' show RegularWindowController;
import 'package:nativeapi/nativeapi.dart'
    show TitleBarStyle, Window, WindowManager;

const kMainWindowTitle = 'biyi';
const kMiniTranslatorWindowTitle = 'biyi mini translator';

final Map<String, Window> _windows = {};
final Map<String, bool Function(Window window)> _windowWillShowHooks = {};

bool _globalWillShowHookInitialized = false;

void setupGlobalWindowHooks() {
  if (_globalWillShowHookInitialized) return;
  _globalWillShowHookInitialized = true;

  WindowManager.instance.setWillShowHook((windowId) {
    final window = WindowManager.instance.getAll().firstWhereOrNull(
          (item) => item.id == windowId,
        );
    if (window == null) return false;

    window.incrementShowCount();

    final hook = _windowWillShowHooks[window.title];
    if (hook != null) {
      return hook(window);
    }
    return true;
  });
}

final mainWindowController = RegularWindowController(
  preferredSize: const Size(960, 720),
  title: kMainWindowTitle,
)..setWillShowHook((window) {
    if (window.isFirstShow) {
      window.titleBarStyle = TitleBarStyle.hidden;
      window.center();
      Future.microtask(window.hide);
    }
    return true;
  });

final miniTranslatorWindowController = RegularWindowController(
  preferredSize: const Size(380, 420),
  title: kMiniTranslatorWindowTitle,
)..setWillShowHook((window) {
    if (window.isFirstShow) {
      window.titleBarStyle = TitleBarStyle.hidden;
      window.windowControlButtonsVisible = false;
      if (Platform.isMacOS) {
        window.center();
      }
    }
    return true;
  });

extension ExtendedRegularWindowController on RegularWindowController {
  Window get window {
    if (_windows.containsKey(title)) return _windows[title]!;

    final window = WindowManager.instance.getAll().firstWhereOrNull(
          (item) => item.title == title,
        );

    if (window == null) {
      throw StateError('Cannot find window with title: $title');
    }

    _windows[title] = window;
    return window;
  }

  void setWillShowHook(bool Function(Window window) callback) {
    _windowWillShowHooks[title] = callback;
  }
}

extension ExtendedWindow on Window {
  static final Map<int, int> _showCounts = {};

  bool get isFirstShow {
    final showCount = _showCounts[id] ?? 0;
    return Platform.isMacOS ? showCount <= 2 : showCount <= 1;
  }

  void incrementShowCount() {
    _showCounts[id] = (_showCounts[id] ?? 0) + 1;
  }
}
