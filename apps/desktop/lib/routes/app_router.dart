import 'package:go_router/go_router.dart';

import '__root.dart';
import 'mini_translator.dart' as mini_translator_route;
import 'ocr_engines_manage.dart' as ocr_engines_manage_route;
import 'settings/index.dart' as settings_route;
import 'translation_engines_manage.dart' as translation_engines_manage_route;

/// Assembles the application's route graph from modular route files.
///
/// TanStack Start-inspired organization:
/// - each route lives in its own module/file
/// - this file is the composition root for router setup
GoRouter createAppRouter({
  String? initialLocation,
}) {
  return GoRouter(
    routes: <RouteBase>[
      ...$appRoutes,
      ...mini_translator_route.$appRoutes,
      ...ocr_engines_manage_route.$appRoutes,
      ...settings_route.$appRoutes,
      ...translation_engines_manage_route.$appRoutes,
    ],
    initialLocation: initialLocation ?? const RootRoute().location,
    debugLogDiagnostics: false,
  );
}
