import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../i18n/i18n.dart';
import '../models/translation_engine_config.dart';
import '../services/local_db/local_db.dart';
import '../widgets/custom_app_bar/custom_app_bar.dart';
import '../widgets/custom_app_bar/custom_app_bar_action_item.dart';
import '../widgets/preference_list/preference_list.dart';
import '../widgets/preference_list/preference_list_item.dart';
import '../widgets/preference_list/preference_list_section.dart';
import '../widgets/translation_engine_icon/translation_engine_icon.dart';
import '../widgets/translation_engine_name/translation_engine_name.dart';

class TranslationEngineChooserPage extends StatefulWidget {
  const TranslationEngineChooserPage({
    super.key,
    this.initialEngineConfig,
    this.onChoosed,
  });

  final TranslationEngineConfig? initialEngineConfig;
  final ValueChanged<TranslationEngineConfig>? onChoosed;

  @override
  State<StatefulWidget> createState() => _TranslationEngineChooserPageState();
}

class _TranslationEngineChooserPageState
    extends State<TranslationEngineChooserPage> {
  List<TranslationEngineConfig> get _proEngineList {
    return localDb.proEngines.list(where: ((e) => !e.disabled));
  }

  List<TranslationEngineConfig> get _privateEngineList {
    return localDb.privateEngines.list(where: ((e) => !e.disabled));
  }

  String? _identifier;

  String t(String key, {List<String> args = const []}) {
    return 'page_translation_engine_chooser.$key'.tr(args: args);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _identifier = widget.initialEngineConfig?.identifier;
    });
  }

  void _handleClickOk() async {
    if (widget.onChoosed != null) {
      TranslationEngineConfig? engineConfig = localDb.engine(_identifier).get();
      widget.onChoosed!(engineConfig!);
    }

    context.pop();
  }

  Widget _buildBody(BuildContext context) {
    return PreferenceList(
      children: [
        if (_proEngineList.isNotEmpty)
          PreferenceListSection(
            children: [
              for (var engineConfig in _proEngineList)
                PreferenceListRadioItem<String>(
                  icon: TranslationEngineIcon(engineConfig.type),
                  title: TranslationEngineName(engineConfig),
                  value: engineConfig.identifier,
                  groupValue: _identifier ?? '',
                  onChanged: (newValue) {
                    setState(() {
                      _identifier = newValue;
                    });
                  },
                ),
            ],
          ),
        PreferenceListSection(
          title: Text(t('pref_section_title_private')),
          children: [
            for (var engineConfig in _privateEngineList)
              PreferenceListRadioItem<String>(
                icon: TranslationEngineIcon(engineConfig.type),
                title: TranslationEngineName(engineConfig),
                value: engineConfig.identifier,
                groupValue: _identifier ?? '',
                onChanged: (newValue) {
                  setState(() {
                    _identifier = newValue;
                  });
                },
              ),
            if (_privateEngineList.isEmpty)
              PreferenceListItem(
                title: Text(t('pref_item_title_no_available_engines')),
                accessoryView: Container(),
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
        actions: [
          CustomAppBarActionItem(
            text: 'ok'.tr(),
            onPressed: _handleClickOk,
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }
}
