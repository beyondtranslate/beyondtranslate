import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import '../../models/translation_result.dart';
import '../language_label/language_label.dart';
import '../ui/button.dart';
import '../ui/card.dart' as ui;

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

    return ui.Card(
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: _kSectionGap),
      height: 40,
      child: Row(
        children: [
          Button(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: LanguageLabel(
              sourceLanguage,
            ),
            onPressed: () => {},
          ),
          SizedBox(
            width: 20,
            height: 38,
            child: Button(
              padding: EdgeInsets.zero,
              child: Container(
                margin: EdgeInsets.zero,
                child: Icon(
                  FluentIcons.arrow_right_20_regular,
                  size: 16,
                  color: theme.iconTheme.color?.withValues(alpha: 0.6),
                ),
              ),
              onPressed: () {},
            ),
          ),
          Button(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: LanguageLabel(
              targetLanguage,
            ),
            onPressed: () => {},
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
