import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ocr_engine_youdao/ocr_engine_youdao.dart';
import 'package:shortid/shortid.dart';

import '../i18n/i18n.dart';
import '../models/ocr_engine_config.dart';
import '../networking/ocr_client/ocr_client.dart';
import '../services/local_db/local_db.dart';
import '../widgets/custom_app_bar/custom_app_bar.dart';
import '../widgets/custom_app_bar/custom_app_bar_action_item.dart';
import '../widgets/ocr_engine_icon/ocr_engine_icon.dart';
import '../widgets/ocr_engine_name/ocr_engine_name.dart';
import '../widgets/preference_list/preference_list.dart';
import '../widgets/preference_list/preference_list_item.dart';
import '../widgets/preference_list/preference_list_section.dart';
import 'ocr_engine_type_chooser.dart';

class OcrEngineCreateOrEditPage extends StatefulWidget {
  const OcrEngineCreateOrEditPage({
    super.key,
    this.editable = true,
    this.ocrEngineType,
    this.ocrEngineConfig,
  });

  final bool editable;
  final String? ocrEngineType;
  final OcrEngineConfig? ocrEngineConfig;

  @override
  State<OcrEngineCreateOrEditPage> createState() =>
      _OcrEngineCreateOrEditPageState();
}

class _OcrEngineCreateOrEditPageState extends State<OcrEngineCreateOrEditPage> {
  final Map<String, TextEditingController> _textEditingControllerMap = {};

  String? _identifier;
  String? _type;
  Map<String, dynamic> _option = {};

  List<String> get _engineOptionKeys {
    switch (_type) {
      case kOcrEngineTypeYoudao:
        return YoudaoOcrEngine.optionKeys;
    }
    return [];
  }

  String t(String key, {List<String> args = const []}) {
    return 'page_ocr_engine_create_or_edit.$key'.tr(args: args);
  }

  @override
  void initState() {
    if (widget.ocrEngineConfig != null) {
      _identifier = widget.ocrEngineConfig?.identifier;
      _type = widget.ocrEngineConfig?.type;
      _option = widget.ocrEngineConfig?.option ?? {};

      for (var optionKey in _engineOptionKeys) {
        var textEditingController =
            TextEditingController(text: _option[optionKey]);
        _textEditingControllerMap[optionKey] = textEditingController;
      }
    } else {
      _identifier = shortid.generate();
      _type = widget.ocrEngineType;
    }
    super.initState();
  }

  void _handleClickOk() async {
    await localDb.privateOcrEngine(_identifier).updateOrCreate(
          type: _type,
          option: _option,
        );

    (sharedOcrClient.adapter as AutoloadOcrClientAdapter).renew(_identifier!);

    if (!mounted) return;
    context.pop();
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: widget.ocrEngineConfig != null
          ? OcrEngineName(widget.ocrEngineConfig!)
          : Text(t('title')),
      actions: [
        if (widget.editable)
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
          title: Text(t('pref_section_title_engine_type')),
          children: [
            PreferenceListItem(
              icon: _type == null ? null : OcrEngineIcon(_type!),
              title: _type == null
                  ? Text('please_choose'.tr())
                  : Text('ocr_engine.$_type'.tr()),
              accessoryView: widget.editable ? null : Container(),
              onTap: widget.editable
                  ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => OcrEngineTypeChooserPage(
                            engineType: _type,
                            onChoosed: (newEngineType) {
                              setState(() {
                                _type = newEngineType;
                              });

                              context.pop();
                            },
                          ),
                        ),
                      );
                    }
                  : null,
            ),
          ],
        ),
        if (widget.editable && _type != null)
          PreferenceListSection(
            title: Text(t('pref_section_title_option')),
            children: [
              for (var optionKey in _engineOptionKeys)
                PreferenceListTextFieldItem(
                  controller: _textEditingControllerMap[optionKey],
                  placeholder: optionKey,
                  accessoryView: Container(),
                  onChanged: (value) {
                    _option[optionKey] = value;
                    setState(() {});
                  },
                ),
              if (_engineOptionKeys.isEmpty)
                PreferenceListItem(
                  title: const Text('No options'),
                  accessoryView: Container(),
                ),
            ],
          ),
        if (widget.editable && widget.ocrEngineConfig != null)
          PreferenceListSection(
            title: const Text(''),
            children: [
              PreferenceListItem(
                title: Center(
                  child: Text(
                    'delete'.tr(),
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                accessoryView: Container(),
                onTap: () async {
                  await localDb.privateOcrEngine(_identifier).delete();
                  if (!context.mounted) return;
                  context.pop();
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
