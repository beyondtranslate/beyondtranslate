import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:flutter/material.dart';

import '../../i18n/i18n.dart';
import '../../services/settings_store.dart';
import '../../utils/language_util.dart';
import '../../widgets/settings_page.dart';
import '../../widgets/ui/preference_list_item.dart';
import '../../widgets/ui/preference_list_section.dart';

/// Mirrors macOS `AppearanceView.swift`.
class AppearanceSettingsPage extends StatefulWidget {
  const AppearanceSettingsPage({super.key});

  @override
  State<AppearanceSettingsPage> createState() => _AppearanceSettingsPageState();
}

class _AppearanceSettingsPageState extends State<AppearanceSettingsPage> {
  static const _themeModes = <_ThemeOption>[
    _ThemeOption(value: 'light'),
    _ThemeOption(value: 'dark'),
    _ThemeOption(value: 'system'),
  ];

  @override
  void initState() {
    super.initState();
    settingsStore.addListener(_handleChanged);
    settingsStore.reloadAppearance();
  }

  @override
  void dispose() {
    settingsStore.removeListener(_handleChanged);
    super.dispose();
  }

  void _handleChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final appearance = settingsStore.appearance;
    final appearanceText = t.settings.appearance;

    return SettingsPage(
      title: appearanceText.title,
      children: [
        PreferenceListSection(
          title: Text(appearanceText.section.app_language),
          children: [
            for (final option
                in appLanguages.map((code) => _LanguageOption(code: code)))
              PreferenceListRadioItem<String>(
                title: Text(option.title),
                value: option.code,
                groupValue: appearance.language,
                onChanged: (v) async {
                  await settingsStore.updateAppearance(
                    AppearanceSettingsPatch(language: v),
                  );
                },
              ),
          ],
        ),
        PreferenceListSection(
          title: Text(appearanceText.section.theme_mode),
          children: [
            for (final mode in _themeModes)
              PreferenceListRadioItem<String>(
                title: Text(mode.title),
                value: mode.value,
                groupValue: appearance.themeMode,
                onChanged: (v) async {
                  await settingsStore.updateAppearance(
                    AppearanceSettingsPatch(themeMode: v),
                  );
                },
              ),
          ],
        ),
      ],
    );
  }
}

class _LanguageOption {
  const _LanguageOption({required this.code});
  final String code;

  String get title {
    return getLanguageName(code);
  }
}

class _ThemeOption {
  const _ThemeOption({required this.value});
  final String value;

  String get title {
    switch (value) {
      case 'light':
        return t.theme.mode.light;
      case 'dark':
        return t.theme.mode.dark;
      case 'system':
        return t.theme.mode.system;
      default:
        return value;
    }
  }
}
