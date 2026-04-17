import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:biyi_app/pages/pages.dart';

part 'extract_text.g.dart';

@TypedGoRoute<SettingExtractTextRoute>(path: '/settings/extract-text')
class SettingExtractTextRoute extends GoRouteData with $SettingExtractTextRoute {
  const SettingExtractTextRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingExtractTextPage();
  }
}
