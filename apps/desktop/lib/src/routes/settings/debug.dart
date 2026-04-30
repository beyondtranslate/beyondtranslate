import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../i18n/i18n.dart';
import '../../widgets/preference_list/preference_list.dart';
import '../../widgets/preference_list/preference_list_item.dart';
import '../../widgets/preference_list/preference_list_section.dart';

class SettingsDebugPage extends StatelessWidget {
  const SettingsDebugPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferenceList(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      children: [
        PreferenceListSection(
          title: const Text('Debug'),
          description: const Text(
            'Open internal debug pages for runtime and native settings verification.',
          ),
          children: [
            PreferenceListItem(
              title: Text(t.page_runtime_debug.title),
              summary: Text(t.page_runtime_debug.description),
              onTap: () => context.push('/debug/runtime'),
            ),
            PreferenceListItem(
              title: const Text('Native Settings Debug'),
              summary: const Text(
                'Validate the macOS Swift -> Dart -> Rust settings bridge.',
              ),
              onTap: () => context.push('/debug/native-settings'),
            ),
          ],
        ),
      ],
    );
  }
}
