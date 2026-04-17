import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:biyi_app/pages/pages.dart';

part 'desktop_popup.g.dart';

@TypedGoRoute<DesktopPopupRoute>(path: '/desktop-popup')
class DesktopPopupRoute extends GoRouteData with $DesktopPopupRoute {
  const DesktopPopupRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DesktopPopupPage();
  }
}
