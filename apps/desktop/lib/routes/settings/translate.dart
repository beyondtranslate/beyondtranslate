import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../i18n/i18n.dart';
import '../../models/preference_item.dart';
import '../../models/translation_target.dart';
import '../../services/local_db/configuration.dart';
import '../../services/local_db/local_db.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/language_label/language_label.dart';
import '../../widgets/preference_list/preference_list.dart';
import '../../widgets/preference_list/preference_list_item.dart';
import '../../widgets/preference_list/preference_list_section.dart';
import '../../widgets/translation_engine_icon/translation_engine_icon.dart';
import '../../widgets/translation_engine_name/translation_engine_name.dart';
import '../translation_engine_chooser.dart';
import '../translation_target_new.dart';

part 'translate.g.dart';

@TypedGoRoute<SettingTranslateRoute>(path: '/settings/translate')
class SettingTranslateRoute extends GoRouteData with $SettingTranslateRoute {
  const SettingTranslateRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingTranslatePage();
  }
}

class SettingTranslatePage extends StatefulWidget {
  const SettingTranslatePage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingTranslatePageState();
}

class _SettingTranslatePageState extends State<SettingTranslatePage> {
  Configuration get _configuration => localDb.configuration;

  List<TranslationTarget> get _translationTargets {
    return localDb.translationTargets.list();
  }

  @override
  void initState() {
    localDb.preferences.addListener(_handleChanged);
    localDb.translationTargets.addListener(_handleChanged);
    super.initState();
  }

  @override
  void dispose() {
    localDb.preferences.removeListener(_handleChanged);
    localDb.translationTargets.removeListener(_handleChanged);
    super.dispose();
  }

  void _handleChanged() {
    if (mounted) setState(() {});
  }

  void _handleTranslationModeChanged(newValue) {
    _configuration.translationMode = newValue;
  }

  Widget _buildBody(BuildContext context) {
    return PreferenceList(
      children: [
        PreferenceListSection(
          title: Text(t('pref_section_title_default_translate_engine')),
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
                    return Text('please_choose'.tr());
                  }
                  return TranslationEngineName(
                    _configuration.defaultTranslateEngineConfig!,
                  );
                },
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
          title: Text(t('pref_section_title_translation_mode')),
          children: [
            PreferenceListRadioItem(
              value: kTranslationModeManual,
              groupValue: _configuration.translationMode,
              onChanged: _handleTranslationModeChanged,
              title: Text('translation_mode.manual'.tr()),
            ),
            PreferenceListRadioItem(
              value: kTranslationModeAuto,
              groupValue: _configuration.translationMode,
              onChanged: _handleTranslationModeChanged,
              title: Text('translation_mode.auto'.tr()),
            ),
          ],
        ),
        if (_configuration.translationMode == kTranslationModeAuto)
          PreferenceListSection(
            title: Text(t('pref_section_title_default_detect_language_engine')),
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
                      return Text('please_choose'.tr());
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
            title: Text(t('pref_section_title_translation_target')),
            children: [
              for (TranslationTarget translationTarget in _translationTargets)
                PreferenceListItem(
                  title: Builder(
                    builder: (_) {
                      return Row(
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
                      );
                    },
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
                  'add'.tr(),
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
          children: [
            PreferenceListSwitchItem(
              value: _configuration.doubleClickCopyResult,
              title: Text(t('pref_item_title_double_click_copy_result')),
              onChanged: (newValue) async {
                _configuration.doubleClickCopyResult = newValue;
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('page_setting_translate.title'.tr()),
      ),
      body: _buildBody(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  String t(String key, {List<String> args = const []}) {
    return 'page_setting_translate.$key'.tr(args: args);
  }
}
