import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:nativeapi/nativeapi.dart' as nativeapi;

import '../../i18n/i18n.dart';
import '../../models/ocr_engine_config.dart';
import '../../models/preference_item.dart';
import '../../models/translation_engine_config.dart';
import '../../models/translation_target.dart';
import '../../services/local_db/configuration.dart';
import '../../services/local_db/local_db.dart';
import '../../utils/platform_util.dart';
import '../../widgets/custom_alert_dialog/custom_alert_dialog.dart';
import '../../widgets/language_label/language_label.dart';
import '../../widgets/ocr_engine_icon/ocr_engine_icon.dart';
import '../../widgets/ocr_engine_name/ocr_engine_name.dart';
import '../../widgets/preference_list/preference_list.dart';
import '../../widgets/preference_list/preference_list_item.dart';
import '../../widgets/preference_list/preference_list_section.dart';
import '../../widgets/translation_engine_icon/translation_engine_icon.dart';
import '../../widgets/translation_engine_name/translation_engine_name.dart';
import '../ocr_engine_chooser.dart';
import '../ocr_engines_manage.dart';
import '../translation_engine_chooser.dart';
import '../translation_engines_manage.dart';
import '../translation_target_new.dart';
import 'index.dart';

class GeneralSettingsPage extends StatefulWidget {
  const GeneralSettingsPage({super.key});

