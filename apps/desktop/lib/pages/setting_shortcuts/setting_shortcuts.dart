import 'package:biyi_advanced_features/biyi_advanced_features.dart';
import '../../i18n/i18n.dart';
import '../../services/services.dart';
import '../../utilities/utilities.dart';
import '../../widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:rise_ui/rise_ui.dart' hide Theme;

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
          Kbd(
            keyModifier.physicalKeys.first.keyLabel,
            size: NamedSize.tiny,
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
        Kbd(
          hotKey.physicalKey.keyLabel,
          size: NamedSize.tiny,
        ),
      ],
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
