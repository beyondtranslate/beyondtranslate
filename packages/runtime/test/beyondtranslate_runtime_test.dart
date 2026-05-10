import 'package:flutter_test/flutter_test.dart';
import 'package:beyondtranslate_runtime/beyondtranslate_runtime.dart' as rp;

void main() {
  // NOTE: these tests resolve `package:beyondtranslate_runtime/uniffi:beyondtranslate_runtime` via
  // Dart's native-assets system. Run them with native assets enabled:
  //
  //     flutter config --enable-native-assets
  //     flutter test
  //
  // The first invocation triggers `hook/build.dart`, which runs
  // `cargo build --release --target <triple>` for the host.

  test('add returns the sum', () {
    expect(rp.add(a: 2, b: 3), 5);
    expect(rp.add(a: -10, b: 7), -3);
  });

  test('greet wraps the input in a hello message', () {
    expect(rp.greet(name: 'World'), 'Hello, World!');
    expect(rp.greet(name: 'BeyondTranslate'), 'Hello, BeyondTranslate!');
  });

  test('version returns a non-empty semver string', () {
    final v = rp.version();
    expect(v, isNotEmpty);
    expect(RegExp(r'^\d+\.\d+\.\d+').hasMatch(v), isTrue);
  });
}
