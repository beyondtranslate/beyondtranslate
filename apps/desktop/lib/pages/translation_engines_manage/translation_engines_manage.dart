import 'package:biyi_advanced_features/biyi_advanced_features.dart';
import 'package:biyi_app/generated/locale_keys.g.dart';
import 'package:biyi_app/includes.dart';
import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';

class TranslationEnginesManagePage extends StatefulWidget {
  const TranslationEnginesManagePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TranslationEnginesManagePageState();
}

class _TranslationEnginesManagePageState
    extends State<TranslationEnginesManagePage> {
  List<TranslationEngineConfig> get _proEngineList =>
      (localDb.proEngines.list());
  List<TranslationEngineConfig> get _privateEngineList =>
      (localDb.privateEngines.list());

  @override
  void initState() {
    localDb.privateEngines.addListener(_handleChanged);
    super.initState();
  }

  @override
  void dispose() {
    localDb.privateEngines.removeListener(_handleChanged);
    super.dispose();
  }

  void _handleChanged() {
    if (mounted) setState(() {});
  }

  void _handleClickAdd() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TranslationEngineTypeChooserPage(
          engineType: null,
          onChoosed: (String engineType) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => TranslationEngineCreateOrEditPage(
                  engineType: engineType,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListSectionProEngines(BuildContext context) {
    if (_proEngineList.isEmpty) return Container();
    return PreferenceListSection(
      children: [
        for (TranslationEngineConfig item in _proEngineList)
          PreferenceListSwitchItem(
            icon: TranslationEngineIcon(item.type),
            title: TranslationEngineName(item),
            value: !item.disabled,
            onChanged: (newValue) {
              localDb //
                  .proEngine(item.identifier)
                  .update(disabled: !item.disabled);
            },
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => TranslationEngineCreateOrEditPage(
                    engineConfig: item,
                    editable: false,
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildListSectionPrivateEngines(BuildContext context) {
    void onReorder(int oldIndex, int newIndex) {
      List<String> idList =
          _privateEngineList.map((e) => e.identifier).toList();
      String oldId = idList.removeAt(oldIndex);
      idList.insert(newIndex, oldId);

      for (var i = 0; i < idList.length; i++) {
        final identifier = idList[i];
        localDb //
            .privateEngine(identifier)
            .update(position: i + 1);
      }
    }

    return PreferenceListSection(
      title: Text(t('pref_section_title_private')),
      description: Text(t('pref_section_description_private')),
      children: [
        ReorderableColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          onReorder: onReorder,
          children: [
            for (var i = 0; i < _privateEngineList.length; i++)
              ReorderableWidget(
                reorderable: true,
                key: ValueKey(i),
                child: Builder(builder: (_) {
                  final item = _privateEngineList[i];
                  return PreferenceListSwitchItem(
                    icon: TranslationEngineIcon(item.type),
                    title: TranslationEngineName(item),
                    value: !item.disabled,
                    onChanged: (newValue) {
                      localDb //
                          .privateEngine(item.identifier)
                          .update(disabled: !item.disabled);
                    },
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TranslationEngineCreateOrEditPage(
                            engineConfig: item,
                          ),
                        ),
                      );
                    },
                  );
                }),
              )
          ],
        ),
        PreferenceListItem(
          title: Text(
            LocaleKeys.add.tr(),
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
          accessoryView: Container(),
          onTap: _handleClickAdd,
        )
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return PreferenceList(
      children: [
        _buildListSectionProEngines(context),
        _buildListSectionPrivateEngines(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(t('title')),
      ),
      body: _buildBody(context),
    );
  }

  String t(String key, {List<String> args = const []}) {
    return 'page_translation_engines_manage.$key'.tr(args: args);
  }
}
