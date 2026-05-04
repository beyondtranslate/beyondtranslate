import 'package:flutter/material.dart';

import '../../rust/domain/settings.dart';
import '../../services/settings_store.dart';
import '../../widgets/preference_list/preference_list.dart';
import '../../widgets/preference_list/preference_list_item.dart';
import '../../widgets/preference_list/preference_list_section.dart';

/// Mirrors macOS `GeneralView.swift`.
class GeneralSettingsPage extends StatefulWidget {
  const GeneralSettingsPage({super.key});

  @override
  State<GeneralSettingsPage> createState() => _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends State<GeneralSettingsPage> {
  @override
  void initState() {
    super.initState();
    settingsStore.addListener(_handleChanged);
    // Refresh when entering the page.
    settingsStore.reloadGeneral();
    settingsStore.reloadProviders();
  }

  @override
  void dispose() {
    settingsStore.removeListener(_handleChanged);
    super.dispose();
  }

  void _handleChanged() {
    if (mounted) setState(() {});
  }

  GeneralSettings get _general => settingsStore.general;

  // Service options (mirrors Swift `dictionaryServiceOptions` /
  // `translationServiceOptions`). The id is `{providerId}+{capability}` to
  // match the runtime contract.
  List<_ServiceOption> get _ocrServiceOptions {
    return [
      const _ServiceOption(id: 'builtin', name: 'Built-in OCR'),
      const _ServiceOption(id: 'tesseract', name: 'Tesseract'),
      const _ServiceOption(id: 'youdao', name: 'Youdao OCR'),
    ];
  }

  List<_ServiceOption> get _dictionaryServiceOptions {
    return settingsStore.providers
        .where((p) => p.capabilities.contains('dictionary'))
        .map((p) => _ServiceOption(id: '${p.id}+dictionary', name: p.id))
        .toList();
  }

  List<_ServiceOption> get _translationServiceOptions {
    return settingsStore.providers
        .where((p) => p.capabilities.contains('translation'))
        .map((p) => _ServiceOption(id: '${p.id}+translation', name: p.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return PreferenceList(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      children: [
        PreferenceListSection(
          children: [
            PreferenceListSwitchItem(
              title: const Text('Launch at login'),
              value: _general.launchAtLogin,
              onChanged: (v) async {
                await settingsStore.updateGeneral(
                  GeneralSettingsPatch(launchAtLogin: v),
                );
              },
            ),
            PreferenceListSwitchItem(
              title: const Text('Show menu bar'),
              value: _general.showMenuBar,
              onChanged: (v) async {
                await settingsStore.updateGeneral(
                  GeneralSettingsPatch(showMenuBar: v),
                );
              },
            ),
          ],
        ),
        PreferenceListSection(
          title: const Text('Extract Text'),
          children: [
            _ServicePickerItem(
              title: 'Default extract text service',
              options: _ocrServiceOptions,
              value: _general.defaultOcrService,
              onChanged: (v) async {
                await settingsStore.updateGeneral(
                  GeneralSettingsPatch(defaultOcrService: v),
                );
              },
            ),
            PreferenceListSwitchItem(
              title: const Text('Auto copy detected text'),
              value: _general.autoCopyDetectedText,
              onChanged: (v) async {
                await settingsStore.updateGeneral(
                  GeneralSettingsPatch(autoCopyDetectedText: v),
                );
              },
            ),
          ],
        ),
        PreferenceListSection(
          title: const Text('Directory'),
          children: [
            _ServicePickerItem(
              title: 'Default directory service',
              options: _dictionaryServiceOptions,
              value: _general.defaultDirectoryService,
              emptyLabel: 'No services available',
              onChanged: (v) async {
                await settingsStore.updateGeneral(
                  GeneralSettingsPatch(defaultDirectoryService: v),
                );
              },
            ),
          ],
        ),
        PreferenceListSection(
          title: const Text('Translation'),
          children: [
            _ServicePickerItem(
              title: 'Default translation service',
              options: _translationServiceOptions,
              value: _general.defaultTranslationService,
              emptyLabel: 'No services available',
              onChanged: (v) async {
                await settingsStore.updateGeneral(
                  GeneralSettingsPatch(defaultTranslationService: v),
                );
              },
            ),
            PreferenceListItem(
              title: const Text('Translation mode'),
              detailText: DropdownButton<TranslationMode>(
                value: _general.translationMode,
                underline: const SizedBox.shrink(),
                items: TranslationMode.values
                    .map(
                      (mode) => DropdownMenuItem<TranslationMode>(
                        value: mode,
                        child: Text(_translationModeTitle(mode)),
                      ),
                    )
                    .toList(),
                onChanged: (mode) async {
                  if (mode == null) return;
                  await settingsStore.updateGeneral(
                    GeneralSettingsPatch(translationMode: mode),
                  );
                },
              ),
            ),
            PreferenceListSwitchItem(
              title: const Text('Double click to copy translation result'),
              value: _general.doubleClickCopyResult,
              onChanged: (v) async {
                await settingsStore.updateGeneral(
                  GeneralSettingsPatch(doubleClickCopyResult: v),
                );
              },
            ),
          ],
        ),
        if (_general.translationMode == TranslationMode.auto)
          PreferenceListSection(
            title: const Text('Translation Target'),
            children: [
              for (final target in _general.translationTargets)
                PreferenceListItem(
                  title: Row(
                    children: [
                      Text(target.source),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.arrow_forward, size: 16),
                      ),
                      Text(target.target),
                    ],
                  ),
                ),
              if (_general.translationTargets.isEmpty)
                const PreferenceListItem(
                  title: Text(
                    'No translation targets configured.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
            ],
          ),
        PreferenceListSection(
          title: const Text('Input Settings'),
          children: [
            for (final mode in InputSubmitMode.values)
              PreferenceListRadioItem<InputSubmitMode>(
                title: Text(_inputSubmitModeTitle(mode)),
                value: mode,
                groupValue: _general.inputSubmitMode,
                onChanged: (v) async {
                  await settingsStore.updateGeneral(
                    GeneralSettingsPatch(inputSubmitMode: v),
                  );
                },
              ),
          ],
        ),
      ],
    );
  }
}

String _translationModeTitle(TranslationMode mode) {
  switch (mode) {
    case TranslationMode.auto:
      return 'Auto';
    case TranslationMode.manual:
      return 'Manual';
  }
}

String _inputSubmitModeTitle(InputSubmitMode mode) {
  switch (mode) {
    case InputSubmitMode.enter:
      return 'Submit with Enter';
    case InputSubmitMode.commandEnter:
      return 'Submit with Command + Enter';
  }
}

class _ServiceOption {
  const _ServiceOption({required this.id, required this.name});
  final String id;
  final String name;
}

class _ServicePickerItem extends StatelessWidget {
  const _ServicePickerItem({
    required this.title,
    required this.options,
    required this.value,
    required this.onChanged,
    this.emptyLabel,
  });

  final String title;
  final List<_ServiceOption> options;
  final String value;
  final ValueChanged<String> onChanged;
  final String? emptyLabel;

  @override
  Widget build(BuildContext context) {
    final isEmpty = options.isEmpty;
    final items = <DropdownMenuItem<String>>[
      const DropdownMenuItem<String>(
        value: '',
        child: Text('None'),
      ),
      for (final opt in options)
        DropdownMenuItem<String>(
          value: opt.id,
          child: Text(opt.name),
        ),
    ];

    // If the persisted value is not present in the options, keep it as a
    // leading item so the picker still reflects the current selection.
    final hasValue = value.isEmpty || options.any((o) => o.id == value);
    if (!hasValue) {
      items.add(
        DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      );
    }

    return PreferenceListItem(
      title: Text(title),
      detailText: isEmpty
          ? Text(emptyLabel ?? 'No services available')
          : DropdownButton<String>(
              value: hasValue ? value : value,
              underline: const SizedBox.shrink(),
              items: items,
              onChanged: (v) {
                if (v == null) return;
                onChanged(v);
              },
            ),
    );
  }
}
