///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element

class Translations with BaseTranslations<AppLocale, Translations> {
  /// Returns the current translations of the given [context].
  ///
  /// Usage:
  /// final t = Translations.of(context);
  static Translations of(BuildContext context) =>
      InheritedLocaleData.of<AppLocale, Translations>(context).translations;

  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  Translations(
      {Map<String, Node>? overrides,
      PluralResolver? cardinalResolver,
      PluralResolver? ordinalResolver,
      TranslationMetadata<AppLocale, Translations>? meta})
      : assert(overrides == null,
            'Set "translation_overrides: true" in order to enable this feature.'),
        $meta = meta ??
            TranslationMetadata(
              locale: AppLocale.en,
              overrides: overrides ?? {},
              cardinalResolver: cardinalResolver,
              ordinalResolver: ordinalResolver,
            ) {
    $meta.setFlatMapFunction(_flatMapFunction);
  }

  /// Metadata for the translations of <en>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  /// Access flat map
  dynamic operator [](String key) => $meta.getTranslation(key);

  late final Translations _root = this; // ignore: unused_field

  Translations $copyWith(
          {TranslationMetadata<AppLocale, Translations>? meta}) =>
      Translations(meta: meta ?? this.$meta);

  // Translations
  late final TranslationsCommonEn common = TranslationsCommonEn.internal(_root);
  late final TranslationsProviderEn provider =
      TranslationsProviderEn.internal(_root);
  late final TranslationsTranslationEn translation =
      TranslationsTranslationEn.internal(_root);
  late final TranslationsOcrEn ocr = TranslationsOcrEn.internal(_root);
  late final TranslationsThemeEn theme = TranslationsThemeEn.internal(_root);
  late final TranslationsTrayEn tray = TranslationsTrayEn.internal(_root);
  late final TranslationsMiniTranslatorEn mini_translator =
      TranslationsMiniTranslatorEn.internal(_root);
  late final TranslationsSettingsEn settings =
      TranslationsSettingsEn.internal(_root);
  late final TranslationsShortcutsEn shortcuts =
      TranslationsShortcutsEn.internal(_root);
}

// Path: common
class TranslationsCommonEn {
  TranslationsCommonEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsCommonAppEn app =
      TranslationsCommonAppEn.internal(_root);
  late final TranslationsCommonButtonEn button =
      TranslationsCommonButtonEn.internal(_root);
  late final TranslationsCommonFeedbackEn feedback =
      TranslationsCommonFeedbackEn.internal(_root);
  late final TranslationsCommonPlaceholderEn placeholder =
      TranslationsCommonPlaceholderEn.internal(_root);
  late final TranslationsCommonLanguageEn language =
      TranslationsCommonLanguageEn.internal(_root);
}

// Path: provider
class TranslationsProviderEn {
  TranslationsProviderEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Baidu'
  String get baidu => 'Baidu';

  /// en: 'Caiyun'
  String get caiyun => 'Caiyun';

  /// en: 'DeepL'
  String get deepl => 'DeepL';

  /// en: 'Google'
  String get google => 'Google';

  /// en: 'IBMWatson'
  String get ibmwatson => 'IBMWatson';

  /// en: 'Iciba'
  String get iciba => 'Iciba';

  /// en: 'OpenAI'
  String get openai => 'OpenAI';

  /// en: 'Sogou'
  String get sogou => 'Sogou';

  /// en: 'Tencent'
  String get tencent => 'Tencent';

  /// en: 'Youda'
  String get youdao => 'Youda';
}

// Path: translation
class TranslationsTranslationEn {
  TranslationsTranslationEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsTranslationEngineScopeEn engine_scope =
      TranslationsTranslationEngineScopeEn.internal(_root);
  late final TranslationsTranslationModeEn mode =
      TranslationsTranslationModeEn.internal(_root);
  late final TranslationsTranslationWordPronunciationEn word_pronunciation =
      TranslationsTranslationWordPronunciationEn.internal(_root);
}

// Path: ocr
class TranslationsOcrEn {
  TranslationsOcrEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsOcrEngineEn engine =
      TranslationsOcrEngineEn.internal(_root);
}

// Path: theme
class TranslationsThemeEn {
  TranslationsThemeEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsThemeModeEn mode =
      TranslationsThemeModeEn.internal(_root);
}

// Path: tray
class TranslationsTrayEn {
  TranslationsTrayEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsTrayContextMenuEn context_menu =
      TranslationsTrayContextMenuEn.internal(_root);
}

// Path: mini_translator
class TranslationsMiniTranslatorEn {
  TranslationsMiniTranslatorEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsMiniTranslatorUpdateBannerEn update_banner =
      TranslationsMiniTranslatorUpdateBannerEn.internal(_root);
  late final TranslationsMiniTranslatorLimitedBannerEn limited_banner =
      TranslationsMiniTranslatorLimitedBannerEn.internal(_root);
  late final TranslationsMiniTranslatorInputEn input =
      TranslationsMiniTranslatorInputEn.internal(_root);
  late final TranslationsMiniTranslatorToolbarEn toolbar =
      TranslationsMiniTranslatorToolbarEn.internal(_root);
  late final TranslationsMiniTranslatorButtonEn button =
      TranslationsMiniTranslatorButtonEn.internal(_root);
  late final TranslationsMiniTranslatorMessageEn message =
      TranslationsMiniTranslatorMessageEn.internal(_root);
}

// Path: settings
class TranslationsSettingsEn {
  TranslationsSettingsEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Settings'
  String get title => 'Settings';

  /// en: 'Version {} BUILD {}'
  String get version => 'Version {} BUILD {}';

