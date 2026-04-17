// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bootstrap.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $bootstrapRoute,
    ];

RouteBase get $bootstrapRoute => GoRouteData.$route(
      path: '/bootstrap',
      factory: $BootstrapRoute._fromState,
    );

mixin $BootstrapRoute on GoRouteData {
  static BootstrapRoute _fromState(GoRouterState state) =>
      const BootstrapRoute();

  @override
  String get location => GoRouteData.$location(
        '/bootstrap',
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
