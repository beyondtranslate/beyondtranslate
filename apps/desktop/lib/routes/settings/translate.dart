import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:biyi_app/pages/pages.dart';

part 'translate.g.dart';

@TypedGoRoute<SettingTranslateRoute>(path: '/settings/translate')
class SettingTranslateRoute extends GoRouteData with $SettingTranslateRoute {
  const SettingTranslateRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingTranslatePage();
  }
}
