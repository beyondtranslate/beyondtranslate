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
  static const String bootstrap = '/bootstrap';
  static const String desktopPopup = '/desktop-popup';
  static const String home = '/home';
  static const String ocrEnginesManage = '/settings/ocr-engines';
  static const String settings = '/settings';
  static const String settingsAppLanguage = '/settings/app-language';
  static const String settingsExtractText = '/settings/extract-text';
  static const String settingsInterface = '/settings/interface';
  static const String settingsShortcuts = '/settings/shortcuts';
  static const String settingsThemeMode = '/settings/theme-mode';
  static const String settingsTranslate = '/settings/translate';
  static const String translationEnginesManage =
      '/settings/translation-engines';
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
const List<RouteNode> routeNodes = <RouteNode>[
  RouteNode(id: 'root', path: RouteTree.root),
  RouteNode(id: 'bootstrap', path: RouteTree.bootstrap, parentId: 'root'),
  RouteNode(
    id: 'desktop-popup',
    path: RouteTree.desktopPopup,
    parentId: 'root',
  ),
  RouteNode(id: 'home', path: RouteTree.home, parentId: 'root'),
  RouteNode(
    id: 'ocr-engines-manage',
    path: RouteTree.ocrEnginesManage,
    parentId: 'settings',
  ),
  RouteNode(id: 'settings', path: RouteTree.settings, parentId: 'root'),
  RouteNode(
    id: 'settings-app-language',
    path: RouteTree.settingsAppLanguage,
    parentId: 'settings',
  ),
  RouteNode(
    id: 'settings-extract-text',
    path: RouteTree.settingsExtractText,
    parentId: 'settings',
  ),
  RouteNode(
    id: 'settings-interface',
    path: RouteTree.settingsInterface,
    parentId: 'settings',
  ),
  RouteNode(
    id: 'settings-shortcuts',
    path: RouteTree.settingsShortcuts,
    parentId: 'settings',
  ),
  RouteNode(
    id: 'settings-theme-mode',
    path: RouteTree.settingsThemeMode,
    parentId: 'settings',
  ),
  RouteNode(
    id: 'settings-translate',
    path: RouteTree.settingsTranslate,
    parentId: 'settings',
  ),
  RouteNode(
    id: 'translation-engines-manage',
    path: RouteTree.translationEnginesManage,
    parentId: 'settings',
  ),
];
