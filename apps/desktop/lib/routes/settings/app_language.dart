import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:biyi_app/pages/pages.dart';

part 'app_language.g.dart';

@TypedGoRoute<SettingAppLanguageRoute>(path: '/settings/app-language')
class SettingAppLanguageRoute extends GoRouteData with $SettingAppLanguageRoute {
  const SettingAppLanguageRoute({this.initialLanguage});

  final String? initialLanguage;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SettingAppLanguagePage(initialLanguage: initialLanguage);
  }
}
