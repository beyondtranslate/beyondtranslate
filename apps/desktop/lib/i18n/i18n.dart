import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'strings.g.dart';


String _replacePositionalArgs(String value, List<String> args) {
  var result = value;
  for (final arg in args) {
    result = result.replaceFirst('{}', arg);
  }
  return result;
}

String _translate(String key, {List<String> args = const []}) {
  try {
    final value = t[key];
    if (value is String) {
      return _replacePositionalArgs(value, args);
    }
  } catch (_) {
    // Keep the legacy fallback behavior for dynamic keys.
  }
  return key;
}

extension SlangStringExtension on String {
  String tr({List<String> args = const []}) {
    return _translate(this, args: args);
  }
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
