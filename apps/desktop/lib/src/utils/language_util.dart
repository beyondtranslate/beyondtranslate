import 'package:flutter/material.dart';

import '../i18n/i18n.dart';
import '../services/runtime.dart' show runtime;

/// Sentinel value for auto-detected source language.
const kAutoSource = 'auto';

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

String get defaultTargetLanguage {
  final appLang = LocaleSettings.currentLocale;
  final code = switch (appLang) {
    AppLocale.en => 'en',
    AppLocale.ja => 'ja',
    AppLocale.ko => 'ko',
    AppLocale.zhHans => 'zh-Hans',
    AppLocale.zhHant => 'zh-Hant',
    _ => 'zh-Hans',
  };
  return _preferredLanguage(code);
}

String _preferredLanguage(String code) {
  final languages = supportedLanguages;
  if (languages.contains(code)) return code;
  return languages.isNotEmpty ? languages.first : code;
}

bool isAutoSource(String source) => source == kAutoSource;

String getSourceDisplayName(String source, {bool showNative = false}) {
  if (isAutoSource(source)) return t.mini_translator.language.auto_detect;
  return getLanguageName(source, showNative: showNative);
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

/// Returns the language name in the app's current locale.
///
/// When [showNative] is true and the native name differs from the translated
/// name, the native name is appended in parentheses.
///
/// Examples with a Chinese app locale:
///   - `getLanguageName("en")`           → "英语"
///   - `getLanguageName("en", showNative: true)` → "英语 (English)"
///   - `getLanguageName("zh-Hans")`      → "中文（简体）"
String getLanguageName(String language, {bool showNative = false}) {
  final translated = _languageNameFromT(language) ?? language;
  if (!showNative) return translated;
  final native = _nativeNames[language] ?? language;
  if (translated == native) return translated;
  return '$translated ($native)';
}

/// Looks up the translated name for a language code via the i18n system.
String? _languageNameFromT(String language) {
  final value =
      t['common.language.${language.toLowerCase().replaceAll('-', '_')}'];
  return value is String ? value : null;
}

/// Returns the default set of common language codes.
/// Always includes a broad set of widely-used languages, filtered to only
/// those actually supported by the current app build.
List<String> defaultCommonLanguages() {
  const base = <String>[
    'en',
    'zh-Hans',
    'zh-Hant',
    'ja',
    'ko',
    'fr',
    'de',
    'es',
    'ru',
    'pt',
    'ar',
    'it',
  ];
  // Keep only languages that are actually in the supported list.
  return base.where((code) => supportedLanguages.contains(code)).toList();
}

/// Returns the subset of [supportedLanguages] that are in [commonLanguageCodes].
/// The order follows [commonLanguageCodes]; codes not in [supportedLanguages]
/// are silently dropped.
List<String> getCommonLanguages(List<String> commonLanguageCodes) {
  return commonLanguageCodes
      .where((code) => supportedLanguages.contains(code))
      .toList();
}

/// Returns the subset of [supportedLanguages] that are NOT in [commonLanguageCodes].
/// The order follows [supportedLanguages].
List<String> getOtherLanguages(List<String> commonLanguageCodes) {
  final commonSet = commonLanguageCodes.toSet();
  return supportedLanguages.where((l) => !commonSet.contains(l)).toList();
}

/// Builds a list of [DropdownMenuItem] items for a language picker, with
/// common languages grouped first and other languages below a separator.
///
/// When [showAutoDetect] is true, an "Auto detect" item is prepended.
List<DropdownMenuItem<String>> buildLanguageDropdownItems({
  List<String> commonLanguageCodes = const [],
  bool showAutoDetect = false,
  bool showNative = false,
}) {
  final items = <DropdownMenuItem<String>>[];

  if (showAutoDetect) {
    items.add(DropdownMenuItem(
      value: kAutoSource,
      child: Text(t.mini_translator.language.auto_detect),
    ));
  }

  final common = getCommonLanguages(commonLanguageCodes);
  final other = getOtherLanguages(commonLanguageCodes);

  for (final lang in common) {
    items.add(DropdownMenuItem(
      value: lang,
      child: Text(getLanguageName(lang, showNative: showNative)),
    ));
  }

  if (other.isNotEmpty && common.isNotEmpty) {
    items.add(const DropdownMenuItem(
      value: null,
      enabled: false,
      child: Divider(height: 1),
    ));
  }

  if (common.isNotEmpty) {
    items.add(DropdownMenuItem(
      value: '__group_header__',
      enabled: false,
      child: Text(
        t.mini_translator.language.more_languages,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
    ));
  }

  for (final lang in other) {
    items.add(DropdownMenuItem(
      value: lang,
      child: Text(getLanguageName(lang, showNative: showNative)),
    ));
  }

  return items;
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
