// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translate.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $settingTranslateRoute,
    ];

RouteBase get $settingTranslateRoute => GoRouteData.$route(
      path: '/settings/translate',
      factory: $SettingTranslateRoute._fromState,
    );

mixin $SettingTranslateRoute on GoRouteData {
  static SettingTranslateRoute _fromState(GoRouterState state) =>
      const SettingTranslateRoute();

  @override
  String get location => GoRouteData.$location(
        '/settings/translate',
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
