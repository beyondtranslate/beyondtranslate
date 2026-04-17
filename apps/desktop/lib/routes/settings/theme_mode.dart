import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:biyi_app/pages/pages.dart';

part 'theme_mode.g.dart';

@TypedGoRoute<SettingThemeModeRoute>(path: '/settings/theme-mode')
class SettingThemeModeRoute extends GoRouteData with $SettingThemeModeRoute {
  const SettingThemeModeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingThemeModePage();
  }
}
