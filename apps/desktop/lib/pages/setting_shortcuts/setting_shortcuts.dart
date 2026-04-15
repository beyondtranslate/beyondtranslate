import 'package:biyi_app/models/models.dart';
import '../../i18n/i18n.dart';
import '../../services/services.dart';
import '../../utilities/utilities.dart';
import '../../widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

class _HotKeyDisplayView extends StatelessWidget {
  const _HotKeyDisplayView(
    this.hotKey, {
    Key? key,
  }) : super(key: key);

  final HotKey hotKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (HotKeyModifier keyModifier in hotKey.modifiers ?? []) ...[
          _KeyCap(
            keyModifier.physicalKeys.first.keyLabel,
            size: _KeyCapSize.tiny,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '+',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Roboto Mono',
              ),
            ),
          ),
        ],
        _KeyCap(
          hotKey.physicalKey.keyLabel,
          size: _KeyCapSize.tiny,
        ),
      ],
    );
  }
}

enum _KeyCapSize {
  tiny,
}

class _KeyCap extends StatelessWidget {
  const _KeyCap(
    this.label, {
    this.size = _KeyCapSize.tiny,
  });

  final String label;
  final _KeyCapSize size;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final EdgeInsetsGeometry padding;
    final double fontSize;

    switch (size) {
      case _KeyCapSize.tiny:
        padding = const EdgeInsets.symmetric(horizontal: 2, vertical: 4);
        fontSize = 10;
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF666666) : const Color(0xFFF9FAFB),
        border: Border(
          left: BorderSide(
            color: isDark ? const Color(0xFF7A7A7A) : const Color(0xFFD1D5DB),
          ),
          top: BorderSide(
            color: isDark ? const Color(0xFF7A7A7A) : const Color(0xFFD1D5DB),
          ),
          right: BorderSide(
            color: isDark ? const Color(0xFF7A7A7A) : const Color(0xFFD1D5DB),
          ),
          bottom: BorderSide(
            width: 3,
            color: isDark ? const Color(0xFF7A7A7A) : const Color(0xFFD1D5DB),
          ),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: padding,
        child: Text(
          label,
          style: TextStyle(
            color: isDark ? const Color(0xFFF5F5F5) : const Color(0xFF374151),
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            fontFamily: 'Roboto Mono',
            fontFamilyFallback: const ['Roboto'],
          ),
        ),
      ),
    );
  }
}

class SettingShortcutsPage extends StatefulWidget {
  const SettingShortcutsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingShortcutsPageState();
}

class _SettingShortcutsPageState extends State<SettingShortcutsPage> {
  Configuration get _configuration => localDb.configuration;

  @override
  void initState() {
    ShortcutService.instance.stop();
    localDb.preferences.addListener(_handleChanged);
    super.initState();
  }

  @override
  void dispose() {
    ShortcutService.instance.start();
    localDb.preferences.removeListener(_handleChanged);
    super.dispose();
  }

  void _handleChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _handleClickRegisterNewHotKey(
    BuildContext context, {
    required String shortcutKey,
    HotKeyScope shortcutScope = HotKeyScope.system,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return RecordHotKeyDialog(
          onHotKeyRecorded: (newHotKey) {
            _configuration.setShortcut(
              shortcutKey,
              HotKey(
                identifier: newHotKey.identifier,
                key: newHotKey.key,
                modifiers: newHotKey.modifiers,
                scope: shortcutScope,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return PreferenceList(
      children: [
        PreferenceListSection(
          children: [
            PreferenceListItem(
              title: Text(t('pref_item_title_show_or_hide')),
              detailText: _HotKeyDisplayView(
                _configuration.shortcutShowOrHide,
              ),
              onTap: () {
                _handleClickRegisterNewHotKey(
                  context,
                  shortcutKey: kShortcutShowOrHide,
                );
              },
            ),
            PreferenceListItem(
              title: Text(t('pref_item_title_hide')),
              detailText: _HotKeyDisplayView(
                _configuration.shortcutHide,
              ),
              onTap: () {
                _handleClickRegisterNewHotKey(
                  context,
                  shortcutKey: kShortcutHide,
                  shortcutScope: HotKeyScope.inapp,
                );
              },
            ),
          ],
        ),
        PreferenceListSection(
          title: Text(t('pref_section_title_extract_text')),
          children: [
            PreferenceListItem(
              title: Text(t('pref_item_title_extract_text_from_selection')),
              detailText: _HotKeyDisplayView(
                _configuration.shortcutExtractFromScreenSelection,
              ),
              onTap: () {
                _handleClickRegisterNewHotKey(
                  context,
                  shortcutKey: kShortcutExtractFromScreenSelection,
                );
              },
            ),
            if (!kIsLinux)
              PreferenceListItem(
                title: Text(t('pref_item_title_extract_text_from_capture')),
                detailText: _HotKeyDisplayView(
                  _configuration.shortcutExtractFromScreenCapture,
                ),
                onTap: () {
                  _handleClickRegisterNewHotKey(
                    context,
                    shortcutKey: kShortcutExtractFromScreenCapture,
                  );
                },
              ),
            PreferenceListItem(
              title: Text(t('pref_item_title_extract_text_from_clipboard')),
              detailText: _HotKeyDisplayView(
                _configuration.shortcutExtractFromClipboard,
              ),
              onTap: () {
                _handleClickRegisterNewHotKey(
                  context,
                  shortcutKey: kShortcutExtractFromClipboard,
                );
              },
            ),
          ],
        ),
        if (!kIsLinux)
          PreferenceListSection(
            title: Text(t('pref_section_title_input_assist_function')),
            children: [
              PreferenceListItem(
                title: Text(t('pref_item_title_translate_input_content')),
                detailText: _HotKeyDisplayView(
                  _configuration.shortcutTranslateInputContent,
                ),
                onTap: () {
                  _handleClickRegisterNewHotKey(
                    context,
                    shortcutKey: kShortcutTranslateInputContent,
                  );
                },
              ),
            ],
          ),
      ],
    );
  }

  Widget _build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(t('title')),
      ),
      body: _buildBody(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  String t(String key) {
    return 'page_setting_shortcuts.$key'.tr();
  }
}
