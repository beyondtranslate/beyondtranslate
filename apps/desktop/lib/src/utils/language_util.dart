import 'package:flutter/material.dart';

import '../i18n/i18n.dart';
import '../services/runtime.dart' show runtime;

List<String>? _appLanguages;
List<String>? _supportedLanguages;

List<String> get appLanguages {
  _appLanguages ??=
      runtime.listAppLanguages().map((lang) => lang.code).toList();
  return _appLanguages!;
}

List<String> get supportedLanguages {
  _supportedLanguages ??=
      runtime.listLanguages().map((lang) => lang.code).toList();
  return _supportedLanguages!;
}

String get defaultSourceLanguage => _preferredLanguage('en');

String get defaultTargetLanguage => _preferredLanguage('zh-Hans');

String _preferredLanguage(String code) {
  final languages = supportedLanguages;
  if (languages.contains(code)) return code;
  return languages.isNotEmpty ? languages.first : code;
}

/// Native (original) name of each language in its own writing system.
///
/// Lazily loaded from the Rust runtime on first access.
Map<String, String>? _nativeLanguageNames;

Map<String, String> get _nativeNames {
  _nativeLanguageNames ??= {
    for (final lang in runtime.listLanguages()) lang.code: lang.localName,
  };
  return _nativeLanguageNames!;
}

String getLanguageName(String language) {
  final translated = _languageNameFromT(language) ?? language;
  final native = _nativeNames[language] ?? language;
  if (translated == native) return translated;
  return '$translated ($native)';
}

/// Looks up the translated name for a language code via the i18n system.
String? _languageNameFromT(String language) {
  final value = t['common.language.${language.replaceAll('-', '_')}'];
  return value is String ? value : null;
}

Locale languageToLocale(String language) {
  final parts = language.split('-');
  if (parts.length >= 2 && parts[1].length == 4) {
    return Locale.fromSubtags(languageCode: parts[0], scriptCode: parts[1]);
  }
  if (parts.length >= 2) {
    return Locale(parts[0], parts[1]);
  }
  return Locale(parts[0]);
}
