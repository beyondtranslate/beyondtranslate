import 'package:biyi_app/includes.dart';
import 'package:flutter/material.dart';

class LanguageLabel extends StatelessWidget {
  const LanguageLabel(
    this.language, {
    Key? key,
    this.flagSize = 22,
    this.flagBorderColor,
    this.style,
  }) : super(key: key);

  final String language;
  final double flagSize;
  final Color? flagBorderColor;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        LanguageFlagView(
          language,
          size: flagSize,
          borderColor: flagBorderColor,
        ),
        const SizedBox(width: 5),
        DefaultTextStyle(
          style: textTheme.bodyMedium!,
          child: Text(
            getLanguageName(language),
            style: style,
          ),
        ),
      ],
    );
  }
}
