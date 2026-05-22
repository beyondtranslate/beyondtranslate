import 'package:beyondtranslate_desktop/src/utils/language_util.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart' hide Card;

import '../../models/translation_result.dart';
import '../ui/button.dart';
import '../ui/card.dart';

class TranslationResultView extends StatelessWidget {
  const TranslationResultView(
    this.translationResult, {
    Key? key,
  }) : super(key: key);

  final TranslationResult translationResult;

  String get sourceLanguage => translationResult.translationTarget!.source;
  String get targetLanguage => translationResult.translationTarget!.target;

  static const _kSectionGap = 8.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: _kSectionGap),
      height: 40,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 12, right: 8),
            child: Text(
              getLanguageName(sourceLanguage),
              style: theme.textTheme.bodyMedium,
            ),
          ),
          SizedBox(
            width: 28,
            height: 28,
            child: Container(
              padding: EdgeInsets.zero,
              child: Container(
                margin: EdgeInsets.zero,
                child: Icon(
                  FluentIcons.arrow_right_20_regular,
                  size: 16,
                  color: theme.iconTheme.color?.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 8, right: 12),
            child: Text(
              getLanguageName(targetLanguage),
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
