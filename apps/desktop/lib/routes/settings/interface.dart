import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:biyi_app/pages/pages.dart';

part 'interface.g.dart';

@TypedGoRoute<SettingInterfaceRoute>(path: '/settings/interface')
class SettingInterfaceRoute extends GoRouteData with $SettingInterfaceRoute {
  const SettingInterfaceRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingInterfacePage();
  }
}
