// ignore_for_file: implementation_imports, invalid_use_of_internal_member

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/_window.dart';
import 'package:go_router/go_router.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:protocol_handler/protocol_handler.dart';

import './i18n/i18n.dart';
import './i18n/strings.g.dart';
import './routes/app_router.dart';
import './routes/settings/index.dart';
import './services/local_db/configuration.dart';
import './services/local_db/local_db.dart';
import './themes/dark_theme.dart';
import './themes/light_theme.dart';
import './utils/env.dart';
import './utils/language_util.dart';
import './utils/platform_util.dart';
import 'features/mini_translator/mini_translator_app.dart';
import 'windowing/window_controllers.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final GoRouter _router = createAppRouter(
    initialLocation: const SettingsRoute().location,
  );

  Configuration get _configuration => localDb.configuration;

  @override
  void initState() {
    localDb.preferences.addListener(_handleChanged);
    super.initState();
  }

  @override
  void dispose() {
    localDb.preferences.removeListener(_handleChanged);
    super.dispose();
  }

  Future<void> _handleChanged() async {
    final oldLocale = context.locale;
    final newLocale = languageToLocale(_configuration.appLanguage);
    if (newLocale != oldLocale) {
      await context.setLocale(newLocale);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return RegularWindow(
      controller: mainWindowController,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: lightThemeData,
        darkTheme: darkThemeData,
        themeMode: _configuration.themeMode,
        builder: (context, child) {
          if (kIsLinux || kIsWindows) {
            child = ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(7),
                topRight: Radius.circular(7),
              ),
              child: child,
            );
          }
          return child!;
        },
        routerConfig: _router,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
      ),
    );
  }
}

Future<void> _ensureInitialized() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsMacOS || kIsWindows) {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    LaunchAtStartup.instance.setup(
      appName: packageInfo.appName,
      appPath: Platform.resolvedExecutable,
    );
    await protocolHandler.register('biyiapp');
  }

  await initEnv();
  await initLocalDb();
}

void main() async {
  await _ensureInitialized();
  await LocaleSettings.setLocaleRaw(
    languageToLocale(localDb.configuration.appLanguage).languageCode,
  );

  setupGlobalWindowHooks();

  runWidget(
    TranslationProvider(
      child: const ViewCollection(
        views: [
          MainApp(),
          MiniTranslatorApp(),
        ],
      ),
    ),
  );
}
