import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../../models/translation_result.dart';
import '../../rust/domain/settings.dart';
import '../../utils/language_util.dart';
import '../../widgets/translation_result_record_view/translation_result_record_view.dart';
import '../../widgets/translation_result_view/translation_result_view.dart';

class TranslationResultsView extends StatelessWidget {
  const TranslationResultsView({
    Key? key,
    required this.viewKey,
    required this.controller,
    required this.translationMode,
    required this.querySubmitted,
    required this.text,
    required this.textDetectedLanguage,
    required this.translationResultList,
    required this.onTextTapped,
  }) : super(key: key);

  final Key viewKey;
  final ScrollController controller;
  final TranslationMode translationMode;
  final bool querySubmitted;
  final String text;
  final String? textDetectedLanguage;
  final List<TranslationResult> translationResultList;
  final ValueChanged<String> onTextTapped;

  Widget _buildNoMatchingTranslationTarget(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
        top: 0,
        bottom: 12,
      ),
      child: Container(
        constraints: const BoxConstraints(minHeight: 40),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(2),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              offset: const Offset(0.0, 1.0),
              blurRadius: 3.0,
            ),
          ],
        ),
        padding: const EdgeInsets.only(
          left: 12,
          right: 12,
          top: 12,
          bottom: 12,
        ),
        child: SizedBox(
          width: double.infinity,
          child: SelectableText.rich(
            TextSpan(
              children: [
                const TextSpan(text: '没有与'),
                TextSpan(
                  text: getLanguageName(textDetectedLanguage!),
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                const TextSpan(text: '匹配的翻译目标，'),
                const TextSpan(text: '请添加该语种的翻译目标或切换至手动翻译模式。'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewWidth = MediaQuery.of(context).size.width;
    return Expanded(
      child: SingleChildScrollView(
        controller: controller,
        child: SizedBox(
          key: viewKey,
          width: viewWidth,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              if (querySubmitted &&
                  translationMode == TranslationMode.auto &&
                  translationResultList.isEmpty &&
                  textDetectedLanguage != null)
                _buildNoMatchingTranslationTarget(context),
              for (var result in translationResultList)
                SizedBox(
                  width: viewWidth,
                  child: StickyHeader(
                    header: translationMode == TranslationMode.auto
                        ? TranslationResultView(result)
                        : Container(),
                    content: Column(
                      children: [
                        for (var resultRecord
                            in result.translationResultRecordList ?? [])
                          TranslationResultRecordView(
                            translationResult: result,
                            translationResultRecord: resultRecord,
                            onTextTapped: onTextTapped,
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
