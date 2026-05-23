import 'dart:math' as math;

import 'package:beyondtranslate_desktop/src/routes/app_router.dart';
import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:nativeapi/nativeapi.dart';

import '../../extensions/window_controller.dart'
    show ExtendedRegularWindowController;
import '../../utils/language_util.dart';
import '../../widgets/ui/button.dart';
import '../../widgets/ui/card.dart';

class TranslationTargetSelectView extends StatefulWidget {
  const TranslationTargetSelectView({
    Key? key,
    required this.translationMode,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.onChanged,
  }) : super(key: key);

  final TranslationMode translationMode;
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
  bool _isSourceMenuOpen = false;
  bool _isTargetMenuOpen = false;
  final _sourceButtonKey = GlobalKey();
  final _targetButtonKey = GlobalKey();

  void _handleChanged(String sourceLanguage, String targetLanguage) {
    widget.onChanged(
      sourceLanguage,
      targetLanguage,
    );
  }

  void _showLanguageMenu({
    required GlobalKey buttonKey,
    required bool isSource,
    required String currentLanguage,
    required ValueChanged<String> onSelected,
  }) {
    final renderBox =
        buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final window = miniTranslatorWindowController.window;

    final localPosition = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    final anchorPosition = Offset(
      localPosition.dx + size.width / 2,
      localPosition.dy + size.height + 6,
    );

    final menu = Menu();
    menu.addCallbackListener<MenuOpenedEvent>((_) {
      if (!mounted) return;
      setState(() {
        if (isSource) {
          _isSourceMenuOpen = true;
        } else {
          _isTargetMenuOpen = true;
        }
      });
    });
    menu.addCallbackListener<MenuClosedEvent>((_) {
      if (!mounted) return;
      setState(() {
        if (isSource) {
          _isSourceMenuOpen = false;
        } else {
          _isTargetMenuOpen = false;
        }
      });
    });
    for (final lang in supportedLanguages) {
      final item = MenuItem(
        getLanguageName(lang, showNative: true),
        MenuItemType.checkbox,
      );
      item.state = lang == currentLanguage
          ? MenuItemState.checked
          : MenuItemState.unchecked;
      item.on<MenuItemClickedEvent>((_) {
        onSelected(lang);
      });
      menu.addItem(item);
    }
    menu.open(
      PositioningStrategy.relativeToWindow(window, anchorPosition),
      Placement.bottom,
    );
  }

  Widget _buildLanguageButton({
    required GlobalKey buttonKey,
    required bool isMenuOpen,
    required String language,
    required bool isSource,
    required EdgeInsets padding,
    required Color? highlightColor,
    required ValueChanged<String> onSelected,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Button(
      key: buttonKey,
      minSize: 40 - 8,
      padding: padding,
      color: isMenuOpen ? highlightColor : null,
      borderRadius: BorderRadius.circular(8),
      trailingIcon: Icon(
        FluentIcons.chevron_down_20_regular,
        size: 14,
        color: textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
      ),
      child: Text(
        getLanguageName(language),
        style: textTheme.bodyMedium,
      ),
      onPressed: () {
        _showLanguageMenu(
          buttonKey: buttonKey,
          isSource: isSource,
          currentLanguage: language,
          onSelected: onSelected,
        );
      },
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
      height: 40,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            _buildLanguageButton(
              buttonKey: _sourceButtonKey,
              isMenuOpen: _isSourceMenuOpen,
              language: widget.sourceLanguage,
              isSource: true,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              highlightColor: selectorButtonColor,
              onSelected: (newLanguage) {
                _handleChanged(newLanguage, widget.targetLanguage);
              },
            ),
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
            _buildLanguageButton(
              buttonKey: _targetButtonKey,
              isMenuOpen: _isTargetMenuOpen,
              language: widget.targetLanguage,
              isSource: false,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              highlightColor: selectorButtonColor,
              onSelected: (newLanguage) {
                _handleChanged(widget.sourceLanguage, newLanguage);
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
