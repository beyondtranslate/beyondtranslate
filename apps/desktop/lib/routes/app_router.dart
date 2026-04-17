import 'package:go_router/go_router.dart';

import '__root.dart';
import 'bootstrap.dart' as bootstrap_route;
import 'mini_translator.dart' as mini_translator_route;
import 'home.dart' as home_route;
import 'ocr_engines_manage.dart' as ocr_engines_manage_route;
import 'settings/app_language.dart' as app_language_route;
import 'settings/extract_text.dart' as extract_text_route;
import 'settings/index.dart' as settings_route;
import 'settings/interface.dart' as interface_route;
import 'settings/shortcuts.dart' as shortcuts_route;
import 'settings/theme_mode.dart' as theme_mode_route;
import 'settings/translate.dart' as translate_route;
import 'translation_engines_manage.dart' as translation_engines_manage_route;

/// Assembles the application's route graph from modular route files.
///
/// TanStack Start-inspired organization:
/// - each route lives in its own module/file
/// - this file is the composition root for router setup
GoRouter createAppRouter() {
  return GoRouter(
    routes: <RouteBase>[
      ...$appRoutes,
      ...bootstrap_route.$appRoutes,
      ...mini_translator_route.$appRoutes,
      ...home_route.$appRoutes,
      ...ocr_engines_manage_route.$appRoutes,
      ...settings_route.$appRoutes,
      ...theme_mode_route.$appRoutes,
      ...interface_route.$appRoutes,
      ...translate_route.$appRoutes,
      ...shortcuts_route.$appRoutes,
      ...app_language_route.$appRoutes,
      ...extract_text_route.$appRoutes,
      ...translation_engines_manage_route.$appRoutes,
    ],
    initialLocation: const RootRoute().location,
    debugLogDiagnostics: false,
  );
}
