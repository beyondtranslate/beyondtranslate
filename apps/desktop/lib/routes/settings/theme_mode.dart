import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../i18n/i18n.dart';
import '../../services/local_db/configuration.dart';
import '../../services/local_db/local_db.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/preference_list/preference_list.dart';
import '../../widgets/preference_list/preference_list_item.dart';
import '../../widgets/preference_list/preference_list_section.dart';

part 'theme_mode.g.dart';

@TypedGoRoute<SettingThemeModeRoute>(path: '/settings/theme-mode')
class SettingThemeModeRoute extends GoRouteData with $SettingThemeModeRoute {
  const SettingThemeModeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingThemeModePage();
  }
}

class SettingThemeModePage extends StatefulWidget {
  const SettingThemeModePage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingThemeModePageState();
}

class _SettingThemeModePageState extends State<SettingThemeModePage> {
  Configuration get _configuration => localDb.configuration;

  @override
  void initState() {
    localDb.preferences.addListener(_handleChanged);
    super.initState();
  }

  @override
  void dispose() {
    localDb.preferences.removeListener(_handleChanged);
    super.dispose();
  }

  void _handleChanged() {
    if (mounted) setState(() {});
  }

  void _handleThemeModeChanged(newValue) {
    _configuration.themeMode = newValue;
  }

  Widget _buildBody(BuildContext context) {
    return PreferenceList(
      children: [
        PreferenceListSection(
          children: [
            PreferenceListRadioItem(
              value: ThemeMode.light,
              groupValue: _configuration.themeMode,
              onChanged: _handleThemeModeChanged,
              title: Text(
                'theme_mode.${ThemeMode.light.name}'.tr(),
              ),
            ),
            PreferenceListRadioItem(
              value: ThemeMode.dark,
              groupValue: _configuration.themeMode,
              onChanged: _handleThemeModeChanged,
              title: Text(
                'theme_mode.${ThemeMode.dark.name}'.tr(),
              ),
            ),
            PreferenceListRadioItem(
              value: ThemeMode.system,
              groupValue: _configuration.themeMode,
              onChanged: _handleThemeModeChanged,
              title: Text(
                'theme_mode.${ThemeMode.system.name}'.tr(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(t('title')),
      ),
      body: _buildBody(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  String t(String key, {List<String> args = const []}) {
    return 'page_setting_theme_mode.$key'.tr(args: args);
  }
}
