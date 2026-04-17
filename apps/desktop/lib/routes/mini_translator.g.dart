// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mini_translator.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $miniTranslatorRoute,
    ];

RouteBase get $miniTranslatorRoute => GoRouteData.$route(
      path: '/mini-translator',
      factory: $MiniTranslatorRoute._fromState,
    );

mixin $MiniTranslatorRoute on GoRouteData {
  static MiniTranslatorRoute _fromState(GoRouterState state) =>
      const MiniTranslatorRoute();

  @override
  String get location => GoRouteData.$location(
        '/mini-translator',
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
