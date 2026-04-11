import 'package:biyi_advanced_features/biyi_advanced_features.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shortid/shortid.dart';

class EnginesModifier extends Listenable {
  Box? _boxInstance;

  Box get _box {
    if (_boxInstance == null || _boxInstance?.isOpen != true) {
      _boxInstance = Hive.box('engines');
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

  List<TranslationEngineConfig> list({
    bool Function(TranslationEngineConfig element)? where,
  }) {
    if (where != null) {
      return _box.values
          .map((e) => TranslationEngineConfig.fromJson(e))
          .where((e) => _group == null || e.group == _group)
          .where(where)
          .toList()
        ..sort((a, b) => a.position.compareTo(b.position));
    }
    return _box.values
        .map((e) => TranslationEngineConfig.fromJson(e))
        .where((e) => _group == null || e.group == _group)
        .toList()
      ..sort((a, b) => a.position.compareTo(b.position));
  }

  TranslationEngineConfig? get() {
    if (_id != null && _box.containsKey(_id)) {
      dynamic value = _box.get(_id);
      return TranslationEngineConfig.fromJson(value);
    }
    return null;
  }

  Future<void> create({
    required String type,
    required Map<String, dynamic> option,
    List<String>? supportedScopes,
    bool? disabled,
  }) async {
    List<TranslationEngineConfig> configs = list();
    int position = 1;
    if (configs.isNotEmpty) {
      position = configs.last.position + 1;
    }
    final value = TranslationEngineConfig(
      position: position,
      group: _group,
      identifier: _id ?? shortid.generate(),
      type: type,
      option: option,
      supportedScopes: supportedScopes ?? [],
      disabled: disabled ?? false,
    );
    _box.put(value.identifier, value.toJson());
  }

  Future<void> update({
    int? position,
    String? type,
    Map<String, dynamic>? option,
    List<String>? supportedScopes,
    bool? disabled,
  }) async {
    final value = TranslationEngineConfig.fromJson(_box.get(_id));
    value.position = position ?? value.position;
    value.type = type ?? value.type;
    value.option = option ?? value.option;
    value.supportedScopes = supportedScopes ?? value.supportedScopes;
    value.disabled = disabled ?? value.disabled;
    _box.put(value.identifier, value.toJson());
  }

  Future<void> delete() async {
    await _box.delete(_id);
  }

  Future<void> deleteAll() async {
    List<String> keys = list().map((e) => e.identifier).toList();
    await _box.deleteAll(keys);
  }

  bool exists() {
    TranslationEngineConfig? config = get();
    return config != null && (_group == null || config.group == _group);
  }

  Future<void> updateOrCreate({
    String? type,
    Map<String, dynamic>? option,
    List<String>? supportedScopes,
    bool? disabled,
  }) async {
    if (_id != null && exists()) {
      update(
        type: type,
        option: option,
        supportedScopes: supportedScopes,
        disabled: disabled,
      );
    } else {
      create(
        type: type!,
        option: option!,
        supportedScopes: supportedScopes,
        disabled: disabled,
      );
    }
  }
}
