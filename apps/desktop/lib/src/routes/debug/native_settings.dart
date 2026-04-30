import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../features/settings/desktop_settings_service.dart';
import '../../features/settings/native_settings.dart';
import '../../i18n/i18n.dart';
import '../../rust/domain/settings.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/preference_list/preference_list.dart';
import '../../widgets/preference_list/preference_list_item.dart';
import '../../widgets/preference_list/preference_list_section.dart';
import '../../widgets/ui/button.dart';

List<RouteBase> get $appRoutes => <RouteBase>[
  GoRoute(
    path: '/debug/native-settings',
    builder: (BuildContext context, GoRouterState state) {
      return const NativeSettingsDebugRoutePage();
    },
  ),
];

class NativeSettingsDebugRoutePage extends StatelessWidget {
  const NativeSettingsDebugRoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: Text('Native Settings Debug'),
      ),
      body: NativeSettingsDebugPage(),
    );
  }
}

class NativeSettingsDebugPage extends StatefulWidget {
  const NativeSettingsDebugPage({super.key});

  @override
  State<NativeSettingsDebugPage> createState() =>
      _NativeSettingsDebugPageState();
}

class _NativeSettingsDebugPageState extends State<NativeSettingsDebugPage> {
  RustSettingsDto? _settings;
  String? _rawJson;
  String? _settingsFilePath;
  String? _errorText;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    setState(() {
      _loading = true;
      _errorText = null;
    });

    try {
      final settingsFilePath = await desktopSettingsService.settingsFilePath;
      final settings = await desktopSettingsService.getSettings();
      final rawJson = await desktopSettingsService.getSettingsJson();

      if (!mounted) {
        return;
      }

      setState(() {
        _settingsFilePath = settingsFilePath;
        _settings = settings;
        _rawJson = rawJson;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _loading = false;
        _errorText = error.toString();
      });
    }
  }

  Future<void> _updateTheme(String theme) async {
    await _runMutation(() => desktopSettingsService.setTheme(theme));
  }

  Future<void> _updateLanguage(String language) async {
    await _runMutation(() => desktopSettingsService.setLanguage(language));
  }

  Future<void> _copySettingsFilePath() async {
    final settingsFilePath = _settingsFilePath;
    if (settingsFilePath == null || settingsFilePath.isEmpty) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: settingsFilePath));
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t.copied)),
    );
  }

  Future<void> _runMutation(Future<RustSettingsDto> Function() action) async {
    setState(() {
      _loading = true;
      _errorText = null;
    });

    try {
      final settings = await action();
      if (!mounted) {
        return;
      }

      setState(() {
        _settings = settings;
        _rawJson = settings.rawJson;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _loading = false;
        _errorText = error.toString();
      });
    }
  }

  Widget _buildPathCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (_loading) {
      return const SizedBox.shrink();
    }

    if (_errorText != null) {
      return const SizedBox.shrink();
    }

    final settingsFilePath = _settingsFilePath;
    if (settingsFilePath == null || settingsFilePath.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'settings.json path',
                  style: textTheme.titleSmall,
                ),
              ),
              Button.outlined(
                minSize: 36,
                onPressed: _copySettingsFilePath,
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.content_copy_rounded, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SelectableText(
            settingsFilePath,
            style: textTheme.bodyMedium?.copyWith(
              fontFamily: 'Roboto Mono',
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (_loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorText != null) {
      return SelectableText(
        _errorText!,
        style: textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.error,
        ),
      );
    }

    final settings = _settings;
    if (settings == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Theme: ${settings.windowTheme}', style: textTheme.bodyMedium),
        const SizedBox(height: 8),
        Text(
          'Language: ${settings.windowLanguage}',
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildSelectorRow<T>({
    required String title,
    required List<T> options,
    required T? selected,
    required String Function(T value) labelBuilder,
    required ValueChanged<T> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in options)
              ChoiceChip(
                selected: option == selected,
                label: Text(labelBuilder(option)),
                onSelected: _loading ? null : (_) => onSelected(option),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildJsonCard(BuildContext context) {
    if (_loading) {
      return const SizedBox.shrink();
    }

    if (_errorText != null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.32),
        ),
      ),
      child: SelectableText(
        _rawJson ?? '{}',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: 'Roboto Mono',
              height: 1.5,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PreferenceList(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      children: [
        PreferenceListSection(
          title: const Text('Native Settings Debug'),
          children: [
            const PreferenceListItem(
              title: Text('Open native settings window'),
              summary: Text(
                'Open the current macOS native settings window without changing it.',
              ),
              onTap: NativeSettings.show,
            ),
            PreferenceListItem(
              title: const Text('Reload current settings'),
              summary: const Text(
                'Read the latest settings.json through the Rust bridge.',
              ),
              onTap: _reload,
            ),
          ],
        ),
        PreferenceListSection(
          title: const Text('Edit Rust settings'),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSelectorRow<String>(
                    title: 'window.theme',
                    options: const ['light', 'dark', 'system'],
                    selected: _settings?.windowTheme,
                    labelBuilder: (value) => value,
                    onSelected: _updateTheme,
                  ),
                  const SizedBox(height: 20),
                  _buildSelectorRow<String>(
                    title: 'window.language',
                    options: const ['en', 'zh'],
                    selected: _settings?.windowLanguage,
                    labelBuilder: (value) => value,
                    onSelected: _updateLanguage,
                  ),
                ],
              ),
            ),
          ],
        ),
        PreferenceListSection(
          title: const Text('Storage'),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: _buildPathCard(context),
            ),
          ],
        ),
        PreferenceListSection(
          title: const Text('Current values'),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: _buildSummaryCard(context),
            ),
          ],
        ),
        PreferenceListSection(
          title: const Text('Raw settings.json'),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: _buildJsonCard(context),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            children: [
              Button.outlined(
                onPressed: _loading ? null : _reload,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Text('Refresh'),
                ),
              ),
              const SizedBox(width: 12),
              const Button.filled(
                onPressed: NativeSettings.show,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Text('Open Native Window'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
