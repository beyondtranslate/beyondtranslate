import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'strings.g.dart';
export 'strings.g.dart';

String formatTranslation(String value, {List<String> args = const []}) {
  var result = value;
  for (final arg in args) {
    result = result.replaceFirst('{}', arg);
  }
  return result;
}

extension SlangBuildContextExtension on BuildContext {
  Iterable<LocalizationsDelegate<dynamic>> get localizationDelegates {
    return GlobalMaterialLocalizations.delegates;
  }

  List<Locale> get supportedLocales {
    return AppLocaleUtils.supportedLocales;
  }

  Locale get locale {
    return LocaleSettings.currentLocale.flutterLocale;
  }

  Future<void> setLocale(Locale locale) async {
    await LocaleSettings.setLocaleRaw(locale.languageCode);
  }
}
