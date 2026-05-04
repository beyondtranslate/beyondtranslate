// ignore_for_file: implementation_imports, invalid_use_of_internal_member

import 'dart:io';

import 'package:beyondtranslate_desktop/src/rust/frb_generated.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/src/widgets/_window.dart';
import 'package:go_router/go_router.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:nativeapi/nativeapi.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:protocol_handler/protocol_handler.dart';

import 'src/extensions/window_controller.dart';
import 'src/features/mini_translator/mini_translator_app.dart';
import 'src/i18n/i18n.dart';
import 'src/routes/app_router.dart';
import 'src/routes/settings/index.dart';
import 'src/services/native_settings.dart';
import 'src/services/settings_store.dart';
import 'src/utils/env.dart';
import 'src/utils/language_util.dart';
import 'src/utils/platform_util.dart';
import 'src/widgets/ui/themes/dark_theme.dart';
import 'src/widgets/ui/themes/light_theme.dart';

const _kMainAppTitle = 'Beyond Translate';

final mainWindowController = RegularWindowController(
  preferredSize: const Size(900, 600),
  title: _kMainAppTitle,
)..setWillShowHook((window) {
    if (window.isFirstShow) {
      window.titleBarStyle = TitleBarStyle.hidden;
      window.center();
    }
    return true;
  });

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final TrayIcon _trayIcon;

  Window get _mainWindow => mainWindowController.window;

  Window get _miniTranslatorWindow => miniTranslatorWindowController.window;

  late final GoRouter _router = createAppRouter(
    initialLocation: const GeneralSettingsRoute().location,
  );

  @override
  void initState() {
    settingsStore.addListener(_handleChanged);
    _setupTrayIcon();
    super.initState();
  }

  @override
  void dispose() {
    settingsStore.removeListener(_handleChanged);
    super.dispose();
  }

  void _setupTrayIcon() {
    _trayIcon = TrayIcon();
    final icon = Image.fromAsset('resources/images/tray_icon.png');
    if (icon != null) _trayIcon.icon = icon;
    _trayIcon.isVisible = true;
    _trayIcon.contextMenu = Menu()
      ..addItem(
        MenuItem('Open Settings')
          ..on<MenuItemClickedEvent>((_) {
            _mainWindow.center();
            _mainWindow.show();
          }),
      )
      ..addItem(
        MenuItem('Exit')
          ..on<MenuItemClickedEvent>((_) {
            print('Clicked Exit');
          }),
      );
    _trayIcon.contextMenuTrigger = ContextMenuTrigger.rightClicked;
    _trayIcon.on<TrayIconClickedEvent>((event) {
      final bounds = _trayIcon.bounds;
      if (bounds != null) {
        _miniTranslatorWindow.setPosition(
          bounds.left - (_miniTranslatorWindow.bounds.width - bounds.width) / 2,
          bounds.bottom + 10,
        );
      }
      _miniTranslatorWindow.show();
    });
  }

  Future<void> _handleChanged() async {
    final oldLocale = context.locale;
    final newLocale = languageToLocale(settingsStore.appLanguage);
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
        themeMode: settingsStore.themeMode,
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
  await LocaleSettings.setLocaleRaw(
    languageToLocale(settingsStore.appLanguage).languageCode,
  );

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
