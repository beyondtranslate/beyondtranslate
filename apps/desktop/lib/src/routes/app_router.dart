// ignore_for_file: implementation_imports, invalid_use_of_internal_member

import 'dart:async';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/src/widgets/_window.dart' hide WindowManager;
import 'package:go_router/go_router.dart';
import 'package:nativeapi/nativeapi.dart';
import 'package:path_provider/path_provider.dart';

import '../extensions/window_controller.dart';
import '../i18n/i18n.dart';
import '../services/mac_settings.dart';
import '../services/mac_window_appearance.dart';
import '../services/settings_store.dart';
import '../utils/language_util.dart';
import '../utils/platform_util.dart';
import '../widgets/ui/themes/dark_theme.dart';
import '../widgets/ui/themes/light_theme.dart';
import '__root.dart';
import 'debug/runtime.dart' as debug_runtime_route;
import 'mini_translator/mini_translator.dart';
import 'settings/index.dart' as settings_route;
import 'settings/index.dart' show GeneralSettingsRoute;

const _kSettingsWindowTitle = 'Settings';
const _kMiniTranslatorAppTitle = 'Mini Translator';
const _kSettingsWindowSize = Size(720, 532);
const _kUseNativeSettingsPreferenceKey = 'use_native_settings';
const _kMiniTranslatorTrayGap = 10.0;

extension PreferencesExtension on Preferences {
  bool get useNativeSettings =>
      get(_kUseNativeSettingsPreferenceKey, 'true') == 'true';

  set useNativeSettings(bool value) {
    set(_kUseNativeSettingsPreferenceKey, value.toString());
  }
}

final Preferences _devToolsPreferences = Preferences.withScope('dev_tools');
TrayIcon? _mainTrayIcon;

// ──────────────────────────────────────────────────────────────────────────────
// Window controllers
// ──────────────────────────────────────────────────────────────────────────────

/// Custom delegate that hides the window instead of destroying it when closed.
/// The app continues running in the system tray.
class _HideOnCloseDelegate extends RegularWindowControllerDelegate {
  @override
  void onWindowCloseRequested(RegularWindowController controller) {
    if (controller.window == settingsWindowController.window) {
      controller.window.hide();
    }
  }
}

final settingsWindowController = RegularWindowController(
  preferredSize: _kSettingsWindowSize,
  title: _kSettingsWindowTitle,
  delegate: _HideOnCloseDelegate(),
)..setWillShowHook((window) {
    if (window.isFirstShow) {
      window.titleBarStyle = TitleBarStyle.hidden;
      window.setMinimumSize(
        _kSettingsWindowSize.width,
        _kSettingsWindowSize.height,
      );
      window.setSize(
        _kSettingsWindowSize.width,
        _kSettingsWindowSize.height,
      );
      window.center();
      return false;
    }
    return true;
  });

// Shows the mini translator window.
void showSettingsWindow() {
  if (_devToolsPreferences.useNativeSettings) {
    MacSettings.show();
    return;
  }
  settingsWindowController.window.center();
  settingsWindowController.window.show();
}

final miniTranslatorWindowController = RegularWindowController(
  preferredSize: const Size(380, 420),
  title: _kMiniTranslatorAppTitle,
)..setWillShowHook((window) {
    if (window.isFirstShow) {
      window.titleBarStyle = TitleBarStyle.hidden;
      window.windowControlButtonsVisible = false;
      if (kIsMacOS) {
        unawaited(MacWindowAppearance.apply(_kMiniTranslatorAppTitle));
      }
      return false;
    }
    return true;
  });

/// Shows the mini translator window.
void showMiniTranslatorWindow({Offset? position, bool belowTray = false}) {
  final newPosition =
      position ?? (belowTray ? miniTranslatorPositionBelowTray() : null);
  if (newPosition != null) {
    miniTranslatorWindowController.window.setPosition(
      newPosition.dx,
      newPosition.dy,
    );
  }
  miniTranslatorWindowController.window.show();
}

Offset? miniTranslatorPositionBelowTray({Size? windowSize}) {
  final trayBounds = _mainTrayIcon?.bounds;
  if (trayBounds == null) return null;

  final size = windowSize ?? miniTranslatorWindowController.window.size;
  final anchor = _resolveTrayAnchor(trayBounds);
  if (anchor == null) return null;

  if (!kIsMacOS) {
    final position = Offset(
      anchor.bounds.left - (size.width - anchor.bounds.width) / 2,
      anchor.bounds.bottom + _kMiniTranslatorTrayGap,
    );
    return _clampPositionToDisplay(position, size, anchor.display);
  }

  final displayBounds = _displayBounds(anchor.display);
  final menuBarBottom = anchor.display.workArea.top > displayBounds.top
      ? anchor.display.workArea.top
      : displayBounds.top + anchor.bounds.height;
  final position = Offset(
    anchor.bounds.center.dx - size.width / 2,
    menuBarBottom + _kMiniTranslatorTrayGap,
  );
  return _clampPositionToDisplay(position, size, anchor.display);
}

