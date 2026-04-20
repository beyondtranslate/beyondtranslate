import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'bootstrap.dart';

part '__root.g.dart';

@TypedGoRoute<RootRoute>(path: '/')
class RootRoute extends GoRouteData with $RootRoute {
  const RootRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    // Keep startup behavior aligned with current app flow.
    return const BootstrapPage();
  }
}
