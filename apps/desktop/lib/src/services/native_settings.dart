import 'dart:io';

import 'package:flutter/services.dart';

import '../rust/api/runtime.dart';
import 'runtime.dart' as runtime_service;

class NativeSettings {
  static const MethodChannel _channel =
      MethodChannel('beyondtranslate/native_settings');

  static bool _handlerRegistered = false;

  static void registerMethodCallHandler() {
    if (_handlerRegistered) {
      return;
    }

    _channel.setMethodCallHandler((call) async {
      final settings = runtime_service.runtime.settings();
      switch (call.method) {
        case 'settings.getAppearance':
          final result = await settings.getAppearance();
          return {'language': result.language, 'themeMode': result.themeMode};

        case 'settings.updateAppearance':
          final args = (call.arguments as Map).cast<String, dynamic>();
          final result = await settings.updateAppearance(
            patch: AppearanceSettingsPatch(
              language: args['language'] as String?,
              themeMode: args['themeMode'] as String?,
            ),
          );
          return {'language': result.language, 'themeMode': result.themeMode};

        case 'settings.getShortcuts':
          final result = await settings.getShortcuts();
          return {'toggleApp': result.toggleApp};

        case 'settings.updateShortcuts':
          final args = (call.arguments as Map).cast<String, dynamic>();
          final result = await settings.updateShortcuts(
            patch: ShortcutSettingsPatch(
              toggleApp: args['toggleApp'] as String?,
            ),
          );
          return {'toggleApp': result.toggleApp};

        case 'settings.getAdvanced':
          final result = await settings.getAdvanced();
          return {'launchAtLogin': result.launchAtLogin, 'proxy': result.proxy};

        case 'settings.updateAdvanced':
          final args = (call.arguments as Map).cast<String, dynamic>();
          final result = await settings.updateAdvanced(
            patch: AdvancedSettingsPatch(
              launchAtLogin: args['launchAtLogin'] as bool?,
              proxy: args['proxy'] as String?,
            ),
          );
          return {'launchAtLogin': result.launchAtLogin, 'proxy': result.proxy};

        case 'settings.listProviders':
          final providers = await settings.listProviders();
          return providers
              .map((p) =>
                  {'id': p.id, 'type': p.type, 'configYaml': p.configYaml})
              .toList();

        case 'settings.updateProvider':
          final args = (call.arguments as Map).cast<String, dynamic>();
          final result = await settings.updateProvider(
            providerId: args['id'] as String,
            configYaml: args['configYaml'] as String,
          );
          return {
            'id': result.id,
            'type': result.type,
            'configYaml': result.configYaml
          };

        case 'settings.deleteProvider':
          final args = (call.arguments as Map).cast<String, dynamic>();
          final result = await settings.deleteProvider(
            providerId: args['id'] as String,
          );
          if (result == null) return null;
          return {
            'id': result.id,
            'type': result.type,
            'configYaml': result.configYaml
          };

        default:
          throw MissingPluginException(
              'Unknown native settings method: ${call.method}');
      }
    });

    _handlerRegistered = true;
  }

  static Future<void> show() async {
    if (!Platform.isMacOS) return;

    await _channel.invokeMethod<void>('showSettings');
  }
}