Offset _clampPositionToDisplay(
  Offset position,
  Size windowSize,
  Display display,
) {
  final workArea = display.workArea;
  return Offset(
    _clampDouble(
      position.dx,
      workArea.left,
      workArea.right - windowSize.width,
    ),
    _clampDouble(
      position.dy,
      workArea.top,
      workArea.bottom - windowSize.height,
    ),
  );
}

_TrayAnchor? _resolveTrayAnchor(Rect rawBounds) {
  final displays = DisplayManager.instance.getAll();
  if (displays.isEmpty) return null;

  final rawCenter = rawBounds.center;
  for (final display in displays) {
    if (_displayBounds(display).contains(rawCenter)) {
      return _TrayAnchor(
        display: display,
        bounds: _trayBoundsOnDisplay(rawBounds, display),
      );
    }
  }

  for (final display in displays) {
    if (_containsHorizontally(_displayBounds(display), rawCenter.dx)) {
      return _TrayAnchor(
        display: display,
        bounds: _trayBoundsOnDisplay(rawBounds, display),
      );
    }
  }

  for (final display in displays) {
    final normalizedBounds = _normalizeScaledTrayBounds(rawBounds, display);
    if (_containsHorizontally(
      _displayBounds(display),
      normalizedBounds.center.dx,
    )) {
      return _TrayAnchor(
        display: display,
        bounds: _trayBoundsOnDisplay(normalizedBounds, display),
      );
    }
  }

  displays.sort((a, b) {
    final aDistance = _distanceSquared(_displayBounds(a).center, rawCenter);
    final bDistance = _distanceSquared(_displayBounds(b).center, rawCenter);
    return aDistance.compareTo(bDistance);
  });
  final display = displays.first;
  return _TrayAnchor(
    display: display,
    bounds: _trayBoundsOnDisplay(rawBounds, display),
  );
}

Rect _displayBounds(Display display) {
  return Rect.fromLTWH(
    display.position.dx,
    display.position.dy,
    display.size.width,
    display.size.height,
  );
}

Rect _trayBoundsOnDisplay(Rect bounds, Display display) {
  return Rect.fromLTWH(
    bounds.left,
    _displayBounds(display).top,
    bounds.width,
    bounds.height,
  );
}

Rect _normalizeScaledTrayBounds(Rect bounds, Display display) {
  final scaleFactor = display.scaleFactor;
  if (scaleFactor == 0 || scaleFactor == 1) return bounds;

  final displayBounds = _displayBounds(display);
  return Rect.fromLTWH(
    displayBounds.left +
        (bounds.left - displayBounds.left * scaleFactor) / scaleFactor,
    displayBounds.top +
        (bounds.top - displayBounds.top * scaleFactor) / scaleFactor,
    bounds.width / scaleFactor,
    bounds.height / scaleFactor,
  );
}

bool _containsHorizontally(Rect rect, double x) {
  return x >= rect.left && x <= rect.right;
}

double _distanceSquared(Offset a, Offset b) {
  final dx = a.dx - b.dx;
  final dy = a.dy - b.dy;
  return dx * dx + dy * dy;
}

double _clampDouble(double value, double min, double max) {
  if (max < min) return min;
  return value.clamp(min, max).toDouble();
}

class _TrayAnchor {
  const _TrayAnchor({
    required this.display,
    required this.bounds,
  });

  final Display display;
  final Rect bounds;
}

// ──────────────────────────────────────────────────────────────────────────────
// Routers
// ──────────────────────────────────────────────────────────────────────────────

