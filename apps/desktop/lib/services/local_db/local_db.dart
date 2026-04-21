import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:ocr_engine_builtin/ocr_engine_builtin.dart';
import 'package:path/path.dart' as path;

import '../../models/ocr_engine_config.dart';
import '../../models/translation_engine_config.dart';
import '../../networking/api_client/api_client.dart';
import '../../networking/ocr_client/ocr_client.dart';
import '../../utils/utils.dart';
import './configuration.dart';
import './modifiers/engines_modifier.dart';
import './modifiers/ocr_engines_modifier.dart';
import './modifiers/preferences_modifier.dart';
import './modifiers/translation_targets_modifier.dart';
import 'init_data_if_need.dart';

class LocalDb {
  Configuration configuration = Configuration();

  EnginesModifier? _enginesModifier;
  OcrEnginesModifier? _ocrEnginesModifier;
  PreferencesModifier? _preferencesModifier;
  TranslationTargetsModifier? _translationTargetsModifier;

  Future<void> loadFromCloudServer() async {
    var oldProEngineList = proEngines.list();
    var oldProOcrEngineList = proOcrEngines.list();

    List<TranslationEngineConfig> newProEngineList = [];
    List<OcrEngineConfig> newProOcrEngineList = [];

    try {
      newProEngineList = await apiClient.engines.list();
      newProEngineList = newProEngineList.map((engine) {
        TranslationEngineConfig? oldEngine = oldProEngineList.firstWhereOrNull(
          (e) => e.identifier == engine.identifier,
        );
        if (oldEngine != null) {
          engine.disabled = oldEngine.disabled;
        }
        return engine;
      }).toList();

      await localDb.proEngines.deleteAll();
      for (var item in newProEngineList) {
        await localDb //
            .proEngine(item.identifier)
            .updateOrCreate(
              type: item.type,
              option: item.option,
              supportedScopes: item.supportedScopes,
              disabled: item.disabled,
            );
      }
    } catch (error) {
      // skip error
    }

    try {
      newProOcrEngineList = await apiClient.ocrEngines.list();
      newProOcrEngineList = newProOcrEngineList.map((engine) {
        var oldOrcEngine = oldProOcrEngineList.firstWhereOrNull(
          (e) => e.identifier == engine.identifier,
        );
        if (oldOrcEngine != null) {
          engine.disabled = oldOrcEngine.disabled;
        }

        return engine;
      }).toList();

      newProOcrEngineList.removeWhere(
        (e) => e.type == kOcrEngineTypeBuiltIn,
      );

      try {
        if (await kDefaultBuiltInOcrEngine.isSupportedOnCurrentPlatform()) {
          newProOcrEngineList.insert(
              0,
              OcrEngineConfig(
                identifier: kDefaultBuiltInOcrEngine.identifier,
                type: kDefaultBuiltInOcrEngine.type,
                option: kDefaultBuiltInOcrEngine.option ?? {},
                disabled: true,
              ));
        }
      } catch (error) {
        // skip error
      }

      await localDb.proOcrEngines.deleteAll();
      for (var item in newProOcrEngineList) {
        await localDb //
            .proOcrEngine(item.identifier)
            .updateOrCreate(
              type: item.type,
              option: item.option,
              disabled: item.disabled,
            );
      }
    } catch (error) {
      // skip error
    }

    if (configuration.defaultTranslateEngineId == null ||
        !engine(configuration.defaultTranslateEngineId).exists()) {
      configuration.defaultTranslateEngineId =
          newProEngineList.firstWhere((e) => e.type == 'baidu').identifier;
    }

    if (configuration.defaultEngineId == null ||
        !engine(configuration.defaultEngineId).exists()) {
      configuration.defaultEngineId =
          newProEngineList.firstWhere((e) => e.type == 'baidu').identifier;
    }

    if (configuration.defaultOcrEngineId == null ||
        !ocrEngine(configuration.defaultOcrEngineId).exists()) {
      configuration.defaultOcrEngineId = newProOcrEngineList
          .firstWhere((e) => e.type == 'built_in' || e.type == 'tesseract')
          .identifier;
    }
  }

