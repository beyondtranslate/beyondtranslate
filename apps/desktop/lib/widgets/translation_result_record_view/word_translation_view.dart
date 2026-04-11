import 'package:biyi_app/includes.dart';
import 'package:flutter/material.dart';

class WordTranslationView extends StatefulWidget {
  const WordTranslationView(
    this.wordTranslation, {
    Key? key,
  }) : super(key: key);
  final TextTranslation wordTranslation;

  @override
  State<WordTranslationView> createState() => _WordTranslationViewState();
}

class _WordTranslationViewState extends State<WordTranslationView> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return MouseRegion(
      onEnter: (event) {
        _isHovered = true;
        setState(() {});
      },
      onExit: (event) {
        _isHovered = false;
        setState(() {});
      },
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          minHeight: 40,
        ),
        padding: const EdgeInsets.only(
          top: 7,
          bottom: 7,
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SelectableText.rich(
              TextSpan(
                children: [
                  TextSpan(text: widget.wordTranslation.text),
                ],
              ),
              style: textTheme.bodyMedium!.copyWith(
                height: 1.4,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 2, left: 4),
              padding: const EdgeInsets.only(left: 2, right: 2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xff80838a).withOpacity(0.6),
                ),
                borderRadius: BorderRadius.circular(2),
              ),
              child: const Text(
                '常见释义',
                style: TextStyle(
                  color: Color(0xff80838a),
                  fontSize: 10,
                ),
              ),
            ),
            if ((widget.wordTranslation.audioUrl ?? '').isNotEmpty &&
                _isHovered)
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: SoundPlayButton(
                  audioUrl: widget.wordTranslation.audioUrl!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