/// Assembles the main application's route graph from modular route files.
///
/// TanStack Start-inspired organization:
/// - each route lives in its own module/file
/// - this file is the composition root for router setup
GoRouter createSettingsAppRouter({
  String? initialLocation,
}) {
  return GoRouter(
    routes: <RouteBase>[
      ...$appRoutes,
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

class SettingsApp extends StatefulWidget {
  const SettingsApp({super.key});

  @override
  State<SettingsApp> createState() => _SettingsAppState();
}

class _SettingsAppState extends State<SettingsApp> {
  late final GoRouter _router = createSettingsAppRouter(
    initialLocation: const GeneralSettingsRoute().location,
  );

  @override
  void initState() {
    super.initState();
    settingsStore.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    settingsStore.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RegularWindow(
      controller: settingsWindowController,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: _kSettingsWindowTitle,
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
  void initState() {
    super.initState();
    settingsStore.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    settingsStore.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();

    return RegularWindow(
      controller: miniTranslatorWindowController,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: _kMiniTranslatorAppTitle,
        color: Colors.transparent,
        theme: _miniTranslatorTheme(lightThemeData),
        darkTheme: _miniTranslatorTheme(darkThemeData),
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

  ThemeData _miniTranslatorTheme(ThemeData baseTheme) {
    return baseTheme.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: baseTheme.appBarTheme.copyWith(
        backgroundColor: Colors.transparent,
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

  bool get _useNativeSettings => _devToolsPreferences.useNativeSettings;

  @override
  void initState() {
    settingsStore.addListener(_handleChanged);
    _setupTrayIcon();
    super.initState();
  }

  @override
  void dispose() {
    settingsStore.removeListener(_handleChanged);
    if (_mainTrayIcon == _trayIcon) {
      _mainTrayIcon = null;
    }
    _trayIcon.dispose();
    super.dispose();
  }

  Future<void> _handleChanged() async {
    final oldLocale = context.locale;
    final newLocale = languageToLocale(settingsStore.appLanguage);
    if (newLocale != oldLocale) {
      await context.setLocale(newLocale);
    }
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Tray icon
  // ────────────────────────────────────────────────────────────────────────────

  void _setupTrayIcon() {
    _trayIcon = TrayIcon();
    _mainTrayIcon = _trayIcon;
    final icon = Image.fromAsset('resources/images/tray_icon.png');
    if (icon != null) _trayIcon.icon = icon;
    _trayIcon.isVisible = true;
    _trayIcon.contextMenu = _buildContextMenu();
    _trayIcon.contextMenuTrigger = ContextMenuTrigger.rightClicked;
    _trayIcon.on<TrayIconClickedEvent>((event) {
      showMiniTranslatorWindow(belowTray: true);
    });
  }

  Menu _buildContextMenu() {
    final menu = Menu();

    // ── 显示窗口 ──
    menu.addItem(
      MenuItem(t.tray.context_menu.show_window)
        ..on<MenuItemClickedEvent>((_) {
          showMiniTranslatorWindow(belowTray: kIsMacOS);
        }),
    );

    menu.addSeparator();

    // ── 🔧 开发工具 (仅 Debug 模式可见) ──
    if (kDebugMode) {
      final devToolsSubmenu = Menu();

      // 打开数据目录
      devToolsSubmenu.addItem(
        MenuItem(t.tray.context_menu.dev_tools.open_data_directory)
          ..on<MenuItemClickedEvent>((_) async {
            final dir = await getApplicationSupportDirectory();
            UrlOpener.instance.open('file://${dir.path}');
          }),
      );

      // ☑ 使用原生设置页面 (checkbox, 仅 macOS 可用)
      final nativeSettingsItem = MenuItem(
        t.tray.context_menu.dev_tools.use_native_settings,
        MenuItemType.checkbox,
      );
      void updateNativeSettingsItemState() {
        nativeSettingsItem.state = _devToolsPreferences.useNativeSettings
            ? MenuItemState.checked
            : MenuItemState.unchecked;
      }

      updateNativeSettingsItemState();
      nativeSettingsItem.enabled = Platform.isMacOS;
      nativeSettingsItem.on<MenuItemClickedEvent>((_) {
        _devToolsPreferences.useNativeSettings =
            !_devToolsPreferences.useNativeSettings;
        updateNativeSettingsItemState();
      });
      devToolsSubmenu.addItem(nativeSettingsItem);

      final devToolsItem = MenuItem(
        t.tray.context_menu.dev_tools.title,
        MenuItemType.submenu,
      );
      devToolsItem.submenu = devToolsSubmenu;
      menu.addItem(devToolsItem);
    }

    // ── Check for updates (暂不实现) ──
    menu.addItem(
      MenuItem(t.tray.context_menu.check_for_updates),
    );

    // ── 设置 ──
    menu.addItem(
      MenuItem(t.tray.context_menu.settings)
        ..on<MenuItemClickedEvent>((_) {
          showSettingsWindow();
        }),
    );

    menu.addSeparator();

    // ── 退出 ──
    menu.addItem(
      MenuItem(t.tray.context_menu.quit)
        ..on<MenuItemClickedEvent>((_) {
          exit(0);
        }),
    );

    return menu;
  }

  @override
  Widget build(BuildContext context) {
    return ViewCollection(
      views: [
        if (!_useNativeSettings) const SettingsApp(),
        const MiniTranslatorApp(),
      ],
    );
  }
}
