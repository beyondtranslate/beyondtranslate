// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'index.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $settingsShellRoute,
    ];

RouteBase get $settingsShellRoute => ShellRouteData.$route(
      factory: $SettingsShellRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: '/settings/general',
          factory: $GeneralSettingsRoute._fromState,
        ),
        GoRouteData.$route(
          path: '/settings/appearance',
          factory: $AppearanceSettingsRoute._fromState,
        ),
        GoRouteData.$route(
          path: '/settings/keybinds',
          factory: $KeybindsSettingsRoute._fromState,
        ),
        GoRouteData.$route(
          path: '/settings/advanced',
          factory: $AdvancedSettingsRoute._fromState,
        ),
      ],
    );

extension $SettingsShellRouteExtension on SettingsShellRoute {
  static SettingsShellRoute _fromState(GoRouterState state) =>
      const SettingsShellRoute();
}

mixin $GeneralSettingsRoute on GoRouteData {
  static GeneralSettingsRoute _fromState(GoRouterState state) =>
      const GeneralSettingsRoute();

  @override
  String get location => GoRouteData.$location(
        '/settings/general',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AppearanceSettingsRoute on GoRouteData {
  static AppearanceSettingsRoute _fromState(GoRouterState state) =>
      const AppearanceSettingsRoute();

  @override
  String get location => GoRouteData.$location(
        '/settings/appearance',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $KeybindsSettingsRoute on GoRouteData {
  static KeybindsSettingsRoute _fromState(GoRouterState state) =>
      const KeybindsSettingsRoute();

  @override
  String get location => GoRouteData.$location(
        '/settings/keybinds',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AdvancedSettingsRoute on GoRouteData {
  static AdvancedSettingsRoute _fromState(GoRouterState state) =>
      const AdvancedSettingsRoute();

  @override
  String get location => GoRouteData.$location(
        '/settings/advanced',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
