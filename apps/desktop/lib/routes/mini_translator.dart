import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:biyi_app/features/mini_translator.dart';

part 'mini_translator.g.dart';

@TypedGoRoute<MiniTranslatorRoute>(path: '/mini-translator')
class MiniTranslatorRoute extends GoRouteData with $MiniTranslatorRoute {
  const MiniTranslatorRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MiniTranslatorPage();
  }
}