  late final TranslationsSettingsGeneralEn general =
      TranslationsSettingsGeneralEn.internal(_root);
  late final TranslationsSettingsAppearanceEn appearance =
      TranslationsSettingsAppearanceEn.internal(_root);
  late final TranslationsSettingsShortcutsEn shortcuts =
      TranslationsSettingsShortcutsEn.internal(_root);
  late final TranslationsSettingsInputEn input =
      TranslationsSettingsInputEn.internal(_root);
  late final TranslationsSettingsAdvancedEn advanced =
      TranslationsSettingsAdvancedEn.internal(_root);
  late final TranslationsSettingsProvidersEn providers =
      TranslationsSettingsProvidersEn.internal(_root);
  late final TranslationsSettingsServiceIntegrationEn service_integration =
      TranslationsSettingsServiceIntegrationEn.internal(_root);
  late final TranslationsSettingsOthersEn others =
      TranslationsSettingsOthersEn.internal(_root);
  late final TranslationsSettingsExitAppDialogEn exit_app_dialog =
      TranslationsSettingsExitAppDialogEn.internal(_root);
  late final TranslationsSettingsPreferenceEn preference =
      TranslationsSettingsPreferenceEn.internal(_root);
  late final TranslationsSettingsEmptyEn empty =
      TranslationsSettingsEmptyEn.internal(_root);
  late final TranslationsSettingsOptionEn option =
      TranslationsSettingsOptionEn.internal(_root);
  late final TranslationsSettingsShortcutEn shortcut =
      TranslationsSettingsShortcutEn.internal(_root);
}

// Path: shortcuts
class TranslationsShortcutsEn {
  TranslationsShortcutsEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsShortcutsRecordDialogEn record_dialog =
      TranslationsShortcutsRecordDialogEn.internal(_root);
}

// Path: common.app
class TranslationsCommonAppEn {
  TranslationsCommonAppEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Beyond Translate'
  String get name => 'Beyond Translate';
}

// Path: common.button
class TranslationsCommonButtonEn {
  TranslationsCommonButtonEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'OK'
  String get ok => 'OK';

  /// en: 'Cancel'
  String get cancel => 'Cancel';

  /// en: 'Add'
  String get add => 'Add';

  /// en: 'Delete'
  String get delete => 'Delete';

  /// en: 'Edit'
  String get edit => 'Edit';

  /// en: 'Save'
  String get save => 'Save';

  /// en: 'Manage'
  String get manage => 'Manage';
}

// Path: common.feedback
class TranslationsCommonFeedbackEn {
  TranslationsCommonFeedbackEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Copied'
  String get copied => 'Copied';
}

// Path: common.placeholder
class TranslationsCommonPlaceholderEn {
  TranslationsCommonPlaceholderEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Please Choose'
  String get choose => 'Please Choose';
}

// Path: common.language
class TranslationsCommonLanguageEn {
  TranslationsCommonLanguageEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Afrikaans'
  String get af => 'Afrikaans';

  /// en: 'Amharic'
  String get am => 'Amharic';

  /// en: 'Arabic'
  String get ar => 'Arabic';

  /// en: 'Azerbaijani'
  String get az => 'Azerbaijani';

  /// en: 'Belarusian'
  String get be => 'Belarusian';

  /// en: 'Bulgarian'
  String get bg => 'Bulgarian';

  /// en: 'Bengali'
  String get bn => 'Bengali';

  /// en: 'Bosnian'
  String get bs => 'Bosnian';

  /// en: 'Catalan'
  String get ca => 'Catalan';

  /// en: 'Cebuano'
  String get ceb => 'Cebuano';

  /// en: 'Corsican'
  String get co => 'Corsican';

  /// en: 'Czech'
  String get cs => 'Czech';

  /// en: 'Welsh'
  String get cy => 'Welsh';

  /// en: 'Danish'
  String get da => 'Danish';

  /// en: 'German'
  String get de => 'German';

  /// en: 'Greek'
  String get el => 'Greek';

  /// en: 'English'
  String get en => 'English';

  /// en: 'Esperanto'
  String get eo => 'Esperanto';

  /// en: 'Spanish'
  String get es => 'Spanish';

  /// en: 'Estonian'
  String get et => 'Estonian';

  /// en: 'Basque'
  String get eu => 'Basque';

  /// en: 'Persian'
  String get fa => 'Persian';

  /// en: 'Finnish'
  String get fi => 'Finnish';

  /// en: 'French'
  String get fr => 'French';

  /// en: 'Frisian'
  String get fy => 'Frisian';

  /// en: 'Irish'
  String get ga => 'Irish';

  /// en: 'Scots Gaelic'
  String get gd => 'Scots Gaelic';

  /// en: 'Galician'
  String get gl => 'Galician';

  /// en: 'Gujarati'
  String get gu => 'Gujarati';

  /// en: 'Hausa'
  String get ha => 'Hausa';

  /// en: 'Hawaiian'
  String get haw => 'Hawaiian';

  /// en: 'Hebrew'
  String get he => 'Hebrew';

  /// en: 'Hindi'
  String get hi => 'Hindi';

  /// en: 'Hmong'
  String get hmn => 'Hmong';

  /// en: 'Croatian'
  String get hr => 'Croatian';

  /// en: 'Haitian Creole'
  String get ht => 'Haitian Creole';

  /// en: 'Hungarian'
  String get hu => 'Hungarian';

  /// en: 'Armenian'
  String get hy => 'Armenian';

  /// en: 'Indonesian'
  String get id => 'Indonesian';

  /// en: 'Igbo'
  String get ig => 'Igbo';

  /// en: 'Icelandic'
  String get kIs => 'Icelandic';

  /// en: 'Italian'
  String get it => 'Italian';

  /// en: 'Hebrew'
  String get iw => 'Hebrew';

  /// en: 'Japanese'
  String get ja => 'Japanese';

  /// en: 'Javanese'
  String get jw => 'Javanese';

  /// en: 'Georgian'
  String get ka => 'Georgian';

