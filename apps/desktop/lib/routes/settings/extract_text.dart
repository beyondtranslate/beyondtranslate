import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:biyi_app/i18n/i18n.dart';
import 'package:biyi_app/models/models.dart';
import 'package:biyi_app/services/services.dart';
import 'package:biyi_app/widgets/widgets.dart';

import '../ocr_engine_chooser.dart';

part 'extract_text.g.dart';

@TypedGoRoute<SettingExtractTextRoute>(path: '/settings/extract-text')
class SettingExtractTextRoute extends GoRouteData
    with $SettingExtractTextRoute {
  const SettingExtractTextRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingExtractTextPage();
  }
}

class SettingExtractTextPage extends StatefulWidget {
  const SettingExtractTextPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingExtractTextPageState();
}

class _SettingExtractTextPageState extends State<SettingExtractTextPage> {
  Configuration get _configuration => localDb.configuration;

  OcrEngineConfig? get _defaultOcrEngineConfig =>
      localDb.ocrEngine(_configuration.defaultOcrEngineId).get();

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
          title: Text(t('pref_section_title_default_detect_text_engine')),
          children: [
            PreferenceListItem(
              icon: _defaultOcrEngineConfig == null
                  ? null
                  : OcrEngineIcon(_defaultOcrEngineConfig!.type),
              title: Builder(
                builder: (_) {
                  if (_defaultOcrEngineConfig == null) {
                    return Text('please_choose'.tr());
                  }
                  return OcrEngineName(_defaultOcrEngineConfig!);
                },
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => OcrEngineChooserPage(
                      initialOcrEngineConfig: _defaultOcrEngineConfig,
                      onChoosed: (ocrEngineConfig) {
                        _configuration.defaultOcrEngineId =
                            ocrEngineConfig.identifier;
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        PreferenceListSection(
          children: [
            PreferenceListSwitchItem(
              value: _configuration.autoCopyDetectedText,
              title: Text(t('pref_item_auto_copy_detected_text')),
              onChanged: (newValue) async {
                _configuration.autoCopyDetectedText = newValue;
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
    return 'page_setting_extract_text.$key'.tr(args: args);
  }
}
