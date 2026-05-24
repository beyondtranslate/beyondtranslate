import 'dart:math' as math;

import 'package:beyondtranslate_desktop/src/routes/app_router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:nativeapi/nativeapi.dart';

import '../../extensions/window_controller.dart'
    show ExtendedRegularWindowController;
import '../../i18n/i18n.dart';
import '../../services/runtime.dart' show TranslationTarget;
import '../../utils/language_util.dart';
import '../../widgets/ui/button.dart';
import '../../widgets/ui/card.dart';

class TranslationTargetSelectView extends StatefulWidget {
  const TranslationTargetSelectView({
    Key? key,
    required this.sourceLanguage,
    this.selectedTargetLanguage,
    this.activeConfigIndex = -1,
    this.persistentTargets = const [],
    required this.onSourceChanged,
    required this.onTargetLanguageChanged,
    required this.onConfigTargetSelected,
    this.onManageTargets,
  }) : super(key: key);

  final String sourceLanguage;
  final String? selectedTargetLanguage;
  final int activeConfigIndex;
  final List<TranslationTarget> persistentTargets;
  final ValueChanged<String> onSourceChanged;
  final ValueChanged<String?> onTargetLanguageChanged;
  final ValueChanged<int> onConfigTargetSelected;
  final VoidCallback? onManageTargets;

  @override
  State<TranslationTargetSelectView> createState() =>
      _TranslationTargetSelectViewState();
}

