import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:biyi_app/i18n/i18n.dart';
import 'package:biyi_app/services/services.dart';
import 'package:biyi_app/widgets/widgets.dart';

part 'interface.g.dart';

@TypedGoRoute<SettingInterfaceRoute>(path: '/settings/interface')
class SettingInterfaceRoute extends GoRouteData with $SettingInterfaceRoute {
  const SettingInterfaceRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingInterfacePage();
  }
}

const List<double> _kMaxWindowHeightOptions = [700, 800, 900, 1000];

class SettingInterfacePage extends StatefulWidget {
  const SettingInterfacePage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingInterfacePageState();
}

class _SettingInterfacePageState extends State<SettingInterfacePage> {
  Configuration get _configuration => localDb.configuration;

  @override
  void initState() {
    localDb.preferences.addListener(_handleChanged);
    super.initState();
  }

  @override
  void dispose() {
    localDb.preferences.removeListener(_handleChanged);
    super.dispose();
  }

  void _handleChanged() {
    if (mounted) setState(() {});
  }

  Widget _buildBody(BuildContext context) {
    return PreferenceList(
      children: [
        PreferenceListSection(
          title: Text(t('pref_section_title_tray_icon')),
          children: [
            PreferenceListSwitchItem(
              title: Text(t('pref_item_title_show_tray_icon')),
              value: _configuration.showTrayIcon,
              onChanged: (newValue) {
                _configuration.showTrayIcon = newValue;
              },
            ),
          ],
        ),
        PreferenceListSection(
          title: Text(t('pref_section_title_max_window_height')),
          children: [
            for (var option in _kMaxWindowHeightOptions)
              PreferenceListRadioItem<double>(
                title: Text('${option.toInt()}'),
                value: option,
                groupValue: _configuration.maxWindowHeight,
                onChanged: (newValue) {
                  _configuration.maxWindowHeight = newValue;
                },
              ),
          ],
        ),
      ],
    );
  }

  Widget _build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(t('title')),
      ),
      body: _buildBody(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  String t(String key, {List<String> args = const []}) {
    return 'page_setting_interface.$key'.tr(args: args);
  }
}
