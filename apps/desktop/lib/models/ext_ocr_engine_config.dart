import '../i18n/i18n.dart';
import './ocr_engine_config.dart';

String getOcrEngineTypeName(String type) {
  switch (type) {
    case 'built_in':
      return t.ocr_engine.built_in;
    case 'tesseract':
      return t.ocr_engine.tesseract;
    case 'youdao':
      return t.ocr_engine.youdao;
    default:
      return type;
  }
}

extension ExtOcrEngineConfig on OcrEngineConfig {
  String get typeName {
    return getOcrEngineTypeName(type);
  }
}
