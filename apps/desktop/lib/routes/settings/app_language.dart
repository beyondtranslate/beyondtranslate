import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../i18n/i18n.dart';
import '../../services/local_db/configuration.dart';
import '../../services/local_db/local_db.dart';
import '../../utils/language_util.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/language_label/language_label.dart';
import '../../widgets/preference_list/preference_list.dart';
import '../../widgets/preference_list/preference_list_item.dart';
import '../../widgets/preference_list/preference_list_section.dart';

part 'app_language.g.dart';

@TypedGoRoute<SettingAppLanguageRoute>(path: '/settings/app-language')
class SettingAppLanguageRoute extends GoRouteData
    with $SettingAppLanguageRoute {
  const SettingAppLanguageRoute({this.initialLanguage});

  final String? initialLanguage;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SettingAppLanguagePage(initialLanguage: initialLanguage);
  }
}

class SettingAppLanguagePage extends StatefulWidget {
  const SettingAppLanguagePage({
    super.key,
    this.initialLanguage,
  });

  final String? initialLanguage;

  @override
  State<StatefulWidget> createState() => _SettingAppLanguagePageState();
}

class _SettingAppLanguagePageState extends State<SettingAppLanguagePage> {
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

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: Text(t('title')),
    );
  }

  Widget _buildBody(BuildContext context) {
    return PreferenceList(
      children: [
        PreferenceListSection(
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  String t(String key) {
    return 'page_setting_app_language.$key'.tr();
  }
}
