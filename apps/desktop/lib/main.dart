// ignore_for_file: implementation_imports, invalid_use_of_internal_member

import 'dart:io';

import 'package:beyondtranslate_desktop/src/rust/frb_generated.dart';
import 'package:flutter/material.dart';
import 'package:launch_at_startup/launch_at_startup.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:protocol_handler/protocol_handler.dart';

import 'src/extensions/window_controller.dart';
import 'src/i18n/i18n.dart';
import 'src/routes/app_router.dart';
import 'src/services/native_settings.dart';
import 'src/services/settings_store.dart';
import 'src/utils/env.dart';
import 'src/utils/language_util.dart';
import 'src/utils/platform_util.dart';

Future<void> _ensureInitialized() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();

  if (kIsMacOS || kIsWindows) {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    LaunchAtStartup.instance.setup(
      appName: packageInfo.appName,
      appPath: Platform.resolvedExecutable,
    );
    await protocolHandler.register('biyiapp');
  }

  await initEnv();
  await settingsStore.init();
  NativeSettings.registerMethodCallHandler();
}

void main() async {
  await _ensureInitialized();

  setupGlobalWillShowHook();
  setupGlobalWillHideHook();

  await LocaleSettings.setLocaleRaw(
    languageToLocale(settingsStore.appLanguage).languageCode,
  );

  runWidget(const RootView());
}