  /// en: 'Kazakh'
  String get kk => 'Kazakh';

  /// en: 'Khmer'
  String get km => 'Khmer';

  /// en: 'Kannada'
  String get kn => 'Kannada';

  /// en: 'Korean'
  String get ko => 'Korean';

  /// en: 'Kurdish (Kurmanji)'
  String get ku => 'Kurdish (Kurmanji)';

  /// en: 'Kyrgyz'
  String get ky => 'Kyrgyz';

  /// en: 'Latin'
  String get la => 'Latin';

  /// en: 'Luxembourgish'
  String get lb => 'Luxembourgish';

  /// en: 'Lao'
  String get lo => 'Lao';

  /// en: 'Lithuanian'
  String get lt => 'Lithuanian';

  /// en: 'Latvian'
  String get lv => 'Latvian';

  /// en: 'Malagasy'
  String get mg => 'Malagasy';

  /// en: 'Maori'
  String get mi => 'Maori';

  /// en: 'Macedonian'
  String get mk => 'Macedonian';

  /// en: 'Malayalam'
  String get ml => 'Malayalam';

  /// en: 'Mongolian'
  String get mn => 'Mongolian';

  /// en: 'Marathi'
  String get mr => 'Marathi';

  /// en: 'Malay'
  String get ms => 'Malay';

  /// en: 'Maltese'
  String get mt => 'Maltese';

  /// en: 'Myanmar (Burmese)'
  String get my => 'Myanmar (Burmese)';

  /// en: 'Nepali'
  String get ne => 'Nepali';

  /// en: 'Dutch'
  String get nl => 'Dutch';

  /// en: 'Norwegian'
  String get no => 'Norwegian';

  /// en: 'Chichewa'
  String get ny => 'Chichewa';

  /// en: 'Odia (Oriya)'
  String get or => 'Odia (Oriya)';

  /// en: 'Punjabi'
  String get pa => 'Punjabi';

  /// en: 'Polish'
  String get pl => 'Polish';

  /// en: 'Pashto'
  String get ps => 'Pashto';

  /// en: 'Portuguese'
  String get pt => 'Portuguese';

  /// en: 'Romanian'
  String get ro => 'Romanian';

  /// en: 'Russian'
  String get ru => 'Russian';

  /// en: 'Kinyarwanda'
  String get rw => 'Kinyarwanda';

  /// en: 'Sindhi'
  String get sd => 'Sindhi';

  /// en: 'Sinhala'
  String get si => 'Sinhala';

  /// en: 'Slovak'
  String get sk => 'Slovak';

  /// en: 'Slovenian'
  String get sl => 'Slovenian';

  /// en: 'Samoan'
  String get sm => 'Samoan';

  /// en: 'Shona'
  String get sn => 'Shona';

  /// en: 'Somali'
  String get so => 'Somali';

  /// en: 'Albanian'
  String get sq => 'Albanian';

  /// en: 'Serbian'
  String get sr => 'Serbian';

  /// en: 'Sesotho'
  String get st => 'Sesotho';

  /// en: 'Sundanese'
  String get su => 'Sundanese';

  /// en: 'Swedish'
  String get sv => 'Swedish';

  /// en: 'Swahili'
  String get sw => 'Swahili';

  /// en: 'Tamil'
  String get ta => 'Tamil';

  /// en: 'Telugu'
  String get te => 'Telugu';

  /// en: 'Tajik'
  String get tg => 'Tajik';

  /// en: 'Thai'
  String get th => 'Thai';

  /// en: 'Turkmen'
  String get tk => 'Turkmen';

  /// en: 'Filipino'
  String get tl => 'Filipino';

  /// en: 'Turkish'
  String get tr => 'Turkish';

  /// en: 'Tatar'
  String get tt => 'Tatar';

  /// en: 'Uyghur'
  String get ug => 'Uyghur';

  /// en: 'Ukrainian'
  String get uk => 'Ukrainian';

  /// en: 'Urdu'
  String get ur => 'Urdu';

  /// en: 'Uzbek'
  String get uz => 'Uzbek';

  /// en: 'Vietnamese'
  String get vi => 'Vietnamese';

  /// en: 'Xhosa'
  String get xh => 'Xhosa';

  /// en: 'Yiddish'
  String get yi => 'Yiddish';

  /// en: 'Yoruba'
  String get yo => 'Yoruba';

  /// en: 'Chinese'
  String get zh => 'Chinese';

  /// en: 'Chinese'
  String get zh_CN => 'Chinese';

  /// en: 'Chinese (Traditional)'
  String get zh_TW => 'Chinese (Traditional)';

  /// en: 'Zulu'
  String get zu => 'Zulu';
}

// Path: translation.engine_scope
class TranslationsTranslationEngineScopeEn {
  TranslationsTranslationEngineScopeEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'detectLanguage'
  String get detect_language => 'detectLanguage';

  /// en: 'LookUp'
  String get lookup => 'LookUp';

  /// en: 'Translate'
  String get translate => 'Translate';
}

// Path: translation.mode
class TranslationsTranslationModeEn {
  TranslationsTranslationModeEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Auto'
  String get auto => 'Auto';

  /// en: 'Manual'
  String get manual => 'Manual';
}

// Path: translation.word_pronunciation
class TranslationsTranslationWordPronunciationEn {
  TranslationsTranslationWordPronunciationEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'US'
  String get us => 'US';

  /// en: 'UK'
  String get uk => 'UK';
}

// Path: ocr.engine
class TranslationsOcrEngineEn {
  TranslationsOcrEngineEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Built In'
  String get built_in => 'Built In';

  /// en: 'Tesseract OCR'
  String get tesseract => 'Tesseract OCR';

  /// en: 'Youdao'
  String get youdao => 'Youdao';
}

