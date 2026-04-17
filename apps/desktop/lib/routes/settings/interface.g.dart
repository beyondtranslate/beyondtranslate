// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interface.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $settingInterfaceRoute,
    ];

RouteBase get $settingInterfaceRoute => GoRouteData.$route(
      path: '/settings/interface',
      factory: $SettingInterfaceRoute._fromState,
    );

mixin $SettingInterfaceRoute on GoRouteData {
  static SettingInterfaceRoute _fromState(GoRouterState state) =>
      const SettingInterfaceRoute();

  @override
  String get location => GoRouteData.$location(
        '/settings/interface',
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
