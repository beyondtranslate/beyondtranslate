import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

import '../../i18n/i18n.dart';
import '../custom_alert_dialog/custom_alert_dialog.dart';

class RecordHotKeyDialog extends StatefulWidget {
  const RecordHotKeyDialog({
    Key? key,
    required this.onHotKeyRecorded,
  }) : super(key: key);

  final ValueChanged<HotKey> onHotKeyRecorded;

  @override
  State<RecordHotKeyDialog> createState() => _RecordHotKeyDialogState();
}

class _RecordHotKeyDialogState extends State<RecordHotKeyDialog> {
  HotKey? _hotKey;

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      title: Text('widget_record_shortcut_dialog.title'.tr()),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Container(
              width: 100,
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  HotKeyRecorder(
                    onHotKeyRecorded: (hotKey) {
                      _hotKey = hotKey;
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        CustomDialogAction(
          child: Text('cancel'.tr()),
          onPressed: () {
            context.pop();
          },
        ),
        CustomDialogAction(
          onPressed: _hotKey == null
              ? null
              : () {
                  widget.onHotKeyRecorded(_hotKey!);
                  context.pop();
                },
          child: Text('ok'.tr()),
        ),
      ],
    );
  }
}
