import 'package:go_router/go_router.dart';

import '__root.dart';
import 'debug/native_settings.dart' as debug_native_settings_route;
import 'debug/runtime.dart' as debug_runtime_route;
import 'settings/index.dart' as settings_route;

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
      ...debug_native_settings_route.$appRoutes,
      ...debug_runtime_route.$appRoutes,
      ...settings_route.$appRoutes,
    ],
    initialLocation: initialLocation ?? const RootRoute().location,
    debugLogDiagnostics: false,
  );
}
