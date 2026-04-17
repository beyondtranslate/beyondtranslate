import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:biyi_app/pages/pages.dart';

part 'index.g.dart';

@TypedGoRoute<SettingsRoute>(path: '/settings')
class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsPage();
  }
}
