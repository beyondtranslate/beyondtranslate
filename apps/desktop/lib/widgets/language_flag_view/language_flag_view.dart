import 'package:biyi_app/includes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LanguageFlagView extends StatelessWidget {
  const LanguageFlagView(
    this.language, {
    Key? key,
    this.size = 22,
    this.borderColor,
  }) : super(key: key);

  final String language;
  final double size;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xffeeeeee),
        borderRadius: BorderRadius.all(
          Radius.circular(size / 2),
        ),
        border: Border.all(
          color: borderColor ?? Colors.black.withOpacity(0.1),
          width: 0.8,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(size / 2),
        ),
        child: SvgPicture.asset(
          getLanguageFlag(language),
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
