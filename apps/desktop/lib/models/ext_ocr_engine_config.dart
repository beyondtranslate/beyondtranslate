import 'package:biyi_advanced_features/biyi_advanced_features.dart';
import 'package:easy_localization/easy_localization.dart';

extension ExtOcrEngineConfig on OcrEngineConfig {
  String get typeName {
    String key = 'ocr_engine.$type';
    if (key.tr() == key) {
      return type;
    }
    return key.tr();
  }
}
