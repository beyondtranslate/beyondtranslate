import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../i18n/i18n.dart';
import '../../utils/utils.dart';
import 'advanced.dart';
import 'appearance.dart';
import 'debug.dart';
import 'general.dart';
import 'providers.dart';
import 'shortcuts.dart';

part 'index.g.dart';

@TypedShellRoute<SettingsShellRoute>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<GeneralSettingsRoute>(path: '/settings/general'),
    TypedGoRoute<ProvidersSettingsRoute>(path: '/settings/providers'),
    TypedGoRoute<AppearanceSettingsRoute>(path: '/settings/appearance'),
    TypedGoRoute<ShortcutsSettingsRoute>(path: '/settings/shortcuts'),
    TypedGoRoute<AdvancedSettingsRoute>(path: '/settings/advanced'),
    TypedGoRoute<SettingsDebugRoute>(path: '/settings/debug'),
  ],
)
class SettingsShellRoute extends ShellRouteData {
  const SettingsShellRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return _SettingsShellPage(
      selectedCategory: _SettingsCategory.fromLocation(state.uri.path),
      child: navigator,
    );
  }
}

class GeneralSettingsRoute extends GoRouteData with $GeneralSettingsRoute {
  const GeneralSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const GeneralSettingsPage();
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildFadeInPage(
      state: state,
      child: const GeneralSettingsPage(),
    );
  }
}

class AppearanceSettingsRoute extends GoRouteData
    with $AppearanceSettingsRoute {
  const AppearanceSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AppearanceSettingsPage();
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildFadeInPage(
      state: state,
      child: const AppearanceSettingsPage(),
    );
  }
}

class ShortcutsSettingsRoute extends GoRouteData with $ShortcutsSettingsRoute {
  const ShortcutsSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ShortcutsSettingsPage();
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildFadeInPage(
      state: state,
      child: const ShortcutsSettingsPage(),
    );
  }
}

class AdvancedSettingsRoute extends GoRouteData with $AdvancedSettingsRoute {
  const AdvancedSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AdvancedSettingsPage();
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildFadeInPage(
      state: state,
      child: const AdvancedSettingsPage(),
    );
  }
}

class ProvidersSettingsRoute extends GoRouteData with $ProvidersSettingsRoute {
  const ProvidersSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProvidersSettingsPage();
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildFadeInPage(
      state: state,
      child: const ProvidersSettingsPage(),
    );
  }
}

class SettingsDebugRoute extends GoRouteData with $SettingsDebugRoute {
  const SettingsDebugRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsDebugPage();
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return _buildFadeInPage(
      state: state,
      child: const SettingsDebugPage(),
    );
  }
}

Page<void> _buildFadeInPage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 180),
    reverseTransitionDuration: const Duration(milliseconds: 120),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ),
        child: child,
      );
    },
  );
}

enum _SettingsCategory {
  general,
  appearance,
  shortcuts,
  providers,
  advanced,
  debug;

  static _SettingsCategory fromLocation(String location) {
    if (location.startsWith('/settings/providers')) {
      return _SettingsCategory.providers;
    }
    if (location.startsWith('/settings/appearance')) {
      return _SettingsCategory.appearance;
    }
    if (location.startsWith('/settings/shortcuts')) {
      return _SettingsCategory.shortcuts;
    }
    if (location.startsWith('/settings/advanced')) {
      return _SettingsCategory.advanced;
    }
    if (location.startsWith('/settings/debug')) {
      return _SettingsCategory.debug;
    }
    return _SettingsCategory.general;
  }
}

class _SettingsShellPage extends StatelessWidget {
  const _SettingsShellPage({
    required this.selectedCategory,
    required this.child,
  });

  final _SettingsCategory selectedCategory;
  final Widget child;

  void _navigateToCategory(BuildContext context, _SettingsCategory category) {
    switch (category) {
      case _SettingsCategory.general:
        const GeneralSettingsRoute().go(context);
      case _SettingsCategory.appearance:
        const AppearanceSettingsRoute().go(context);
      case _SettingsCategory.shortcuts:
        const ShortcutsSettingsRoute().go(context);
      case _SettingsCategory.providers:
        const ProvidersSettingsRoute().go(context);
      case _SettingsCategory.advanced:
        const AdvancedSettingsRoute().go(context);
      case _SettingsCategory.debug:
        const SettingsDebugRoute().go(context);
    }
  }

