import 'package:flutter/material.dart' show Scaffold;
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../services/native_settings.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/preference_list/preference_list.dart';
import '../../widgets/preference_list/preference_list_item.dart';
import '../../widgets/preference_list/preference_list_section.dart';

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
  @override
  Widget build(BuildContext context) {
    return const PreferenceList(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      children: [
        PreferenceListSection(
          title: Text('Native Settings Debug'),
          children: [
            PreferenceListItem(
              title: Text('Open native settings window'),
              summary: Text(
                'Open the current macOS native settings window without changing it.',
              ),
              onTap: NativeSettings.show,
            ),
          ],
        ),
      ],
    );
  }
}
