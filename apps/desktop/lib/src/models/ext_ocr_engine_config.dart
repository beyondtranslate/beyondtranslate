import '../i18n/i18n.dart';
import './ocr_engine_config.dart';

String getOcrEngineTypeName(String type) {
  switch (type) {
    case 'built_in':
      return t.ocr.engine.built_in;
    case 'tesseract':
      return t.ocr.engine.tesseract;
    case 'youdao':
      return t.ocr.engine.youdao;
    default:
      return type;
  }
}

extension ExtOcrEngineConfig on OcrEngineConfig {
  String get typeName {
    return getOcrEngineTypeName(type);
  }
}
