import '../i18n/i18n.dart';
import './ocr_engine_config.dart';

extension ExtOcrEngineConfig on OcrEngineConfig {
  String get typeName {
    String key = 'ocr_engine.$type';
    if (key.tr() == key) {
      return type;
    }
    return key.tr();
  }
}
