import 'package:flutter/material.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

import '../../i18n/i18n.dart';
import '../../models/preference_item.dart';
import '../../services/local_db/configuration.dart';
import '../../services/local_db/local_db.dart';
import '../../services/shortcut_service/shortcut_service.dart';
import '../../utils/platform_util.dart';
import '../../widgets/preference_list/preference_list.dart';
import '../../widgets/preference_list/preference_list_item.dart';
import '../../widgets/preference_list/preference_list_section.dart';
import '../../widgets/record_shortcut_dialog/record_shortcut_dialog.dart';

class KeybindsSettingsPage extends StatefulWidget {
  const KeybindsSettingsPage({super.key});

  @override
  State<KeybindsSettingsPage> createState() => _KeybindsSettingsPageState();
}

class _KeybindsSettingsPageState extends State<KeybindsSettingsPage> {
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
    if (mounted) {
      setState(() {});
    }
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

  @override
  Widget build(BuildContext context) {
    return PreferenceList(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      children: [
        PreferenceListSection(
          title: Text(t.page_setting_shortcuts.title),
          children: [
            PreferenceListItem(
              title:
                  Text(t.page_setting_shortcuts.pref_item_title_show_or_hide),
              detailText: _HotKeyDisplayView(_configuration.shortcutShowOrHide),
              onTap: () {
                _handleClickRegisterNewHotKey(
                  context,
                  shortcutKey: kShortcutShowOrHide,
                );
              },
            ),
            PreferenceListItem(
              title: Text(t.page_setting_shortcuts.pref_item_title_hide),
              detailText: _HotKeyDisplayView(_configuration.shortcutHide),
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
          title: Text(t.page_setting_shortcuts.pref_section_title_extract_text),
          children: [
            PreferenceListItem(
              title: Text(
                t.page_setting_shortcuts
                    .pref_item_title_extract_text_from_selection,
              ),
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
                title: Text(
                  t.page_setting_shortcuts
                      .pref_item_title_extract_text_from_capture,
                ),
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
              title: Text(
                t.page_setting_shortcuts
                    .pref_item_title_extract_text_from_clipboard,
              ),
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
            title: Text(
              t.page_setting_shortcuts.pref_section_title_input_assist_function,
            ),
            children: [
              PreferenceListItem(
                title: Text(
                  t.page_setting_shortcuts
                      .pref_item_title_translate_input_content,
                ),
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
}

class _HotKeyDisplayView extends StatelessWidget {
  const _HotKeyDisplayView(this.hotKey);

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
        _KeyCap(hotKey.physicalKey.keyLabel, size: _KeyCapSize.tiny),
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
