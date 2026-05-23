import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../i18n/i18n.dart';
import '../../models/translation_result.dart';
import '../../models/translation_result_record.dart';
import '../../services/runtime.dart';
import '../../services/settings_store.dart';
import '../ui/card.dart' as ui;
import '../ui/loading_indicator.dart';
import 'translation_engine_tag.dart';
import 'word_pronunciation_view.dart';
import 'word_tag_view.dart';
import 'word_translation_view.dart';

class TranslationResultRecordView extends StatelessWidget {
  final TranslationResult translationResult;

  final TranslationResultRecord translationResultRecord;
  final ValueChanged<String> onTextTapped;
  final EdgeInsetsGeometry margin;
  const TranslationResultRecordView({
    Key? key,
    required this.translationResult,
    required this.translationResultRecord,
    required this.onTextTapped,
    this.margin = const EdgeInsets.only(
      left: 12,
      right: 12,
      bottom: _kSectionGap,
    ),
  }) : super(key: key);

  bool get _isErrorOccurred {
    final hasResponse = translationResultRecord.lookUpResponse != null ||
        translationResultRecord.translateResponse != null;
    if (hasResponse) return false;
    return translationResultRecord.lookUpError != null ||
        translationResultRecord.translateError != null;
  }

  bool get _isLoading {
    if (_isErrorOccurred) return false;
    return translationResultRecord.lookUpResponse == null &&
        translationResultRecord.translateResponse == null;
  }

  static const _kSectionGap = 8.0;

  @override
  Widget build(BuildContext context) {
    return ui.Card(
      width: double.infinity,
      margin: margin,
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
    );
  }

  Widget _buildBody(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    List<TextTranslation>? lookUpTranslations; // 词典翻译
    List<TextTranslation>? translateTranslations; // 文本翻译
    List<WordTag>? tags; // 标签
    List<WordDefinition>? definitions; // 定义（基本释义）
    List<WordPronunciation>? pronunciations; // 发音
    List<WordImage>? images; // 图片
    // List<WordPhrase> phrases; // 短语
    List<WordTense>? tenses; // 时态
    // List<WordSentence> sentences; // 例句
    List<WordEtymology>? etymology; // 词源
    List<WordSynonym>? synonyms; // 同/反义词

    if (translationResultRecord.lookUpResponse != null) {
      final resp = translationResultRecord.lookUpResponse;
      lookUpTranslations = resp?.translations;
      tags = resp?.tags;
      definitions = resp?.definitions;
      pronunciations = resp?.pronunciations;
      images = resp?.images;
      // phrases = resp.phrases;
      tenses = resp?.tenses;
      // sentences = resp.sentences;
      etymology = resp?.etymology;
      synonyms = resp?.synonyms;
    }
    translateTranslations =
        translationResultRecord.translateResponse?.translations;

    // 是否显示为查词结果
    bool isShowAsLookUpResult = (definitions ?? []).isNotEmpty ||
        (pronunciations ?? []).isNotEmpty ||
        (images ?? []).isNotEmpty ||
        (lookUpTranslations ?? []).isNotEmpty ||
        (etymology ?? []).isNotEmpty ||
        (synonyms ?? []).isNotEmpty;

    if (!isShowAsLookUpResult && (translateTranslations ?? []).isNotEmpty) {
      return _buildTranslateText(context, translateTranslations!.first);
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
          // 文本翻译
          if ((translateTranslations ?? []).isNotEmpty)
            _buildTranslateText(
              context,
              translateTranslations!.first,
              padding: const EdgeInsets.only(top: 7, bottom: 7),
            ),
          if ((translateTranslations ?? []).isNotEmpty && isShowAsLookUpResult)
            const Divider(height: 0),
          // 词典翻译
          if ((lookUpTranslations ?? []).isNotEmpty)
            WordTranslationView(lookUpTranslations!.first),
          if ((lookUpTranslations ?? []).isNotEmpty) const Divider(height: 0),
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
          // 词源
          if ((etymology ?? []).isNotEmpty)
            _buildEtymologySection(context, etymology!),
          // 同/反义词
          if ((synonyms ?? []).isNotEmpty)
            _buildSynonymsSection(context, synonyms!),
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

  Widget _buildTranslateText(
    BuildContext context,
    TextTranslation textTranslation, {
    EdgeInsetsGeometry padding = const EdgeInsets.only(
      left: 12,
      right: 12,
      top: 7,
      bottom: 7,
    ),
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onDoubleTap: () {
        if (settingsStore.doubleClickCopyResult) {
          Clipboard.setData(ClipboardData(text: textTranslation.text));
          BotToast.showText(
            text: t.common.ui.feedback.copied,
            align: Alignment.center,
          );
        }
      },
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 40,
        ),
        padding: padding,
        alignment: Alignment.centerLeft,
        child: SelectableText.rich(
          TextSpan(
            children: [
              TextSpan(text: textTranslation.text),
            ],
          ),
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                height: 1.4,
              ),
        ),
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

  Widget _buildEtymologySection(
      BuildContext context, List<WordEtymology> etymology) {
    final textTheme = Theme.of(context).textTheme;
    final originText = etymology
        .where((e) => e.origin != null && e.origin!.isNotEmpty)
        .map((e) => e.origin!)
        .join('\n');
    final rootTexts = etymology
        .where((e) => e.root != null && e.root!.isNotEmpty)
        .expand((e) => e.root!)
        .toList();

    if (originText.isEmpty && rootTexts.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (originText.isNotEmpty)
            SelectableText(
              originText,
              style: textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.color
                    ?.withValues(alpha: 0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
          if (rootTexts.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: SelectableText(
                rootTexts.join(' · '),
                style: textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.color
                      ?.withValues(alpha: 0.7),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSynonymsSection(
      BuildContext context, List<WordSynonym> synonyms) {
    // Group synonyms by type
    final synonymList =
        synonyms.where((s) => s.type == null || s.type == 'synonym').toList();
    final antonymList = synonyms.where((s) => s.type == 'antonym').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (synonymList.isNotEmpty)
          _buildSynonymGroup(context, synonymList, '同义词'),
        if (antonymList.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: _buildSynonymGroup(context, antonymList, '反义词'),
          ),
      ],
    );
  }

  Widget _buildSynonymGroup(
      BuildContext context, List<WordSynonym> items, String label) {
    final chips = items.map((s) {
      final text = s.word;
      if (s.definitions != null && s.definitions!.isNotEmpty) {
        return '$text (${s.definitions!.join("; ")})';
      }
      return text;
    }).join(' · ');

    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => onTextTapped(items.first.word),
      child: SelectableText.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: chips,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
