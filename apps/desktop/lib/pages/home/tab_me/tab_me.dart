import '../../pages.dart';
import '../../../routes/routes.dart';
import '../../../widgets/widgets.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class TabMeScene extends StatelessWidget {
  const TabMeScene({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Me'),
        actions: [
          CustomAppBarActionItem(
            icon: FluentIcons.settings_20_regular,
            onPressed: () {
              const SettingsRoute().push(context);
            },
          ),
        ],
      ),
      body: Container(),
    );
  }
}
