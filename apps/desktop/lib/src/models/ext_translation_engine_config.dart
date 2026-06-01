import '../i18n/i18n.dart';
import './translation_engine_config.dart';

String getTranslationEngineTypeName(String type) {
  switch (type) {
    case 'anthropic':
      return 'Anthropic';
    case 'baidu':
      return t.common.provider.baidu;
    case 'caiyun':
      return t.common.provider.caiyun;
    case 'deepl':
      return t.common.provider.deepl;
    case 'google':
      return t.common.provider.google;
    case 'ollama':
      return 'Ollama';
    case 'openai':
      return 'OpenAI';
    case 'xai':
      return 'xAI';
    case 'sogou':
      return t.common.provider.sogou;
    case 'tencent':
      return t.common.provider.tencent;
    case 'youdao':
      return t.common.provider.youdao;
    default:
      return type;
  }
}

extension ExtTranslationEngineConfig on TranslationEngineConfig {
  String get typeName {
    return getTranslationEngineTypeName(type);
  }
}
