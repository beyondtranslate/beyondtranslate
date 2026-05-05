// ignore_for_file: implementation_imports, invalid_use_of_internal_member

import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/src/widgets/_window.dart';
import 'package:go_router/go_router.dart';
import 'package:nativeapi/nativeapi.dart';

import '../extensions/window_controller.dart';
import '../i18n/i18n.dart';
import '../services/native_settings.dart';
import '../services/settings_store.dart';
import '../utils/language_util.dart';
import '../utils/platform_util.dart';
import '../widgets/ui/themes/dark_theme.dart';
import '../widgets/ui/themes/light_theme.dart';
import '__root.dart';
import 'debug/native_settings.dart' as debug_native_settings_route;
import 'debug/runtime.dart' as debug_runtime_route;
import 'mini_translator/mini_translator.dart';
import 'settings/index.dart' as settings_route;
import 'settings/index.dart' show GeneralSettingsRoute;

const _kMainAppTitle = 'Beyond Translate';
const _kMiniTranslatorAppTitle = 'Mini Translator';

// ──────────────────────────────────────────────────────────────────────────────
// Window controllers
// ──────────────────────────────────────────────────────────────────────────────

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

final miniTranslatorWindowController = RegularWindowController(
  preferredSize: const Size(380, 420),
  title: _kMiniTranslatorAppTitle,
)..setWillShowHook((window) {
    if (window.isFirstShow) {
      window.titleBarStyle = TitleBarStyle.hidden;
      window.windowControlButtonsVisible = false;
      return false;
    }
    return true;
  });

// ──────────────────────────────────────────────────────────────────────────────
// Routers
// ──────────────────────────────────────────────────────────────────────────────

/// Assembles the main application's route graph from modular route files.
///
/// TanStack Start-inspired organization:
/// - each route lives in its own module/file
/// - this file is the composition root for router setup
GoRouter createMainAppRouter({
  String? initialLocation,
}) {
  return GoRouter(
    routes: <RouteBase>[
      ...$appRoutes,
      ...debug_native_settings_route.$appRoutes,
      ...debug_runtime_route.$appRoutes,
      ...settings_route.$appRoutes,
    ],
    initialLocation: initialLocation ?? const RootRoute().location,
    debugLogDiagnostics: false,
  );
}

/// Assembles the mini-translator window's route graph.
GoRouter createMiniTranslatorAppRouter() {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MiniTranslatorPage(),
      ),
    ],
    debugLogDiagnostics: false,
  );
}

// ──────────────────────────────────────────────────────────────────────────────
// App widgets
// ──────────────────────────────────────────────────────────────────────────────

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final GoRouter _router = createMainAppRouter(
    initialLocation: const GeneralSettingsRoute().location,
  );

  @override
  Widget build(BuildContext context) {
    return RegularWindow(
      controller: mainWindowController,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: _kMainAppTitle,
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

class MiniTranslatorApp extends StatefulWidget {
  const MiniTranslatorApp({super.key});

  @override
  State<MiniTranslatorApp> createState() => _MiniTranslatorAppState();
}

class _MiniTranslatorAppState extends State<MiniTranslatorApp> {
  late final GoRouter _router = createMiniTranslatorAppRouter();

  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();

    return RegularWindow(
      controller: miniTranslatorWindowController,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: _kMiniTranslatorAppTitle,
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
          child = botToastBuilder(context, child);
          return child;
        },
        routerConfig: _router,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
      ),
    );
  }
}

class RootView extends StatelessWidget {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    return TranslationProvider(
      child: const _RootBodyView(),
    );
  }
}

class _RootBodyView extends StatefulWidget {
  const _RootBodyView();

  @override
  State<_RootBodyView> createState() => _RootBodyViewState();
}

class _RootBodyViewState extends State<_RootBodyView> {
  late final TrayIcon _trayIcon;

  Window get _mainWindow => mainWindowController.window;
  Window get _miniTranslatorWindow => miniTranslatorWindowController.window;

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

  Future<void> _handleChanged() async {
    final oldLocale = context.locale;
    final newLocale = languageToLocale(settingsStore.appLanguage);
    if (newLocale != oldLocale) {
      await context.setLocale(newLocale);
    }
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
            if (Platform.isMacOS) {
              NativeSettings.show();
              return;
            }
            _mainWindow.center();
            _mainWindow.show();
          }),
      )
      ..addItem(
        MenuItem('Exit')
          ..on<MenuItemClickedEvent>((_) {
            // print('Clicked Exit');
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

  @override
  Widget build(BuildContext context) {
    return ViewCollection(
      views: [
        if (!Platform.isMacOS) const MainApp(),
        const MiniTranslatorApp(),
      ],
    );
  }
}
