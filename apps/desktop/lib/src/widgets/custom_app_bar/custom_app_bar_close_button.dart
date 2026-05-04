import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui/button.dart';

class CustomAppBarCloseButton extends StatelessWidget {
  const CustomAppBarCloseButton({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Button(
      minSize: 0,
      padding: const EdgeInsets.only(right: 12),
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
          return;
        }
        if (context.canPop()) {
          context.pop();
        }
      },
      child: Icon(
        FluentIcons.dismiss_20_regular,
        color: Theme.of(context).appBarTheme.iconTheme!.color,
        size: 22,
      ),
    );
  }
}
