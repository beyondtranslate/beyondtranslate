import 'package:biyi_advanced_features/biyi_advanced_features.dart';
import 'package:biyi_app/includes.dart';
import 'package:flutter/material.dart';

class SettingExtractTextPage extends StatefulWidget {
  const SettingExtractTextPage({Key? key}) : super(key: key);

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
              title: Builder(builder: (_) {
                if (_defaultOcrEngineConfig == null) {
                  return Text('please_choose'.tr());
                }
                return OcrEngineName(_defaultOcrEngineConfig!);
              }),
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
