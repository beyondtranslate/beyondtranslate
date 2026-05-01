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
          path: '/settings/shortcuts',
          factory: $ShortcutsSettingsRoute._fromState,
        ),
        GoRouteData.$route(
          path: '/settings/advanced',
          factory: $AdvancedSettingsRoute._fromState,
        ),
        GoRouteData.$route(
          path: '/settings/providers',
          factory: $ProvidersSettingsRoute._fromState,
        ),
        GoRouteData.$route(
          path: '/settings/debug',
          factory: $SettingsDebugRoute._fromState,
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

mixin $ShortcutsSettingsRoute on GoRouteData {
  static ShortcutsSettingsRoute _fromState(GoRouterState state) =>
      const ShortcutsSettingsRoute();

  @override
  String get location => GoRouteData.$location(
        '/settings/shortcuts',
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

mixin $ProvidersSettingsRoute on GoRouteData {
  static ProvidersSettingsRoute _fromState(GoRouterState state) =>
      const ProvidersSettingsRoute();

  @override
  String get location => GoRouteData.$location(
        '/settings/providers',
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

mixin $SettingsDebugRoute on GoRouteData {
  static SettingsDebugRoute _fromState(GoRouterState state) =>
      const SettingsDebugRoute();

  @override
  String get location => GoRouteData.$location(
        '/settings/debug',
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
