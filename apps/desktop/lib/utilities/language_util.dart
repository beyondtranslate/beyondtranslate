import 'package:biyi_app/includes.dart';
import 'package:flutter/material.dart';

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

final Map<String, String> _knownFlagIcons = {
  kLanguageDE: 'de',
  kLanguageEN: 'gb',
  kLanguageES: 'es',
  kLanguageFR: 'fr',
  kLanguageIT: 'in',
  kLanguageJA: 'jp',
  kLanguageKO: 'kr',
  kLanguagePT: 'pt',
  kLanguageRU: 'ru',
  kLanguageZH: 'cn',
};

String getLanguageName(String language) {
  return 'language.$language'.tr();
}

String getLanguageFlag(String language) {
  return R.image('flag_icons/${_knownFlagIcons[language]}.svg');
}

Locale languageToLocale(String language) {
  if (language.contains('-')) {
    return Locale(
        language.substring(0, 1).toUpperCase(), language.substring(1));
  }
  return Locale(language);
}
