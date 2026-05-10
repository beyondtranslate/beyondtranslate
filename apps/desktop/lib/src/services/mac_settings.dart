import 'dart:io';

import 'package:flutter/services.dart';

/// Thin wrapper around the `beyondtranslate/mac_settings` Flutter method
/// channel.
///
/// The channel only exposes window-management entry points
/// ([show], [highlightPermissions]); all settings reads/writes are owned
/// directly by the native macOS Settings UI through the Rust runtime's
/// Swift bindings.
class MacSettings {
  static const MethodChannel _channel =
      MethodChannel('beyondtranslate/mac_settings');

  static Future<void> show() async {
    if (!Platform.isMacOS) return;

    await _channel.invokeMethod<void>('showSettings');
  }

  static Future<void> highlightPermissions() async {
    if (!Platform.isMacOS) return;

    await _channel.invokeMethod<void>('highlightPermissions');
  }

  static Future<void> showAndHighlightPermissions() async {
    if (!Platform.isMacOS) return;

    await show();
    await highlightPermissions();
  }
}
