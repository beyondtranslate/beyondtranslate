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

  /// en: 'Biyi'
  String get app_name => 'Biyi';

  /// en: 'OK'
  String get ok => 'OK';

  /// en: 'Cancel'
  String get cancel => 'Cancel';

  /// en: 'Add'
  String get add => 'Add';

  /// en: 'Delete'
  String get delete => 'Delete';

  /// en: 'Copied'
  String get copied => 'Copied';

  /// en: 'Please Choose'
  String get please_choose => 'Please Choose';

  late final TranslationsLanguageEn language =
      TranslationsLanguageEn.internal(_root);
  late final TranslationsEngineEn engine = TranslationsEngineEn.internal(_root);
  late final TranslationsEngineScopeEn engine_scope =
      TranslationsEngineScopeEn.internal(_root);
  late final TranslationsOcrEngineEn ocr_engine =
      TranslationsOcrEngineEn.internal(_root);
  late final TranslationsTranslationModeEn translation_mode =
      TranslationsTranslationModeEn.internal(_root);
  late final TranslationsThemeModeEn theme_mode =
      TranslationsThemeModeEn.internal(_root);
  late final TranslationsWordPronunciationEn word_pronunciation =
      TranslationsWordPronunciationEn.internal(_root);
  late final TranslationsTrayContextMenuEn tray_context_menu =
      TranslationsTrayContextMenuEn.internal(_root);
  late final TranslationsMiniTranslatorEn mini_translator =
      TranslationsMiniTranslatorEn.internal(_root);
  late final TranslationsPageLanguageChooserEn page_language_chooser =
      TranslationsPageLanguageChooserEn.internal(_root);
  late final TranslationsPageOcrEngineChooserEn page_ocr_engine_chooser =
      TranslationsPageOcrEngineChooserEn.internal(_root);
  late final TranslationsPageOcrEngineCreateOrEditEn
      page_ocr_engine_create_or_edit =
      TranslationsPageOcrEngineCreateOrEditEn.internal(_root);
  late final TranslationsPageOcrEngineTypeChooserEn
      page_ocr_engine_type_chooser =
      TranslationsPageOcrEngineTypeChooserEn.internal(_root);
  late final TranslationsPageOcrEnginesManageEn page_ocr_engines_manage =
      TranslationsPageOcrEnginesManageEn.internal(_root);
  late final TranslationsPageSettingAppLanguageEn page_setting_app_language =
      TranslationsPageSettingAppLanguageEn.internal(_root);
  late final TranslationsPageSettingExtractTextEn page_setting_extract_text =
      TranslationsPageSettingExtractTextEn.internal(_root);
  late final TranslationsPageSettingInterfaceEn page_setting_interface =
      TranslationsPageSettingInterfaceEn.internal(_root);
  late final TranslationsPageSettingShortcutsEn page_setting_shortcuts =
      TranslationsPageSettingShortcutsEn.internal(_root);
  late final TranslationsPageSettingThemeModeEn page_setting_theme_mode =
      TranslationsPageSettingThemeModeEn.internal(_root);
  late final TranslationsPageSettingTranslateEn page_setting_translate =
      TranslationsPageSettingTranslateEn.internal(_root);
  late final TranslationsPageSettingsEn page_settings =
      TranslationsPageSettingsEn.internal(_root);
  late final TranslationsPageTranslationEngineChooserEn
      page_translation_engine_chooser =
      TranslationsPageTranslationEngineChooserEn.internal(_root);
  late final TranslationsPageTranslationEngineCreateOrEditEn
      page_translation_engine_create_or_edit =
      TranslationsPageTranslationEngineCreateOrEditEn.internal(_root);
  late final TranslationsPageTranslationEngineTypeChooserEn
      page_translation_engine_type_chooser =
      TranslationsPageTranslationEngineTypeChooserEn.internal(_root);
  late final TranslationsPageTranslationEnginesManageEn
      page_translation_engines_manage =
      TranslationsPageTranslationEnginesManageEn.internal(_root);
  late final TranslationsPageTranslationTargetNewEn
      page_translation_target_new =
      TranslationsPageTranslationTargetNewEn.internal(_root);
  late final TranslationsPageYourPlanSelectorEn page_your_plan_selector =
      TranslationsPageYourPlanSelectorEn.internal(_root);
  late final TranslationsWidgetRecordShortcutDialogEn
      widget_record_shortcut_dialog =
      TranslationsWidgetRecordShortcutDialogEn.internal(_root);
}

