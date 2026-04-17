// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_engines_manage.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $ocrEnginesManageRoute,
    ];

RouteBase get $ocrEnginesManageRoute => GoRouteData.$route(
      path: '/settings/ocr-engines',
      factory: $OcrEnginesManageRoute._fromState,
    );

mixin $OcrEnginesManageRoute on GoRouteData {
  static OcrEnginesManageRoute _fromState(GoRouterState state) =>
      const OcrEnginesManageRoute();

  @override
  String get location => GoRouteData.$location(
        '/settings/ocr-engines',
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
