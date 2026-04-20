import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:biyi_app/i18n/i18n.dart';
import 'package:biyi_app/models/models.dart';
import 'package:biyi_app/services/services.dart';
import 'package:biyi_app/widgets/widgets.dart';

class OcrEngineChooserPage extends StatefulWidget {
  const OcrEngineChooserPage({
    super.key,
    this.initialOcrEngineConfig,
    this.onChoosed,
  });

  final OcrEngineConfig? initialOcrEngineConfig;
  final ValueChanged<OcrEngineConfig>? onChoosed;

  @override
  State<StatefulWidget> createState() => _OcrEngineChooserPageState();
}

class _OcrEngineChooserPageState extends State<OcrEngineChooserPage> {
  List<OcrEngineConfig> get _proOcrEngineList {
    return localDb.proOcrEngines.list(where: ((e) => !e.disabled));
  }

  List<OcrEngineConfig> get _privateOcrEngineList {
    return localDb.privateOcrEngines.list(where: ((e) => !e.disabled));
  }

  String? _identifier;

  @override
  void initState() {
    super.initState();
    setState(() {
      _identifier = widget.initialOcrEngineConfig?.identifier;
    });
  }

  void _handleClickOk() async {
    if (widget.onChoosed != null) {
      OcrEngineConfig? ocrEngineConfig = localDb.ocrEngine(_identifier).get();
      widget.onChoosed!(ocrEngineConfig!);
    }

    context.pop();
  }

  Widget _buildBody(BuildContext context) {
    return PreferenceList(
      children: [
        if (_proOcrEngineList.isNotEmpty)
          PreferenceListSection(
            children: [
              for (var ocrEngineConfig in _proOcrEngineList)
                PreferenceListRadioItem<String>(
                  icon: OcrEngineIcon(ocrEngineConfig.type),
                  title: OcrEngineName(ocrEngineConfig),
                  value: ocrEngineConfig.identifier,
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
            for (var ocrEngineConfig in _privateOcrEngineList)
              PreferenceListRadioItem<String>(
                icon: OcrEngineIcon(ocrEngineConfig.type),
                title: OcrEngineName(ocrEngineConfig),
                value: ocrEngineConfig.identifier,
                groupValue: _identifier ?? '',
                onChanged: (newValue) {
                  setState(() {
                    _identifier = newValue;
                  });
                },
              ),
            if (_privateOcrEngineList.isEmpty)
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

  String t(String key, {List<String> args = const []}) {
    return 'page_ocr_engine_chooser.$key'.tr(args: args);
  }
}
