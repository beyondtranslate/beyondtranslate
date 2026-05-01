/// TanStack Start-inspired route tree placeholder.
///
/// This file is intentionally lightweight for the first migration step:
/// - keep route modules discoverable in one place
/// - mirror a "route tree" entrypoint shape
/// - avoid coupling too early while go_router_builder generation is introduced
///
/// As more routes are migrated, add imports + entries here and let this
/// become the single "route graph" reference for the app.
library route_tree;

/// Logical route keys (path-like identifiers) used by route modules.
///
/// These are *not* go_router declarations themselves; they are stable names
/// for organizing route files in a TanStack-style mental model.
abstract final class RouteTree {
  static const String root = '/';
  static const DebugRouteTree debug = DebugRouteTree();
  static const SettingsRouteTree settings = SettingsRouteTree();
}

class DebugRouteTree {
  const DebugRouteTree();

  final String path = '/debug';
  final String nativeSettings = '/debug/native-settings';
  final String runtime = '/debug/runtime';
}

class SettingsRouteTree {
  const SettingsRouteTree();

  final String path = '/settings';
  final String general = '/settings/general';
  final String appearance = '/settings/appearance';
  final String shortcuts = '/settings/shortcuts';
  final String advanced = '/settings/advanced';
  final String providers = '/settings/providers';
  final String debug = '/settings/debug';
  final String ocrEnginesManage = '/settings/ocr-engines';
  final String translationEnginesManage = '/settings/translation-engines';
}

/// Optional metadata carrier for future route registration/indexing.
class RouteNode {
  final String id;
  final String path;
  final String? parentId;

  const RouteNode({
    required this.id,
    required this.path,
    this.parentId,
  });
}

/// Flat list placeholder for future expansion.
/// Keep this list sorted by `path` for readability.
final List<RouteNode> routeNodes = <RouteNode>[
  RouteNode(
    id: 'debug',
    path: RouteTree.debug.path,
    parentId: 'root',
  ),
  RouteNode(
    id: 'debug-native-settings',
    path: RouteTree.debug.nativeSettings,
    parentId: 'debug',
  ),
  RouteNode(
    id: 'debug-runtime',
    path: RouteTree.debug.runtime,
    parentId: 'debug',
  ),
  const RouteNode(id: 'root', path: RouteTree.root),
  RouteNode(
    id: 'ocr-engines-manage',
    path: RouteTree.settings.ocrEnginesManage,
    parentId: 'settings',
  ),
  RouteNode(
    id: 'settings',
    path: RouteTree.settings.path,
    parentId: 'root',
  ),
  RouteNode(
    id: 'settings-advanced',
    path: RouteTree.settings.advanced,
    parentId: 'settings',
  ),
  RouteNode(
    id: 'settings-appearance',
    path: RouteTree.settings.appearance,
    parentId: 'settings',
  ),
  RouteNode(
    id: 'settings-debug',
    path: RouteTree.settings.debug,
    parentId: 'settings',
  ),
  RouteNode(
    id: 'settings-providers',
    path: RouteTree.settings.providers,
    parentId: 'settings',
  ),
  RouteNode(
    id: 'settings-general',
    path: RouteTree.settings.general,
    parentId: 'settings',
  ),
  RouteNode(
    id: 'settings-shortcuts',
    path: RouteTree.settings.shortcuts,
    parentId: 'settings',
  ),
  RouteNode(
    id: 'translation-engines-manage',
    path: RouteTree.settings.translationEnginesManage,
    parentId: 'settings',
  ),
];
