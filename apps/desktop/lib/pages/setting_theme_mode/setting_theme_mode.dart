import 'package:biyi_app/includes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SettingThemeModePage extends StatefulWidget {
  const SettingThemeModePage({
    Key? key,
  }) : super(key: key);

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
                'theme_mode.${describeEnum(ThemeMode.light)}'.tr(),
              ),
            ),
            PreferenceListRadioItem(
              value: ThemeMode.dark,
              groupValue: _configuration.themeMode,
              onChanged: _handleThemeModeChanged,
              title: Text(
                'theme_mode.${describeEnum(ThemeMode.dark)}'.tr(),
              ),
            ),
            PreferenceListRadioItem(
              value: ThemeMode.system,
              groupValue: _configuration.themeMode,
              onChanged: _handleThemeModeChanged,
              title: Text(
                'theme_mode.${describeEnum(ThemeMode.system)}'.tr(),
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