  Widget _buildSidebarItem(
    BuildContext context, {
    required _SettingsCategory category,
    required IconData icon,
    required String title,
  }) {
    final isSelected = selectedCategory == category;
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = isSelected
        ? colorScheme.primary.withValues(alpha: 0.10)
        : Colors.transparent;
    final foregroundColor =
        isSelected ? colorScheme.primary : colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _navigateToCategory(context, category),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(icon, size: 20, color: foregroundColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: foregroundColor,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactSidebarItem(
    BuildContext context, {
    required _SettingsCategory category,
    required IconData icon,
    required String title,
  }) {
    final isSelected = selectedCategory == category;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        selected: isSelected,
        showCheckmark: false,
        avatar: Icon(
          icon,
          size: 18,
          color: isSelected ? colorScheme.primary : colorScheme.onSurface,
        ),
        label: Text(title),
        onSelected: (_) => _navigateToCategory(context, category),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: 248,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text(
              t.page_settings.title,
              style: textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              children: [
                _buildSidebarItem(
                  context,
                  category: _SettingsCategory.general,
                  icon: FluentIcons.settings_20_regular,
                  title: t.page_settings.pref_section_title_general,
                ),
                _buildSidebarItem(
                  context,
                  category: _SettingsCategory.appearance,
                  icon: FluentIcons.color_20_regular,
                  title: t.page_settings.pref_section_title_appearance,
                ),
                _buildSidebarItem(
                  context,
                  category: _SettingsCategory.shortcuts,
                  icon: FluentIcons.keyboard_20_regular,
                  title: t.page_settings.pref_section_title_shortcuts,
                ),
                _buildSidebarItem(
                  context,
                  category: _SettingsCategory.providers,
                  icon: FluentIcons.connector_20_regular,
                  title: 'Providers',
                ),
                _buildSidebarItem(
                  context,
                  category: _SettingsCategory.advanced,
                  icon: FluentIcons.code_block_20_regular,
                  title: t.page_settings.pref_section_title_advanced,
                ),
                _buildSidebarItem(
                  context,
                  category: _SettingsCategory.debug,
                  icon: FluentIcons.bug_20_regular,
                  title: 'Debug',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Text(
              formatTranslation(
                t.page_settings.text_version,
                args: [
                  sharedEnv.appVersion,
                  '${sharedEnv.appBuildNumber}',
                ],
              ),
              style: textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactSidebar(BuildContext context) {
    return SizedBox(
      height: 64,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        children: [
          _buildCompactSidebarItem(
            context,
            category: _SettingsCategory.general,
            icon: FluentIcons.settings_20_regular,
            title: t.page_settings.pref_section_title_general,
          ),
          _buildCompactSidebarItem(
            context,
            category: _SettingsCategory.appearance,
            icon: FluentIcons.color_20_regular,
            title: t.page_settings.pref_section_title_appearance,
          ),
          _buildCompactSidebarItem(
            context,
            category: _SettingsCategory.shortcuts,
            icon: FluentIcons.keyboard_20_regular,
            title: t.page_settings.pref_section_title_shortcuts,
          ),
          _buildCompactSidebarItem(
            context,
            category: _SettingsCategory.providers,
            icon: FluentIcons.connector_20_regular,
            title: 'Providers',
          ),
          _buildCompactSidebarItem(
            context,
            category: _SettingsCategory.advanced,
            icon: FluentIcons.code_block_20_regular,
            title: t.page_settings.pref_section_title_advanced,
          ),
          _buildCompactSidebarItem(
            context,
            category: _SettingsCategory.debug,
            icon: FluentIcons.bug_20_regular,
            title: 'Debug',
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 820;
        if (isCompact) {
          return Column(
            children: [
              _buildCompactSidebar(context),
              const Divider(height: 1),
              Expanded(child: child),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSidebar(context),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: Theme.of(context).dividerColor.withValues(alpha: 0.16),
            ),
            Expanded(child: child),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }
}
