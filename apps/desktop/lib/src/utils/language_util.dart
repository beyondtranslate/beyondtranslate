import 'package:flutter/material.dart';

import '../i18n/i18n.dart';

const kLanguageDE = 'de';
const kLanguageEN = 'en';
const kLanguageES = 'es';
const kLanguageFR = 'fr';
const kLanguageIT = 'it';
const kLanguageJA = 'ja';
const kLanguageKO = 'ko';
const kLanguagePT = 'pt';
const kLanguageRU = 'ru';
const kLanguageZH = 'zh';

final List<String> kAppLanguages = [
  kLanguageEN,
  kLanguageZH,
];

final List<String> kSupportedLanguages = [
  kLanguageDE,
  kLanguageEN,
  kLanguageES,
  kLanguageFR,
  kLanguageIT,
  kLanguageJA,
  kLanguageKO,
  kLanguagePT,
  kLanguageRU,
  kLanguageZH,
];

String getLanguageName(String language) {
  switch (language) {
    case kLanguageDE:
      return t.common.language.de;
    case kLanguageEN:
      return t.common.language.en;
    case kLanguageES:
      return t.common.language.es;
    case kLanguageFR:
      return t.common.language.fr;
    case kLanguageIT:
      return t.common.language.it;
    case kLanguageJA:
      return t.common.language.ja;
    case kLanguageKO:
      return t.common.language.ko;
    case kLanguagePT:
      return t.common.language.pt;
    case kLanguageRU:
      return t.common.language.ru;
    case kLanguageZH:
      return t.common.language.zh;
    default:
      return language;
  }
}

Locale languageToLocale(String language) {
  if (language.contains('-')) {
    return Locale(
        language.substring(0, 1).toUpperCase(), language.substring(1));
  }
  return Locale(language);
}