// Path: language
class TranslationsLanguageEn {
  TranslationsLanguageEn.internal(this._root);

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

// Path: engine
class TranslationsEngineEn {
  TranslationsEngineEn.internal(this._root);

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

// Path: engine_scope
class TranslationsEngineScopeEn {
  TranslationsEngineScopeEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'detectLanguage'
  String get detectlanguage => 'detectLanguage';

  /// en: 'LookUp'
  String get lookup => 'LookUp';

  /// en: 'Translate'
  String get translate => 'Translate';
}

// Path: ocr_engine
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

// Path: translation_mode
class TranslationsTranslationModeEn {
  TranslationsTranslationModeEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Auto'
  String get auto => 'Auto';

  /// en: 'Manual'
  String get manual => 'Manual';
}

// Path: theme_mode
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

// Path: word_pronunciation
class TranslationsWordPronunciationEn {
  TranslationsWordPronunciationEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'US'
  String get us => 'US';

  /// en: 'UK'
  String get uk => 'UK';
}

// Path: tray_context_menu
class TranslationsTrayContextMenuEn {
  TranslationsTrayContextMenuEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Show'
  String get item_show => 'Show';

  /// en: 'Quick Start'
  String get item_quick_start_guide => 'Quick Start';

  /// en: 'Join Discussion'
  String get item_discussion => 'Join Discussion';

  /// en: 'Quit Biyi'
  String get item_quit_app => 'Quit Biyi';

  /// en: 'Join Discord'
  String get item_discussion_subitem_discord_server => 'Join Discord';

  /// en: 'Join QQ Group'
  String get item_discussion_subitem_qq_group => 'Join QQ Group';
}

// Path: mini_translator
class TranslationsMiniTranslatorEn {
  TranslationsMiniTranslatorEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'New version found: {}'
  String get newversion_banner_text_found_new_version =>
      'New version found: {}';

  /// en: 'Update'
  String get newversion_banner_btn_update => 'Update';

  /// en: 'Functionality is limited, please follow the tips to check.'
  String get limited_banner_title =>
      'Functionality is limited, please follow the tips to check.';

  /// en: 'Grant screen recording access'
  String get limited_banner_text_screen_capture =>
      'Grant screen recording access';

  /// en: 'Grant accessibility access'
  String get limited_banner_text_screen_selection =>
      'Grant accessibility access';

  /// en: 'Allow'
  String get limited_banner_btn_allow => 'Allow';

  /// en: 'Go Settings'
  String get limited_banner_btn_go_settings => 'Go Settings';

  /// en: 'Check Again'
  String get limited_banner_btn_check_again => 'Check Again';

  /// en: 'View the help document'
  String get limited_banner_tip_help => 'View the help document';

  /// en: 'If there is no response after clicking "Allow", please click "Go Settings" to set it manually.'
  String get limited_banner_msg_allow_access_tip =>
      'If there is no response after clicking "Allow", please click "Go Settings" to set it manually.';

  /// en: 'The Screen extract text is enabled'
  String get limited_banner_msg_all_access_allowed =>
      'The Screen extract text is enabled';

  /// en: 'The required access are not allowed. Please check and set again.'
  String get limited_banner_msg_all_access_not_allowed =>
      'The required access are not allowed.\nPlease check and set again.';

  /// en: 'Enter the word or text here'
  String get input_hint => 'Enter the word or text here';

  /// en: 'Extracting text...'
  String get text_extracting_text => 'Extracting text...';

  /// en: 'Current translation mode: {}'
  String get tip_translation_mode => 'Current translation mode: {}';

  /// en: 'Capture screen area and recognize text'
  String get tip_extract_text_from_screen_capture =>
      'Capture screen area and recognize text';

  /// en: 'Read clipboard content'
  String get tip_extract_text_from_clipboard => 'Read clipboard content';

  /// en: 'Clear'
  String get btn_clear => 'Clear';

  /// en: 'Translate'
  String get btn_trans => 'Translate';

  /// en: 'No text entered or text not extracted'
  String get msg_please_enter_word_or_text =>
      'No text entered or text not extracted';

  /// en: 'Capture screen area has been canceled'
  String get msg_capture_screen_area_canceled =>
      'Capture screen area has been canceled';
}

// Path: page_language_chooser
class TranslationsPageLanguageChooserEn {
  TranslationsPageLanguageChooserEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Choose language'
  String get title => 'Choose language';

