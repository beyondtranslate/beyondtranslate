import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:biyi_app/pages/pages.dart';

part 'translation_engines_manage.g.dart';

@TypedGoRoute<TranslationEnginesManageRoute>(
  path: '/settings/translation-engines',
)
class TranslationEnginesManageRoute extends GoRouteData
    with $TranslationEnginesManageRoute {
  const TranslationEnginesManageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TranslationEnginesManagePage();
  }
}
