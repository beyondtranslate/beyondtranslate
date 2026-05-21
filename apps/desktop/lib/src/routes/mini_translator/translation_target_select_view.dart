import 'dart:math' as math;

import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart' hide Card;

import '../../utils/language_util.dart';
import '../../widgets/language_label/language_label.dart';
import '../../widgets/ui/button.dart';
import '../../widgets/ui/card.dart';

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
    final theme = Theme.of(context);
    final unselectedColor =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.12) ??
            theme.dividerColor;

    return Container(
      margin: const EdgeInsets.only(left: 14, top: 12, bottom: 14),
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.start,
        spacing: 8,
        runSpacing: 8,
        children: [
          for (String supportedLanguage in kSupportedLanguages)
            SizedBox(
              height: 30,
              child: Builder(builder: (_) {
                bool isSelected = value == supportedLanguage;
                EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 10);

                Widget child = LanguageLabel(
                  supportedLanguage,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: !isSelected
                        ? theme.textTheme.bodyMedium?.color
                            ?.withValues(alpha: 0.8)
                        : Colors.white,
                  ),
                );

                return isSelected
                    ? Button.filled(
                        padding: padding,
                        borderRadius: BorderRadius.circular(15), // pill
                        onPressed: () => onChanged(supportedLanguage),
                        child: child,
                      )
                    : Button.outlined(
                        padding: padding,
                        color: unselectedColor,
                        borderRadius: BorderRadius.circular(15), // pill
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
    required this.translationMode,
    required this.isShowSourceLanguageSelector,
    required this.isShowTargetLanguageSelector,
    required this.onToggleShowSourceLanguageSelector,
    required this.onToggleShowTargetLanguageSelector,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.onChanged,
  }) : super(key: key);

  final TranslationMode translationMode;
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
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final selectorButtonColor =
        textTheme.bodyMedium?.color?.withValues(alpha: 0.10) ??
            theme.dividerColor;

    if (widget.translationMode == TranslationMode.auto) {
      return Container();
    }

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                // Source language selector
                Button(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  color: widget.isShowSourceLanguageSelector
                      ? selectorButtonColor
                      : null,
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LanguageLabel(
                        widget.sourceLanguage,
                        style: textTheme.bodyMedium!.copyWith(
                          fontWeight: widget.isShowSourceLanguageSelector
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: widget.isShowSourceLanguageSelector
                              ? theme.primaryColor
                              : textTheme.bodyMedium?.color
                                  ?.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(width: 4),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.fastOutSlowIn,
                        transformAlignment: Alignment.center,
                        transform: Matrix4.rotationZ(
                          widget.isShowSourceLanguageSelector ? math.pi : 0,
                        ),
                        child: Icon(
                          FluentIcons.chevron_down_20_regular,
                          size: 14,
                          color: widget.isShowSourceLanguageSelector
                              ? theme.primaryColor
                              : textTheme.bodyMedium?.color
                                  ?.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    widget.onToggleShowSourceLanguageSelector(
                        !widget.isShowSourceLanguageSelector);
                  },
                ),
                const Spacer(),
                // Swap button
                SizedBox(
                  width: 28,
                  height: 28,
                  child: Button(
                    minSize: 0,
                    padding: EdgeInsets.zero,
                    borderRadius: BorderRadius.circular(14),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      transformAlignment: Alignment.center,
                      transform: Matrix4.rotationZ(
                        _isRotated ? math.pi : 0,
                      ),
                      child: Icon(
                        FluentIcons.arrow_swap_20_regular,
                        size: 18,
                        color: theme.iconTheme.color?.withValues(alpha: 0.6),
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
                const Spacer(),
                // Target language selector
                Button(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  color: widget.isShowTargetLanguageSelector
                      ? selectorButtonColor
                      : null,
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LanguageLabel(
                        widget.targetLanguage,
                        style: textTheme.bodyMedium!.copyWith(
                          fontWeight: widget.isShowTargetLanguageSelector
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: widget.isShowTargetLanguageSelector
                              ? theme.primaryColor
                              : textTheme.bodyMedium?.color
                                  ?.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(width: 4),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.fastOutSlowIn,
                        transformAlignment: Alignment.center,
                        transform: Matrix4.rotationZ(
                          widget.isShowTargetLanguageSelector ? math.pi : 0,
                        ),
                        child: Icon(
                          FluentIcons.chevron_down_20_regular,
                          size: 14,
                          color: widget.isShowTargetLanguageSelector
                              ? theme.primaryColor
                              : textTheme.bodyMedium?.color
                                  ?.withValues(alpha: 0.5),
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
            Container(
              height: 0.5,
              margin: const EdgeInsets.symmetric(horizontal: 14),
              color: theme.dividerColor.withValues(alpha: 0.3),
            ),
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
    );
  }
}
