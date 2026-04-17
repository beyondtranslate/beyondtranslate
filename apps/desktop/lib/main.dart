import 'dart:io';

import 'package:biyi_app/models/models.dart';
import 'i18n/i18n.dart';
import 'pages/pages.dart';
import 'services/services.dart';
import 'themes/themes.dart';
import 'utilities/utilities.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:protocol_handler/protocol_handler.dart';
import 'package:window_manager/window_manager.dart';

import 'routes/routes.dart';

Future<void> _ensureInitialized() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsLinux || kIsMacOS || kIsWindows) {
    await windowManager.ensureInitialized();
  }

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

  runApp(
    TranslationProvider(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with LocalDbListener {
  late final GoRouter _router = createAppRouter();

  Configuration get _configuration => localDb.configuration;

  @override
  void initState() {
    localDb.addListener(this);
    localDb.preferences.addListener(_handleChanged);
    super.initState();
  }

  @override
  void dispose() {
    localDb.removeListener(this);
    localDb.preferences.removeListener(_handleChanged);
    super.dispose();
  }

  void _handleChanged() async {
    Locale oldLocale = context.locale;
    Locale newLocale = languageToLocale(_configuration.appLanguage);
    if (newLocale != oldLocale) {
      await context.setLocale(newLocale);
    }

    await windowManager.setBrightness(
      _configuration.themeMode == ThemeMode.dark
          ? Brightness.dark
          : Brightness.light,
    );

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: lightThemeData,
      darkTheme: darkThemeData,
      themeMode: _configuration.themeMode,
      builder: (context, child) {
        if (kIsLinux || kIsWindows) {
          child = Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(7),
                  topRight: Radius.circular(7),
                ),
                child: child,
              ),
              const DragToMoveArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 34,
                ),
              ),
            ],
          );
        }
        child = botToastBuilder(context, child);
        return child;
      },
      routerConfig: _router,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }

  @override
  void onUserChanged(User oldUser, User newUser) {
    _handleChanged();
  }
}
