import 'package:uni_translate_client/uni_translate_client.dart';

import '../../models/translation_engine_config.dart';

class ProTranslationEngine extends TranslationEngine {
  ProTranslationEngine(
    this.config,
  ) : super(identifier: config.identifier, option: config.option);

  TranslationEngineConfig config;

  @override
  List<TranslationEngineScope> get supportedScopes => config.supportedScopes
      .map(
        (scope) => TranslationEngineScope.values.firstWhere(
          (item) => item.name == scope,
        ),
      )
      .toList();

  @override
  Future<DetectLanguageResponse> detectLanguage(DetectLanguageRequest request) {
    throw UnsupportedError('detectLanguage');
  }

  @override
  Future<LookUpResponse> lookUp(LookUpRequest request) {
    throw UnsupportedError('lookUp');
  }

  @override
  Future<TranslateResponse> translate(TranslateRequest request) {
    throw UnsupportedError('translate');
  }
}
