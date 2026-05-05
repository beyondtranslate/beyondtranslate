// ignore_for_file: invalid_use_of_internal_member, implementation_imports

import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/src/widgets/_window.dart' hide WindowManager;
import 'package:nativeapi/nativeapi.dart';

final Map<String, Window> _windows = {};
final Map<String, bool Function(Window window)> _windowWillShowHooks = {};
final Map<String, bool Function(Window window)> _windowWillHideHooks = {};

bool _globalWillShowHookInitialized = false;
bool _globalWillHideHookInitialized = false;

void setupGlobalWillShowHook() {
  if (_globalWillShowHookInitialized) return;
  _globalWillShowHookInitialized = true;
  WindowManager.instance.setWillShowHook((windowId) {
    final window = WindowManager.instance.getAll().firstWhereOrNull(
          (e) => e.id == windowId,
        );
    if (window != null) {
      if (window.title == 'Settings') return true;
      window._incrementShowCount();
      final hook = _windowWillShowHooks[window.title];
      if (hook != null) {
        return hook(window);
      }
    }
    return false;
  });
}

void setupGlobalWillHideHook() {
  if (_globalWillHideHookInitialized) return;
  _globalWillHideHookInitialized = true;
  WindowManager.instance.setWillHideHook((windowId) {
    final window = WindowManager.instance.getAll().firstWhereOrNull(
          (e) => e.id == windowId,
        );
    if (window != null) {
      if (window.title == 'Settings') return true;
      final hook = _windowWillHideHooks[window.title];
      if (hook != null) {
        return hook(window);
      }
    }
    return false;
  });
}

/// Extension for the RegularWindowController to add hooks for the window.
extension ExtendedRegularWindowController on RegularWindowController {
  /// Get the window by the title.
  /// Returns the window if found, throws an exception otherwise.
  Window get window {
    if (_windows.containsKey(title)) return _windows[title]!;
    final windows = WindowManager.instance.getAll();
    final window = windows.firstWhereOrNull((e) => e.title == title);
    if (window == null) {
      throw Exception('Can\'t find the window with title: $title');
    }
    _windows[title] = window;
    return window;
  }

  /// Set the hook to be called when the window is shown.
  /// [callback] The callback to be called when the window is shown.
  /// Returns true if the window should be shown, false otherwise.
  void setWillShowHook(bool Function(Window window) callback) {
    _windowWillShowHooks[title] = callback;
  }

  /// Set the hook to be called when the window is hidden.
  /// [callback] The callback to be called when the window is hidden.
  /// Returns true if the window should be hidden, false otherwise.
  void setWillHideHook(bool Function(Window window) callback) {
    _windowWillHideHooks[title] = callback;
  }
}

extension ExtendedWindow on Window {
  static final Map<int, int> _showCounts = {};

  /// Whether the window is the first time to be shown.
  bool get isFirstShow {
    final showCount = _showCounts.containsKey(id) ? _showCounts[id]! : 0;
    return Platform.isMacOS ? showCount <= 2 : showCount <= 1;
  }

  /// Increment the show count.
  void _incrementShowCount() {
    final showCount = _showCounts.containsKey(id) ? _showCounts[id]! : 0;
    _showCounts[id] = showCount + 1;
  }
}
