import 'package:flutter/material.dart';

import '../../utils/language_util.dart';

class LanguageLabel extends StatelessWidget {
  const LanguageLabel(
    this.language, {
    Key? key,
    this.style,
  }) : super(key: key);

  final String language;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return DefaultTextStyle(
      style: textTheme.bodyMedium!,
      child: Text(
        getLanguageName(language),
        style: style,
      ),
    );
  }
}