// Path: theme.mode
class TranslationsThemeModeEn {
  TranslationsThemeModeEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Light'
  String get light => 'Light';

  /// en: 'Dark'
  String get dark => 'Dark';

  /// en: 'System'
  String get system => 'System';
}

// Path: tray.context_menu
class TranslationsTrayContextMenuEn {
  TranslationsTrayContextMenuEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Show'
  String get show => 'Show';

  /// en: 'Quick Start'
  String get quick_start_guide => 'Quick Start';

  late final TranslationsTrayContextMenuDiscussionEn discussion =
      TranslationsTrayContextMenuDiscussionEn.internal(_root);

  /// en: 'Quit Biyi'
  String get quit_app => 'Quit Biyi';
}

// Path: mini_translator.update_banner
class TranslationsMiniTranslatorUpdateBannerEn {
  TranslationsMiniTranslatorUpdateBannerEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'New version found: {}'
  String get found_new_version => 'New version found: {}';

  late final TranslationsMiniTranslatorUpdateBannerButtonEn button =
      TranslationsMiniTranslatorUpdateBannerButtonEn.internal(_root);
}

// Path: mini_translator.limited_banner
class TranslationsMiniTranslatorLimitedBannerEn {
  TranslationsMiniTranslatorLimitedBannerEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Functionality is limited, please follow the tips to check.'
  String get title =>
      'Functionality is limited, please follow the tips to check.';

  late final TranslationsMiniTranslatorLimitedBannerPermissionEn permission =
      TranslationsMiniTranslatorLimitedBannerPermissionEn.internal(_root);
  late final TranslationsMiniTranslatorLimitedBannerButtonEn button =
      TranslationsMiniTranslatorLimitedBannerButtonEn.internal(_root);
  late final TranslationsMiniTranslatorLimitedBannerTooltipEn tooltip =
      TranslationsMiniTranslatorLimitedBannerTooltipEn.internal(_root);
  late final TranslationsMiniTranslatorLimitedBannerMessageEn message =
      TranslationsMiniTranslatorLimitedBannerMessageEn.internal(_root);
}

// Path: mini_translator.input
class TranslationsMiniTranslatorInputEn {
  TranslationsMiniTranslatorInputEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Enter the word or text here'
  String get hint => 'Enter the word or text here';

  /// en: 'Extracting text...'
  String get extracting_text => 'Extracting text...';
}

// Path: mini_translator.toolbar
class TranslationsMiniTranslatorToolbarEn {
  TranslationsMiniTranslatorToolbarEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsMiniTranslatorToolbarTooltipEn tooltip =
      TranslationsMiniTranslatorToolbarTooltipEn.internal(_root);
}

// Path: mini_translator.button
class TranslationsMiniTranslatorButtonEn {
  TranslationsMiniTranslatorButtonEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Clear'
  String get clear => 'Clear';

  /// en: 'Translate'
  String get translate => 'Translate';
}

// Path: mini_translator.message
class TranslationsMiniTranslatorMessageEn {
  TranslationsMiniTranslatorMessageEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'No text entered or text not extracted'
  String get please_enter_word_or_text =>
      'No text entered or text not extracted';

  /// en: 'Capture screen area has been canceled'
  String get capture_screen_area_canceled =>
      'Capture screen area has been canceled';
}

// Path: settings.general
class TranslationsSettingsGeneralEn {
  TranslationsSettingsGeneralEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'General'
  String get title => 'General';
}

// Path: settings.appearance
class TranslationsSettingsAppearanceEn {
  TranslationsSettingsAppearanceEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Appearance'
  String get title => 'Appearance';
}

// Path: settings.shortcuts
class TranslationsSettingsShortcutsEn {
  TranslationsSettingsShortcutsEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Shortcuts'
  String get title => 'Shortcuts';
}

// Path: settings.input
class TranslationsSettingsInputEn {
  TranslationsSettingsInputEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Input Settings'
  String get title => 'Input Settings';
}

// Path: settings.advanced
class TranslationsSettingsAdvancedEn {
  TranslationsSettingsAdvancedEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Advanced'
  String get title => 'Advanced';

  /// en: 'No advanced settings available.'
  String get empty => 'No advanced settings available.';
}

// Path: settings.providers
class TranslationsSettingsProvidersEn {
  TranslationsSettingsProvidersEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Providers'
  String get title => 'Providers';

  /// en: 'Add a Provider...'
  String get add => 'Add a Provider...';

  /// en: 'Add Provider'
  String get add_title => 'Add Provider';

  /// en: 'Edit Provider'
  String get edit_title => 'Edit Provider';

  /// en: 'Delete Provider'
  String get delete_title => 'Delete Provider';

  /// en: 'Delete "{}"?'
  String get delete_confirm => 'Delete "{}"?';

  /// en: 'This action cannot be undone.'
  String get delete_message => 'This action cannot be undone.';

  /// en: 'No providers configured. Add one to enable translation services.'
  String get empty =>
      'No providers configured. Add one to enable translation services.';

  /// en: 'Error'
  String get error => 'Error';

  /// en: 'Help'
  String get help => 'Help';

  /// en: 'Edit provider'
  String get help_edit => 'Edit provider';

  /// en: 'Provider ID'
  String get id => 'Provider ID';

  /// en: 'e.g. deepl-main'
  String get id_placeholder => 'e.g. deepl-main';

  /// en: 'Choose the translation and dictionary providers used by the app.'
  String get intro =>
      'Choose the translation and dictionary providers used by the app.';

  /// en: 'Providers you add may process the text you send, so only connect services you trust.'
  String get intro_warning =>
      'Providers you add may process the text you send, so only connect services you trust.';

  /// en: 'Loading providers...'
  String get loading => 'Loading providers...';

  /// en: 'Provider Type'
  String get type => 'Provider Type';

