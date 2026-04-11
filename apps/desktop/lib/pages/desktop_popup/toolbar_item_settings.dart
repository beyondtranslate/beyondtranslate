// import 'package:page_transition/page_transition.dart';
// import 'package:window_manager/window_manager.dart';

import 'package:biyi_app/includes.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class ToolbarItemSettings extends StatefulWidget {
  const ToolbarItemSettings({
    Key? key,
    required this.onSubPageDismissed,
  }) : super(key: key);

  final VoidCallback onSubPageDismissed;

  @override
  State<ToolbarItemSettings> createState() => _ToolbarItemSettingsState();
}

class _ToolbarItemSettingsState extends State<ToolbarItemSettings> {
  // Offset? _lastShownPosition;
  // Size? _lastShownSize;

  void _handleDismiss() async {
    // if (kIsLinux || kIsMacOS || kIsWindows) {
    //   await windowManager.hide();
    //   await windowManager.setTitleBarStyle(
    //     TitleBarStyle.hidden,
    //     windowButtonVisibility: false,
    //   );
    //   if (_lastShownPosition != null) {
    //     await windowManager.setPosition(_lastShownPosition!);
    //   }
    //   if (_lastShownSize != null) {
    //     await windowManager.setSize(_lastShownSize!);
    //   }
    // }
    // Navigator.of(context).pop();

    await Future.delayed(const Duration(milliseconds: 200));
    widget.onSubPageDismissed();

    // await windowManager.show();
  }

  // void _handleOpenSettings() async {
  //   if (kIsLinux || kIsMacOS || kIsWindows) {
  //     _lastShownPosition = await windowManager.getPosition();
  //     _lastShownSize = await windowManager.getSize();

  //     await windowManager.hide();
  //     await windowManager.setTitleBarStyle(
  //       TitleBarStyle.normal,
  //       windowButtonVisibility: true,
  //     );
  //     await windowManager.setSize(const Size(700, 680.0));
  //     await windowManager.center();
  //   }

  //   Navigator.of(context).push(
  //     PageTransition(
  //       type: PageTransitionType.fade,
  //       child: DesktopSettingsPage(
  //         onDismiss: _handleDismiss,
  //       ),
  //     ),
  //   );

  //   await Future.delayed(const Duration(milliseconds: 200));
  //   await windowManager.show();
  // }

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
        onPressed: () {
          showModalBottomSheetPage(
            context: context,
            builder: (ctx) {
              return SettingsPage(
                onDismiss: () {
                  Navigator.of(ctx).pop();
                  _handleDismiss();
                },
              );
            },
          ).whenComplete(() => _handleDismiss());
        },
      ),
    );
  }
}
