import '../i18n/i18n.dart';
import './translation_engine_config.dart';

extension ExtTranslationEngineConfig on TranslationEngineConfig {
  String get typeName {
    String key = 'engine.$type';
    if (key.tr() == key) {
      return type;
    }
    return key.tr();
  }
}
