import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../i18n/i18n.dart';
import '../../services/mac_settings.dart';
import '../../services/settings_store.dart';
import '../../utils/language_util.dart';
import '../../utils/platform_util.dart';
import '../../widgets/settings_page.dart';
import '../../widgets/ui/button.dart';
import '../../widgets/ui/preference_list_item.dart';
import '../../widgets/ui/preference_list_section.dart';

/// Mirrors macOS `GeneralView.swift`.
class GeneralSettingsPage extends StatefulWidget {
  const GeneralSettingsPage({super.key});

  /// When set to true before the page is opened, the common languages
  /// dialog will auto-open once the page is built. Set by
  /// [MiniTranslatorPageState._handleManageCommonLanguages].
  static bool pendingOpenCommonLanguages = false;

  /// When set to true before the page is opened, the add target dialog
  /// will auto-open once the page is built. Set by
  /// [MiniTranslatorPageState._handleAddTarget].
  static bool pendingOpenAddTarget = false;

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
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (GeneralSettingsPage.pendingOpenCommonLanguages) {
      GeneralSettingsPage.pendingOpenCommonLanguages = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showCommonLanguagesDialog(context);
      });
    }

    if (GeneralSettingsPage.pendingOpenAddTarget) {
      GeneralSettingsPage.pendingOpenAddTarget = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAddTargetDialog(context);
      });
    }
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
  // `translationServiceOptions`). The id is the provider id consumed by the
  // runtime.
  List<_ServiceOption> get _ocrServiceOptions {
    return [
      _ServiceOption(
          id: 'builtin', name: t.settings.general.option.built_in_ocr),
      _ServiceOption(
          id: 'tesseract', name: t.settings.general.option.tesseract),
      _ServiceOption(id: 'youdao', name: t.settings.general.option.youdao_ocr),
    ];
  }

  List<_ServiceOption> get _dictionaryServiceOptions {
    return settingsStore.providers
        .where((p) => p.capabilities.contains(ProviderCapability.dictionary))
        .map((p) => _ServiceOption(id: p.id, name: p.id))
        .toList();
  }

  List<_ServiceOption> get _translationServiceOptions {
    return settingsStore.providers
        .where((p) => p.capabilities.contains(ProviderCapability.translation))
        .map((p) => _ServiceOption(id: p.id, name: p.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final general = t.settings.general;
    final hasDirectoryServices = _dictionaryServiceOptions.isNotEmpty;
    final hasTranslationServices = _translationServiceOptions.isNotEmpty;

    return SettingsPage(
      title: general.title,
      children: [
        PreferenceListSection(
          children: [
            PreferenceListSwitchItem(
              title: Text(general.row.launch_at_login),
              value: _general.launchAtLogin,
              onChanged: (v) async {
                await settingsStore.updateGeneral(
                  GeneralSettingsPatch(launchAtLogin: v),
                );
              },
            ),
            PreferenceListSwitchItem(
              title: Text(general.row.show_in_menu_bar),
              value: _general.showInMenuBar,
              onChanged: (v) async {
                await settingsStore.updateGeneral(
                  GeneralSettingsPatch(showInMenuBar: v),
                );
              },
            ),
          ],
        ),
        if (kIsMacOS)
          PreferenceListSection(
            title: Text(general.section.permissions),
            children: [
              _PermissionAccessRow(title: general.row.screen_capture_access),
              _PermissionAccessRow(title: general.row.screen_selection_access),
            ],
          ),
        PreferenceListSection(
          title: Text(general.section.ocr),
          children: [
            _ServicePickerItem(
              title: general.row.default_ocr_service,
              options: _ocrServiceOptions,
              value: _providerId(_general.defaultOcrService),
              onChanged: (v) async {
                await settingsStore.updateGeneral(
                  GeneralSettingsPatch(defaultOcrService: _providerId(v)),
                );
              },
            ),
            PreferenceListSwitchItem(
              title: Text(general.row.auto_copy_detected_text),
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
          title: Text(general.section.directory),
          children: [
            if (hasDirectoryServices)
              _ServicePickerItem(
                title: general.row.default_directory_service,
                options: _dictionaryServiceOptions,
                value: _providerId(_general.defaultDirectoryService),
                onChanged: (v) async {
                  await settingsStore.updateGeneral(
                    GeneralSettingsPatch(
                      defaultDirectoryService: _providerId(v),
                    ),
                  );
                },
              )
            else
              _ServiceUnavailableItem(
                title: general.row.default_directory_service,
                onAddProvider: () => context.go('/settings/providers'),
              ),
          ],
        ),
        PreferenceListSection(
          title: Text(general.section.translation),
          children: [
            if (hasTranslationServices)
              _ServicePickerItem(
                title: general.row.default_translation_service,
                options: _translationServiceOptions,
                value: _providerId(_general.defaultTranslationService),
                onChanged: (v) async {
                  await settingsStore.updateGeneral(
                    GeneralSettingsPatch(
                      defaultTranslationService: _providerId(v),
                    ),
                  );
                },
              )
            else
              _ServiceUnavailableItem(
                title: general.row.default_translation_service,
                onAddProvider: () => context.go('/settings/providers'),
              ),
            PreferenceListSwitchItem(
              title: Text(general.row.double_click_copy_result),
              value: _general.doubleClickCopyResult,
              disabled: !hasTranslationServices,
              onChanged: (v) async {
                await settingsStore.updateGeneral(
                  GeneralSettingsPatch(doubleClickCopyResult: v),
                );
              },
            ),
            PreferenceListItem(
              title: Text(general.row.common_languages),
              summary: Text(
                '${_general.commonLanguages.length} / ${supportedLanguages.length}',
              ),
              onTap: () => _showCommonLanguagesDialog(context),
              detailText: Text(
                t.common.ui.button.edit,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        if (hasTranslationServices)
          PreferenceListSection(
            title: Text(general.section.translation_target),
            children: [
              for (final target in _general.translationTargets)
                PreferenceListItem(
                  title: Row(
                    children: [
                      Text(getSourceDisplayName(target.source)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.arrow_forward, size: 16),
                      ),
                      Text(getLanguageName(target.target)),
                    ],
                  ),
                  detailText: TextButton(
                    onPressed: () => _showEditTargetDialog(context, target),
                    child: Text(t.common.ui.button.edit),
                  ),
                ),
              if (_general.translationTargets.isEmpty)
                const PreferenceListItem(
                  title: Text(
                    'No translation targets configured.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              PreferenceListItem(
                title: TextButton(
                  onPressed: () => _showAddTargetDialog(context),
                  child: Text(general.button.add_target),
                ),
                accessoryView: const SizedBox.shrink(),
              ),
            ],
          ),
        PreferenceListSection(
          title: Text(general.section.input),
          children: [
            for (final mode in InputSubmitMode.values)
              PreferenceListRadioItem<InputSubmitMode>(
                title: Text(_inputSubmitModeTitle(context, mode)),
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

  Future<void> _showAddTargetDialog(BuildContext context) async {
    String source = kAutoSource;
    String target = defaultTargetLanguage;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(t.settings.general.button.add_target),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: source,
                    decoration:
                        const InputDecoration(labelText: 'Source Language'),
                    items: buildLanguageDropdownItems(
                      commonLanguageCodes: _general.commonLanguages,
                      showAutoDetect: true,
                      showNative: true,
                    ),
                    onChanged: (v) {
                      if (v != null) setDialogState(() => source = v);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: target,
                    decoration:
                        const InputDecoration(labelText: 'Target Language'),
                    items: buildLanguageDropdownItems(
                      commonLanguageCodes: _general.commonLanguages,
                      showNative: true,
                    ),
                    onChanged: (v) {
                      if (v != null) setDialogState(() => target = v);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(t.common.ui.button.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(t.common.ui.button.ok),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == true) {
      final newTargets = [
        ..._general.translationTargets,
        TranslationTarget(
          source: source,
          target: target,
        ),
      ];
      await settingsStore.updateGeneral(
        GeneralSettingsPatch(translationTargets: newTargets),
      );
    }
  }

  Future<void> _showEditTargetDialog(
      BuildContext context, TranslationTarget target) async {
    final index = _general.translationTargets.indexOf(target);
    if (index < 0) return;

    String source = target.source;
    String targetLang = target.target;

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(t.common.ui.button.edit),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: source,
                    decoration:
                        const InputDecoration(labelText: 'Source Language'),
                    items: buildLanguageDropdownItems(
                      commonLanguageCodes: _general.commonLanguages,
                      showAutoDetect: true,
                      showNative: true,
                    ),
                    onChanged: (v) {
                      if (v != null) setDialogState(() => source = v);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: targetLang,
                    decoration:
                        const InputDecoration(labelText: 'Target Language'),
                    items: buildLanguageDropdownItems(
                      commonLanguageCodes: _general.commonLanguages,
                      showNative: true,
                    ),
                    onChanged: (v) {
                      if (v != null) setDialogState(() => targetLang = v);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    final newTargets = [..._general.translationTargets];
                    newTargets.removeAt(index);
                    await settingsStore.updateGeneral(
                      GeneralSettingsPatch(translationTargets: newTargets),
                    );
                    if (context.mounted) Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: Text(t.common.ui.button.delete),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(t.common.ui.button.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'save'),
                  child: Text(t.common.ui.button.save),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == 'save') {
      final newTargets = [..._general.translationTargets];
      newTargets[index] = TranslationTarget(
        source: source,
        target: targetLang,
      );
      await settingsStore.updateGeneral(
        GeneralSettingsPatch(translationTargets: newTargets),
      );
    }
  }

  Future<void> _showCommonLanguagesDialog(BuildContext context) async {
    final selected = Set<String>.from(_general.commonLanguages);
    final available = supportedLanguages;

    final result = await showDialog<List<String>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(t.settings.general.row.common_languages),
              content: SizedBox(
                width: 320,
                height: 400,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        t.settings.general.row.common_languages_hint,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.color
                                  ?.withValues(alpha: 0.6),
                            ),
                      ),
                    ),
                    ...available.map((lang) {
                      return CheckboxListTile(
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        value: selected.contains(lang),
                        title: Text(getLanguageName(lang, showNative: true)),
                        onChanged: (checked) {
                          setDialogState(() {
                            if (checked == true) {
                              selected.add(lang);
                            } else {
                              selected.remove(lang);
                            }
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(t.common.ui.button.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, selected.toList()),
                  child: Text(t.common.ui.button.save),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      await settingsStore.updateGeneral(
        GeneralSettingsPatch(commonLanguages: result),
      );
    }
  }
}

String _providerId(String serviceId) {
  for (final suffix in const ['+translation', '+dictionary', '+ocr']) {
    if (serviceId.endsWith(suffix)) {
      return serviceId.substring(0, serviceId.length - suffix.length);
    }
  }
  return serviceId;
}

String _inputSubmitModeTitle(BuildContext context, InputSubmitMode mode) {
  switch (mode) {
    case InputSubmitMode.enter:
      return t.settings.general.row.submit_with_enter;
    case InputSubmitMode.commandEnter:
      return t.settings.general.row.submit_with_meta_enter_mac;
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
  });

  final String title;
  final List<_ServiceOption> options;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final isEmpty = options.isEmpty;
    final items = <DropdownMenuItem<String>>[
      DropdownMenuItem<String>(
        value: '',
        child: Text(t.settings.general.option.none),
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
          ? Text(t.settings.general.option.no_services_available)
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

class _ServiceUnavailableItem extends StatelessWidget {
  const _ServiceUnavailableItem({
    required this.title,
    required this.onAddProvider,
  });

  final String title;
  final VoidCallback onAddProvider;

  @override
  Widget build(BuildContext context) {
    return PreferenceListItem(
      title: Text(title),
      detailText: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(t.settings.general.option.no_services_available),
          const SizedBox(width: 8),
          Button.outlined(
            onPressed: onAddProvider,
            child: Text(t.settings.general.button.add_provider),
          ),
        ],
      ),
    );
  }
}

class _PermissionAccessRow extends StatelessWidget {
  const _PermissionAccessRow({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return PreferenceListItem(
      title: Text(title),
      detailText: Button.outlined(
        onPressed: MacSettings.showAndHighlightPermissions,
        child: Text(t.settings.general.button.grant),
      ),
    );
  }
}
