import '../i18n/i18n.dart';
import './translation_engine_config.dart';

String getTranslationEngineTypeName(String type) {
  switch (type) {
    case 'baidu':
      return t.engine.baidu;
    case 'caiyun':
      return t.engine.caiyun;
    case 'deepl':
      return t.engine.deepl;
    case 'google':
      return t.engine.google;
    case 'ibmwatson':
      return t.engine.ibmwatson;
    case 'iciba':
      return t.engine.iciba;
    case 'openai':
      return t.engine.openai;
    case 'sogou':
      return t.engine.sogou;
    case 'tencent':
      return t.engine.tencent;
    case 'youdao':
      return t.engine.youdao;
    default:
      return type;
  }
}

extension ExtTranslationEngineConfig on TranslationEngineConfig {
  String get typeName {
    return getTranslationEngineTypeName(type);
  }
}
