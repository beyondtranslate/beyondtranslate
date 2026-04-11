import 'package:biyi_advanced_features/biyi_advanced_features.dart';
import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/includes.dart';
import 'package:flutter/material.dart';

class TranslationEngineChooserPage extends StatefulWidget {
  const TranslationEngineChooserPage({
    Key? key,
    this.initialEngineConfig,
    this.onChoosed,
  }) : super(key: key);

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

    Navigator.of(context).pop();
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
            text: LocaleKeys.ok.tr(),
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
