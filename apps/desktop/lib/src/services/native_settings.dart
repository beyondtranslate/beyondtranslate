import 'dart:io';

import 'package:flutter/services.dart';

import '../rust/domain/settings.dart';
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
            AppearanceSettingsPatch(
              language: args['language'] as String?,
              themeMode: args['themeMode'] as String?,
            ),
          );
          return {'language': result.language, 'themeMode': result.themeMode};

        case 'settings.getShortcuts':
          final result = await settings.getShortcuts();
          return {
            'toggleApp': result.toggleApp,
            'hideApp': result.hideApp,
            'extractFromScreenSelection': result.extractFromScreenSelection,
            'extractFromScreenCapture': result.extractFromScreenCapture,
            'extractFromClipboard': result.extractFromClipboard,
          };

        case 'settings.updateShortcuts':
          final args = (call.arguments as Map).cast<String, dynamic>();
          final result = await settings.updateShortcuts(
            ShortcutSettingsPatch(
              toggleApp: args['toggleApp'] as String?,
              hideApp: args['hideApp'] as String?,
              extractFromScreenSelection:
                  args['extractFromScreenSelection'] as String?,
              extractFromScreenCapture:
                  args['extractFromScreenCapture'] as String?,
              extractFromClipboard: args['extractFromClipboard'] as String?,
            ),
          );
          return {
            'toggleApp': result.toggleApp,
            'hideApp': result.hideApp,
            'extractFromScreenSelection': result.extractFromScreenSelection,
            'extractFromScreenCapture': result.extractFromScreenCapture,
            'extractFromClipboard': result.extractFromClipboard,
          };

        case 'settings.getAdvanced':
          final result = await settings.getAdvanced();
          return {'launchAtLogin': result.launchAtLogin};

        case 'settings.updateAdvanced':
          final args = (call.arguments as Map).cast<String, dynamic>();
          final result = await settings.updateAdvanced(
            AdvancedSettingsPatch(
              launchAtLogin: args['launchAtLogin'] as bool?,
            ),
          );
          return {'launchAtLogin': result.launchAtLogin};

        case 'settings.listProviders':
          final providers = await settings.listProviders();
          return providers
              .map((p) => {
                    'id': p.id,
                    'type': p.type,
                    'fields': p.fields,
                    'capabilities': p.capabilities
                  })
              .toList();

        case 'settings.updateProvider':
          final args = (call.arguments as Map).cast<String, dynamic>();
          final result = await settings.updateProvider(
            providerId: args['id'] as String,
            providerType: args['providerType'] as String,
            fields: (args['fields'] as Map).cast<String, String>(),
          );
          return {
            'id': result.id,
            'type': result.type,
            'fields': result.fields,
            'capabilities': <String>[]
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
            'fields': result.fields,
            'capabilities': <String>[]
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
