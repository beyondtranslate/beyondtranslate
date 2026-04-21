import 'package:uni_translate_client/uni_translate_client.dart';
import '../i18n/i18n.dart';

extension ExtWordPronunciation on WordPronunciation {
  String get localType {
    switch (type) {
      case 'us':
        return t.word_pronunciation.us;
      case 'uk':
        return t.word_pronunciation.uk;
      default:
        return type ?? '';
    }
  }
}