  /// en: 'All'
  String get pref_section_title_all => 'All';
}

// Path: page_ocr_engine_chooser
class TranslationsPageOcrEngineChooserEn {
  TranslationsPageOcrEngineChooserEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Text Detection Engine'
  String get title => 'Text Detection Engine';

  /// en: 'Private'
  String get pref_section_title_private => 'Private';

  /// en: 'No available engines'
  String get pref_item_title_no_available_engines => 'No available engines';
}

// Path: page_ocr_engine_create_or_edit
class TranslationsPageOcrEngineCreateOrEditEn {
  TranslationsPageOcrEngineCreateOrEditEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Add Text Detection Engine'
  String get title => 'Add Text Detection Engine';

  /// en: 'Engine type'
  String get pref_section_title_engine_type => 'Engine type';

  /// en: 'Option'
  String get pref_section_title_option => 'Option';
}

// Path: page_ocr_engine_type_chooser
class TranslationsPageOcrEngineTypeChooserEn {
  TranslationsPageOcrEngineTypeChooserEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Engine Type'
  String get title => 'Engine Type';
}

// Path: page_ocr_engines_manage
class TranslationsPageOcrEnginesManageEn {
  TranslationsPageOcrEnginesManageEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Text Detection Engine'
  String get title => 'Text Detection Engine';

  /// en: 'Private'
  String get pref_section_title_private => 'Private';

  /// en: 'Long press an item to reorder it'
  String get pref_section_description_private =>
      'Long press an item to reorder it';
}

// Path: page_setting_app_language
class TranslationsPageSettingAppLanguageEn {
  TranslationsPageSettingAppLanguageEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Display Language'
  String get title => 'Display Language';
}

// Path: page_setting_extract_text
class TranslationsPageSettingExtractTextEn {
  TranslationsPageSettingExtractTextEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Screen extract text'
  String get title => 'Screen extract text';

  /// en: 'Default detect text engine'
  String get pref_section_title_default_detect_text_engine =>
      'Default detect text engine';

  /// en: 'Auto copy the detected text'
  String get pref_item_auto_copy_detected_text => 'Auto copy the detected text';
}

// Path: page_setting_interface
class TranslationsPageSettingInterfaceEn {
  TranslationsPageSettingInterfaceEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Interface'
  String get title => 'Interface';

  /// en: 'Tray Icon'
  String get pref_section_title_tray_icon => 'Tray Icon';

  /// en: 'Tray Icon Style'
  String get pref_section_title_tray_icon_style => 'Tray Icon Style';

  /// en: 'Maximum window height (logical pixels)'
  String get pref_section_title_max_window_height =>
      'Maximum window height (logical pixels)';

  /// en: 'Show Tray Icon'
  String get pref_item_title_show_tray_icon => 'Show Tray Icon';
}

// Path: page_setting_shortcuts
class TranslationsPageSettingShortcutsEn {
  TranslationsPageSettingShortcutsEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Shortcuts'
  String get title => 'Shortcuts';

  /// en: 'Screen / Clipboard extract text'
  String get pref_section_title_extract_text =>
      'Screen / Clipboard extract text';

  /// en: 'Input assist function'
  String get pref_section_title_input_assist_function =>
      'Input assist function';

  /// en: 'Show/Hide'
  String get pref_item_title_show_or_hide => 'Show/Hide';

  /// en: 'Hide'
  String get pref_item_title_hide => 'Hide';

  /// en: 'Selection'
  String get pref_item_title_extract_text_from_selection => 'Selection';

  /// en: 'Capture Area'
  String get pref_item_title_extract_text_from_capture => 'Capture Area';

  /// en: 'Clipboard'
  String get pref_item_title_extract_text_from_clipboard => 'Clipboard';

  /// en: 'Translate input content'
  String get pref_item_title_translate_input_content =>
      'Translate input content';
}

// Path: page_setting_theme_mode
class TranslationsPageSettingThemeModeEn {
  TranslationsPageSettingThemeModeEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Theme Mode'
  String get title => 'Theme Mode';
}

// Path: page_setting_translate
class TranslationsPageSettingTranslateEn {
  TranslationsPageSettingTranslateEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Translate'
  String get title => 'Translate';

  /// en: 'Default translate engine'
  String get pref_section_title_default_translate_engine =>
      'Default translate engine';

  /// en: 'Translation mode'
  String get pref_section_title_translation_mode => 'Translation mode';

