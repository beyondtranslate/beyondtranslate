import 'package:biyi_app/models/models.dart';
import 'package:biyi_app/i18n/i18n.dart';

extension ExtOcrEngineConfig on OcrEngineConfig {
  String get typeName {
    String key = 'ocr_engine.$type';
    if (key.tr() == key) {
      return type;
    }
    return key.tr();
  }
}
