import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shortid/shortid.dart';
import 'package:uni_translate_client/uni_translate_client.dart';

import '../i18n/i18n.dart';
import '../models/translation_engine_config.dart';
import '../networking/translate_client/translate_client.dart';
import '../services/local_db/local_db.dart';
import '../widgets/custom_app_bar/custom_app_bar.dart';
import '../widgets/custom_app_bar/custom_app_bar_action_item.dart';
import '../widgets/preference_list/preference_list.dart';
import '../widgets/preference_list/preference_list_item.dart';
import '../widgets/preference_list/preference_list_section.dart';
import '../widgets/translation_engine_icon/translation_engine_icon.dart';
import '../widgets/translation_engine_name/translation_engine_name.dart';
import 'translation_engine_type_chooser.dart';

const List<TranslationEngineScope> _kAllScopes = [
  TranslationEngineScope.detectLanguage,
  TranslationEngineScope.lookUp,
  TranslationEngineScope.translate,
];

class TranslationEngineCreateOrEditPage extends StatefulWidget {
  const TranslationEngineCreateOrEditPage({
    super.key,
    this.editable = true,
    this.engineType,
    this.engineConfig,
  });

  final bool editable;
  final String? engineType;
  final TranslationEngineConfig? engineConfig;

  @override
  State<TranslationEngineCreateOrEditPage> createState() =>
      _TranslationEngineCreateOrEditPageState();
}

class _TranslationEngineCreateOrEditPageState
    extends State<TranslationEngineCreateOrEditPage> {
  final Map<String, TextEditingController> _textEditingControllerMap = {};

  String? _identifier;
  String? _type;
  Map<String, dynamic> _option = {};

  List<String> get _engineOptionKeys {
    return kKnownSupportedEngineOptionKeys[_type] ?? [];
  }

  TranslationEngine? get translationEngine {
    if (_type != null) {
      var engineConfig = TranslationEngineConfig(
        identifier: '',
        type: _type!,
        option: _option,
      );
      if (widget.engineConfig != null && widget.engineConfig?.option == null) {
        engineConfig = TranslationEngineConfig(
          identifier: '',
          type: _type!,
          option: {},
        );
      }
      return createTranslationEngine(engineConfig)!;
    }
    return null;
  }

  @override
  void initState() {
    if (widget.engineConfig != null) {
      _identifier = widget.engineConfig?.identifier;
      _type = widget.engineConfig?.type;
      _option = widget.engineConfig?.option ?? {};

      for (var optionKey in _engineOptionKeys) {
        var textEditingController = TextEditingController(
          text: _option[optionKey] ?? '',
        );
        _textEditingControllerMap[optionKey] = textEditingController;
      }
    } else {
      _identifier = shortid.generate();
      _type = widget.engineType;
    }

    super.initState();
  }

  void _handleClickOk() async {
    await localDb.privateEngine(_identifier).updateOrCreate(
          type: _type,
          option: _option,
        );

    (translateClient.adapter as AutoloadTranslateClientAdapter)
        .renew(_identifier!);

    if (!mounted) return;
    context.pop();
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: widget.engineConfig != null
          ? TranslationEngineName(widget.engineConfig!)
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
              icon: _type == null ? null : TranslationEngineIcon(_type!),
              title: _type == null
                  ? Text('please_choose'.tr())
                  : Text('engine.$_type'.tr()),
              accessoryView: widget.editable ? null : Container(),
              onTap: widget.editable
                  ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TranslationEngineTypeChooserPage(
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
        if (translationEngine != null)
          PreferenceListSection(
            title: Text(t('pref_section_title_support_interface')),
            children: [
              for (var scope in _kAllScopes)
                PreferenceListItem(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    left: 12,
                    right: 12,
                  ),
                  title: Text('engine_scope.${scope.name.toLowerCase()}'.tr()),
                  summary: Text(scope.name),
                  accessoryView: Container(
                    margin: EdgeInsets.zero,
                    child: Builder(
                      builder: (_) {
                        if (!(translationEngine?.supportedScopes ?? [])
                            .contains(scope)) {
                          return const Icon(
                            FluentIcons.dismiss_circle_20_filled,
                            color: Colors.red,
                          );
                        }
                        return const Icon(
                          FluentIcons.checkmark_circle_20_filled,
                          color: Colors.green,
                        );
                      },
                    ),
                  ),
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
        if (widget.editable && widget.engineConfig != null)
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
                  await localDb.privateEngine(_identifier).delete();

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

  String t(String key, {List<String> args = const []}) {
    return 'page_translation_engine_create_or_edit.$key'.tr(args: args);
  }
}
