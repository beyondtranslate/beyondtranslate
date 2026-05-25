import 'dart:ui';

import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart' hide Card, TextField;

import '../../i18n/i18n.dart';
import '../../widgets/ui/button.dart';
import '../../widgets/ui/card.dart';
import '../../widgets/ui/loading_indicator.dart';
import '../../widgets/ui/text_field.dart';

class TranslationInputView extends StatelessWidget {
  const TranslationInputView({
    Key? key,
    required this.focusNode,
    required this.controller,
    required this.onChanged,
    required this.isTextDetecting,
    required this.inputSubmitMode,
    required this.onClickExtractTextFromScreenCapture,
    required this.onClickExtractTextFromClipboard,
    required this.onButtonTappedClear,
    required this.onButtonTappedTrans,
  }) : super(key: key);

  final FocusNode focusNode;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  final bool isTextDetecting;

  final InputSubmitMode inputSubmitMode;

  final VoidCallback onClickExtractTextFromScreenCapture;
  final VoidCallback onClickExtractTextFromClipboard;

  final VoidCallback onButtonTappedClear;
  final VoidCallback onButtonTappedTrans;

  final bool isAddedToVocabulary = true;

  static const _kCornerRadius = 10.0;

  Widget _buildToolbarItems(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Tooltip(
          message: t
              .mini_translator.toolbar.tooltip.extract_text_from_screen_capture,
          child: Button(
            minSize: 0,
            padding: const EdgeInsets.all(4),
            onPressed: onClickExtractTextFromScreenCapture,
            child: SizedBox(
              width: 28,
              height: 28,
              child: Icon(
                FluentIcons.crop_20_regular,
                size: 20,
                color: theme.iconTheme.color?.withValues(alpha: 0.7),
              ),
            ),
          ),
        ),
        Tooltip(
          message:
              t.mini_translator.toolbar.tooltip.extract_text_from_clipboard,
          child: Button(
            minSize: 0,
            padding: const EdgeInsets.all(4),
            onPressed: onClickExtractTextFromClipboard,
            child: SizedBox(
              width: 28,
              height: 28,
              child: Icon(
                FluentIcons.clipboard_text_ltr_20_regular,
                size: 20,
                color: theme.iconTheme.color?.withValues(alpha: 0.7),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);
    final secondaryButtonColor =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.12) ??
            theme.dividerColor;

    return Row(
      children: [
        SizedBox(
          height: 28,
          child: Button.outlined(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            borderRadius: BorderRadius.circular(14), // pill-shaped
            color: secondaryButtonColor,
            onPressed: onButtonTappedClear,
            child: Text(
              t.mini_translator.button.clear,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 28,
          child: Button.filled(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            borderRadius: BorderRadius.circular(14), // pill-shaped
            onPressed: onButtonTappedTrans,
            child: Text(
              t.mini_translator.button.translate,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      borderRadius: BorderRadius.circular(_kCornerRadius),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text input area
          SizedBox(
            child: Stack(
              children: [
                TextField(
                  focusNode: focusNode,
                  selectionHeightStyle: BoxHeightStyle.max,
                  controller: controller,
                  padding: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                    top: 12,
                    bottom: 10,
                  ),
                  placeholder: t.mini_translator.input.hint,
                  placeholderStyle: textTheme.bodyMedium?.copyWith(
                    color: textTheme.bodyMedium?.color?.withValues(alpha: 0.4),
                    height: 1.3,
                  ),
                  style: textTheme.bodyMedium?.copyWith(
                    height: 1.3,
                  ),
                  maxLines: inputSubmitMode == InputSubmitMode.enter ? 1 : 6,
                  minLines: 1,
                  onChanged: onChanged,
                  onSubmitted: (newValue) {
                    onButtonTappedTrans();
                  },
                ),
                if (isTextDetecting)
                  Positioned.fill(
                    child: Container(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      color: theme.canvasColor
                          .withValues(alpha: isDark ? 0.80 : 0.95),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LoadingIndicator.doubleBounce(
                            color: textTheme.bodySmall!.color,
                            size: 18.0,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            t.mini_translator.input.extracting_text,
                            style: TextStyle(
                              color: textTheme.bodySmall!.color,
                              fontSize: 13,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Divider with macOS style
          Container(
            height: 0.5,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            color: theme.dividerColor.withValues(alpha: 0.3),
          ),
          // Bottom toolbar row
          Padding(
            padding: const EdgeInsets.only(
              left: 2,
              right: 12,
              top: 8,
              bottom: 8,
            ),
            child: Row(
              children: [
                _buildToolbarItems(context),
                const Spacer(),
                _buildActionButtons(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
