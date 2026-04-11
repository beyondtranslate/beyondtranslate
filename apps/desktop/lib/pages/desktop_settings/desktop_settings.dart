import 'package:biyi_app/includes.dart';
import 'package:flutter/material.dart';

class DesktopSettingsPage extends StatefulWidget {
  const DesktopSettingsPage({Key? key, this.onDismiss}) : super(key: key);

  final VoidCallback? onDismiss;

  @override
  State<StatefulWidget> createState() => _DesktopSettingsPageState();
}

class _DesktopSettingsPageState extends State<DesktopSettingsPage> {
  // Configuration get _configuration => localDb.configuration;

  Widget _buildBody(BuildContext context) {
    return const PreferenceList(
      children: [],
    );
  }

  Widget _build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(t('title')),
        leading: widget.onDismiss != null
            ? CustomAppBarCloseButton(
                onPressed: widget.onDismiss,
              )
            : null,
      ),
      body: _buildBody(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  String t(String key, {List<String> args = const []}) {
    return 'page_desktop_settings.$key'.tr(args: args);
  }
}
