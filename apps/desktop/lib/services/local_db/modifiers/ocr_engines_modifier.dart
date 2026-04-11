import 'package:biyi_advanced_features/biyi_advanced_features.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shortid/shortid.dart';

class OcrEnginesModifier extends Listenable {
  Box? _boxInstance;

  Box get _box {
    if (_boxInstance == null || _boxInstance?.isOpen != true) {
      _boxInstance = Hive.box('ocr_engines');
    }
    return _boxInstance!;
  }

  String? _id;
  String? _group;

  void setId(String? id) {
    _id = id;
  }

  void setGroup(String? group) {
    _group = group;
  }

  @override
  void addListener(VoidCallback listener) {
    _box.listenable().addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _box.listenable().removeListener(listener);
  }

  List<OcrEngineConfig> list({
    bool Function(OcrEngineConfig element)? where,
  }) {
    if (where != null) {
      return _box.values
          .map((e) => OcrEngineConfig.fromJson(e))
          .where((e) => _group == null || e.group == _group)
          .where(where)
          .toList()
        ..sort((a, b) => a.position.compareTo(b.position));
    }
    return _box.values
        .map((e) => OcrEngineConfig.fromJson(e))
        .where((e) => _group == null || e.group == _group)
        .toList()
      ..sort((a, b) => a.position.compareTo(b.position));
  }

  OcrEngineConfig? get() {
    dynamic value = _box.get(_id);
    if (value != null) {
      return OcrEngineConfig.fromJson(value);
    }
    return null;
  }

  Future<void> create({
    required String type,
    required Map<String, dynamic> option,
  }) async {
    List<OcrEngineConfig> configs = list();
    int position = 1;
    if (configs.isNotEmpty) {
      position = configs.last.position + 1;
    }
    final value = OcrEngineConfig(
      position: position,
      group: _group,
      identifier: _id ?? shortid.generate(),
      type: type,
      option: option,
    );
    _box.put(value.identifier, value.toJson());
  }

  Future<void> update({
    int? position,
    String? type,
    Map<String, dynamic>? option,
    bool? disabled,
  }) async {
    final value = OcrEngineConfig.fromJson(_box.get(_id));
    value.position = position ?? value.position;
    value.type = type ?? value.type;
    value.option = option ?? value.option;
    value.disabled = disabled ?? value.disabled;
    _box.put(value.identifier, value.toJson());
  }

  Future<void> delete() async {
    _box.delete(_id);
  }

  Future<void> deleteAll() async {
    List<String> keys = list().map((e) => e.identifier).toList();
    _box.deleteAll(keys);
  }

  bool exists() {
    OcrEngineConfig? config = get();
    return config != null && (_group == null || config.group == _group);
  }

  Future<void> updateOrCreate({
    String? type,
    Map<String, dynamic>? option,
    bool? disabled,
  }) async {
    if (_id != null && exists()) {
      update(
        type: type,
        option: option,
        disabled: disabled,
      );
    } else {
      create(
        type: type!,
        option: option!,
      );
    }
  }
}
