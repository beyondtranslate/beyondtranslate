import '../src/rust/api/simple.dart';

class RustRuntimeDebugService {
  const RustRuntimeDebugService();

  Future<RustTranslateDebugResponse> translate({
    required String providerType,
    required String providerConfigYaml,
    String? sourceLanguage,
    required String targetLanguage,
    required String text,
  }) {
    return translateWithRuntime(
      request: RustTranslateDebugRequest(
        providerType: providerType,
        providerConfigYaml: providerConfigYaml,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
        text: text,
      ),
    );
  }

  Future<RustLookupDebugResponse> lookup({
    required String providerType,
    required String providerConfigYaml,
    required String sourceLanguage,
    required String targetLanguage,
    required String word,
  }) {
    return lookupWithRuntime(
      request: RustLookupDebugRequest(
        providerType: providerType,
        providerConfigYaml: providerConfigYaml,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
        word: word,
      ),
    );
  }
}

const rustRuntimeDebugService = RustRuntimeDebugService();
