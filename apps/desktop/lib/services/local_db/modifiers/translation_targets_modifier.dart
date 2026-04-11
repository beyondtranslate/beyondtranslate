import 'package:biyi_app/includes.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shortid/shortid.dart';

class TranslationTargetsModifier extends Listenable {
  Box? _boxInstance;

  Box get _box {
    if (_boxInstance == null || _boxInstance?.isOpen != true) {
      _boxInstance = Hive.box('translation_targets');
    }
    return _boxInstance!;
  }

  String? _id;

  void setId(String? id) {
    _id = id;
  }

  @override
  void addListener(VoidCallback listener) {
    _box.listenable().addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _box.listenable().removeListener(listener);
  }

  List<TranslationTarget> list() {
    return _box.values.map((e) => TranslationTarget.fromJson(e)).toList();
  }

  TranslationTarget? get() {
    if (_id != null && _box.containsKey(_id)) {
      return TranslationTarget.fromJson(_box.get(_id));
    }
    return null;
  }

  Future<void> create({
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    final value = TranslationTarget(
      id: _id ?? shortid.generate(),
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );
    _box.put(value.id, value.toJson());
  }

  Future<void> update({
    String? sourceLanguage,
    String? targetLanguage,
  }) async {
    final value = TranslationTarget.fromJson(_box.get(_id));
    value.sourceLanguage = sourceLanguage ?? value.sourceLanguage;
    value.targetLanguage = targetLanguage ?? value.targetLanguage;
    _box.put(value.id, value.toJson());
  }

  Future<void> delete() async {
    _box.delete(_id);
  }

  bool exists() {
    return _id != null && _box.containsKey(_id);
  }

  Future<void> updateOrCreate({
    String? sourceLanguage,
    String? targetLanguage,
  }) async {
    if (_id != null && exists()) {
      update(
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
      );
    } else {
      create(
        sourceLanguage: sourceLanguage!,
        targetLanguage: targetLanguage!,
      );
    }
  }
}
