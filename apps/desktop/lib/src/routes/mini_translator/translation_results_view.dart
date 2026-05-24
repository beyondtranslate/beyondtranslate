import 'package:flutter/material.dart' hide Card;
import 'package:sticky_headers/sticky_headers.dart';

import '../../models/translation_result.dart';
import '../../utils/language_util.dart';
import '../../widgets/translation_result_record_view/translation_result_record_view.dart';
import '../../widgets/translation_result_view/translation_result_view.dart';
import '../../widgets/ui/card.dart';

class TranslationResultsView extends StatelessWidget {
  const TranslationResultsView({
    Key? key,
    required this.viewKey,
    required this.controller,
    required this.querySubmitted,
    required this.text,
    required this.textDetectedLanguage,
    required this.translationResultList,
    required this.onTextTapped,
  }) : super(key: key);

  final Key viewKey;
  final ScrollController controller;
  final bool querySubmitted;
  final String text;
  final String? textDetectedLanguage;
  final List<TranslationResult> translationResultList;
  final ValueChanged<String> onTextTapped;

  static const _kSectionGap = 8.0;
  static const _kEdgePadding = 12.0;

  Widget _buildNoMatchingTranslationTarget(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(
        left: _kEdgePadding,
        right: _kEdgePadding,
      ),
      constraints: const BoxConstraints(minHeight: 40),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: SizedBox(
        width: double.infinity,
        child: SelectableText.rich(
          TextSpan(
            children: [
              const TextSpan(text: '没有与'),
              TextSpan(
                text: getLanguageName(textDetectedLanguage!),
                style: TextStyle(color: theme.primaryColor),
              ),
              const TextSpan(text: '匹配的翻译目标，'),
              const TextSpan(text: '请添加该语种的翻译目标或切换至手动翻译模式。'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewWidth = MediaQuery.of(context).size.width;

    final List<Widget> items = [];

    if (querySubmitted &&
        translationResultList.isEmpty &&
        textDetectedLanguage != null) {
      items.add(const SizedBox(height: _kSectionGap));
      items.add(_buildNoMatchingTranslationTarget(context));
    }

    if (translationResultList.isNotEmpty) {
      items.add(const SizedBox(height: _kSectionGap));
    }

    for (var resultIndex = 0;
        resultIndex < translationResultList.length;
        resultIndex++) {
      final result = translationResultList[resultIndex];
      final resultRecordList = result.translationResultRecordList ?? [];
      items.add(
        SizedBox(
          width: viewWidth,
          child: StickyHeader(
            header: TranslationResultView(result),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var resultRecordIndex = 0;
                    resultRecordIndex < resultRecordList.length;
                    resultRecordIndex++)
                  TranslationResultRecordView(
                    translationResult: result,
                    translationResultRecord:
                        resultRecordList[resultRecordIndex],
                    onTextTapped: onTextTapped,
                    margin: EdgeInsets.only(
                      left: _kEdgePadding,
                      right: _kEdgePadding,
                      bottom: resultIndex == translationResultList.length - 1 &&
                              resultRecordIndex == resultRecordList.length - 1
                          ? 0
                          : _kSectionGap,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    final content = Padding(
      key: viewKey,
      padding: const EdgeInsets.only(bottom: _kEdgePadding),
      child: SizedBox(
        width: viewWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: items,
        ),
      ),
    );

    return Expanded(
      child: SingleChildScrollView(
        controller: controller,
        child: content,
      ),
    );
  }
}
