import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reorderables/reorderables.dart';

import '../i18n/i18n.dart';
import '../models/translation_engine_config.dart';
import '../services/local_db/local_db.dart';
import '../widgets/custom_app_bar/custom_app_bar.dart';
import '../widgets/preference_list/preference_list.dart';
import '../widgets/preference_list/preference_list_item.dart';
import '../widgets/preference_list/preference_list_section.dart';
import '../widgets/translation_engine_icon/translation_engine_icon.dart';
import '../widgets/translation_engine_name/translation_engine_name.dart';
import 'translation_engine_create_or_edit.dart';
import 'translation_engine_type_chooser.dart';

part 'translation_engines_manage.g.dart';

@TypedGoRoute<TranslationEnginesManageRoute>(
  path: '/settings/translation-engines',
)
class TranslationEnginesManageRoute extends GoRouteData
    with $TranslationEnginesManageRoute {
  const TranslationEnginesManageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TranslationEnginesManagePage();
  }
}

class TranslationEnginesManagePage extends StatefulWidget {
  const TranslationEnginesManagePage({super.key});

  @override
  State<StatefulWidget> createState() => _TranslationEnginesManagePageState();
}

class _TranslationEnginesManagePageState
    extends State<TranslationEnginesManagePage> {
  List<TranslationEngineConfig> get _proEngineList => localDb.proEngines.list();
  List<TranslationEngineConfig> get _privateEngineList =>
      localDb.privateEngines.list();

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
              localDb
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
        localDb.privateEngine(identifier).update(position: i + 1);
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
                child: Builder(
                  builder: (_) {
                    final item = _privateEngineList[i];
                    return PreferenceListSwitchItem(
                      icon: TranslationEngineIcon(item.type),
                      title: TranslationEngineName(item),
                      value: !item.disabled,
                      onChanged: (newValue) {
                        localDb
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
                  },
                ),
              ),
          ],
        ),
        PreferenceListItem(
          title: Text(
            'add'.tr(),
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
          accessoryView: Container(),
          onTap: _handleClickAdd,
        ),
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
