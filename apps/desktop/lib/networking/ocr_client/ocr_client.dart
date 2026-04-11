import 'package:biyi_advanced_features/biyi_advanced_features.dart';
import 'package:biyi_app/includes.dart';
import 'package:ocr_engine_builtin/ocr_engine_builtin.dart';
import 'package:ocr_engine_youdao/ocr_engine_youdao.dart';

final kDefaultBuiltInOcrEngine = BuiltInOcrEngine(
  identifier: 'builtin',
  option: Map<String, dynamic>.from({}),
);

bool kDefaultBuiltInOcrEngineIsSupportedOnCurrentPlatform = false;

const kSupportedOcrEngineTypes = [
  kOcrEngineTypeYoudao,
];

OcrEngine? createOcrEngine(
  OcrEngineConfig ocrEngineConfig,
) {
  OcrEngine? ocrEngine;
  if (localDb.proOcrEngine(ocrEngineConfig.identifier).exists()) {
    ocrEngine = ProOcrEngine(ocrEngineConfig);
    if (ocrEngineConfig.identifier == kDefaultBuiltInOcrEngine.identifier) {
      ocrEngine = kDefaultBuiltInOcrEngine;
    }
  } else {
    switch (ocrEngineConfig.type) {
      case kOcrEngineTypeYoudao:
        ocrEngine = YoudaoOcrEngine(
          identifier: ocrEngineConfig.identifier,
          option: ocrEngineConfig.option,
        );
        break;
    }
  }
  return ocrEngine;
}

class AutoloadOcrClientAdapter extends UniOcrClientAdapter {
  final Map<String, OcrEngine> _ocrEngineMap = {};

  @override
  OcrEngine get first {
    OcrEngineConfig engineConfig = localDb.ocrEngines.list().first;
    return use(engineConfig.identifier);
  }

  @override
  OcrEngine use(String identifier) {
    OcrEngineConfig? engineConfig = localDb.ocrEngine(identifier).get();

    OcrEngine? ocrEngine;
    if (_ocrEngineMap.containsKey(engineConfig?.identifier)) {
      ocrEngine = _ocrEngineMap[engineConfig?.identifier];
    }

    if (ocrEngine == null) {
      ocrEngine = createOcrEngine(engineConfig!);
      if (ocrEngine != null) {
        _ocrEngineMap.update(
          engineConfig.identifier,
          (_) => ocrEngine!,
          ifAbsent: () => ocrEngine!,
        );
      }
    }

    return ocrEngine!;
  }

  void renew(String identifier) {
    _ocrEngineMap.remove(identifier);
  }
}

UniOcrClient sharedOcrClient = UniOcrClient(AutoloadOcrClientAdapter());
