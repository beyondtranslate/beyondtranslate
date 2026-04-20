import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:biyi_app/i18n/i18n.dart';
import 'package:biyi_app/services/services.dart';
import 'package:biyi_app/utilities/utilities.dart';
import 'package:biyi_app/widgets/widgets.dart';

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
