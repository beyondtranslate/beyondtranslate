import 'package:biyi_app/includes.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class TranslationResultView extends StatelessWidget {
  const TranslationResultView(
    this.translationResult, {
    Key? key,
  }) : super(key: key);

  final TranslationResult translationResult;

  String get sourceLanguage =>
      translationResult.translationTarget!.sourceLanguage!;
  String get targetLanguage =>
      translationResult.translationTarget!.targetLanguage!;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
        top: 0,
        bottom: 12,
      ),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(2),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              offset: const Offset(0.0, 1.0),
              blurRadius: 3.0,
            ),
          ],
        ),
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            CustomButton(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: LanguageLabel(
                sourceLanguage,
                flagSize: 18,
              ),
              onPressed: () => {},
            ),
            SizedBox(
              width: 20,
              height: 38,
              child: CustomButton(
                padding: EdgeInsets.zero,
                child: Container(
                  margin: EdgeInsets.zero,
                  child: Icon(
                    FluentIcons.arrow_right_20_regular,
                    size: 16,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                onPressed: () {},
              ),
            ),
            CustomButton(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: LanguageLabel(
                targetLanguage,
                flagSize: 18,
              ),
              onPressed: () => {},
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
