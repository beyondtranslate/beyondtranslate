import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nativeapi/nativeapi.dart' as nativeapi;

import '../../i18n/i18n.dart';
import '../../models/ocr_engine_config.dart';
import '../../models/preference_item.dart';
import '../../models/translation_engine_config.dart';
import '../../services/local_db/configuration.dart';
import '../../services/local_db/local_db.dart';
import '../../utils/language_util.dart';
import '../../utils/platform_util.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_alert_dialog/custom_alert_dialog.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/custom_app_bar/custom_app_bar_close_button.dart';
import '../../widgets/ocr_engine_icon/ocr_engine_icon.dart';
import '../../widgets/preference_list/preference_list.dart';
import '../../widgets/preference_list/preference_list_item.dart';
import '../../widgets/preference_list/preference_list_section.dart';
import '../../widgets/translation_engine_icon/translation_engine_icon.dart';
import '../ocr_engines_manage.dart';
import '../translation_engines_manage.dart';
import 'app_language.dart';
import 'extract_text.dart';
import 'interface.dart';
import 'shortcuts.dart';
import 'theme_mode.dart';
import 'translate.dart';

part 'index.g.dart';

@TypedGoRoute<SettingsRoute>(path: '/settings')
class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsPage();
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, this.onDismiss});

  final VoidCallback? onDismiss;

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Configuration get _configuration => localDb.configuration;

  List<TranslationEngineConfig> get _engineList {
    return localDb.engines.list(where: (e) => !e.disabled);
  }

  List<OcrEngineConfig> get _ocrEngineList {
    return localDb.ocrEngines.list(where: (e) => !e.disabled);
  }

  @override
  void initState() {
    localDb.privateEngines.addListener(_handleChanged);
    localDb.privateOcrEngines.addListener(_handleChanged);
    super.initState();
    _init();
  }

  @override
  void dispose() {
    localDb.privateEngines.removeListener(_handleChanged);
    localDb.privateOcrEngines.removeListener(_handleChanged);
    super.dispose();
  }

  void _handleChanged() {
    if (mounted) setState(() {});
  }

  void _init() async {
    setState(() {});
  }

  Widget _buildBody(BuildContext context) {
    return PreferenceList(
      children: [
        PreferenceListSection(
          title: Text(t('pref_section_title_general')),
          children: [
            PreferenceListItem(
              title: Text(t('pref_item_title_extract_text')),
              onTap: () {
                const SettingExtractTextRoute().push(context);
              },
            ),
            PreferenceListItem(
              title: Text(t('pref_item_title_translate')),
              onTap: () {
                const SettingTranslateRoute().push(context);
              },
            ),
          ],
        ),
        PreferenceListSection(
          title: Text(t('pref_section_title_appearance')),
          children: [
            PreferenceListItem(
              title: Text(t('pref_item_title_interface')),
              onTap: () {
                const SettingInterfaceRoute().push(context);
              },
            ),
            PreferenceListItem(
              title: Text(t('pref_item_title_app_language')),
              detailText: Text(getLanguageName(_configuration.appLanguage)),
              onTap: () {
                SettingAppLanguageRoute(
                  initialLanguage: _configuration.appLanguage,
                ).push(context);
              },
            ),
            PreferenceListItem(
              title: Text(t('pref_item_title_theme_mode')),
              detailText: Text(
                'theme_mode.${_configuration.themeMode.name}'.tr(),
              ),
              onTap: () {
                const SettingThemeModeRoute().push(context);
              },
            ),
          ],
        ),
        PreferenceListSection(
          title: Text(t('pref_section_title_shortcuts')),
          children: [
            PreferenceListItem(
              title: Text(t('pref_item_title_keyboard_shortcuts')),
              onTap: () {
                const SettingShortcutsRoute().push(context);
              },
            ),
          ],
        ),
        PreferenceListSection(
          title: Text(t('pref_section_title_input_settings')),
          children: [
            PreferenceListRadioItem<String>(
              value: kInputSettingSubmitWithEnter,
              groupValue: _configuration.inputSetting,
              title: Text(t('pref_item_title_submit_with_enter')),
              onChanged: (newValue) {
                _configuration.inputSetting = newValue;
              },
            ),
            PreferenceListRadioItem<String>(
              value: kInputSettingSubmitWithMetaEnter,
              groupValue: _configuration.inputSetting,
              title: Text(
                t(
                  kIsMacOS
                      ? 'pref_item_title_submit_with_meta_enter_mac'
                      : 'pref_item_title_submit_with_meta_enter',
                ),
              ),
              onChanged: (newValue) {
                _configuration.inputSetting = newValue;
              },
            ),
          ],
        ),
        PreferenceListSection(
          title: Text(t('pref_section_title_service_integration')),
          children: [
            PreferenceListItem(
              title: Text(t('pref_item_title_engines')),
              detailText: Row(
                children: [
                  for (var item in _engineList)
                    Container(
                      margin: const EdgeInsets.only(left: 4),
                      child: TranslationEngineIcon(
                        item.type,
                        size: 18,
                      ),
                    ),
                ],
              ),
              onTap: () {
                const TranslationEnginesManageRoute().push(context);
              },
            ),
            PreferenceListItem(
              title: Text(t('pref_item_title_ocr_engines')),
              detailText: Row(
                children: [
                  for (var item in _ocrEngineList)
                    Container(
                      margin: const EdgeInsets.only(left: 4),
                      child: OcrEngineIcon(
                        item.type,
                        size: 18,
                      ),
                    ),
                ],
              ),
              onTap: () {
                const OcrEnginesManageRoute().push(context);
              },
            ),
          ],
        ),
        PreferenceListSection(
          title: Text(t('pref_section_title_others')),
          children: [
            PreferenceListItem(
              title: Text(t('pref_item_title_about')),
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
                  t('pref_item_title_exit_app'),
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
              accessoryView: Container(),
              onTap: () async {
                return showDialog<void>(
                  context: context,
                  builder: (BuildContext ctx) {
                    return CustomAlertDialog(
                      title: Text(t('exit_app_dialog.title')),
                      actions: <Widget>[
                        CustomDialogAction(
                          child: Text('cancel'.tr()),
                          onPressed: () async {
                            ctx.pop();
                          },
                        ),
                        CustomDialogAction(
                          child: Text('ok'.tr()),
                          onPressed: () async {
                            exit(0);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 20,
              ),
              child: Text(
                t('text_version', args: [
                  sharedEnv.appVersion,
                  '${sharedEnv.appBuildNumber}',
                ]),
                style: Theme.of(context).textTheme.bodySmall,
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
        leading: widget.onDismiss != null
            ? CustomAppBarCloseButton(
                onPressed: widget.onDismiss,
              )
            : null,
      ),
      body: _buildBody(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  String t(String key, {List<String> args = const []}) {
    return 'page_settings.$key'.tr(args: args);
  }
}
