import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_button/custom_button.dart';
import '../../windowing/window_controllers.dart';

class ToolbarItemSettings extends StatelessWidget {
  const ToolbarItemSettings({
    Key? key,
    required this.onSubPageDismissed,
  }) : super(key: key);

  final VoidCallback onSubPageDismissed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: CustomButton(
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.zero,
        child: Icon(
          FluentIcons.settings_20_regular,
          size: 20,
          color: Theme.of(context).iconTheme.color,
        ),
        onPressed: () async {
          final mainWindow = mainWindowController.window;
          mainWindow.show();
          mainWindow.focus();
          await Future.delayed(const Duration(milliseconds: 200));
          onSubPageDismissed();
        },
      ),
    );
  }
}
