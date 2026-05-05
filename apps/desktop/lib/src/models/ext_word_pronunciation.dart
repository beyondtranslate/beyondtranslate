import '../i18n/i18n.dart';
import '../services/runtime.dart';

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
