import 'dart:io';

import 'package:flutter/material.dart';

import '../../i18n/i18n.dart';
import '../../services/runtime.dart' as runtime_service;
import '../../services/runtime.dart' show AdvancedSettingsPatch;
import '../../services/settings_store.dart';
import '../../widgets/settings_page.dart';
import '../../widgets/ui/preference_list_item.dart';
import '../../widgets/ui/preference_list_section.dart';

/// Mirrors macOS `AdvancedView.swift`.
class AdvancedSettingsPage extends StatefulWidget {
  const AdvancedSettingsPage({super.key});

  @override
  State<AdvancedSettingsPage> createState() => _AdvancedSettingsPageState();
}

class _AdvancedSettingsPageState extends State<AdvancedSettingsPage> {
  late final TextEditingController _portController;

  @override
  void initState() {
    super.initState();
    _portController = TextEditingController();
    settingsStore.addListener(_handleSettingsChanged);
    _syncControllers();
  }

  @override
  void dispose() {
    settingsStore.removeListener(_handleSettingsChanged);
    _portController.dispose();
    super.dispose();
  }

  void _handleSettingsChanged() {
    _syncControllers();
    if (mounted) {
      setState(() {});
    }
  }

  void _syncControllers() {
    final advanced = settingsStore.advanced;
    _setControllerText(_portController, advanced.apiServerPort.toString());
  }

  void _setControllerText(TextEditingController controller, String value) {
    if (controller.text == value) return;
    controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  Future<void> _updatePort(String value) async {
    final port = int.tryParse(value.trim()) ?? 0;
    await settingsStore.updateAdvanced(AdvancedSettingsPatch(
      apiServerPort: port.clamp(0, 65535),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final advanced = settingsStore.advanced;
    final apiInfo = runtime_service.apiServerInfo;
    final address = apiInfo?.baseUrl ?? t.settings.advanced.disabled;

    return SettingsPage(
      title: t.settings.advanced.title,
      children: [
        PreferenceListSection(
          title: Text(t.settings.advanced.api_server),
          description: advanced.apiServerEnabled
              ? apiInfo == null
                  ? Text(t.settings.advanced.disabled)
                  : _ApiServerLinkText(baseUrl: address)
              : Text(t.settings.advanced.api_server_description),
          children: [
            PreferenceListSwitchItem(
              title: Text(t.settings.advanced.api_server),
              value: advanced.apiServerEnabled,
              onChanged: (value) {
                settingsStore.updateAdvanced(AdvancedSettingsPatch(
                  apiServerEnabled: value,
                ));
              },
            ),
            if (advanced.apiServerEnabled) ...[
              _CompactTextFieldItem(
                title: t.settings.advanced.port,
                controller: _portController,
                placeholder: '0',
                onSubmitted: _updatePort,
                onEditingComplete: () => _updatePort(_portController.text),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _ApiServerLinkText extends StatelessWidget {
  const _ApiServerLinkText({required this.baseUrl});

  final String baseUrl;

  @override
  Widget build(BuildContext context) {
    final text = t.settings.advanced.running_at;
    final parts = text.split('{url}');
    final style = DefaultTextStyle.of(context).style;
    final linkStyle = style.copyWith(
      color: Theme.of(context).colorScheme.primary,
      decoration: TextDecoration.underline,
    );

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: parts.first),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: InkWell(
              onTap: () => _openUrl(baseUrl),
              child: Text(baseUrl, style: linkStyle),
            ),
          ),
          if (parts.length > 1) TextSpan(text: parts.last),
        ],
      ),
    );
  }
}

Future<void> _openUrl(String url) async {
  if (Platform.isMacOS) {
    await Process.start('open', [url]);
  } else if (Platform.isWindows) {
    await Process.start('rundll32', ['url.dll,FileProtocolHandler', url]);
  } else {
    await Process.start('xdg-open', [url]);
  }
}

class _CompactTextFieldItem extends StatelessWidget {
  const _CompactTextFieldItem({
    required this.title,
    required this.controller,
    this.placeholder,
    this.onSubmitted,
    this.onEditingComplete,
  });

  final String title;
  final TextEditingController controller;
  final String? placeholder;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return PreferenceListItem(
      title: Text(title),
      detailText: SizedBox(
        width: 80,
        child: TextField(
          controller: controller,
          textAlign: TextAlign.end,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 6,
            ),
            border: const OutlineInputBorder(),
            hintText: placeholder,
          ),
          style: textTheme.bodyMedium,
          onSubmitted: onSubmitted,
          onEditingComplete: onEditingComplete,
        ),
      ),
      accessoryView: const SizedBox.shrink(),
    );
  }
}
