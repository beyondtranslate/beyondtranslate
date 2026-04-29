import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reorderables/reorderables.dart';

import '../i18n/i18n.dart';
import '../models/ocr_engine_config.dart';
import '../services/local_db/local_db.dart';
import '../widgets/custom_app_bar/custom_app_bar.dart';
import '../widgets/ocr_engine_icon/ocr_engine_icon.dart';
import '../widgets/ocr_engine_name/ocr_engine_name.dart';
import '../widgets/preference_list/preference_list.dart';
import '../widgets/preference_list/preference_list_item.dart';
import '../widgets/preference_list/preference_list_section.dart';
import 'ocr_engine_create_or_edit.dart';
import 'ocr_engine_type_chooser.dart';

part 'ocr_engines_manage.g.dart';

@TypedGoRoute<OcrEnginesManageRoute>(path: '/settings/ocr-engines')
class OcrEnginesManageRoute extends GoRouteData with $OcrEnginesManageRoute {
  const OcrEnginesManageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const OcrEnginesManagePage();
  }
}

class OcrEnginesManagePage extends StatefulWidget {
  const OcrEnginesManagePage({super.key});

  @override
  State<OcrEnginesManagePage> createState() => _OcrEnginesManagePageState();
}

class _OcrEnginesManagePageState extends State<OcrEnginesManagePage> {
  List<OcrEngineConfig> get _proOcrEngineList => localDb.proOcrEngines.list();
  List<OcrEngineConfig> get _privateOcrEngineList =>
      localDb.privateOcrEngines.list();

  @override
  void initState() {
    localDb.privateOcrEngines.addListener(_handleChanged);
    super.initState();
  }

  @override
  void dispose() {
    localDb.privateOcrEngines.removeListener(_handleChanged);
    super.dispose();
  }

  void _handleChanged() {
    if (mounted) setState(() {});
  }

  void _handleClickAdd() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OcrEngineTypeChooserPage(
          engineType: null,
          onChoosed: (String ocrEngineType) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => OcrEngineCreateOrEditPage(
                  ocrEngineType: ocrEngineType,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListSectionProEngines(BuildContext context) {
    if (_proOcrEngineList.isEmpty) return Container();
    return PreferenceListSection(
      children: [
        for (OcrEngineConfig item in _proOcrEngineList)
          PreferenceListSwitchItem(
            icon: OcrEngineIcon(item.type),
            title: OcrEngineName(item),
            value: !item.disabled,
            onChanged: (newValue) {
              localDb
                  .proOcrEngine(item.identifier)
                  .update(disabled: !item.disabled);
            },
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => OcrEngineCreateOrEditPage(
                    ocrEngineConfig: item,
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
          _privateOcrEngineList.map((e) => e.identifier).toList();
      String oldId = idList.removeAt(oldIndex);
      idList.insert(newIndex, oldId);

      for (var i = 0; i < idList.length; i++) {
        final identifier = idList[i];
        localDb.privateOcrEngine(identifier).update(position: i + 1);
      }
    }

    return PreferenceListSection(
      title: Text(t.page_ocr_engines_manage.pref_section_title_private),
      description:
          Text(t.page_ocr_engines_manage.pref_section_description_private),
      children: [
        ReorderableColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          onReorder: onReorder,
          children: [
            for (var i = 0; i < _privateOcrEngineList.length; i++)
              ReorderableWidget(
                reorderable: true,
                key: ValueKey(i),
                child: Builder(
                  builder: (_) {
                    final item = _privateOcrEngineList[i];
                    return PreferenceListSwitchItem(
                      icon: OcrEngineIcon(item.type),
                      title: OcrEngineName(item),
                      value: !item.disabled,
                      onChanged: (newValue) {
                        localDb
                            .privateOcrEngine(item.identifier)
                            .update(disabled: !item.disabled);
                      },
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => OcrEngineCreateOrEditPage(
                              ocrEngineConfig: item,
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
            t.add,
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
        title: Text(t.page_ocr_engines_manage.title),
      ),
      body: _buildBody(context),
    );
  }
}