  @override
  State<GeneralSettingsPage> createState() => _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends State<GeneralSettingsPage> {
  Configuration get _configuration => localDb.configuration;

  OcrEngineConfig? get _defaultOcrEngineConfig =>
      localDb.ocrEngine(_configuration.defaultOcrEngineId).get();

  List<TranslationTarget> get _translationTargets {
    return localDb.translationTargets.list();
  }

  List<TranslationEngineConfig> get _engineList {
    return localDb.engines.list(where: (e) => !e.disabled);
  }

  List<OcrEngineConfig> get _ocrEngineList {
    return localDb.ocrEngines.list(where: (e) => !e.disabled);
  }

  @override
  void initState() {
    localDb.preferences.addListener(_handleChanged);
    localDb.translationTargets.addListener(_handleChanged);
    localDb.privateEngines.addListener(_handleChanged);
    localDb.privateOcrEngines.addListener(_handleChanged);
    super.initState();
  }

  @override
  void dispose() {
    localDb.preferences.removeListener(_handleChanged);
    localDb.translationTargets.removeListener(_handleChanged);
    localDb.privateEngines.removeListener(_handleChanged);
    localDb.privateOcrEngines.removeListener(_handleChanged);
    super.dispose();
  }

  void _handleChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _handleTranslationModeChanged(newValue) {
    _configuration.translationMode = newValue;
  }

  Future<void> _handleExit(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext ctx) {
        return CustomAlertDialog(
          title: Text(t.page_settings.exit_app_dialog.title),
          actions: <Widget>[
            CustomDialogAction(
              child: Text(t.cancel),
              onPressed: () async {
                Navigator.of(ctx).pop();
              },
            ),
            CustomDialogAction(
              child: Text(t.ok),
              onPressed: () async {
                exit(0);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PreferenceList(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      children: [
        PreferenceListSection(
          title: Text(t.page_setting_extract_text.title),
          children: [
            PreferenceListItem(
              icon: _defaultOcrEngineConfig == null
                  ? null
                  : OcrEngineIcon(_defaultOcrEngineConfig!.type),
              title: Builder(
                builder: (_) {
                  if (_defaultOcrEngineConfig == null) {
                    return Text(t.please_choose);
                  }
                  return OcrEngineName(_defaultOcrEngineConfig!);
                },
              ),
              summary: Text(
                t.page_setting_extract_text
                    .pref_section_title_default_detect_text_engine,
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => OcrEngineChooserPage(
                      initialOcrEngineConfig: _defaultOcrEngineConfig,
                      onChoosed: (ocrEngineConfig) {
                        _configuration.defaultOcrEngineId =
                            ocrEngineConfig.identifier;
                      },
                    ),
                  ),
                );
              },
            ),
            PreferenceListSwitchItem(
              value: _configuration.autoCopyDetectedText,
              title: Text(
                t.page_setting_extract_text.pref_item_auto_copy_detected_text,
              ),
              onChanged: (newValue) async {
                _configuration.autoCopyDetectedText = newValue;
              },
            ),
          ],
        ),
        PreferenceListSection(
          title: Text(t.page_setting_translate.title),
          children: [
            PreferenceListItem(
              icon: _configuration.defaultTranslateEngineConfig == null
                  ? null
                  : TranslationEngineIcon(
                      _configuration.defaultTranslateEngineConfig!.type,
                    ),
              title: Builder(
                builder: (_) {
                  if (_configuration.defaultTranslateEngineConfig == null) {
                    return Text(t.please_choose);
                  }
                  return TranslationEngineName(
                    _configuration.defaultTranslateEngineConfig!,
                  );
                },
              ),
              summary: Text(
                t.page_setting_translate
                    .pref_section_title_default_translate_engine,
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => TranslationEngineChooserPage(
                      initialEngineConfig:
                          _configuration.defaultTranslateEngineConfig,
                      onChoosed: (engineConfig) {
                        _configuration.defaultTranslateEngineId =
                            engineConfig.identifier;
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        PreferenceListSection(
          title: Text(
              t.page_setting_translate.pref_section_title_translation_mode),
          children: [
            PreferenceListRadioItem(
              value: kTranslationModeManual,
              groupValue: _configuration.translationMode,
              onChanged: _handleTranslationModeChanged,
              title: Text(t.translation_mode.manual),
            ),
            PreferenceListRadioItem(
              value: kTranslationModeAuto,
              groupValue: _configuration.translationMode,
              onChanged: _handleTranslationModeChanged,
              title: Text(t.translation_mode.auto),
            ),
          ],
        ),
        if (_configuration.translationMode == kTranslationModeAuto)
          PreferenceListSection(
            title: Text(
              t.page_setting_translate
                  .pref_section_title_default_detect_language_engine,
            ),
            children: [
              PreferenceListItem(
                icon: _configuration.defaultEngineConfig == null
                    ? null
                    : TranslationEngineIcon(
                        _configuration.defaultEngineConfig!.type,
                      ),
                title: Builder(
                  builder: (_) {
                    if (_configuration.defaultEngineConfig == null) {
                      return Text(t.please_choose);
                    }
                    return TranslationEngineName(
                      _configuration.defaultEngineConfig!,
                    );
                  },
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TranslationEngineChooserPage(
                        initialEngineConfig: _configuration.defaultEngineConfig,
                        onChoosed: (engineConfig) {
                          _configuration.defaultEngineId =
                              engineConfig.identifier;
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        if (_configuration.translationMode == kTranslationModeAuto)
          PreferenceListSection(
            title: Text(
                t.page_setting_translate.pref_section_title_translation_target),
            children: [
              for (TranslationTarget translationTarget in _translationTargets)
                PreferenceListItem(
                  title: Row(
                    children: [
                      if (translationTarget.sourceLanguage != null)
                        LanguageLabel(translationTarget.sourceLanguage!),
                      if (translationTarget.targetLanguage != null)
                        Container(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Icon(
                            FluentIcons.arrow_right_20_regular,
                            size: 16,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                      if (translationTarget.targetLanguage != null)
                        LanguageLabel(translationTarget.targetLanguage!),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TranslationTargetNewPage(
                          translationTarget: translationTarget,
                        ),
                      ),
                    );
                  },
                ),
              PreferenceListItem(
                title: Text(
                  t.add,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                accessoryView: Container(),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const TranslationTargetNewPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        PreferenceListSection(
          title: Text(t.page_settings.pref_section_title_input_settings),
          children: [
            PreferenceListRadioItem<String>(
              value: kInputSettingSubmitWithEnter,
              groupValue: _configuration.inputSetting,
              title: Text(t.page_settings.pref_item_title_submit_with_enter),
              onChanged: (newValue) {
                _configuration.inputSetting = newValue;
              },
            ),
            PreferenceListRadioItem<String>(
              value: kInputSettingSubmitWithMetaEnter,
              groupValue: _configuration.inputSetting,
              title: Text(
                kIsMacOS
                    ? t.page_settings.pref_item_title_submit_with_meta_enter_mac
                    : t.page_settings.pref_item_title_submit_with_meta_enter,
              ),
              onChanged: (newValue) {
                _configuration.inputSetting = newValue;
              },
            ),
          ],
        ),
        PreferenceListSection(
          title: Text(t
              .page_setting_translate.pref_item_title_double_click_copy_result),
          children: [
            PreferenceListSwitchItem(
              value: _configuration.doubleClickCopyResult,
              title: Text(
                t.page_setting_translate
                    .pref_item_title_double_click_copy_result,
              ),
              onChanged: (newValue) async {
                _configuration.doubleClickCopyResult = newValue;
              },
            ),
          ],
        ),
        PreferenceListSection(
          title: Text(t.page_settings.pref_section_title_service_integration),
          children: [
            PreferenceListItem(
              title: Text(t.page_settings.pref_item_title_engines),
              detailText: Row(
                children: [
                  for (var item in _engineList)
                    Container(
                      margin: const EdgeInsets.only(left: 4),
                      child: TranslationEngineIcon(item.type, size: 18),
                    ),
                ],
              ),
              onTap: () {
                const TranslationEnginesManageRoute().push(context);
              },
            ),
            PreferenceListItem(
              title: Text(t.page_settings.pref_item_title_ocr_engines),
              detailText: Row(
                children: [
                  for (var item in _ocrEngineList)
                    Container(
                      margin: const EdgeInsets.only(left: 4),
                      child: OcrEngineIcon(item.type, size: 18),
                    ),
                ],
              ),
              onTap: () {
                const OcrEnginesManageRoute().push(context);
              },
            ),
            PreferenceListItem(
              title: const Text('Providers'),
              summary: const Text('Manage runtime provider configurations.'),
              onTap: () {
                const ProvidersSettingsRoute().push(context);
              },
            ),
          ],
        ),
        PreferenceListSection(
          title: Text(t.page_settings.pref_section_title_others),
          children: [
            PreferenceListItem(
              title: Text(t.page_settings.pref_item_title_about),
              onTap: () async {
                final result = nativeapi.UrlOpener.instance.open(
                  'https://github.com/biyidev/biyi',
                );
                if (!result.success) {
                  throw result.errorMessage;
                }
              },
            ),
          ],
        ),
        PreferenceListSection(
          children: [
            PreferenceListItem(
              title: Container(
                margin: EdgeInsets.zero,
                width: double.infinity,
                child: Text(
                  t.page_settings.pref_item_title_exit_app,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
              accessoryView: Container(),
              onTap: () {
                _handleExit(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}
