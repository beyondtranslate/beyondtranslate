import 'package:test/test.dart';

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
}
