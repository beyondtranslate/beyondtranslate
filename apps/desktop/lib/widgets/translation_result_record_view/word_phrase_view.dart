import 'package:biyi_app/includes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class WordPhraseView extends StatelessWidget {
  const WordPhraseView(
    this.wordPhrase, {
    Key? key,
    required this.onTextTapped,
  }) : super(key: key);

  final WordPhrase wordPhrase;
  final ValueChanged<String> onTextTapped;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(top: 6),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SelectableText.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: wordPhrase.text,
                  style: textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => onTextTapped(wordPhrase.text),
                ),
                const TextSpan(text: ' '),
                TextSpan(
                  text: wordPhrase.translations.first,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 13,
                      ),
                ),
              ],
            ),
            style: textTheme.bodyMedium!.copyWith(
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
