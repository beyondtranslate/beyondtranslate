import 'package:flutter/material.dart';

import '../i18n/i18n.dart';
import '../networking/translate_client/translate_client.dart';
import '../widgets/custom_app_bar/custom_app_bar.dart';
import '../widgets/custom_app_bar/custom_app_bar_action_item.dart';
import '../widgets/preference_list/preference_list.dart';
import '../widgets/preference_list/preference_list_item.dart';
import '../widgets/preference_list/preference_list_section.dart';
import '../widgets/translation_engine_icon/translation_engine_icon.dart';

class TranslationEngineTypeChooserPage extends StatefulWidget {
  const TranslationEngineTypeChooserPage({
    super.key,
    this.engineType,
    this.onChoosed,
  });

  final String? engineType;
  final ValueChanged<String>? onChoosed;

  @override
  State<TranslationEngineTypeChooserPage> createState() =>
      _TranslationEngineTypeChooserPageState();
}

class _TranslationEngineTypeChooserPageState
    extends State<TranslationEngineTypeChooserPage> {
  String? _type;

  String t(String key, {List<String> args = const []}) {
    return 'page_translation_engine_type_chooser.$key'.tr(args: args);
  }

  @override
  void initState() {
    _type = widget.engineType;
    super.initState();
  }

  void _handleClickOk() async {
    widget.onChoosed?.call(_type!);
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
          children: [
            for (var engineType in kSupportedEngineTypes)
              PreferenceListRadioItem(
                icon: TranslationEngineIcon(engineType),
                title: Text('engine.$engineType'.tr()),
                value: engineType,
                groupValue: _type,
                onChanged: (newGroupValue) {
                  _type = engineType;
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
}