  /// en: 'Default detect language engine'
  String get pref_section_title_default_detect_language_engine =>
      'Default detect language engine';

  /// en: 'Translation target'
  String get pref_section_title_translation_target => 'Translation target';

  /// en: 'Double-click to copy translation result'
  String get pref_item_title_double_click_copy_result =>
      'Double-click to copy translation result';
}

// Path: page_settings
class TranslationsPageSettingsEn {
  TranslationsPageSettingsEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Settings'
  String get title => 'Settings';

  /// en: 'Version {} BUILD {}'
  String get text_version => 'Version {} BUILD {}';

  /// en: 'General'
  String get pref_section_title_general => 'General';

  /// en: 'Appearance'
  String get pref_section_title_appearance => 'Appearance';

  /// en: 'Shortcuts'
  String get pref_section_title_shortcuts => 'Shortcuts';

  /// en: 'Input Settings'
  String get pref_section_title_input_settings => 'Input Settings';

  /// en: 'Advanced'
  String get pref_section_title_advanced => 'Advanced';

  /// en: 'Service Integration'
  String get pref_section_title_service_integration => 'Service Integration';

  /// en: 'Others'
  String get pref_section_title_others => 'Others';

  /// en: 'Your Plan'
  String get pref_item_title_your_plan => 'Your Plan';

  /// en: 'Extract text'
  String get pref_item_title_extract_text => 'Extract text';

  /// en: 'Interface'
  String get pref_item_title_interface => 'Interface';

  /// en: 'Translate'
  String get pref_item_title_translate => 'Translate';

  /// en: 'Display Language'
  String get pref_item_title_app_language => 'Display Language';

  /// en: 'Theme Mode'
  String get pref_item_title_theme_mode => 'Theme Mode';

  /// en: 'Keyboard Shortcuts'
  String get pref_item_title_keyboard_shortcuts => 'Keyboard Shortcuts';

  /// en: 'Submit with Enter'
  String get pref_item_title_submit_with_enter => 'Submit with Enter';

  /// en: 'Submit with Ctrl + Enter'
  String get pref_item_title_submit_with_meta_enter =>
      'Submit with Ctrl + Enter';

  /// en: 'Submit with ⌘ + Enter'
  String get pref_item_title_submit_with_meta_enter_mac =>
      'Submit with ⌘ + Enter';

  /// en: 'Launch when you log in'
  String get pref_item_title_launch_at_startup => 'Launch when you log in';

  /// en: 'Text Translation'
  String get pref_item_title_engines => 'Text Translation';

  /// en: 'Text Detection'
  String get pref_item_title_ocr_engines => 'Text Detection';

  /// en: 'About Biyi'
  String get pref_item_title_about => 'About Biyi';

  /// en: 'Exit App'
  String get pref_item_title_exit_app => 'Exit App';

  late final TranslationsPageSettingsExitAppDialogEn exit_app_dialog =
      TranslationsPageSettingsExitAppDialogEn.internal(_root);
}

// Path: page_translation_engine_chooser
class TranslationsPageTranslationEngineChooserEn {
  TranslationsPageTranslationEngineChooserEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Text Translation Engine'
  String get title => 'Text Translation Engine';

  /// en: 'Private'
  String get pref_section_title_private => 'Private';

  /// en: 'No available engines'
  String get pref_item_title_no_available_engines => 'No available engines';
}

// Path: page_translation_engine_create_or_edit
class TranslationsPageTranslationEngineCreateOrEditEn {
  TranslationsPageTranslationEngineCreateOrEditEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Add Text Translation Engine'
  String get title => 'Add Text Translation Engine';

  /// en: 'Engine type'
  String get pref_section_title_engine_type => 'Engine type';

  /// en: 'Support interface'
  String get pref_section_title_support_interface => 'Support interface';

  /// en: 'Option'
  String get pref_section_title_option => 'Option';
}

// Path: page_translation_engine_type_chooser
class TranslationsPageTranslationEngineTypeChooserEn {
  TranslationsPageTranslationEngineTypeChooserEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Engine type'
  String get title => 'Engine type';
}

// Path: page_translation_engines_manage
class TranslationsPageTranslationEnginesManageEn {
  TranslationsPageTranslationEnginesManageEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Text Translation Engine'
  String get title => 'Text Translation Engine';

  /// en: 'Private'
  String get pref_section_title_private => 'Private';

