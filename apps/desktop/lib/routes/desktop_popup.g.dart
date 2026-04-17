// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'desktop_popup.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $desktopPopupRoute,
    ];

RouteBase get $desktopPopupRoute => GoRouteData.$route(
      path: '/desktop-popup',
      factory: $DesktopPopupRoute._fromState,
    );

mixin $DesktopPopupRoute on GoRouteData {
  static DesktopPopupRoute _fromState(GoRouterState state) =>
      const DesktopPopupRoute();

  @override
  String get location => GoRouteData.$location(
        '/desktop-popup',
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