  EnginesModifier get engines {
    return engine(null);
  }

  EnginesModifier engine(String? id) {
    _enginesModifier ??= EnginesModifier();
    _enginesModifier?.setId(id);
    _enginesModifier?.setGroup(null);
    return _enginesModifier!;
  }

  OcrEnginesModifier get ocrEngines {
    return ocrEngine(null);
  }

  OcrEnginesModifier ocrEngine(String? id) {
    _ocrEnginesModifier ??= OcrEnginesModifier();
    _ocrEnginesModifier?.setId(id);
    _ocrEnginesModifier?.setGroup(null);
    return _ocrEnginesModifier!;
  }

  EnginesModifier get proEngines {
    return proEngine(null);
  }

  EnginesModifier proEngine(String? id) {
    _enginesModifier ??= EnginesModifier();
    _enginesModifier?.setId(id);
    _enginesModifier?.setGroup('pro');
    return _enginesModifier!;
  }

  OcrEnginesModifier get proOcrEngines {
    return proOcrEngine(null);
  }

  OcrEnginesModifier proOcrEngine(String? id) {
    _ocrEnginesModifier ??= OcrEnginesModifier();
    _ocrEnginesModifier?.setId(id);
    _ocrEnginesModifier?.setGroup('pro');
    return _ocrEnginesModifier!;
  }

  EnginesModifier get privateEngines {
    return privateEngine(null);
  }

  EnginesModifier privateEngine(String? id) {
    _enginesModifier ??= EnginesModifier();
    _enginesModifier?.setId(id);
    _enginesModifier?.setGroup('private');
    return _enginesModifier!;
  }

  OcrEnginesModifier get privateOcrEngines {
    return privateOcrEngine(null);
  }

  OcrEnginesModifier privateOcrEngine(String? id) {
    _ocrEnginesModifier ??= OcrEnginesModifier();
    _ocrEnginesModifier?.setId(id);
    _ocrEnginesModifier?.setGroup('private');
    return _ocrEnginesModifier!;
  }

  PreferencesModifier get preferences {
    return preference(null);
  }

  PreferencesModifier preference(String? key) {
    _preferencesModifier ??= PreferencesModifier();
    _preferencesModifier?.setKey(key);
    return _preferencesModifier!;
  }

  TranslationTargetsModifier get translationTargets {
    return translationTarget(null);
  }

  TranslationTargetsModifier translationTarget(String? id) {
    _translationTargetsModifier ??= TranslationTargetsModifier();
    _translationTargetsModifier?.setId(id);
    return _translationTargetsModifier!;
  }
}

final localDb = LocalDb();

Future<void> _safeOpenBox(Directory userDataDirectory, String name) async {
  bool isOpenFailed = false;

  try {
    await Hive.openBox(name);
  } on FileSystemException {
    isOpenFailed = true;
  }

  if (isOpenFailed) {
    File lockFile = File(path.join(userDataDirectory.path, '$name.lock'));

    if (lockFile.existsSync()) {
      lockFile.deleteSync();
    }
    try {
      await Hive.openBox(name);
    } on FileSystemException {
      // skip
    }
  }
}

Future<void> initLocalDb() async {
  Directory dataDirectory = await getAppDataDirectory();

  await Hive.close();
  Hive.init(dataDirectory.path);
  await _safeOpenBox(dataDirectory, 'preferences');
  await _safeOpenBox(dataDirectory, 'engines');
  await _safeOpenBox(dataDirectory, 'ocr_engines');
  await _safeOpenBox(dataDirectory, 'translation_targets');
  await _safeOpenBox(dataDirectory, 'newwords');
  // await migrateOldDb();
  if (!kIsWeb) {
    await initDataIfNeed();
  }
}
