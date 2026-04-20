import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:biyi_app/i18n/i18n.dart';
import 'package:biyi_app/models/models.dart';
import 'package:biyi_app/services/services.dart';
import 'package:biyi_app/widgets/widgets.dart';

import 'language_chooser.dart';

class TranslationTargetNewPage extends StatefulWidget {
  const TranslationTargetNewPage({
    super.key,
    this.translationTarget,
  });

  final TranslationTarget? translationTarget;

  @override
  State<TranslationTargetNewPage> createState() =>
      _TranslationTargetNewPageState();
}

class _TranslationTargetNewPageState extends State<TranslationTargetNewPage> {
  String? _sourceLanguage;
  String? _targetLanguage;

  @override
  void initState() {
    if (widget.translationTarget != null) {
      _sourceLanguage = widget.translationTarget?.sourceLanguage;
      _targetLanguage = widget.translationTarget?.targetLanguage;
    }
    super.initState();
  }

  void _handleClickOk() async {
    await localDb
        .translationTarget(widget.translationTarget?.id)
        .updateOrCreate(
          sourceLanguage: _sourceLanguage,
          targetLanguage: _targetLanguage,
        );

    if (!mounted) return;
    context.pop();
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: widget.translationTarget != null
          ? Text(t('title_with_edit'))
          : Text(t('title')),
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
            PreferenceListItem(
              title: Text(t('source_language')),
              detailText: _sourceLanguage != null
                  ? LanguageLabel(_sourceLanguage!)
                  : Text('please_choose'.tr()),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => LanguageChooserPage(
                      onChoosed: (language) {
                        _sourceLanguage = language;
                        setState(() {});
                      },
                    ),
                  ),
                );
              },
            ),
            PreferenceListItem(
              title: Text(t('target_language')),
              detailText: _targetLanguage != null
                  ? LanguageLabel(_targetLanguage!)
                  : Text('please_choose'.tr()),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => LanguageChooserPage(
                      onChoosed: (language) {
                        _targetLanguage = language;
                        setState(() {});
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        if (widget.translationTarget != null)
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
                  await localDb
                      .translationTarget(widget.translationTarget?.id)
                      .delete();

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
    return 'page_translation_target_new.$key'.tr(args: args);
  }
}
