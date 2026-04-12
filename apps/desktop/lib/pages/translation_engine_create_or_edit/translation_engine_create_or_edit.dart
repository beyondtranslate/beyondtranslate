import 'package:biyi_advanced_features/biyi_advanced_features.dart';
import 'package:uni_translate_client/uni_translate_client.dart';
import '../../i18n/i18n.dart';
import '../../networking/networking.dart';
import '../pages.dart';
import '../../services/services.dart';
import '../../widgets/widgets.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:shortid/shortid.dart';

const List<TranslationEngineScope> _kAllScopes = [
  TranslationEngineScope.detectLanguage,
  TranslationEngineScope.lookUp,
  TranslationEngineScope.translate,
];

class TranslationEngineCreateOrEditPage extends StatefulWidget {
  const TranslationEngineCreateOrEditPage({
    Key? key,
    this.editable = true,
    this.engineType,
    this.engineConfig,
  }) : super(key: key);

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
    // try {
    //   var resp = await translationEngine?.lookUp(
    //     LookUpRequest(
    //       sourceLanguage: kLanguageEN,
    //       targetLanguage: kLanguageZH,
    //       word: 'hello',
    //     ),
    //   );
    //   print(resp?.toJson());
    // } catch (error) {
    //   print((error as UniTranslateClientError).message);
    // }

    await localDb //
        .privateEngine(_identifier)
        .updateOrCreate(
          type: _type,
          option: _option,
        );

    (translateClient.adapter as AutoloadTranslateClientAdapter)
        .renew(_identifier!);

    Navigator.of(context).pop();
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

                              Navigator.of(context).pop();
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

                  Navigator.of(context).pop();
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
