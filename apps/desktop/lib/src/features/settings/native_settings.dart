import 'dart:io';

import 'package:flutter/services.dart';

import 'desktop_settings_service.dart';

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
          final settings = await desktopSettingsService.getSettings();
          return <String, dynamic>{
            'theme': settings.windowTheme,
            'language': settings.windowLanguage,
          };
        case 'setTheme':
          final arguments = Map<dynamic, dynamic>.from(
            (call.arguments as Map?) ?? const <dynamic, dynamic>{},
          );
          final settings = await desktopSettingsService.setTheme(
            '${arguments['theme'] ?? ''}',
          );
          return <String, dynamic>{
            'theme': settings.windowTheme,
            'language': settings.windowLanguage,
          };
        case 'setLanguage':
          final arguments = Map<dynamic, dynamic>.from(
            (call.arguments as Map?) ?? const <dynamic, dynamic>{},
          );
          final settings = await desktopSettingsService.setLanguage(
            '${arguments['language'] ?? ''}',
          );
          return <String, dynamic>{
            'theme': settings.windowTheme,
            'language': settings.windowLanguage,
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
