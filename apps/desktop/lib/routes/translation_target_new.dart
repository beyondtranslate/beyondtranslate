import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../i18n/i18n.dart';
import '../models/translation_target.dart';
import '../services/local_db/local_db.dart';
import '../widgets/custom_app_bar/custom_app_bar.dart';
import '../widgets/custom_app_bar/custom_app_bar_action_item.dart';
import '../widgets/language_label/language_label.dart';
import '../widgets/preference_list/preference_list.dart';
import '../widgets/preference_list/preference_list_item.dart';
import '../widgets/preference_list/preference_list_section.dart';
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
          ? Text(t.page_translation_target_new.title_with_edit)
          : Text(t.page_translation_target_new.title),
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
            PreferenceListItem(
              title: Text(t.page_translation_target_new.source_language),
              detailText: _sourceLanguage != null
                  ? LanguageLabel(_sourceLanguage!)
                  : Text(t.please_choose),
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
              title: Text(t.page_translation_target_new.target_language),
              detailText: _targetLanguage != null
                  ? LanguageLabel(_targetLanguage!)
                  : Text(t.please_choose),
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
                    t.delete,
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
}