  /// en: 'Services'
  String get services => 'Services';

  /// en: 'No services available.'
  String get no_services => 'No services available.';

  late final TranslationsSettingsProvidersCapabilityEn capability =
      TranslationsSettingsProvidersCapabilityEn.internal(_root);
  late final TranslationsSettingsProvidersDescriptionEn description =
      TranslationsSettingsProvidersDescriptionEn.internal(_root);
}

// Path: settings.service_integration
class TranslationsSettingsServiceIntegrationEn {
  TranslationsSettingsServiceIntegrationEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Service Integration'
  String get title => 'Service Integration';
}

// Path: settings.others
class TranslationsSettingsOthersEn {
  TranslationsSettingsOthersEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Others'
  String get title => 'Others';
}

// Path: settings.exit_app_dialog
class TranslationsSettingsExitAppDialogEn {
  TranslationsSettingsExitAppDialogEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Are you sure you want to exit?'
  String get title => 'Are you sure you want to exit?';
}

// Path: settings.preference
class TranslationsSettingsPreferenceEn {
  TranslationsSettingsPreferenceEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Your Plan'
  String get your_plan => 'Your Plan';

  /// en: 'Extract text'
  String get extract_text => 'Extract text';

  /// en: 'Translate'
  String get translate => 'Translate';

  /// en: 'Interface'
  String get interface => 'Interface';

  /// en: 'Display Language'
  String get app_language => 'Display Language';

  /// en: 'Theme Mode'
  String get theme_mode => 'Theme Mode';

  /// en: 'Keyboard Shortcuts'
  String get keyboard_shortcuts => 'Keyboard Shortcuts';

  /// en: 'Submit with Enter'
  String get submit_with_enter => 'Submit with Enter';

  /// en: 'Submit with Ctrl + Enter'
  String get submit_with_meta_enter => 'Submit with Ctrl + Enter';

  /// en: 'Submit with ⌘ + Enter'
  String get submit_with_meta_enter_mac => 'Submit with ⌘ + Enter';

  /// en: 'Launch when you log in'
  String get launch_at_startup => 'Launch when you log in';

  /// en: 'Show menu bar'
  String get show_menu_bar => 'Show menu bar';

  /// en: 'Permissions'
  String get permissions => 'Permissions';

  /// en: 'Default extract text service'
  String get default_extract_text_service => 'Default extract text service';

  /// en: 'Auto copy detected text'
  String get auto_copy_detected_text => 'Auto copy detected text';

  /// en: 'Directory'
  String get directory => 'Directory';

  /// en: 'Default directory service'
  String get default_directory_service => 'Default directory service';

  /// en: 'Translation'
  String get translation => 'Translation';

  /// en: 'Default translation service'
  String get default_translation_service => 'Default translation service';

  /// en: 'Translation mode'
  String get translation_mode => 'Translation mode';

  /// en: 'Double click to copy translation result'
  String get double_click_copy_result =>
      'Double click to copy translation result';

  /// en: 'Translation Target'
  String get translation_target => 'Translation Target';

  /// en: 'Add Target'
  String get add_target => 'Add Target';

  /// en: 'Text Translation'
  String get engines => 'Text Translation';

  /// en: 'Text Detection'
  String get ocr_engines => 'Text Detection';

  /// en: 'About Biyi'
  String get about => 'About Biyi';

  /// en: 'Exit App'
  String get exit_app => 'Exit App';
}

// Path: settings.empty
class TranslationsSettingsEmptyEn {
  TranslationsSettingsEmptyEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Select a Category'
  String get title => 'Select a Category';

  /// en: 'Choose a settings section from the sidebar.'
  String get message => 'Choose a settings section from the sidebar.';
}

// Path: settings.option
class TranslationsSettingsOptionEn {
  TranslationsSettingsOptionEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'None'
  String get none => 'None';

  /// en: 'No services available'
  String get no_services_available => 'No services available';

  /// en: 'Granted'
  String get granted => 'Granted';

  /// en: 'Built-in OCR'
  String get built_in_ocr => 'Built-in OCR';

  /// en: 'Tesseract'
  String get tesseract => 'Tesseract';

  /// en: 'Youdao OCR'
  String get youdao_ocr => 'Youdao OCR';

  /// en: 'English'
  String get english => 'English';

  /// en: 'Chinese'
  String get chinese => 'Chinese';
}

// Path: settings.shortcut
class TranslationsSettingsShortcutEn {
  TranslationsSettingsShortcutEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Shortcuts'
  String get section => 'Shortcuts';

  /// en: 'Show or Hide'
  String get show_or_hide => 'Show or Hide';

  /// en: 'Hide'
  String get hide => 'Hide';

  /// en: 'Extract Text'
  String get extract_text => 'Extract Text';

  /// en: 'Extract text from selection'
  String get extract_selection => 'Extract text from selection';

  /// en: 'Extract text from capture'
  String get extract_capture => 'Extract text from capture';

  /// en: 'Extract text from clipboard'
  String get extract_clipboard => 'Extract text from clipboard';

  /// en: 'Input Assist Function'
  String get input_assist => 'Input Assist Function';

  /// en: 'Translate input content'
  String get translate_input => 'Translate input content';
}

// Path: shortcuts.record_dialog
class TranslationsShortcutsRecordDialogEn {
  TranslationsShortcutsRecordDialogEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Customize your shortcut'
  String get title => 'Customize your shortcut';
}

// Path: tray.context_menu.discussion
class TranslationsTrayContextMenuDiscussionEn {
  TranslationsTrayContextMenuDiscussionEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Join Discussion'
  String get title => 'Join Discussion';

  /// en: 'Join Discord'
  String get discord_server => 'Join Discord';

  /// en: 'Join QQ Group'
  String get qq_group => 'Join QQ Group';
}

