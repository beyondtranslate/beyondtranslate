import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:biyi_app/pages/pages.dart';

part 'bootstrap.g.dart';

/// Bootstrap route module.
///
/// This mirrors a TanStack Start-style route module layout:
/// - file-per-route entry
/// - route data colocated with route path declaration
@TypedGoRoute<BootstrapRoute>(
  path: '/bootstrap',
)
class BootstrapRoute extends GoRouteData with $BootstrapRoute {
  const BootstrapRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const BootstrapPage();
  }
}
