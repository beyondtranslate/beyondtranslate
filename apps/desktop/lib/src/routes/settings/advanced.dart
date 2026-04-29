import 'package:flutter/material.dart';
import 'package:launch_at_startup/launch_at_startup.dart';

import '../../i18n/i18n.dart';
import '../../widgets/preference_list/preference_list.dart';
import '../../widgets/preference_list/preference_list_item.dart';
import '../../widgets/preference_list/preference_list_section.dart';
import 'index.dart';

class AdvancedSettingsPage extends StatefulWidget {
  const AdvancedSettingsPage({super.key});

  @override
  State<AdvancedSettingsPage> createState() => _AdvancedSettingsPageState();
}

class _AdvancedSettingsPageState extends State<AdvancedSettingsPage> {
  bool? _launchAtStartupEnabled;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadLaunchAtStartupState();
  }

  Future<void> _loadLaunchAtStartupState() async {
    try {
      final enabled = await LaunchAtStartup.instance.isEnabled();
      if (!mounted) {
        return;
      }
      setState(() {
        _launchAtStartupEnabled = enabled;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _launchAtStartupEnabled = false;
        _loading = false;
      });
    }
  }

  Future<void> _handleLaunchAtStartupChanged(bool value) async {
    setState(() {
      _loading = true;
    });

    try {
      if (value) {
        await LaunchAtStartup.instance.enable();
      } else {
        await LaunchAtStartup.instance.disable();
      }
      final enabled = await LaunchAtStartup.instance.isEnabled();
      if (!mounted) {
        return;
      }
      setState(() {
        _launchAtStartupEnabled = enabled;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PreferenceList(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      children: [
        PreferenceListSection(
          title: Text(t.page_settings.pref_section_title_advanced),
          children: [
            PreferenceListSwitchItem(
              title: Text(t.page_settings.pref_item_title_launch_at_startup),
              value: _launchAtStartupEnabled ?? false,
              onChanged: _loading ? (_) {} : _handleLaunchAtStartupChanged,
            ),
            PreferenceListItem(
              title: Text(t.page_settings.pref_item_title_runtime_debug),
              summary: Text(t.page_runtime_debug.description),
              onTap: () => const RuntimeDebugRoute().push(context),
            ),
          ],
        ),
      ],
    );
  }
}
