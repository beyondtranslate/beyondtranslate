import 'package:biyi_app/includes.dart';
import 'package:flutter/material.dart';

class SettingAppLanguagePage extends StatefulWidget {
  const SettingAppLanguagePage({
    Key? key,
    this.initialLanguage,
  }) : super(key: key);

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
