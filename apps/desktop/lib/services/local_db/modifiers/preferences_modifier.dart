import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart' as path;
import 'package:unified_persistence/unified_persistence.dart';

import '../../../models/preference_item.dart';

class PreferencesModifier extends ChangeNotifier {
  static final _PreferencesStore _store = _PreferencesStore();

  static Future<void> initialize(Directory userDataDirectory) async {
    await _store.initialize(userDataDirectory);
  }

  String? _key;

  void setKey(String? key) {
    _key = key;
  }

  List<PreferenceItem> list() {
    return _store.values.map(PreferenceItem.fromJson).toList();
  }

  PreferenceItem? get() {
    if (!exists()) {
      return null;
    }

    final Map<String, dynamic>? json = _store.get(_key!);
    if (json == null) {
      return null;
    }

    return PreferenceItem.fromJson(json);
  }

  Future<void> create({
    required String key,
    String type = 'string',
    required String value,
  }) async {
    final PreferenceItem preference = PreferenceItem(
      key: key,
      type: type,
      value: value,
    );
    _store.put(preference.key!, preference.toJson());
    notifyListeners();
  }

  Future<void> update({
    String? type,
    String? value,
  }) async {
    final Map<String, dynamic>? json = _key == null ? null : _store.get(_key!);
    if (json == null) {
      return;
    }

    final PreferenceItem preference = PreferenceItem.fromJson(json);
    preference.type = type ?? preference.type;
    preference.value = value ?? preference.value;

    _store.put(preference.key!, preference.toJson());
    notifyListeners();
  }

  Future<void> delete() async {
    if (_key == null) {
      return;
    }

    _store.delete(_key!);
    notifyListeners();
  }

  bool exists() {
    return _key != null && _store.containsKey(_key!);
  }

  Future<void> updateOrCreate({
    String type = 'string',
    required String value,
  }) async {
    if (_key != null && exists()) {
      await update(
        type: type,
        value: value,
      );
    } else if (_key != null) {
      await create(
        key: _key!,
        type: type,
        value: value,
      );
    }
  }
}

class _PreferencesStore {
  static const String _storageKey = 'preferences';
  static const String _storageFileName = 'preferences.json';

  Persistor<Map<String, dynamic>>? _persistor;
  String? _storageFilePath;
  Map<String, dynamic> _cache = <String, dynamic>{};
  bool _initialized = false;

  Iterable<Map<String, dynamic>> get values sync* {
    for (final dynamic value in _cache.values) {
      if (value is Map) {
        yield Map<String, dynamic>.from(value);
      }
    }
  }

  Future<void> initialize(Directory userDataDirectory) async {
    if (_initialized) {
      return;
    }

    _storageFilePath = path.join(userDataDirectory.path, _storageFileName);
    _persistor = JsonFilePersistor<Map<String, dynamic>>(
      filePath: _storageFilePath!,
      toJson: (Map<String, dynamic> value) => value,
      fromJson: (Map<String, dynamic> json) => Map<String, dynamic>.from(json),
    );

    await _migrateFromHiveIfNeeded();

    _cache = await _persistor!.restore() ?? <String, dynamic>{};
    _initialized = true;
  }

  bool containsKey(String key) {
    _ensureInitialized();
    return _cache.containsKey(key);
  }

  Map<String, dynamic>? get(String key) {
    _ensureInitialized();
    final dynamic value = _cache[key];
    if (value is! Map) {
      return null;
    }
    return Map<String, dynamic>.from(value);
  }

  void put(String key, Map<String, dynamic> value) {
    _ensureInitialized();
    _cache[key] = value;
    _persistor!.persistSync(_cache);
  }

  void delete(String key) {
    _ensureInitialized();
    _cache.remove(key);
    if (_cache.isEmpty) {
      _persistor!.persistSync(null);
      return;
    }
    _persistor!.persistSync(_cache);
  }

  Future<void> _migrateFromHiveIfNeeded() async {
    final File storageFile = File(_storageFilePath!);
    if (storageFile.existsSync()) {
      return;
    }

    Box? legacyBox;
    try {
      legacyBox = await Hive.openBox(_storageKey);
      if (legacyBox.isEmpty) {
        return;
      }

      final Map<String, dynamic> legacyPreferences = <String, dynamic>{};
      for (final dynamic key in legacyBox.keys) {
        final dynamic value = legacyBox.get(key);
        if (value is Map) {
          legacyPreferences['$key'] = Map<String, dynamic>.from(value);
        }
      }

      if (legacyPreferences.isNotEmpty) {
        _persistor!.persistSync(legacyPreferences);
      }
    } catch (_) {
      // Skip migration when the legacy box cannot be opened.
    } finally {
      await legacyBox?.close();
    }
  }

  void _ensureInitialized() {
    if (!_initialized || _persistor == null || _storageFilePath == null) {
      throw StateError('PreferencesModifier is not initialized.');
    }
  }
}