// Path: mini_translator.update_banner.button
class TranslationsMiniTranslatorUpdateBannerButtonEn {
  TranslationsMiniTranslatorUpdateBannerButtonEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Update'
  String get update => 'Update';
}

// Path: mini_translator.limited_banner.permission
class TranslationsMiniTranslatorLimitedBannerPermissionEn {
  TranslationsMiniTranslatorLimitedBannerPermissionEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Grant screen recording access'
  String get screen_capture => 'Grant screen recording access';

  /// en: 'Grant accessibility access'
  String get screen_selection => 'Grant accessibility access';
}

// Path: mini_translator.limited_banner.button
class TranslationsMiniTranslatorLimitedBannerButtonEn {
  TranslationsMiniTranslatorLimitedBannerButtonEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Allow'
  String get allow => 'Allow';

  /// en: 'Go Settings'
  String get go_settings => 'Go Settings';

  /// en: 'Check Again'
  String get check_again => 'Check Again';
}

// Path: mini_translator.limited_banner.tooltip
class TranslationsMiniTranslatorLimitedBannerTooltipEn {
  TranslationsMiniTranslatorLimitedBannerTooltipEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'View the help document'
  String get help => 'View the help document';
}

// Path: mini_translator.limited_banner.message
class TranslationsMiniTranslatorLimitedBannerMessageEn {
  TranslationsMiniTranslatorLimitedBannerMessageEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'If there is no response after clicking "Allow", please click "Go Settings" to set it manually.'
  String get allow_access_tip =>
      'If there is no response after clicking "Allow", please click "Go Settings" to set it manually.';

  /// en: 'The Screen extract text is enabled'
  String get all_access_allowed => 'The Screen extract text is enabled';

  /// en: 'The required access are not allowed. Please check and set again.'
  String get all_access_not_allowed =>
      'The required access are not allowed.\nPlease check and set again.';
}

// Path: mini_translator.toolbar.tooltip
class TranslationsMiniTranslatorToolbarTooltipEn {
  TranslationsMiniTranslatorToolbarTooltipEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Current translation mode: {}'
  String get translation_mode => 'Current translation mode: {}';

  /// en: 'Capture screen area and recognize text'
  String get extract_text_from_screen_capture =>
      'Capture screen area and recognize text';

  /// en: 'Read clipboard content'
  String get extract_text_from_clipboard => 'Read clipboard content';
}

// Path: settings.providers.capability
class TranslationsSettingsProvidersCapabilityEn {
  TranslationsSettingsProvidersCapabilityEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Translation'
  String get translation => 'Translation';

  /// en: 'Dictionary'
  String get dictionary => 'Dictionary';
}

// Path: settings.providers.description
class TranslationsSettingsProvidersDescriptionEn {
  TranslationsSettingsProvidersDescriptionEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Provides dictionary lookup and text translation'
  String get all => 'Provides dictionary lookup and text translation';

  /// en: 'Provides text translation between languages'
  String get translation => 'Provides text translation between languages';

  /// en: 'Provides dictionary lookup and word definitions'
  String get dictionary => 'Provides dictionary lookup and word definitions';

