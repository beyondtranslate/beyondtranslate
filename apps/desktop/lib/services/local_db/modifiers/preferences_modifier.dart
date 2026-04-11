import 'package:biyi_advanced_features/biyi_advanced_features.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PreferencesModifier extends Listenable {
  Box? _boxInstance;

  Box get _box {
    if (_boxInstance == null || _boxInstance?.isOpen != true) {
      _boxInstance = Hive.box('preferences');
    }
    return _boxInstance!;
  }

  String? _key;

  void setKey(String? key) {
    _key = key;
  }

  @override
  void addListener(VoidCallback listener) {
    _box.listenable().addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _box.listenable().removeListener(listener);
  }

  List<UserPreference> list() {
    return _box.values.map((e) => UserPreference.fromJson(e)).toList();
  }

  UserPreference? get() {
    if (exists()) {
      return UserPreference.fromJson(_box.get(_key));
    }
    return null;
  }

  Future<void> create({
    required String key,
    String type = 'string',
    required String value,
  }) async {
    UserPreference preference = UserPreference(
      key: key,
      type: type,
      value: value,
    );
    _box.put(preference.key, preference.toJson());
  }

  Future<void> update({
    String? type,
    String? value,
  }) async {
    UserPreference preference = UserPreference.fromJson(_box.get(_key));
    preference.type = type ?? preference.type;
    preference.value = value ?? preference.value;
    _box.put(preference.key, preference.toJson());
  }

  Future<void> delete() async {
    _box.delete(_key);
  }

  bool exists() {
    return _key != null && _box.containsKey(_key);
  }

  Future<void> updateOrCreate({
    String type = 'string',
    required String value,
  }) async {
    if (_key != null && exists()) {
      update(
        type: type,
        value: value,
      );
    } else {
      create(
        key: _key!,
        type: type,
        value: value,
      );
    }
  }
}
