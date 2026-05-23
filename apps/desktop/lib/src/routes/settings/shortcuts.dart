import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import '../../i18n/i18n.dart';
import '../../services/settings_store.dart';
import '../../widgets/settings_page.dart';
import '../../widgets/ui/preference_list_item.dart';
import '../../widgets/ui/preference_list_section.dart';

/// Mirrors macOS `ShortcutsView.swift`.
///
/// Shortcuts are displayed read-only here. Editing of shortcut bindings is
/// not yet implemented for the Flutter shell; the source of truth lives in
/// the Rust runtime ([RuntimeSettings.getShortcuts]).
class ShortcutsSettingsPage extends StatefulWidget {
  const ShortcutsSettingsPage({super.key});

  @override
  State<ShortcutsSettingsPage> createState() => _ShortcutsSettingsPageState();
}

class _ShortcutsSettingsPageState extends State<ShortcutsSettingsPage> {
  @override
  void initState() {
    super.initState();
    settingsStore.addListener(_handleChanged);
    settingsStore.reloadShortcuts();
  }

  @override
  void dispose() {
    settingsStore.removeListener(_handleChanged);
    super.dispose();
  }

  void _handleChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _resetToDefaults() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.settings.shortcuts.reset_dialog.title),
        content: Text(t.settings.shortcuts.reset_dialog.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.settings.shortcuts.reset_dialog.cancel),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(t.settings.shortcuts.reset_dialog.confirm),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await settingsStore.resetShortcuts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ShortcutSettings shortcuts = settingsStore.shortcuts;
    final shortcutsText = t.settings.shortcuts;

    return SettingsPage(
      title: shortcutsText.title,
      actions: [
        IconButton(
          tooltip: shortcutsText.reset_dialog.title,
          onPressed: _resetToDefaults,
          icon: const Icon(FluentIcons.arrow_counterclockwise_20_regular),
        ),
      ],
      children: [
        PreferenceListSection(
          children: [
            _ShortcutRow(
              title: shortcutsText.row.toggle_mini_translator,
              shortcut: shortcuts.toggleMiniTranslator,
            ),
          ],
        ),
        PreferenceListSection(
          title: Text(shortcutsText.section.text_extraction),
          children: [
            _ShortcutRow(
              title: shortcutsText.row.extract_text_from_screen_selection,
              shortcut: shortcuts.extractTextFromScreenSelection,
            ),
            _ShortcutRow(
              title: shortcutsText.row.extract_text_from_screen_capture,
              shortcut: shortcuts.extractTextFromScreenCapture,
            ),
            _ShortcutRow(
              title: shortcutsText.row.extract_text_from_clipboard,
              shortcut: shortcuts.extractTextFromClipboard,
            ),
          ],
        ),
        PreferenceListSection(
          title: Text(shortcutsText.section.input_assist),
          children: [
            _ShortcutRow(
              title: shortcutsText.row.translate_input,
              shortcut: shortcuts.translateInputContent,
            ),
          ],
        ),
      ],
    );
  }
}

class _ShortcutRow extends StatelessWidget {
  const _ShortcutRow({
    required this.title,
    required this.shortcut,
  });

  final String title;
  final String shortcut;

  @override
  Widget build(BuildContext context) {
    return PreferenceListItem(
      title: Text(title),
      detailText: _ShortcutBadge(shortcut: shortcut),
    );
  }
}

class _ShortcutBadge extends StatelessWidget {
  const _ShortcutBadge({required this.shortcut});

  final String shortcut;

  List<String> get _parts {
    return shortcut
        .split('+')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final parts = _parts;
    if (parts.isEmpty) {
      return Text(
        '—',
        style: Theme.of(context).textTheme.bodySmall,
      );
    }
    return Wrap(
      spacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var i = 0; i < parts.length; i++) ...[
          if (i > 0)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 2),
              child: Text('+', style: TextStyle(fontFamily: 'Roboto Mono')),
            ),
          _KeyCap(label: parts[i]),
        ],
      ],
    );
  }
}

class _KeyCap extends StatelessWidget {
  const _KeyCap({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto Mono',
          fontFamilyFallback: const ['Roboto'],
          color: isDark ? const Color(0xFFF5F5F5) : const Color(0xFF374151),
        ),
      ),
    );
  }
}
