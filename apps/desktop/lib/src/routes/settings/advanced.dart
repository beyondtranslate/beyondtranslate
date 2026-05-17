import 'package:flutter/material.dart';

import '../../i18n/i18n.dart';
import '../../widgets/settings_page.dart';
import '../../widgets/ui/preference_list_section.dart';

/// Mirrors macOS `AdvancedView.swift`.
class AdvancedSettingsPage extends StatelessWidget {
  const AdvancedSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsPage(
      title: t.settings.advanced.title,
      children: [
        PreferenceListSection(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Text(
                t.settings.advanced.empty,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
