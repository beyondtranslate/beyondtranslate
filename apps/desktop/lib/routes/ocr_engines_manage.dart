import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:biyi_app/pages/pages.dart';

part 'ocr_engines_manage.g.dart';

@TypedGoRoute<OcrEnginesManageRoute>(path: '/settings/ocr-engines')
class OcrEnginesManageRoute extends GoRouteData with $OcrEnginesManageRoute {
  const OcrEnginesManageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const OcrEnginesManagePage();
  }
}
