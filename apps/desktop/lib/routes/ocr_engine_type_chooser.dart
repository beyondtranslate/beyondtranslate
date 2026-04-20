import 'package:flutter/material.dart';

import 'package:biyi_app/i18n/i18n.dart';
import 'package:biyi_app/networking/networking.dart';
import 'package:biyi_app/widgets/widgets.dart';

class OcrEngineTypeChooserPage extends StatefulWidget {
  const OcrEngineTypeChooserPage({
    super.key,
    this.engineType,
    this.onChoosed,
  });

  final String? engineType;
  final ValueChanged<String>? onChoosed;

  @override
  State<OcrEngineTypeChooserPage> createState() =>
      _OcrEngineTypeChooserPageState();
}

class _OcrEngineTypeChooserPageState extends State<OcrEngineTypeChooserPage> {
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
            for (var engineType in kSupportedOcrEngineTypes)
              PreferenceListRadioItem(
                icon: OcrEngineIcon(engineType),
                title: Text('ocr_engine.$engineType'.tr()),
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

  String t(String key, {List<String> args = const []}) {
    return 'page_ocr_engine_type_chooser.$key'.tr(args: args);
  }
}
