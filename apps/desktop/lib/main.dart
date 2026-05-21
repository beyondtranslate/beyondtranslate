import 'dart:io';
import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart'
    as beyondtranslate_runtime;
import 'package:flutter/material.dart';
import 'package:launch_at_startup/launch_at_startup.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:protocol_handler/protocol_handler.dart';

import 'src/extensions/window_controller.dart';
import 'src/i18n/i18n.dart';
import 'src/routes/app_router.dart';
import 'src/services/runtime.dart' show initRuntime;
import 'src/services/settings_store.dart';
import 'src/utils/env.dart';
import 'src/utils/language_util.dart';
import 'src/utils/platform_util.dart';

Future<void> _ensureInitialized() async {
  WidgetsFlutterBinding.ensureInitialized();
  _smokeTestBeyondtranslateRuntime();
  await initRuntime();

  if (kIsMacOS || kIsWindows) {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    LaunchAtStartup.instance.setup(
      appName: packageInfo.appName,
      appPath: Platform.resolvedExecutable,
    );
    await protocolHandler.register('beyondtranslate');
  }

  await initEnv();
  await settingsStore.init();
}

void _smokeTestBeyondtranslateRuntime() {
  beyondtranslate_runtime.ensureInitialized();
  debugPrint(
    '[beyondtranslate_runtime] Dart version() = '
    '${beyondtranslate_runtime.version()}',
  );
  debugPrint(
    '[beyondtranslate_runtime] Dart add(a: 2, b: 3) = '
    '${beyondtranslate_runtime.add(a: 2, b: 3)}',
  );
  debugPrint(
    '[beyondtranslate_runtime] Dart greet(name: "main.dart") = '
    '${beyondtranslate_runtime.greet(name: 'main.dart')}',
  );
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
