import 'dart:io';

import 'package:flutter/services.dart';

class NativeSettings {
  static const MethodChannel _channel =
      MethodChannel('beyondtranslate/native_settings');

  static bool _handlerRegistered = false;

  static void registerMethodCallHandler() {
    if (_handlerRegistered) {
      return;
    }

    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'getSettings':
          return <String, dynamic>{
            'theme': 'light',
            'language': 'en',
          };
        case 'setTheme':
          return <String, dynamic>{
            'theme': 'light',
            'language': 'en',
          };
        case 'setLanguage':
          return <String, dynamic>{
            'theme': 'light',
            'language': 'en',
          };
        default:
          throw MissingPluginException('Unknown native settings method');
      }
    });

    _handlerRegistered = true;
  }

  static Future<void> show() async {
    if (!Platform.isMacOS) return;

    await _channel.invokeMethod<void>('showSettings');
  }
}
