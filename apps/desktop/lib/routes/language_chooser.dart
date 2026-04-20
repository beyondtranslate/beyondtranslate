import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../i18n/i18n.dart';
import '../utils/language_util.dart';
import '../widgets/custom_app_bar/custom_app_bar.dart';
import '../widgets/custom_app_bar/custom_app_bar_action_item.dart';
import '../widgets/language_label/language_label.dart';
import '../widgets/preference_list/preference_list.dart';
import '../widgets/preference_list/preference_list_item.dart';
import '../widgets/preference_list/preference_list_section.dart';

class LanguageChooserPage extends StatefulWidget {
  const LanguageChooserPage({
    super.key,
    this.initialLanguage,
    this.onChoosed,
  });

  final String? initialLanguage;
  final ValueChanged<String>? onChoosed;

  @override
  State<StatefulWidget> createState() => _LanguageChooserPageState();
}

class _LanguageChooserPageState extends State<LanguageChooserPage> {
  String? _language;

  @override
  void initState() {
    _language = widget.initialLanguage;
    super.initState();
  }

  void _handleClickOk() async {
    widget.onChoosed?.call(_language!);
    context.pop();
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: Text(t('title')),
      actions: [
        CustomAppBarActionItem(
          text: 'ok'.tr(),
          onPressed: _handleClickOk,
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return PreferenceList(
      children: [
        PreferenceListSection(
          title: Text(t('pref_section_title_all')),
          children: [
            for (var supportedLanguage in kSupportedLanguages)
              PreferenceListRadioItem(
                title: LanguageLabel(supportedLanguage),
                accessoryView: Container(),
                value: supportedLanguage,
                groupValue: _language,
                onChanged: (newGroupValue) {
                  _language = supportedLanguage;
                  setState(() {});
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

  String t(String key, {List<String> args = const []}) {
    return 'page_language_chooser.$key'.tr(args: args);
  }
}