  /// en: 'Long press an item to reorder it'
  String get pref_section_description_private =>
      'Long press an item to reorder it';
}

// Path: page_translation_target_new
class TranslationsPageTranslationTargetNewEn {
  TranslationsPageTranslationTargetNewEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Add Translation Target'
  String get title => 'Add Translation Target';

  /// en: 'Edit Translation Target'
  String get title_with_edit => 'Edit Translation Target';

  /// en: 'Source language'
  String get source_language => 'Source language';

  /// en: 'Target language'
  String get target_language => 'Target language';
}

// Path: page_your_plan_selector
class TranslationsPageYourPlanSelectorEn {
  TranslationsPageYourPlanSelectorEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Select Your Plan'
  String get title => 'Select Your Plan';

  /// en: 'Free'
  String get label_free => 'Free';

  /// en: 'Forever'
  String get label_forever => 'Forever';

  /// en: 'Plan benefits'
  String get btn_plan_benefits => 'Plan benefits';

  /// en: 'activate'
  String get btn_activate => 'activate';

  /// en: 'Activation code'
  String get activation_code_input_hint => 'Activation code';

  /// en: 'Choose the right plan for you.'
  String get pref_section_title_plans => 'Choose the right plan for you.';

  /// en: 'Activate Your Pla'
  String get pref_section_title_activate_your_plan => 'Activate Your Pla';

  /// en: 'Your plan expiry date'
  String get pref_section_title_your_plan_expiry_date =>
      'Your plan expiry date';

  /// en: 'Get activation code'
  String get pref_item_title_get_activation_code => 'Get activation code';