class _TranslationTargetSelectViewState
    extends State<TranslationTargetSelectView> {
  bool _isRotated = false;
  bool _isSourceMenuOpen = false;
  bool _isTargetMenuOpen = false;
  bool _isConfigMenuOpen = false;
  final _sourceButtonKey = GlobalKey();
  final _targetButtonKey = GlobalKey();
  final _configButtonKey = GlobalKey();

  void _openMenu(
    GlobalKey buttonKey,
    Menu menu, {
    Placement placement = Placement.bottom,
    double anchorX = 0.5,
  }) {
    final renderBox =
        buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final localPosition = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final anchorPosition = Offset(
      localPosition.dx + size.width * anchorX,
      localPosition.dy + size.height + 8,
    );

    menu.open(
      PositioningStrategy.relativeToWindow(
        miniTranslatorWindowController.window,
        anchorPosition,
      ),
      placement,
    );
  }

  void _trackMenu(Menu menu, ValueChanged<bool> setOpen) {
    menu.addCallbackListener<MenuOpenedEvent>((_) {
      if (mounted) setState(() => setOpen(true));
    });
    menu.addCallbackListener<MenuClosedEvent>((_) {
      if (mounted) setState(() => setOpen(false));
    });
  }

  void _showSourceMenu() {
    final menu = Menu();
    _trackMenu(menu, (value) => _isSourceMenuOpen = value);

    final autoItem = MenuItem(
      t.mini_translator.language.auto_detect,
      MenuItemType.checkbox,
    );
    autoItem.state = isAutoSource(widget.sourceLanguage)
        ? MenuItemState.checked
        : MenuItemState.unchecked;
    autoItem.on<MenuItemClickedEvent>((_) {
      widget.onSourceChanged(kAutoSource);
    });
    menu.addItem(autoItem);
    menu.addItem(MenuItem('', MenuItemType.separator));

    for (final lang in supportedLanguages) {
      final item = MenuItem(
        getLanguageName(lang, showNative: true),
        MenuItemType.checkbox,
      );
      item.state = lang == widget.sourceLanguage
          ? MenuItemState.checked
          : MenuItemState.unchecked;
      item.on<MenuItemClickedEvent>((_) {
        widget.onSourceChanged(lang);
      });
      menu.addItem(item);
    }
    _openMenu(_sourceButtonKey, menu);
  }

  void _showTargetMenu() {
    final menu = Menu();
    _trackMenu(menu, (value) => _isTargetMenuOpen = value);

    final autoItem = MenuItem(
      t.mini_translator.language.auto_match,
      MenuItemType.checkbox,
    );
    autoItem.state = widget.selectedTargetLanguage == null
        ? MenuItemState.checked
        : MenuItemState.unchecked;
    autoItem.on<MenuItemClickedEvent>((_) {
      widget.onTargetLanguageChanged(null);
    });
    menu.addItem(autoItem);
    menu.addItem(MenuItem('', MenuItemType.separator));

    for (final lang in supportedLanguages) {
      final item = MenuItem(
        getLanguageName(lang, showNative: true),
        MenuItemType.checkbox,
      );
      item.state = widget.selectedTargetLanguage == lang
          ? MenuItemState.checked
          : MenuItemState.unchecked;
      item.on<MenuItemClickedEvent>((_) {
        widget.onTargetLanguageChanged(lang);
      });
      menu.addItem(item);
    }
    _openMenu(_targetButtonKey, menu);
  }

  void _showConfigMenu() {
    final menu = Menu();
    _trackMenu(menu, (value) => _isConfigMenuOpen = value);

    final autoLabel =
        '${t.mini_translator.language.auto_detect} -> ${t.mini_translator.language.auto_match}';
    final autoItem = MenuItem(
      autoLabel,
      MenuItemType.checkbox,
    );
    autoItem.state = widget.activeConfigIndex == -1
        ? MenuItemState.checked
        : MenuItemState.unchecked;
    autoItem.on<MenuItemClickedEvent>((_) {
      widget.onConfigTargetSelected(-1);
    });
    menu.addItem(autoItem);
    menu.addItem(MenuItem('', MenuItemType.separator));

    for (var i = 0; i < widget.persistentTargets.length; i++) {
      final target = widget.persistentTargets[i];
      final label =
          '${getSourceDisplayName(target.source)} -> ${getLanguageName(target.target)}';
      final item = MenuItem(label, MenuItemType.checkbox);
      item.state = widget.activeConfigIndex == i
          ? MenuItemState.checked
          : MenuItemState.unchecked;
      item.on<MenuItemClickedEvent>((_) {
        widget.onConfigTargetSelected(i);
      });
      menu.addItem(item);
    }

    if (widget.persistentTargets.isNotEmpty) {
      menu.addItem(MenuItem('', MenuItemType.separator));
    }

    final manageItem = MenuItem(
      t.settings.general.button.manage_targets,
      MenuItemType.normal,
    );
    manageItem.on<MenuItemClickedEvent>((_) => widget.onManageTargets?.call());
    menu.addItem(manageItem);
    _openMenu(_configButtonKey, menu,
        placement: Placement.bottomEnd, anchorX: 1.0);
  }

  Widget _buildSelectorButton({
    required GlobalKey key,
    required bool isMenuOpen,
    required String label,
    required VoidCallback onPressed,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 8),
  }) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final selectorButtonColor =
        textTheme.bodyMedium?.color?.withValues(alpha: 0.10) ??
            theme.dividerColor;

    return Button(
      key: key,
      minSize: 32,
      padding: padding,
      color: isMenuOpen ? selectorButtonColor : null,
      borderRadius: BorderRadius.circular(8),
      trailingIcon: Icon(
        FluentIcons.chevron_down_20_regular,
        size: 14,
        color: textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        overflow: TextOverflow.ellipsis,
        style: textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildConfigButton({
    required GlobalKey key,
    required bool isMenuOpen,
    required String tooltip,
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final selectorButtonColor =
        textTheme.bodyMedium?.color?.withValues(alpha: 0.10) ??
            theme.dividerColor;

    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: 28,
        height: 28,
        child: Button(
          key: key,
          minSize: 0,
          padding: EdgeInsets.zero,
          color: isMenuOpen ? selectorButtonColor : null,
          borderRadius: BorderRadius.circular(14),
          onPressed: onPressed,
          child: Icon(
            icon,
            size: 18,
            color: theme.iconTheme.color?.withValues(alpha: 0.65),
          ),
        ),
      ),
    );
  }

  String get _targetLabel {
    final target = widget.selectedTargetLanguage;
    return target == null
        ? t.mini_translator.language.auto_match
        : getLanguageName(target);
  }

  String get _configLabel {
    final index = widget.activeConfigIndex;
    if (index >= 0 && index < widget.persistentTargets.length) {
      final target = widget.persistentTargets[index];
      return '${getSourceDisplayName(target.source)} -> ${getLanguageName(target.target)}';
    }
    return t.mini_translator.language.switch_config;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      constraints: const BoxConstraints(minHeight: 40),
      padding: const EdgeInsets.only(left: 4, top: 4, bottom: 4, right: 8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: Row(
            children: [
              _buildSelectorButton(
                key: _sourceButtonKey,
                isMenuOpen: _isSourceMenuOpen,
                label: getSourceDisplayName(widget.sourceLanguage),
                onPressed: _showSourceMenu,
              ),
              SizedBox(
                width: 28,
                height: 28,
                child: Button(
                  minSize: 0,
                  padding: EdgeInsets.zero,
                  borderRadius: BorderRadius.circular(14),
                  onPressed: isAutoSource(widget.sourceLanguage)
                      ? null
                      : () {
                          setState(() {
                            _isRotated = !_isRotated;
                          });
                          widget.onSourceChanged(
                            widget.selectedTargetLanguage ??
                                defaultTargetLanguage,
                          );
                          widget.onTargetLanguageChanged(
                            widget.sourceLanguage,
                          );
                        },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    transformAlignment: Alignment.center,
                    transform: Matrix4.rotationZ(_isRotated ? math.pi : 0),
                    child: Icon(
                      FluentIcons.arrow_swap_20_regular,
                      size: 18,
                      color: theme.iconTheme.color?.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
              _buildSelectorButton(
                key: _targetButtonKey,
                isMenuOpen: _isTargetMenuOpen,
                label: _targetLabel,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                onPressed: _showTargetMenu,
              ),
            ],
          )),
          _buildConfigButton(
            key: _configButtonKey,
            isMenuOpen: _isConfigMenuOpen,
            tooltip: _configLabel,
            icon: FluentIcons.options_20_regular,
            onPressed: _showConfigMenu,
          ),
        ],
      ),
    );
  }
}
