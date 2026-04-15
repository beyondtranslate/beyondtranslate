import 'package:biyi_app/models/models.dart';
import 'package:biyi_app/i18n/i18n.dart';

extension ExtTranslationEngineConfig on TranslationEngineConfig {
  String get typeName {
    String key = 'engine.$type';
    if (key.tr() == key) {
      return type;
    }
    return key.tr();
  }
}
