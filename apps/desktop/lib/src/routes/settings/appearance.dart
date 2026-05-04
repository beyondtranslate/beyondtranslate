import 'package:flutter/material.dart';

import '../../rust/domain/settings.dart';
import '../../services/settings_store.dart';
import '../../widgets/preference_list/preference_list.dart';
import '../../widgets/preference_list/preference_list_item.dart';
import '../../widgets/preference_list/preference_list_section.dart';

/// Mirrors macOS `AppearanceView.swift`.
class AppearanceSettingsPage extends StatefulWidget {
  const AppearanceSettingsPage({super.key});

  @override
  State<AppearanceSettingsPage> createState() => _AppearanceSettingsPageState();
}

class _AppearanceSettingsPageState extends State<AppearanceSettingsPage> {
  static const _languageOptions = <_LanguageOption>[
    _LanguageOption(code: 'en', label: 'English'),
    _LanguageOption(code: 'zh', label: 'Chinese'),
  ];

  static const _themeModes = <_ThemeOption>[
    _ThemeOption(value: 'light', label: 'Light'),
    _ThemeOption(value: 'dark', label: 'Dark'),
    _ThemeOption(value: 'system', label: 'System'),
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

    return PreferenceList(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      children: [
        PreferenceListSection(
          title: const Text('Display Language'),
          children: [
            for (final option in _languageOptions)
              PreferenceListRadioItem<String>(
                title: Text(option.label),
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
          title: const Text('Theme Mode'),
          children: [
            for (final mode in _themeModes)
              PreferenceListRadioItem<String>(
                title: Text(mode.label),
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
  const _LanguageOption({required this.code, required this.label});
  final String code;
  final String label;
}

class _ThemeOption {
  const _ThemeOption({required this.value, required this.label});
  final String value;
  final String label;
}
