import 'package:flutter/material.dart';

import '../../i18n/i18n.dart';
import '../../services/local_db/configuration.dart';
import '../../services/local_db/local_db.dart';
import '../../utils/language_util.dart';
import '../../widgets/language_label/language_label.dart';
import '../../widgets/preference_list/preference_list.dart';
import '../../widgets/preference_list/preference_list_item.dart';
import '../../widgets/preference_list/preference_list_section.dart';

const List<double> _kMaxWindowHeightOptions = [700, 800, 900, 1000];

class AppearanceSettingsPage extends StatefulWidget {
  const AppearanceSettingsPage({super.key});

  @override
  State<AppearanceSettingsPage> createState() => _AppearanceSettingsPageState();
}

class _AppearanceSettingsPageState extends State<AppearanceSettingsPage> {
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
    if (mounted) {
      setState(() {});
    }
  }

  void _handleThemeModeChanged(newValue) {
    _configuration.themeMode = newValue;
  }

  @override
  Widget build(BuildContext context) {
    return PreferenceList(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      children: [
        PreferenceListSection(
          title: Text(t.page_setting_interface.title),
          children: [
            PreferenceListSwitchItem(
              title:
                  Text(t.page_setting_interface.pref_item_title_show_tray_icon),
              summary:
                  Text(t.page_setting_interface.pref_section_title_tray_icon),
              value: _configuration.showTrayIcon,
              onChanged: (newValue) {
                _configuration.showTrayIcon = newValue;
              },
            ),
          ],
        ),
        PreferenceListSection(
          title: Text(
            t.page_setting_interface.pref_section_title_max_window_height,
          ),
          children: [
            for (var option in _kMaxWindowHeightOptions)
              PreferenceListRadioItem<double>(
                title: Text('${option.toInt()}'),
                value: option,
                groupValue: _configuration.maxWindowHeight,
                onChanged: (newValue) {
                  _configuration.maxWindowHeight = newValue;
                },
              ),
          ],
        ),
        PreferenceListSection(
          title: Text(t.page_setting_app_language.title),
          children: [
            for (var appLanguage in kAppLanguages)
              PreferenceListRadioItem<String>(
                title: LanguageLabel(appLanguage),
                accessoryView: Container(),
                value: appLanguage,
                groupValue: _configuration.appLanguage,
                onChanged: (newGroupValue) async {
                  _configuration.appLanguage = newGroupValue;
                  await context.setLocale(languageToLocale(newGroupValue));
                },
              ),
          ],
        ),
        PreferenceListSection(
          title: Text(t.page_setting_theme_mode.title),
          children: [
            PreferenceListRadioItem(
              value: ThemeMode.light,
              groupValue: _configuration.themeMode,
              onChanged: _handleThemeModeChanged,
              title: Text(t.theme_mode.light),
            ),
            PreferenceListRadioItem(
              value: ThemeMode.dark,
              groupValue: _configuration.themeMode,
              onChanged: _handleThemeModeChanged,
              title: Text(t.theme_mode.dark),
            ),
            PreferenceListRadioItem(
              value: ThemeMode.system,
              groupValue: _configuration.themeMode,
              onChanged: _handleThemeModeChanged,
              title: Text(t.theme_mode.system),
            ),
          ],
        ),
      ],
    );
  }
}
