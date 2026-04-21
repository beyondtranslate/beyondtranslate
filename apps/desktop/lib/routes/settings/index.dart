import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../i18n/i18n.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import 'advanced.dart';
import 'appearance.dart';
import 'general.dart';
import 'keybinds.dart';

part 'index.g.dart';

@TypedShellRoute<SettingsShellRoute>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<GeneralSettingsRoute>(path: '/settings/general'),
    TypedGoRoute<AppearanceSettingsRoute>(path: '/settings/appearance'),
    TypedGoRoute<KeybindsSettingsRoute>(path: '/settings/keybinds'),
    TypedGoRoute<AdvancedSettingsRoute>(path: '/settings/advanced'),
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
}

class AppearanceSettingsRoute extends GoRouteData
    with $AppearanceSettingsRoute {
  const AppearanceSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AppearanceSettingsPage();
  }
}

class KeybindsSettingsRoute extends GoRouteData with $KeybindsSettingsRoute {
  const KeybindsSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const KeybindsSettingsPage();
  }
}

class AdvancedSettingsRoute extends GoRouteData with $AdvancedSettingsRoute {
  const AdvancedSettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AdvancedSettingsPage();
  }
}

enum _SettingsCategory {
  general,
  appearance,
  keybinds,
  advanced;

  static _SettingsCategory fromLocation(String location) {
    if (location.startsWith('/settings/appearance')) {
      return _SettingsCategory.appearance;
    }
    if (location.startsWith('/settings/keybinds')) {
      return _SettingsCategory.keybinds;
    }
    if (location.startsWith('/settings/advanced')) {
      return _SettingsCategory.advanced;
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
      case _SettingsCategory.keybinds:
        const KeybindsSettingsRoute().go(context);
      case _SettingsCategory.advanced:
        const AdvancedSettingsRoute().go(context);
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
                  category: _SettingsCategory.keybinds,
                  icon: FluentIcons.keyboard_20_regular,
                  title: t.page_settings.pref_section_title_shortcuts,
                ),
                _buildSidebarItem(
                  context,
                  category: _SettingsCategory.advanced,
                  icon: FluentIcons.code_block_20_regular,
                  title: t.page_settings.pref_section_title_advanced,
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
            category: _SettingsCategory.keybinds,
            icon: FluentIcons.keyboard_20_regular,
            title: t.page_settings.pref_section_title_shortcuts,
          ),
          _buildCompactSidebarItem(
            context,
            category: _SettingsCategory.advanced,
            icon: FluentIcons.code_block_20_regular,
            title: t.page_settings.pref_section_title_advanced,
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 860;
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
      appBar: CustomAppBar(
        title: Text(t.page_settings.title),
      ),
      body: _buildBody(context),
    );
  }
}
