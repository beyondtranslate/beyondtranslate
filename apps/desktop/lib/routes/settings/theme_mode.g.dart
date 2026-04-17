// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_mode.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $settingThemeModeRoute,
    ];

RouteBase get $settingThemeModeRoute => GoRouteData.$route(
      path: '/settings/theme-mode',
      factory: $SettingThemeModeRoute._fromState,
    );

mixin $SettingThemeModeRoute on GoRouteData {
  static SettingThemeModeRoute _fromState(GoRouterState state) =>
      const SettingThemeModeRoute();

  @override
  String get location => GoRouteData.$location(
        '/settings/theme-mode',
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
