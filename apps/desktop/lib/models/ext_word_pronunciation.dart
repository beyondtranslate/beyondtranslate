import 'package:uni_translate_client/uni_translate_client.dart';
import '../i18n/i18n.dart';

extension ExtWordPronunciation on WordPronunciation {
  String get localType {
    return 'word_pronunciation.$type'.tr();
  }
}