  /// en: 'Provides translation services'
  String get fallback => 'Provides translation services';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
  dynamic _flatMapFunction(String path) {
    return switch (path) {
      'common.app.name' => 'Beyond Translate',
      'common.button.ok' => 'OK',
      'common.button.cancel' => 'Cancel',
      'common.button.add' => 'Add',
      'common.button.delete' => 'Delete',
      'common.button.edit' => 'Edit',
      'common.button.save' => 'Save',
      'common.button.manage' => 'Manage',
      'common.feedback.copied' => 'Copied',
      'common.placeholder.choose' => 'Please Choose',
      'common.language.af' => 'Afrikaans',
      'common.language.am' => 'Amharic',
      'common.language.ar' => 'Arabic',
      'common.language.az' => 'Azerbaijani',
      'common.language.be' => 'Belarusian',
      'common.language.bg' => 'Bulgarian',
      'common.language.bn' => 'Bengali',
      'common.language.bs' => 'Bosnian',
      'common.language.ca' => 'Catalan',
      'common.language.ceb' => 'Cebuano',
      'common.language.co' => 'Corsican',
      'common.language.cs' => 'Czech',
      'common.language.cy' => 'Welsh',
      'common.language.da' => 'Danish',
      'common.language.de' => 'German',
      'common.language.el' => 'Greek',
      'common.language.en' => 'English',
      'common.language.eo' => 'Esperanto',
      'common.language.es' => 'Spanish',
      'common.language.et' => 'Estonian',
      'common.language.eu' => 'Basque',
      'common.language.fa' => 'Persian',
      'common.language.fi' => 'Finnish',
      'common.language.fr' => 'French',
      'common.language.fy' => 'Frisian',
      'common.language.ga' => 'Irish',
      'common.language.gd' => 'Scots Gaelic',
      'common.language.gl' => 'Galician',
      'common.language.gu' => 'Gujarati',
      'common.language.ha' => 'Hausa',
      'common.language.haw' => 'Hawaiian',
      'common.language.he' => 'Hebrew',
      'common.language.hi' => 'Hindi',
      'common.language.hmn' => 'Hmong',
      'common.language.hr' => 'Croatian',
      'common.language.ht' => 'Haitian Creole',
      'common.language.hu' => 'Hungarian',
      'common.language.hy' => 'Armenian',
      'common.language.id' => 'Indonesian',
      'common.language.ig' => 'Igbo',
      'common.language.kIs' => 'Icelandic',
      'common.language.it' => 'Italian',
      'common.language.iw' => 'Hebrew',
      'common.language.ja' => 'Japanese',
      'common.language.jw' => 'Javanese',
      'common.language.ka' => 'Georgian',
      'common.language.kk' => 'Kazakh',
      'common.language.km' => 'Khmer',
      'common.language.kn' => 'Kannada',
      'common.language.ko' => 'Korean',
      'common.language.ku' => 'Kurdish (Kurmanji)',
      'common.language.ky' => 'Kyrgyz',
      'common.language.la' => 'Latin',
      'common.language.lb' => 'Luxembourgish',
      'common.language.lo' => 'Lao',
      'common.language.lt' => 'Lithuanian',
      'common.language.lv' => 'Latvian',
      'common.language.mg' => 'Malagasy',
      'common.language.mi' => 'Maori',
      'common.language.mk' => 'Macedonian',
      'common.language.ml' => 'Malayalam',
      'common.language.mn' => 'Mongolian',
      'common.language.mr' => 'Marathi',
      'common.language.ms' => 'Malay',
      'common.language.mt' => 'Maltese',
      'common.language.my' => 'Myanmar (Burmese)',
      'common.language.ne' => 'Nepali',
      'common.language.nl' => 'Dutch',
      'common.language.no' => 'Norwegian',
      'common.language.ny' => 'Chichewa',
      'common.language.or' => 'Odia (Oriya)',
      'common.language.pa' => 'Punjabi',
      'common.language.pl' => 'Polish',
      'common.language.ps' => 'Pashto',
      'common.language.pt' => 'Portuguese',
      'common.language.ro' => 'Romanian',
      'common.language.ru' => 'Russian',
      'common.language.rw' => 'Kinyarwanda',
      'common.language.sd' => 'Sindhi',
      'common.language.si' => 'Sinhala',
      'common.language.sk' => 'Slovak',
      'common.language.sl' => 'Slovenian',
      'common.language.sm' => 'Samoan',
      'common.language.sn' => 'Shona',
      'common.language.so' => 'Somali',
      'common.language.sq' => 'Albanian',
      'common.language.sr' => 'Serbian',
      'common.language.st' => 'Sesotho',
      'common.language.su' => 'Sundanese',
      'common.language.sv' => 'Swedish',
      'common.language.sw' => 'Swahili',
      'common.language.ta' => 'Tamil',
      'common.language.te' => 'Telugu',
      'common.language.tg' => 'Tajik',
      'common.language.th' => 'Thai',
      'common.language.tk' => 'Turkmen',
      'common.language.tl' => 'Filipino',
      'common.language.tr' => 'Turkish',
      'common.language.tt' => 'Tatar',
      'common.language.ug' => 'Uyghur',
      'common.language.uk' => 'Ukrainian',
      'common.language.ur' => 'Urdu',
      'common.language.uz' => 'Uzbek',
      'common.language.vi' => 'Vietnamese',
      'common.language.xh' => 'Xhosa',
      'common.language.yi' => 'Yiddish',
      'common.language.yo' => 'Yoruba',
      'common.language.zh' => 'Chinese',
      'common.language.zh_CN' => 'Chinese',
      'common.language.zh_TW' => 'Chinese (Traditional)',
      'common.language.zu' => 'Zulu',
      'provider.baidu' => 'Baidu',
      'provider.caiyun' => 'Caiyun',
      'provider.deepl' => 'DeepL',
      'provider.google' => 'Google',
      'provider.ibmwatson' => 'IBMWatson',
      'provider.iciba' => 'Iciba',
      'provider.openai' => 'OpenAI',
      'provider.sogou' => 'Sogou',
      'provider.tencent' => 'Tencent',
      'provider.youdao' => 'Youda',
      'translation.engine_scope.detect_language' => 'detectLanguage',
      'translation.engine_scope.lookup' => 'LookUp',
      'translation.engine_scope.translate' => 'Translate',
      'translation.mode.auto' => 'Auto',
      'translation.mode.manual' => 'Manual',
      'translation.word_pronunciation.us' => 'US',
      'translation.word_pronunciation.uk' => 'UK',
      'ocr.engine.built_in' => 'Built In',
      'ocr.engine.tesseract' => 'Tesseract OCR',
      'ocr.engine.youdao' => 'Youdao',
      'theme.mode.light' => 'Light',
      'theme.mode.dark' => 'Dark',
      'theme.mode.system' => 'System',
      'tray.context_menu.show' => 'Show',
      'tray.context_menu.quick_start_guide' => 'Quick Start',
      'tray.context_menu.discussion.title' => 'Join Discussion',
      'tray.context_menu.discussion.discord_server' => 'Join Discord',
      'tray.context_menu.discussion.qq_group' => 'Join QQ Group',
      'tray.context_menu.quit_app' => 'Quit Biyi',
      'mini_translator.update_banner.found_new_version' =>
        'New version found: {}',
      'mini_translator.update_banner.button.update' => 'Update',
      'mini_translator.limited_banner.title' =>
        'Functionality is limited, please follow the tips to check.',
      'mini_translator.limited_banner.permission.screen_capture' =>
        'Grant screen recording access',
      'mini_translator.limited_banner.permission.screen_selection' =>
        'Grant accessibility access',
      'mini_translator.limited_banner.button.allow' => 'Allow',
      'mini_translator.limited_banner.button.go_settings' => 'Go Settings',
      'mini_translator.limited_banner.button.check_again' => 'Check Again',
      'mini_translator.limited_banner.tooltip.help' => 'View the help document',
      'mini_translator.limited_banner.message.allow_access_tip' =>
        'If there is no response after clicking "Allow", please click "Go Settings" to set it manually.',
      'mini_translator.limited_banner.message.all_access_allowed' =>
        'The Screen extract text is enabled',
      'mini_translator.limited_banner.message.all_access_not_allowed' =>
        'The required access are not allowed.\nPlease check and set again.',
      'mini_translator.input.hint' => 'Enter the word or text here',
      'mini_translator.input.extracting_text' => 'Extracting text...',
      'mini_translator.toolbar.tooltip.translation_mode' =>
        'Current translation mode: {}',
      'mini_translator.toolbar.tooltip.extract_text_from_screen_capture' =>
        'Capture screen area and recognize text',
      'mini_translator.toolbar.tooltip.extract_text_from_clipboard' =>
        'Read clipboard content',
      'mini_translator.button.clear' => 'Clear',
      'mini_translator.button.translate' => 'Translate',
      'mini_translator.message.please_enter_word_or_text' =>
        'No text entered or text not extracted',
      'mini_translator.message.capture_screen_area_canceled' =>
        'Capture screen area has been canceled',
      'settings.title' => 'Settings',
      'settings.version' => 'Version {} BUILD {}',
      'settings.general.title' => 'General',
      'settings.appearance.title' => 'Appearance',
      'settings.shortcuts.title' => 'Shortcuts',
      'settings.input.title' => 'Input Settings',
      'settings.advanced.title' => 'Advanced',
      'settings.advanced.empty' => 'No advanced settings available.',
      'settings.providers.title' => 'Providers',
      'settings.providers.add' => 'Add a Provider...',
      'settings.providers.add_title' => 'Add Provider',
      'settings.providers.edit_title' => 'Edit Provider',
      'settings.providers.delete_title' => 'Delete Provider',
      'settings.providers.delete_confirm' => 'Delete "{}"?',
      'settings.providers.delete_message' => 'This action cannot be undone.',
      'settings.providers.empty' =>
        'No providers configured. Add one to enable translation services.',
      'settings.providers.error' => 'Error',
      'settings.providers.help' => 'Help',
      'settings.providers.help_edit' => 'Edit provider',
      'settings.providers.id' => 'Provider ID',
      'settings.providers.id_placeholder' => 'e.g. deepl-main',
      'settings.providers.intro' =>
        'Choose the translation and dictionary providers used by the app.',
      'settings.providers.intro_warning' =>
        'Providers you add may process the text you send, so only connect services you trust.',
      'settings.providers.loading' => 'Loading providers...',
      'settings.providers.type' => 'Provider Type',
      'settings.providers.services' => 'Services',
      'settings.providers.no_services' => 'No services available.',
      'settings.providers.capability.translation' => 'Translation',
      'settings.providers.capability.dictionary' => 'Dictionary',
      'settings.providers.description.all' =>
        'Provides dictionary lookup and text translation',
      'settings.providers.description.translation' =>
        'Provides text translation between languages',
      'settings.providers.description.dictionary' =>
        'Provides dictionary lookup and word definitions',
      'settings.providers.description.fallback' =>
        'Provides translation services',
      'settings.service_integration.title' => 'Service Integration',
      'settings.others.title' => 'Others',
      'settings.exit_app_dialog.title' => 'Are you sure you want to exit?',
      'settings.preference.your_plan' => 'Your Plan',
      'settings.preference.extract_text' => 'Extract text',
      'settings.preference.translate' => 'Translate',
      'settings.preference.interface' => 'Interface',
      'settings.preference.app_language' => 'Display Language',
      'settings.preference.theme_mode' => 'Theme Mode',
      'settings.preference.keyboard_shortcuts' => 'Keyboard Shortcuts',
      'settings.preference.submit_with_enter' => 'Submit with Enter',
      'settings.preference.submit_with_meta_enter' =>
        'Submit with Ctrl + Enter',
      'settings.preference.submit_with_meta_enter_mac' =>
        'Submit with ⌘ + Enter',
      'settings.preference.launch_at_startup' => 'Launch when you log in',
      'settings.preference.show_menu_bar' => 'Show menu bar',
      'settings.preference.permissions' => 'Permissions',
      'settings.preference.default_extract_text_service' =>
        'Default extract text service',
      'settings.preference.auto_copy_detected_text' =>
        'Auto copy detected text',
      'settings.preference.directory' => 'Directory',
      'settings.preference.default_directory_service' =>
        'Default directory service',
      'settings.preference.translation' => 'Translation',
      'settings.preference.default_translation_service' =>
        'Default translation service',
      'settings.preference.translation_mode' => 'Translation mode',
      'settings.preference.double_click_copy_result' =>
        'Double click to copy translation result',
      'settings.preference.translation_target' => 'Translation Target',
      'settings.preference.add_target' => 'Add Target',
      'settings.preference.engines' => 'Text Translation',
      'settings.preference.ocr_engines' => 'Text Detection',
      'settings.preference.about' => 'About Biyi',
      'settings.preference.exit_app' => 'Exit App',
      'settings.empty.title' => 'Select a Category',
      'settings.empty.message' => 'Choose a settings section from the sidebar.',
      'settings.option.none' => 'None',
      'settings.option.no_services_available' => 'No services available',
      'settings.option.granted' => 'Granted',
      'settings.option.built_in_ocr' => 'Built-in OCR',
      'settings.option.tesseract' => 'Tesseract',
      'settings.option.youdao_ocr' => 'Youdao OCR',
      'settings.option.english' => 'English',
      'settings.option.chinese' => 'Chinese',
      'settings.shortcut.section' => 'Shortcuts',
      'settings.shortcut.show_or_hide' => 'Show or Hide',
      'settings.shortcut.hide' => 'Hide',
      'settings.shortcut.extract_text' => 'Extract Text',
      'settings.shortcut.extract_selection' => 'Extract text from selection',
      'settings.shortcut.extract_capture' => 'Extract text from capture',
      'settings.shortcut.extract_clipboard' => 'Extract text from clipboard',
      'settings.shortcut.input_assist' => 'Input Assist Function',
      'settings.shortcut.translate_input' => 'Translate input content',
      'shortcuts.record_dialog.title' => 'Customize your shortcut',
      _ => null,
    };
  }
}
