// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_language.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $settingAppLanguageRoute,
    ];

RouteBase get $settingAppLanguageRoute => GoRouteData.$route(
      path: '/settings/app-language',
      factory: $SettingAppLanguageRoute._fromState,
    );

mixin $SettingAppLanguageRoute on GoRouteData {
  static SettingAppLanguageRoute _fromState(GoRouterState state) =>
      SettingAppLanguageRoute(
        initialLanguage: state.uri.queryParameters['initial-language'],
      );

  SettingAppLanguageRoute get _self => this as SettingAppLanguageRoute;

  @override
  String get location => GoRouteData.$location(
        '/settings/app-language',
        queryParams: {
          if (_self.initialLanguage != null)
            'initial-language': _self.initialLanguage,
        },
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
