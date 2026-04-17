// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_engines_manage.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $translationEnginesManageRoute,
    ];

RouteBase get $translationEnginesManageRoute => GoRouteData.$route(
      path: '/settings/translation-engines',
      factory: $TranslationEnginesManageRoute._fromState,
    );

mixin $TranslationEnginesManageRoute on GoRouteData {
  static TranslationEnginesManageRoute _fromState(GoRouterState state) =>
      const TranslationEnginesManageRoute();

  @override
  String get location => GoRouteData.$location(
        '/settings/translation-engines',
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
