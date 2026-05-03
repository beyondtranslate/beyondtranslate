import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../i18n/i18n.dart';
import '../../models/translation_result.dart';
import '../../models/translation_result_record.dart';
import '../../services/local_db/configuration.dart';
import '../../services/local_db/local_db.dart';
import '../../services/runtime.dart';
import '../ui/loading_indicator.dart';
import 'translation_engine_tag.dart';
import 'word_pronunciation_view.dart';
import 'word_tag_view.dart';
import 'word_translation_view.dart';

class TranslationResultRecordView extends StatelessWidget {
  const TranslationResultRecordView({
    Key? key,
    required this.translationResult,
    required this.translationResultRecord,
    required this.onTextTapped,
  }) : super(key: key);

  final TranslationResult translationResult;
  final TranslationResultRecord translationResultRecord;
  final ValueChanged<String> onTextTapped;

  Configuration get _configuration => localDb.configuration;

  bool get _isLoading {
    if (_isErrorOccurred) return false;
    return translationResultRecord.lookUpResponse == null &&
        translationResultRecord.translateResponse == null;
  }

  bool get _isErrorOccurred {
    return translationResultRecord.lookUpError != null ||
        translationResultRecord.translateError != null;
  }

  Widget _buildRequestLoading(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 40,
      ),
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LoadingIndicator.threeBounce(
            color: Theme.of(context).textTheme.bodySmall!.color,
            size: 12.0,
          ),
        ],
      ),
    );
  }

  Widget _buildRequestError(BuildContext context) {
    final error = translationResultRecord.lookUpError ??
        translationResultRecord.translateError ??
        const TranslationError(
          message: 'Unknown Error',
        );

    return Container(
      constraints: const BoxConstraints(
        minHeight: 40,
      ),
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
        top: 7,
        bottom: 7,
      ),
      alignment: Alignment.centerLeft,
      child: SelectableText(
        error.message,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    // String? word;
    List<TextTranslation>? translations; // 翻译
    List<WordTag>? tags; // 标签
    List<WordDefinition>? definitions; // 定义（基本释义）
    List<WordPronunciation>? pronunciations; // 发音
    List<WordImage>? images; // 图片
    // List<WordPhrase> phrases; // 短语
    List<WordTense>? tenses; // 时态
    // List<WordSentence> sentences; // 例句

    if (translationResultRecord.lookUpResponse != null) {
      final resp = translationResultRecord.lookUpResponse;
      // word = resp?.word;
      translations = resp?.translations;
      tags = resp?.tags;
      definitions = resp?.definitions;
      pronunciations = resp?.pronunciations;
      images = resp?.images;
      // phrases = resp.phrases;
      tenses = resp?.tenses;
      // sentences = resp.sentences;
    } else if (translationResultRecord.translateResponse != null) {
      final resp = translationResultRecord.translateResponse;
      translations = resp?.translations;
    }

    // 是否显示为查词结果
    bool isShowAsLookUpResult = (definitions ?? []).isNotEmpty ||
        (pronunciations ?? []).isNotEmpty ||
        (images ?? []).isNotEmpty;

    if (!isShowAsLookUpResult && (translations ?? []).isNotEmpty) {
      TextTranslation textTranslation = translations!.first;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onDoubleTap: () {
          if (_configuration.doubleClickCopyResult) {
            Clipboard.setData(ClipboardData(text: textTranslation.text));
            BotToast.showText(
              text: t.copied,
              align: Alignment.center,
            );
          }
        },
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 40,
          ),
          padding: const EdgeInsets.only(
            left: 12,
            right: 12,
            top: 7,
            bottom: 7,
          ),
          alignment: Alignment.centerLeft,
          child: SelectableText.rich(
            TextSpan(
              children: [
                TextSpan(text: textTranslation.text),
              ],
            ),
            style: textTheme.bodyMedium!.copyWith(
              height: 1.4,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
        bottom: 14,
      ),
      constraints: const BoxConstraints(
        minHeight: 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 翻译
          if ((translations ?? []).isNotEmpty)
            WordTranslationView(translations!.first),
          // 包含查词结果时显示分割线
          if ((translations ?? []).isNotEmpty) const Divider(height: 0),
          // 音标
          if ((pronunciations ?? []).isNotEmpty)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 12, bottom: 4),
              child: Wrap(
                spacing: 22,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  for (WordPronunciation wordPronunciation in pronunciations!)
                    WordPronunciationView(wordPronunciation)
                ],
              ),
            ),
          // 释义
          if ((definitions ?? []).isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 4, bottom: 4),
              child: SelectableText.rich(
                TextSpan(
                  children: [
                    for (var i = 0; i < definitions!.length; i++)
                      TextSpan(
                        children: [
                          if ((definitions[i].name ?? '').isNotEmpty)
                            TextSpan(
                              text: '${definitions[i].name}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          if ((definitions[i].name ?? '').isNotEmpty)
                            const TextSpan(text: ' '),
                          TextSpan(
                              text: (definitions[i].values ?? []).join('；')),
                          if (i < definitions.length - 1)
                            const TextSpan(text: '\n'),
                        ],
                      ),
                  ],
                ),
                style: textTheme.bodyMedium!.copyWith(
                  height: 1.5,
                ),
              ),
            ),
          // 时态
          if ((tenses ?? []).isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 4),
              child: SelectableText.rich(
                TextSpan(
                  children: [
                    for (var i = 0; i < tenses!.length; i++)
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${tenses[i].name}',
                          ),
                          for (var tenseValue in (tenses[i].values ?? []))
                            TextSpan(
                              text: ' $tenseValue ',
                              style: textTheme.bodyMedium!.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => onTextTapped(tenseValue),
                            ),
                        ],
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontSize: 13,
                            ),
                      ),
                  ],
                ),
                style: textTheme.bodyMedium!.copyWith(
                  height: 1.5,
                ),
              ),
            ),
          // // 常用短词/短句
          // if ((phrases ?? []).isNotEmpty)
          //   Container(
          //     margin: EdgeInsets.only(top: 10),
          //     width: double.infinity,
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Container(
          //           padding: EdgeInsets.only(
          //             top: 2,
          //             bottom: 2,
          //           ),
          //           decoration: BoxDecoration(
          //             border: Border(
          //               bottom: BorderSide(
          //                 color: Theme.of(context).primaryColor,
          //                 width: 2,
          //               ),
          //             ),
          //           ),
          //           child: Text(
          //             '常用短语/词组',
          //             style: Theme.of(context).textTheme.bodySmall.copyWith(
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //           ),
          //         ),
          //         for (WordPhrase wordPhrase in phrases)
          //           WordPhraseView(
          //             wordPhrase,
          //             onTextTapped: onTextTapped,
          //           ),
          //       ],
          //     ),
          //   ),
          // // 例句
          // if ((sentences ?? []).isNotEmpty)
          //   Container(
          //     margin: EdgeInsets.only(top: 10),
          //     width: double.infinity,
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Container(
          //           padding: EdgeInsets.only(
          //             top: 2,
          //             bottom: 2,
          //           ),
          //           decoration: BoxDecoration(
          //             border: Border(
          //               bottom: BorderSide(
          //                 color: Theme.of(context).primaryColor,
          //                 width: 2,
          //               ),
          //             ),
          //           ),
          //           child: Text(
          //             '例句',
          //             style: Theme.of(context).textTheme.bodySmall.copyWith(
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //           ),
          //         ),
          //         for (WordSentence wordSentence in sentences)
          //           WordSentenceView(wordSentence),
          //       ],
          //     ),
          //   ),
          // 标签
          if ((tags ?? []).isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (WordTag wordTag in tags!) WordTagView(wordTag),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        left: 12,
        right: 12,
        top: 0,
        bottom: 12,
      ),
      child: Container(
        width: double.infinity,
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
        child: Stack(
          children: [
            if (_isLoading)
              _buildRequestLoading(context)
            else if (_isErrorOccurred)
              _buildRequestError(context)
            else
              _buildBody(context),
            Positioned(
              right: 0,
              top: 0,
              child: TranslationEngineTag(
                translationResultRecord: translationResultRecord,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
