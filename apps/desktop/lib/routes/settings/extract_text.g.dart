// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extract_text.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $settingExtractTextRoute,
    ];

RouteBase get $settingExtractTextRoute => GoRouteData.$route(
      path: '/settings/extract-text',
      factory: $SettingExtractTextRoute._fromState,
    );

mixin $SettingExtractTextRoute on GoRouteData {
  static SettingExtractTextRoute _fromState(GoRouterState state) =>
      const SettingExtractTextRoute();

  @override
  String get location => GoRouteData.$location(
        '/settings/extract-text',
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
