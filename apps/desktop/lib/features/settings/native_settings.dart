import 'dart:io';

import 'package:flutter/services.dart';

class NativeSettings {
  static const MethodChannel _channel =
      MethodChannel('beyondtranslate/native_settings');

  static Future<void> show() async {
    if (!Platform.isMacOS) return;

    await _channel.invokeMethod<void>('showSettings');
  }
}
