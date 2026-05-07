import '../i18n/i18n.dart';
import './translation_engine_config.dart';

String getTranslationEngineTypeName(String type) {
  switch (type) {
    case 'baidu':
      return t.provider.baidu;
    case 'caiyun':
      return t.provider.caiyun;
    case 'deepl':
      return t.provider.deepl;
    case 'google':
      return t.provider.google;
    case 'ibmwatson':
      return t.provider.ibmwatson;
    case 'iciba':
      return t.provider.iciba;
    case 'openai':
      return t.provider.openai;
    case 'sogou':
      return t.provider.sogou;
    case 'tencent':
      return t.provider.tencent;
    case 'youdao':
      return t.provider.youdao;
    default:
      return type;
  }
}

extension ExtTranslationEngineConfig on TranslationEngineConfig {
  String get typeName {
    return getTranslationEngineTypeName(type);
  }
}
