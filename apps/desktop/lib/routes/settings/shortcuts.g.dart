// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shortcuts.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $settingShortcutsRoute,
    ];

RouteBase get $settingShortcutsRoute => GoRouteData.$route(
      path: '/settings/shortcuts',
      factory: $SettingShortcutsRoute._fromState,
    );

mixin $SettingShortcutsRoute on GoRouteData {
  static SettingShortcutsRoute _fromState(GoRouterState state) =>
      const SettingShortcutsRoute();

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
