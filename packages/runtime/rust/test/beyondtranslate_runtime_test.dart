import 'package:test/test.dart';

import '../beyondtranslate_core.dart';
import '../beyondtranslate_runtime.dart';

void main() {
  test('add', () {
    expect(add(a: 2, b: 3), 5);
    expect(add(a: -10, b: 7), -3);
  });

  test('greet', () {
    expect(greet(name: 'World'), 'Hello, World!');
    expect(greet(name: 'BeyondTranslate'), 'Hello, BeyondTranslate!');
  });

  test('version returns a non-empty semver string', () {
    final v = version();
    expect(v, isNotEmpty);
    expect(RegExp(r'^\d+\.\d+\.\d+').hasMatch(v), isTrue);
  });

  test('core model bindings round trip', () {
    final request = TranslateRequest(
      sourceLanguage: 'zh',
      targetLanguage: 'en',
      text: '你好',
    );
    final echoedRequest = echoTranslateRequest(request: request);

    expect(echoedRequest.sourceLanguage, 'zh');
    expect(echoedRequest.targetLanguage, 'en');
    expect(echoedRequest.text, '你好');

    final response = echoLookUpResponse(
      response: LookUpResponse(
        translations: [
          TextTranslation(
            detectedSourceLanguage: 'zh',
            text: 'hello',
            audioUrl: null,
          ),
        ],
        word: 'hello',
        tip: null,
        tags: [WordTag(name: 'noun')],
        definitions: [
          WordDefinition(
            type: 'n',
            name: 'noun',
            values: ['hello'],
          ),
        ],
        pronunciations: null,
        images: null,
        phrases: null,
        tenses: null,
        sentences: null,
      ),
    );

    expect(response.translations.single.text, 'hello');
    expect(response.tags!.single.name, 'noun');
    expect(response.definitions!.single.type, 'n');
  });
}
