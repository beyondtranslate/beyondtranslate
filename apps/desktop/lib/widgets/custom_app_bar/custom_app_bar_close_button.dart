import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBarCloseButton extends StatelessWidget {
  const CustomAppBarCloseButton({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.only(right: 12),
      child: Icon(
        FluentIcons.dismiss_20_regular,
        color: Theme.of(context).appBarTheme.iconTheme!.color,
        size: 22,
      ),
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
          return;
        }
        Navigator.maybePop(context);
      },
    );
  }
}
