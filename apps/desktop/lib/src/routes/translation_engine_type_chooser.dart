import 'package:flutter/material.dart';

import '../i18n/i18n.dart';
import '../models/ext_translation_engine_config.dart';
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
      title: Text(t.page_translation_engine_type_chooser.title),
      actions: [
        CustomAppBarActionItem(
          text: t.ok,
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
                title: Text(getTranslationEngineTypeName(engineType)),
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
