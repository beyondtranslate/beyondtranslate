import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:biyi_app/pages/pages.dart';

part 'home.g.dart';

@TypedGoRoute<HomeRoute>(path: '/home')
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomePage();
  }
}
