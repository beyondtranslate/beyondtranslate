import 'dart:math' as math;

import 'package:biyi_advanced_features/biyi_advanced_features.dart';
import 'package:biyi_app/includes.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class _AvailableLanguageSelector extends StatelessWidget {
  const _AvailableLanguageSelector({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12, top: 12, bottom: 12),
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.start,
        spacing: 6,
        runSpacing: 6,
        children: [
          for (String supportedLanguage in kSupportedLanguages)
            Container(
              margin: EdgeInsets.zero,
              height: 28,
              child: Builder(builder: (_) {
                bool isSelected = value == supportedLanguage;
                EdgeInsets padding = const EdgeInsets.only(left: 6, right: 6);
                Widget child = LanguageLabel(
                  supportedLanguage,
                  flagSize: 18,
                  style: TextStyle(
                    color: !isSelected ? null : Colors.white,
                  ),
                );

                return isSelected
                    ? CustomButton.filled(
                        padding: padding,
                        borderRadius: BorderRadius.circular(2),
                        onPressed: () => onChanged(supportedLanguage),
                        child: child,
                      )
                    : CustomButton.outlined(
                        padding: padding,
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(2),
                        onPressed: () => onChanged(supportedLanguage),
                        child: child,
                      );
              }),
            ),
        ],
      ),
    );
  }
}

class TranslationTargetSelectView extends StatefulWidget {
  const TranslationTargetSelectView({
    Key? key,
    // this.viewKey,
    required this.translationMode,
    required this.isShowSourceLanguageSelector,
    required this.isShowTargetLanguageSelector,
    required this.onToggleShowSourceLanguageSelector,
    required this.onToggleShowTargetLanguageSelector,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.onChanged,
  }) : super(key: key);
  // final Key viewKey;
  final String translationMode;
  final bool isShowSourceLanguageSelector;
  final bool isShowTargetLanguageSelector;
  final ValueChanged<bool> onToggleShowSourceLanguageSelector;
  final ValueChanged<bool> onToggleShowTargetLanguageSelector;
  final String sourceLanguage;
  final String targetLanguage;
  final Function(String sourceLanguage, String targetLanguage) onChanged;

  @override
  State<TranslationTargetSelectView> createState() =>
      _TranslationTargetSelectViewState();
}

class _TranslationTargetSelectViewState
    extends State<TranslationTargetSelectView> {
  bool _isRotated = false;

  void _handleChanged(String sourceLanguage, String targetLanguage) {
    widget.onChanged(
      sourceLanguage,
      targetLanguage,
    );
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    if (widget.translationMode == kTranslationModeAuto) {
      return Container();
    }
    return Container(
      margin: const EdgeInsets.only(
        left: 12,
        right: 12,
        top: 0,
        bottom: 12,
      ),
      child: Container(
        padding: EdgeInsets.zero,
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
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.zero,
              height: 40,
              child: Row(
                children: [
                  CustomButton(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    borderRadius: BorderRadius.zero,
                    child: Row(
                      children: [
                        LanguageLabel(
                          widget.sourceLanguage,
                          flagSize: 18,
                          flagBorderColor: widget.isShowSourceLanguageSelector
                              ? Theme.of(context).primaryColor
                              : null,
                          style: textTheme.bodyMedium!.copyWith(
                            color: widget.isShowSourceLanguageSelector
                                ? Theme.of(context).primaryColor
                                : null,
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.fastOutSlowIn,
                          transformAlignment: Alignment.center,
                          transform: Matrix4.rotationZ(
                            widget.isShowSourceLanguageSelector
                                ? math.pi / 1
                                : 0,
                          ),
                          child: Container(
                            margin: EdgeInsets.zero,
                            child: Icon(
                              FluentIcons.chevron_down_20_regular,
                              size: 14,
                              color: widget.isShowSourceLanguageSelector
                                  ? Theme.of(context).primaryColor
                                  : textTheme.bodyMedium!.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      widget.onToggleShowSourceLanguageSelector(
                          !widget.isShowSourceLanguageSelector);
                    },
                  ),
                  SizedBox(
                    width: 20,
                    height: 38,
                    child: CustomButton(
                      padding: EdgeInsets.zero,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.fastOutSlowIn,
                        transformAlignment: Alignment.center,
                        transform: Matrix4.rotationZ(
                          _isRotated ? math.pi / 1 : 0,
                        ),
                        child: Icon(
                          FluentIcons.arrow_swap_20_regular,
                          size: 20,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _isRotated = !_isRotated;
                        });
                        _handleChanged(
                          widget.targetLanguage,
                          widget.sourceLanguage,
                        );
                      },
                    ),
                  ),
                  CustomButton(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    borderRadius: BorderRadius.zero,
                    child: Row(
                      children: [
                        LanguageLabel(
                          widget.targetLanguage,
                          flagSize: 18,
                          flagBorderColor: widget.isShowTargetLanguageSelector
                              ? Theme.of(context).primaryColor
                              : null,
                          style: textTheme.bodyMedium!.copyWith(
                            color: widget.isShowTargetLanguageSelector
                                ? Theme.of(context).primaryColor
                                : null,
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.fastOutSlowIn,
                          transformAlignment: Alignment.center,
                          transform: Matrix4.rotationZ(
                            widget.isShowTargetLanguageSelector
                                ? math.pi / 1
                                : 0,
                          ),
                          child: Container(
                            margin: EdgeInsets.zero,
                            child: Icon(
                              FluentIcons.chevron_down_20_regular,
                              size: 14,
                              color: widget.isShowTargetLanguageSelector
                                  ? Theme.of(context).primaryColor
                                  : textTheme.bodyMedium!.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      widget.onToggleShowTargetLanguageSelector(
                          !widget.isShowTargetLanguageSelector);
                    },
                  ),
                ],
              ),
            ),
            if (widget.isShowSourceLanguageSelector ||
                widget.isShowTargetLanguageSelector)
              const Divider(height: 0, indent: 12, endIndent: 12),
            if (widget.isShowSourceLanguageSelector)
              _AvailableLanguageSelector(
                value: widget.sourceLanguage,
                onChanged: (newLanguage) {
                  _handleChanged(newLanguage, widget.targetLanguage);
                },
              ),
            if (widget.isShowTargetLanguageSelector)
              _AvailableLanguageSelector(
                value: widget.targetLanguage,
                onChanged: (newLanguage) {
                  _handleChanged(widget.sourceLanguage, newLanguage);
                },
              ),
          ],
        ),
      ),
    );
  }
}
