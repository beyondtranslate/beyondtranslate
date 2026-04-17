import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:biyi_app/pages/pages.dart';

part 'shortcuts.g.dart';

@TypedGoRoute<SettingShortcutsRoute>(path: '/settings/shortcuts')
class SettingShortcutsRoute extends GoRouteData with $SettingShortcutsRoute {
  const SettingShortcutsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingShortcutsPage();
  }
}