  /// en: 'Coming soon, Please stay tuned.'
  String get msg_plan_pro_coming_soon => 'Coming soon, Please stay tuned.';
}

// Path: widget_record_shortcut_dialog
class TranslationsWidgetRecordShortcutDialogEn {
  TranslationsWidgetRecordShortcutDialogEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Customize your shortcut'
  String get title => 'Customize your shortcut';
}

// Path: page_settings.exit_app_dialog
class TranslationsPageSettingsExitAppDialogEn {
  TranslationsPageSettingsExitAppDialogEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Are you sure you want to exit?'
  String get title => 'Are you sure you want to exit?';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
  dynamic _flatMapFunction(String path) {
    return switch (path) {
      'app_name' => 'Biyi',
      'ok' => 'OK',
      'cancel' => 'Cancel',
      'add' => 'Add',
      'delete' => 'Delete',
      'copied' => 'Copied',
      'please_choose' => 'Please Choose',
      'language.af' => 'Afrikaans',
      'language.am' => 'Amharic',
      'language.ar' => 'Arabic',
      'language.az' => 'Azerbaijani',
      'language.be' => 'Belarusian',
      'language.bg' => 'Bulgarian',
      'language.bn' => 'Bengali',
      'language.bs' => 'Bosnian',
      'language.ca' => 'Catalan',
      'language.ceb' => 'Cebuano',
      'language.co' => 'Corsican',
      'language.cs' => 'Czech',
      'language.cy' => 'Welsh',
      'language.da' => 'Danish',
      'language.de' => 'German',
      'language.el' => 'Greek',
      'language.en' => 'English',
      'language.eo' => 'Esperanto',
      'language.es' => 'Spanish',
      'language.et' => 'Estonian',
      'language.eu' => 'Basque',
      'language.fa' => 'Persian',
      'language.fi' => 'Finnish',
      'language.fr' => 'French',
      'language.fy' => 'Frisian',
      'language.ga' => 'Irish',
      'language.gd' => 'Scots Gaelic',
      'language.gl' => 'Galician',
      'language.gu' => 'Gujarati',
      'language.ha' => 'Hausa',
      'language.haw' => 'Hawaiian',
      'language.he' => 'Hebrew',
      'language.hi' => 'Hindi',
      'language.hmn' => 'Hmong',
      'language.hr' => 'Croatian',
      'language.ht' => 'Haitian Creole',
      'language.hu' => 'Hungarian',
      'language.hy' => 'Armenian',
      'language.id' => 'Indonesian',
      'language.ig' => 'Igbo',
      'language.kIs' => 'Icelandic',
      'language.it' => 'Italian',
      'language.iw' => 'Hebrew',
      'language.ja' => 'Japanese',
      'language.jw' => 'Javanese',
      'language.ka' => 'Georgian',
      'language.kk' => 'Kazakh',
      'language.km' => 'Khmer',
      'language.kn' => 'Kannada',
      'language.ko' => 'Korean',
      'language.ku' => 'Kurdish (Kurmanji)',
      'language.ky' => 'Kyrgyz',
      'language.la' => 'Latin',
      'language.lb' => 'Luxembourgish',
      'language.lo' => 'Lao',
      'language.lt' => 'Lithuanian',
      'language.lv' => 'Latvian',
      'language.mg' => 'Malagasy',
      'language.mi' => 'Maori',
      'language.mk' => 'Macedonian',
      'language.ml' => 'Malayalam',
      'language.mn' => 'Mongolian',
      'language.mr' => 'Marathi',
      'language.ms' => 'Malay',
      'language.mt' => 'Maltese',
      'language.my' => 'Myanmar (Burmese)',
      'language.ne' => 'Nepali',
      'language.nl' => 'Dutch',
      'language.no' => 'Norwegian',
      'language.ny' => 'Chichewa',
      'language.or' => 'Odia (Oriya)',
      'language.pa' => 'Punjabi',
      'language.pl' => 'Polish',
      'language.ps' => 'Pashto',
      'language.pt' => 'Portuguese',
      'language.ro' => 'Romanian',
      'language.ru' => 'Russian',
      'language.rw' => 'Kinyarwanda',
      'language.sd' => 'Sindhi',
      'language.si' => 'Sinhala',
      'language.sk' => 'Slovak',
      'language.sl' => 'Slovenian',
      'language.sm' => 'Samoan',
      'language.sn' => 'Shona',
      'language.so' => 'Somali',
      'language.sq' => 'Albanian',
      'language.sr' => 'Serbian',
      'language.st' => 'Sesotho',
      'language.su' => 'Sundanese',
      'language.sv' => 'Swedish',
      'language.sw' => 'Swahili',
      'language.ta' => 'Tamil',
      'language.te' => 'Telugu',
      'language.tg' => 'Tajik',
      'language.th' => 'Thai',
      'language.tk' => 'Turkmen',
      'language.tl' => 'Filipino',
      'language.tr' => 'Turkish',
      'language.tt' => 'Tatar',
      'language.ug' => 'Uyghur',
      'language.uk' => 'Ukrainian',
      'language.ur' => 'Urdu',
      'language.uz' => 'Uzbek',
      'language.vi' => 'Vietnamese',
      'language.xh' => 'Xhosa',
      'language.yi' => 'Yiddish',
      'language.yo' => 'Yoruba',
      'language.zh' => 'Chinese',
      'language.zh_CN' => 'Chinese',
      'language.zh_TW' => 'Chinese (Traditional)',
      'language.zu' => 'Zulu',
      'engine.baidu' => 'Baidu',
      'engine.caiyun' => 'Caiyun',
      'engine.deepl' => 'DeepL',
      'engine.google' => 'Google',
      'engine.ibmwatson' => 'IBMWatson',
      'engine.iciba' => 'Iciba',
      'engine.openai' => 'OpenAI',
      'engine.sogou' => 'Sogou',
      'engine.tencent' => 'Tencent',
      'engine.youdao' => 'Youda',
      'engine_scope.detectlanguage' => 'detectLanguage',
      'engine_scope.lookup' => 'LookUp',
      'engine_scope.translate' => 'Translate',
      'ocr_engine.built_in' => 'Built In',
      'ocr_engine.tesseract' => 'Tesseract OCR',
      'ocr_engine.youdao' => 'Youdao',
      'translation_mode.auto' => 'Auto',
      'translation_mode.manual' => 'Manual',
      'theme_mode.light' => 'Light',
      'theme_mode.dark' => 'Dark',
      'theme_mode.system' => 'System',
      'word_pronunciation.us' => 'US',
      'word_pronunciation.uk' => 'UK',
      'tray_context_menu.item_show' => 'Show',
      'tray_context_menu.item_quick_start_guide' => 'Quick Start',
      'tray_context_menu.item_discussion' => 'Join Discussion',
      'tray_context_menu.item_quit_app' => 'Quit Biyi',
      'tray_context_menu.item_discussion_subitem_discord_server' =>
        'Join Discord',
      'tray_context_menu.item_discussion_subitem_qq_group' => 'Join QQ Group',
      'mini_translator.newversion_banner_text_found_new_version' =>
        'New version found: {}',
      'mini_translator.newversion_banner_btn_update' => 'Update',
      'mini_translator.limited_banner_title' =>
        'Functionality is limited, please follow the tips to check.',
      'mini_translator.limited_banner_text_screen_capture' =>
        'Grant screen recording access',
      'mini_translator.limited_banner_text_screen_selection' =>
        'Grant accessibility access',
      'mini_translator.limited_banner_btn_allow' => 'Allow',
      'mini_translator.limited_banner_btn_go_settings' => 'Go Settings',
      'mini_translator.limited_banner_btn_check_again' => 'Check Again',
      'mini_translator.limited_banner_tip_help' => 'View the help document',
      'mini_translator.limited_banner_msg_allow_access_tip' =>
        'If there is no response after clicking "Allow", please click "Go Settings" to set it manually.',
      'mini_translator.limited_banner_msg_all_access_allowed' =>
        'The Screen extract text is enabled',
      'mini_translator.limited_banner_msg_all_access_not_allowed' =>
        'The required access are not allowed.\nPlease check and set again.',
      'mini_translator.input_hint' => 'Enter the word or text here',
      'mini_translator.text_extracting_text' => 'Extracting text...',
      'mini_translator.tip_translation_mode' => 'Current translation mode: {}',
      'mini_translator.tip_extract_text_from_screen_capture' =>
        'Capture screen area and recognize text',
      'mini_translator.tip_extract_text_from_clipboard' =>
        'Read clipboard content',
      'mini_translator.btn_clear' => 'Clear',
      'mini_translator.btn_trans' => 'Translate',
      'mini_translator.msg_please_enter_word_or_text' =>
        'No text entered or text not extracted',
      'mini_translator.msg_capture_screen_area_canceled' =>
        'Capture screen area has been canceled',
      'page_language_chooser.title' => 'Choose language',
      'page_language_chooser.pref_section_title_all' => 'All',
      'page_ocr_engine_chooser.title' => 'Text Detection Engine',
      'page_ocr_engine_chooser.pref_section_title_private' => 'Private',
      'page_ocr_engine_chooser.pref_item_title_no_available_engines' =>
        'No available engines',
      'page_ocr_engine_create_or_edit.title' => 'Add Text Detection Engine',
      'page_ocr_engine_create_or_edit.pref_section_title_engine_type' =>
        'Engine type',
      'page_ocr_engine_create_or_edit.pref_section_title_option' => 'Option',
      'page_ocr_engine_type_chooser.title' => 'Engine Type',
      'page_ocr_engines_manage.title' => 'Text Detection Engine',
      'page_ocr_engines_manage.pref_section_title_private' => 'Private',
      'page_ocr_engines_manage.pref_section_description_private' =>
        'Long press an item to reorder it',
      'page_setting_app_language.title' => 'Display Language',
      'page_setting_extract_text.title' => 'Screen extract text',
      'page_setting_extract_text.pref_section_title_default_detect_text_engine' =>
        'Default detect text engine',
      'page_setting_extract_text.pref_item_auto_copy_detected_text' =>
        'Auto copy the detected text',
      'page_setting_interface.title' => 'Interface',
      'page_setting_interface.pref_section_title_tray_icon' => 'Tray Icon',
      'page_setting_interface.pref_section_title_tray_icon_style' =>
        'Tray Icon Style',
      'page_setting_interface.pref_section_title_max_window_height' =>
        'Maximum window height (logical pixels)',
      'page_setting_interface.pref_item_title_show_tray_icon' =>
        'Show Tray Icon',
      'page_setting_shortcuts.title' => 'Shortcuts',
      'page_setting_shortcuts.pref_section_title_extract_text' =>
        'Screen / Clipboard extract text',
      'page_setting_shortcuts.pref_section_title_input_assist_function' =>
        'Input assist function',
      'page_setting_shortcuts.pref_item_title_show_or_hide' => 'Show/Hide',
      'page_setting_shortcuts.pref_item_title_hide' => 'Hide',
      'page_setting_shortcuts.pref_item_title_extract_text_from_selection' =>
        'Selection',
      'page_setting_shortcuts.pref_item_title_extract_text_from_capture' =>
        'Capture Area',
      'page_setting_shortcuts.pref_item_title_extract_text_from_clipboard' =>
        'Clipboard',
      'page_setting_shortcuts.pref_item_title_translate_input_content' =>
        'Translate input content',
      'page_setting_theme_mode.title' => 'Theme Mode',
      'page_setting_translate.title' => 'Translate',
      'page_setting_translate.pref_section_title_default_translate_engine' =>
        'Default translate engine',
      'page_setting_translate.pref_section_title_translation_mode' =>
        'Translation mode',
      'page_setting_translate.pref_section_title_default_detect_language_engine' =>
        'Default detect language engine',
      'page_setting_translate.pref_section_title_translation_target' =>
        'Translation target',
      'page_setting_translate.pref_item_title_double_click_copy_result' =>
        'Double-click to copy translation result',
      'page_settings.title' => 'Settings',
      'page_settings.text_version' => 'Version {} BUILD {}',
      'page_settings.pref_section_title_general' => 'General',
      'page_settings.pref_section_title_appearance' => 'Appearance',
      'page_settings.pref_section_title_shortcuts' => 'Shortcuts',
      'page_settings.pref_section_title_input_settings' => 'Input Settings',
      'page_settings.pref_section_title_advanced' => 'Advanced',
      'page_settings.pref_section_title_service_integration' =>
        'Service Integration',
      'page_settings.pref_section_title_others' => 'Others',
      'page_settings.pref_item_title_your_plan' => 'Your Plan',
      'page_settings.pref_item_title_extract_text' => 'Extract text',
      'page_settings.pref_item_title_interface' => 'Interface',
      'page_settings.pref_item_title_translate' => 'Translate',
      'page_settings.pref_item_title_app_language' => 'Display Language',
      'page_settings.pref_item_title_theme_mode' => 'Theme Mode',
      'page_settings.pref_item_title_keyboard_shortcuts' =>
        'Keyboard Shortcuts',
      'page_settings.pref_item_title_submit_with_enter' => 'Submit with Enter',
      'page_settings.pref_item_title_submit_with_meta_enter' =>
        'Submit with Ctrl + Enter',
      'page_settings.pref_item_title_submit_with_meta_enter_mac' =>
        'Submit with ⌘ + Enter',
      'page_settings.pref_item_title_launch_at_startup' =>
        'Launch when you log in',
      'page_settings.pref_item_title_engines' => 'Text Translation',
      'page_settings.pref_item_title_ocr_engines' => 'Text Detection',
      'page_settings.pref_item_title_about' => 'About Biyi',
      'page_settings.pref_item_title_exit_app' => 'Exit App',
      'page_settings.exit_app_dialog.title' => 'Are you sure you want to exit?',
      'page_translation_engine_chooser.title' => 'Text Translation Engine',
      'page_translation_engine_chooser.pref_section_title_private' => 'Private',
      'page_translation_engine_chooser.pref_item_title_no_available_engines' =>
        'No available engines',
      'page_translation_engine_create_or_edit.title' =>
        'Add Text Translation Engine',
      'page_translation_engine_create_or_edit.pref_section_title_engine_type' =>
        'Engine type',
      'page_translation_engine_create_or_edit.pref_section_title_support_interface' =>
        'Support interface',
      'page_translation_engine_create_or_edit.pref_section_title_option' =>
        'Option',
      'page_translation_engine_type_chooser.title' => 'Engine type',
      'page_translation_engines_manage.title' => 'Text Translation Engine',
      'page_translation_engines_manage.pref_section_title_private' => 'Private',
      'page_translation_engines_manage.pref_section_description_private' =>
        'Long press an item to reorder it',
      'page_translation_target_new.title' => 'Add Translation Target',
      'page_translation_target_new.title_with_edit' =>
        'Edit Translation Target',
      'page_translation_target_new.source_language' => 'Source language',
      'page_translation_target_new.target_language' => 'Target language',
      'page_your_plan_selector.title' => 'Select Your Plan',
      'page_your_plan_selector.label_free' => 'Free',
      'page_your_plan_selector.label_forever' => 'Forever',
      'page_your_plan_selector.btn_plan_benefits' => 'Plan benefits',
      'page_your_plan_selector.btn_activate' => 'activate',
      'page_your_plan_selector.activation_code_input_hint' => 'Activation code',
      'page_your_plan_selector.pref_section_title_plans' =>
        'Choose the right plan for you.',
      'page_your_plan_selector.pref_section_title_activate_your_plan' =>
        'Activate Your Pla',
      'page_your_plan_selector.pref_section_title_your_plan_expiry_date' =>
        'Your plan expiry date',
      'page_your_plan_selector.pref_item_title_get_activation_code' =>
        'Get activation code',
      'page_your_plan_selector.msg_plan_pro_coming_soon' =>
        'Coming soon, Please stay tuned.',
      'widget_record_shortcut_dialog.title' => 'Customize your shortcut',
      _ => null,
    };
  }
}
