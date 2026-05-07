import 'dart:io';

import 'package:flutter/services.dart';

class MacWindowAppearance {
  static const MethodChannel _channel =
      MethodChannel('beyondtranslate/mac_window_appearance');

  static Future<void> apply(String title) async {
    if (!Platform.isMacOS) return;

    await _channel.invokeMethod<void>(
      'apply',
      {'title': title},
    );
  }
}
