import 'package:biyi_app/includes.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class ToolbarItemAlwaysOnTop extends StatefulWidget {
  const ToolbarItemAlwaysOnTop({Key? key}) : super(key: key);

  @override
  State<ToolbarItemAlwaysOnTop> createState() => _ToolbarItemAlwaysOnTopState();
}

class _ToolbarItemAlwaysOnTopState extends State<ToolbarItemAlwaysOnTop> {
  bool _isAlwaysOnTop = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    _isAlwaysOnTop = await windowManager.isAlwaysOnTop();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: CustomButton(
        padding: EdgeInsets.zero,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
          transformAlignment: Alignment.center,
          transform: Matrix4.rotationZ(
            _isAlwaysOnTop ? 0 : -0.8,
          ),
          child: Icon(
            _isAlwaysOnTop
                ? FluentIcons.pin_20_filled
                : FluentIcons.pin_20_regular,
            size: 20,
            color: _isAlwaysOnTop
                ? Theme.of(context).primaryColor
                : Theme.of(context).iconTheme.color,
          ),
        ),
        onPressed: () {
          setState(() {
            _isAlwaysOnTop = !_isAlwaysOnTop;
          });
          windowManager.setAlwaysOnTop(_isAlwaysOnTop);
        },
      ),
    );
  }
}
