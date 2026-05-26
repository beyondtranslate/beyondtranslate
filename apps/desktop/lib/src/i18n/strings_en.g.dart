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
  late final TranslationsAppEn app = TranslationsAppEn.internal(_root);
  late final TranslationsMiniTranslatorEn mini_translator =
      TranslationsMiniTranslatorEn.internal(_root);
  late final TranslationsSettingsEn settings =
      TranslationsSettingsEn.internal(_root);
}

// Path: common
class TranslationsCommonEn {
  TranslationsCommonEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsCommonUiEn ui = TranslationsCommonUiEn.internal(_root);
  late final TranslationsCommonLanguageEn language =
      TranslationsCommonLanguageEn.internal(_root);
  late final TranslationsCommonThemeModeEn theme_mode =
      TranslationsCommonThemeModeEn.internal(_root);
  late final TranslationsCommonProviderEn provider =
      TranslationsCommonProviderEn.internal(_root);
  late final TranslationsCommonWordPronunciationEn word_pronunciation =
      TranslationsCommonWordPronunciationEn.internal(_root);
}

// Path: app
class TranslationsAppEn {
  TranslationsAppEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsAppTrayEn tray = TranslationsAppTrayEn.internal(_root);
}

// Path: mini_translator
class TranslationsMiniTranslatorEn {
  TranslationsMiniTranslatorEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsMiniTranslatorLimitedBannerEn limited_banner =
      TranslationsMiniTranslatorLimitedBannerEn.internal(_root);
  late final TranslationsMiniTranslatorInputEn input =
      TranslationsMiniTranslatorInputEn.internal(_root);
  late final TranslationsMiniTranslatorToolbarEn toolbar =
      TranslationsMiniTranslatorToolbarEn.internal(_root);
  late final TranslationsMiniTranslatorButtonEn button =
      TranslationsMiniTranslatorButtonEn.internal(_root);
  late final TranslationsMiniTranslatorLanguageEn language =
      TranslationsMiniTranslatorLanguageEn.internal(_root);
  late final TranslationsMiniTranslatorMessageEn message =
      TranslationsMiniTranslatorMessageEn.internal(_root);
}

// Path: settings
class TranslationsSettingsEn {
  TranslationsSettingsEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Version {} BUILD {}'
  String get version => 'Version {} BUILD {}';

  late final TranslationsSettingsGeneralEn general =
      TranslationsSettingsGeneralEn.internal(_root);
  late final TranslationsSettingsAppearanceEn appearance =
      TranslationsSettingsAppearanceEn.internal(_root);
  late final TranslationsSettingsShortcutsEn shortcuts =
      TranslationsSettingsShortcutsEn.internal(_root);
  late final TranslationsSettingsAdvancedEn advanced =
      TranslationsSettingsAdvancedEn.internal(_root);
  late final TranslationsSettingsProvidersEn providers =
      TranslationsSettingsProvidersEn.internal(_root);
  late final TranslationsSettingsLayoutEn layout =
      TranslationsSettingsLayoutEn.internal(_root);
}

// Path: common.ui
class TranslationsCommonUiEn {
  TranslationsCommonUiEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsCommonUiButtonEn button =
      TranslationsCommonUiButtonEn.internal(_root);
  late final TranslationsCommonUiFeedbackEn feedback =
      TranslationsCommonUiFeedbackEn.internal(_root);
}

// Path: common.language
class TranslationsCommonLanguageEn {
  TranslationsCommonLanguageEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Arabic'
  String get ar => 'Arabic';

  /// en: 'Bengali'
  String get bn => 'Bengali';

  /// en: 'German'
  String get de => 'German';

  /// en: 'English'
  String get en => 'English';

  /// en: 'Spanish'
  String get es => 'Spanish';

  /// en: 'Persian'
  String get fa => 'Persian';

  /// en: 'French'
  String get fr => 'French';

  /// en: 'Gujarati'
  String get gu => 'Gujarati';

  /// en: 'Hausa'
  String get ha => 'Hausa';

  /// en: 'Hindi'
  String get hi => 'Hindi';

  /// en: 'Indonesian'
  String get id => 'Indonesian';

  /// en: 'Italian'
  String get it => 'Italian';

  /// en: 'Japanese'
  String get ja => 'Japanese';

  /// en: 'Javanese'
  String get jv => 'Javanese';

  /// en: 'Korean'
  String get ko => 'Korean';

  /// en: 'Malayalam'
  String get ml => 'Malayalam';

  /// en: 'Marathi'
  String get mr => 'Marathi';

  /// en: 'Malay'
  String get ms => 'Malay';

  /// en: 'Dutch'
  String get nl => 'Dutch';

  /// en: 'Punjabi'
  String get pa => 'Punjabi';

  /// en: 'Polish'
  String get pl => 'Polish';

  /// en: 'Portuguese'
  String get pt => 'Portuguese';

  /// en: 'Romanian'
  String get ro => 'Romanian';

  /// en: 'Russian'
  String get ru => 'Russian';

  /// en: 'Swahili'
  String get sw => 'Swahili';

  /// en: 'Tamil'
  String get ta => 'Tamil';

  /// en: 'Telugu'
  String get te => 'Telugu';

  /// en: 'Thai'
  String get th => 'Thai';

  /// en: 'Turkish'
  String get tr => 'Turkish';

  /// en: 'Ukrainian'
  String get uk => 'Ukrainian';

  /// en: 'Urdu'
  String get ur => 'Urdu';

  /// en: 'Vietnamese'
  String get vi => 'Vietnamese';

  /// en: 'Yoruba'
  String get yo => 'Yoruba';

  /// en: 'Chinese (Simplified)'
  String get zh_hans => 'Chinese (Simplified)';

  /// en: 'Chinese (Traditional)'
  String get zh_hant => 'Chinese (Traditional)';
}

// Path: common.theme_mode
class TranslationsCommonThemeModeEn {
  TranslationsCommonThemeModeEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Light'
  String get light => 'Light';

  /// en: 'Dark'
  String get dark => 'Dark';

  /// en: 'System'
  String get system => 'System';
}

// Path: common.provider
class TranslationsCommonProviderEn {
  TranslationsCommonProviderEn.internal(this._root);

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

  /// en: 'Iciba'
  String get iciba => 'Iciba';

  /// en: 'Sogou'
  String get sogou => 'Sogou';

  /// en: 'System'
  String get system => 'System';

  /// en: 'Tencent'
  String get tencent => 'Tencent';

  /// en: 'Youda'
  String get youdao => 'Youda';
}

// Path: common.word_pronunciation
class TranslationsCommonWordPronunciationEn {
  TranslationsCommonWordPronunciationEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'US'
  String get us => 'US';

  /// en: 'UK'
  String get uk => 'UK';
}

// Path: app.tray
class TranslationsAppTrayEn {
  TranslationsAppTrayEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsAppTrayContextMenuEn context_menu =
      TranslationsAppTrayContextMenuEn.internal(_root);
}

// Path: mini_translator.limited_banner
class TranslationsMiniTranslatorLimitedBannerEn {
  TranslationsMiniTranslatorLimitedBannerEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsMiniTranslatorLimitedBannerPermissionEn permission =
      TranslationsMiniTranslatorLimitedBannerPermissionEn.internal(_root);
  late final TranslationsMiniTranslatorLimitedBannerInstructionEn instruction =
      TranslationsMiniTranslatorLimitedBannerInstructionEn.internal(_root);
  late final TranslationsMiniTranslatorLimitedBannerActionEn action =
      TranslationsMiniTranslatorLimitedBannerActionEn.internal(_root);
  late final TranslationsMiniTranslatorLimitedBannerFeedbackEn feedback =
      TranslationsMiniTranslatorLimitedBannerFeedbackEn.internal(_root);
  late final TranslationsMiniTranslatorLimitedBannerTooltipEn tooltip =
      TranslationsMiniTranslatorLimitedBannerTooltipEn.internal(_root);
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

// Path: mini_translator.language
class TranslationsMiniTranslatorLanguageEn {
  TranslationsMiniTranslatorLanguageEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Auto Detect'
  String get auto_detect => 'Auto Detect';

  /// en: 'Auto Match'
  String get auto_match => 'Auto Match';

  /// en: 'Switch Target'
  String get switch_config => 'Switch Target';

  /// en: 'More languages...'
  String get more_languages => 'More languages...';

  /// en: 'Manage Common Languages...'
  String get manage_common_languages => 'Manage Common Languages...';

  /// en: 'Manage Translation Targets...'
  String get manage_targets => 'Manage Translation Targets...';

  /// en: 'Add Translation Target...'
  String get add_target => 'Add Translation Target...';
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

  /// en: 'No default text recognition service configured. Please set one in Settings.'
  String get ocr_service_not_configured =>
      'No default text recognition service configured. Please set one in Settings.';

  /// en: 'Text recognition failed'
  String get ocr_recognition_failed => 'Text recognition failed';
}

// Path: settings.general
class TranslationsSettingsGeneralEn {
  TranslationsSettingsGeneralEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'General'
  String get title => 'General';

  late final TranslationsSettingsGeneralSectionEn section =
      TranslationsSettingsGeneralSectionEn.internal(_root);
  late final TranslationsSettingsGeneralRowEn row =
      TranslationsSettingsGeneralRowEn.internal(_root);
  late final TranslationsSettingsGeneralButtonEn button =
      TranslationsSettingsGeneralButtonEn.internal(_root);
  late final TranslationsSettingsGeneralOptionEn option =
      TranslationsSettingsGeneralOptionEn.internal(_root);
  late final TranslationsSettingsGeneralEditorEn editor =
      TranslationsSettingsGeneralEditorEn.internal(_root);
}

// Path: settings.appearance
class TranslationsSettingsAppearanceEn {
  TranslationsSettingsAppearanceEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Appearance'
  String get title => 'Appearance';

  late final TranslationsSettingsAppearanceSectionEn section =
      TranslationsSettingsAppearanceSectionEn.internal(_root);
}

// Path: settings.shortcuts
class TranslationsSettingsShortcutsEn {
  TranslationsSettingsShortcutsEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Shortcuts'
  String get title => 'Shortcuts';

  late final TranslationsSettingsShortcutsSectionEn section =
      TranslationsSettingsShortcutsSectionEn.internal(_root);
  late final TranslationsSettingsShortcutsRowEn row =
      TranslationsSettingsShortcutsRowEn.internal(_root);
  late final TranslationsSettingsShortcutsResetDialogEn reset_dialog =
      TranslationsSettingsShortcutsResetDialogEn.internal(_root);
}

// Path: settings.advanced
class TranslationsSettingsAdvancedEn {
  TranslationsSettingsAdvancedEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Advanced'
  String get title => 'Advanced';

  /// en: 'Local API server'
  String get api_server => 'Local API server';

  /// en: 'Expose the translation API on 127.0.0.1 for local integrations.'
  String get api_server_description =>
      'Expose the translation API on 127.0.0.1 for local integrations.';

  /// en: 'Enable'
  String get enable => 'Enable';

  /// en: 'Port'
  String get port => 'Port';

  /// en: 'Running at {url}'
  String get running_at => 'Running at {url}';

  /// en: 'Disabled'
  String get disabled => 'Disabled';
}

// Path: settings.providers
class TranslationsSettingsProvidersEn {
  TranslationsSettingsProvidersEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Providers'
  String get title => 'Providers';

  late final TranslationsSettingsProvidersSectionEn section =
      TranslationsSettingsProvidersSectionEn.internal(_root);
  late final TranslationsSettingsProvidersItemEn item =
      TranslationsSettingsProvidersItemEn.internal(_root);
  late final TranslationsSettingsProvidersButtonEn button =
      TranslationsSettingsProvidersButtonEn.internal(_root);
  late final TranslationsSettingsProvidersAlertEn alert =
      TranslationsSettingsProvidersAlertEn.internal(_root);
  late final TranslationsSettingsProvidersIntroEn intro =
      TranslationsSettingsProvidersIntroEn.internal(_root);
  late final TranslationsSettingsProvidersEditorEn editor =
      TranslationsSettingsProvidersEditorEn.internal(_root);
  late final TranslationsSettingsProvidersDetailEn detail =
      TranslationsSettingsProvidersDetailEn.internal(_root);
  late final TranslationsSettingsProvidersCapabilityEn capability =
      TranslationsSettingsProvidersCapabilityEn.internal(_root);
  late final TranslationsSettingsProvidersDescriptionEn description =
      TranslationsSettingsProvidersDescriptionEn.internal(_root);
  late final TranslationsSettingsProvidersDeleteDialogEn delete_dialog =
      TranslationsSettingsProvidersDeleteDialogEn.internal(_root);
}

// Path: settings.layout
class TranslationsSettingsLayoutEn {
  TranslationsSettingsLayoutEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Settings'
  String get title => 'Settings';

  late final TranslationsSettingsLayoutEmptyEn empty =
      TranslationsSettingsLayoutEmptyEn.internal(_root);
}

// Path: common.ui.button
class TranslationsCommonUiButtonEn {
  TranslationsCommonUiButtonEn.internal(this._root);

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

  /// en: 'Continue'
  String get kContinue => 'Continue';
}

// Path: common.ui.feedback
class TranslationsCommonUiFeedbackEn {
  TranslationsCommonUiFeedbackEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Copied'
  String get copied => 'Copied';
}

// Path: app.tray.context_menu
class TranslationsAppTrayContextMenuEn {
  TranslationsAppTrayContextMenuEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Show Window'
  String get show_window => 'Show Window';

  late final TranslationsAppTrayContextMenuDevToolsEn dev_tools =
      TranslationsAppTrayContextMenuDevToolsEn.internal(_root);

  /// en: 'Check for Updates'
  String get check_for_updates => 'Check for Updates';

  /// en: 'Settings'
  String get settings => 'Settings';

  /// en: 'Quit'
  String get quit => 'Quit';
}

// Path: mini_translator.limited_banner.permission
class TranslationsMiniTranslatorLimitedBannerPermissionEn {
  TranslationsMiniTranslatorLimitedBannerPermissionEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Grant Screen Recording and Accessibility permissions to enable all features.'
  String get missing_both =>
      'Grant Screen Recording and Accessibility permissions to enable all features.';

  /// en: 'Grant Screen Recording permission to enable all features.'
  String get missing_screen_capture =>
      'Grant Screen Recording permission to enable all features.';

  /// en: 'Grant Accessibility permission to enable all features.'
  String get missing_accessibility =>
      'Grant Accessibility permission to enable all features.';
}

// Path: mini_translator.limited_banner.instruction
class TranslationsMiniTranslatorLimitedBannerInstructionEn {
  TranslationsMiniTranslatorLimitedBannerInstructionEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Go to '
  String get app_settings_prefix => 'Go to ';

  /// en: ', follow the guide, then click '
  String get follow_guide_prefix => ', follow the guide, then click ';

  /// en: '.'
  String get suffix => '.';
}

// Path: mini_translator.limited_banner.action
class TranslationsMiniTranslatorLimitedBannerActionEn {
  TranslationsMiniTranslatorLimitedBannerActionEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'App Settings'
  String get app_settings => 'App Settings';

  /// en: 'Recheck'
  String get recheck => 'Recheck';
}

// Path: mini_translator.limited_banner.feedback
class TranslationsMiniTranslatorLimitedBannerFeedbackEn {
  TranslationsMiniTranslatorLimitedBannerFeedbackEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Screen text extraction is enabled.'
  String get enabled => 'Screen text extraction is enabled.';

  /// en: 'Required permissions are still missing. Please check your settings and try again.'
  String get still_missing =>
      'Required permissions are still missing.\nPlease check your settings and try again.';
}

// Path: mini_translator.limited_banner.tooltip
class TranslationsMiniTranslatorLimitedBannerTooltipEn {
  TranslationsMiniTranslatorLimitedBannerTooltipEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'View help'
  String get help => 'View help';
}

// Path: mini_translator.toolbar.tooltip
class TranslationsMiniTranslatorToolbarTooltipEn {
  TranslationsMiniTranslatorToolbarTooltipEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Capture screen area and recognize text'
  String get extract_text_from_screen_capture =>
      'Capture screen area and recognize text';

  /// en: 'Read clipboard content'
  String get extract_text_from_clipboard => 'Read clipboard content';
}

// Path: settings.general.section
class TranslationsSettingsGeneralSectionEn {
  TranslationsSettingsGeneralSectionEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Permissions'
  String get permissions => 'Permissions';

  /// en: 'Text Recognition'
  String get ocr => 'Text Recognition';

  /// en: 'Directory'
  String get directory => 'Directory';

  /// en: 'Translation'
  String get translation => 'Translation';

  /// en: 'Translation Target'
  String get translation_target => 'Translation Target';

  /// en: 'Languages'
  String get languages => 'Languages';

  /// en: 'Input Settings'
  String get input => 'Input Settings';
}

// Path: settings.general.row
class TranslationsSettingsGeneralRowEn {
  TranslationsSettingsGeneralRowEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Launch when you log in'
  String get launch_at_login => 'Launch when you log in';

  /// en: 'Show in menu bar'
  String get show_in_menu_bar => 'Show in menu bar';

  /// en: 'Grant screen recording access'
  String get screen_capture_access => 'Grant screen recording access';

  /// en: 'Grant accessibility access'
  String get screen_selection_access => 'Grant accessibility access';

  /// en: 'Default text recognition service'
  String get default_ocr_service => 'Default text recognition service';

  /// en: 'Auto copy detected text'
  String get auto_copy_detected_text => 'Auto copy detected text';

  /// en: 'Default directory service'
  String get default_directory_service => 'Default directory service';

  /// en: 'Default translation service'
  String get default_translation_service => 'Default translation service';

  /// en: 'Configure language pairs used by the translator.'
  String get translation_target_hint =>
      'Configure language pairs used by the translator.';

  /// en: 'Common Languages'
  String get common_languages => 'Common Languages';

  /// en: 'Shown at the top of language pickers.'
  String get common_languages_description =>
      'Shown at the top of language pickers.';

  /// en: 'Select your common languages:'
  String get common_languages_hint => 'Select your common languages:';

  /// en: 'Sort by Code'
  String get common_languages_sort => 'Sort by Code';

  /// en: 'Double click to copy translation result'
  String get double_click_copy_result =>
      'Double click to copy translation result';

  /// en: 'Reset to Defaults'
  String get common_languages_reset => 'Reset to Defaults';

  /// en: 'Reset to the default set of common languages'
  String get common_languages_reset_help =>
      'Reset to the default set of common languages';

  /// en: 'Search languages...'
  String get common_languages_search => 'Search languages...';

  /// en: 'All Languages'
  String get common_languages_all => 'All Languages';

  /// en: 'Submit with Enter'
  String get submit_with_enter => 'Submit with Enter';

  /// en: 'Submit with ⌘ + Enter'
  String get submit_with_meta_enter_mac => 'Submit with ⌘ + Enter';
}

// Path: settings.general.button
class TranslationsSettingsGeneralButtonEn {
  TranslationsSettingsGeneralButtonEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Add...'
  String get add_provider => 'Add...';

  /// en: 'Add Target...'
  String get add_target => 'Add Target...';

  /// en: 'Manage Translation Targets...'
  String get manage_targets => 'Manage Translation Targets...';

  /// en: 'Manage Common Languages...'
  String get manage_languages => 'Manage Common Languages...';

  /// en: 'Grant'
  String get grant => 'Grant';
}

// Path: settings.general.option
class TranslationsSettingsGeneralOptionEn {
  TranslationsSettingsGeneralOptionEn.internal(this._root);

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
}

// Path: settings.general.editor
class TranslationsSettingsGeneralEditorEn {
  TranslationsSettingsGeneralEditorEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Add Translation Target'
  String get add_target_title => 'Add Translation Target';

  /// en: 'Edit Translation Target'
  String get edit_target_title => 'Edit Translation Target';

  late final TranslationsSettingsGeneralEditorRowEn row =
      TranslationsSettingsGeneralEditorRowEn.internal(_root);
}

// Path: settings.appearance.section
class TranslationsSettingsAppearanceSectionEn {
  TranslationsSettingsAppearanceSectionEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Display Language'
  String get app_language => 'Display Language';

  /// en: 'Theme Mode'
  String get theme_mode => 'Theme Mode';
}

// Path: settings.shortcuts.section
class TranslationsSettingsShortcutsSectionEn {
  TranslationsSettingsShortcutsSectionEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Text Extraction'
  String get text_extraction => 'Text Extraction';

  /// en: 'Input Assist Function'
  String get input_assist => 'Input Assist Function';
}

// Path: settings.shortcuts.row
class TranslationsSettingsShortcutsRowEn {
  TranslationsSettingsShortcutsRowEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Show/Hide Window'
  String get toggle_mini_translator => 'Show/Hide Window';

  /// en: 'Extract text from screen selection'
  String get extract_text_from_screen_selection =>
      'Extract text from screen selection';

  /// en: 'Extract text from screen capture'
  String get extract_text_from_screen_capture =>
      'Extract text from screen capture';

  /// en: 'Extract text from clipboard'
  String get extract_text_from_clipboard => 'Extract text from clipboard';

  /// en: 'Translate input content'
  String get translate_input => 'Translate input content';
}

// Path: settings.shortcuts.reset_dialog
class TranslationsSettingsShortcutsResetDialogEn {
  TranslationsSettingsShortcutsResetDialogEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Reset Shortcuts'
  String get title => 'Reset Shortcuts';

  /// en: 'Are you sure you want to reset all shortcuts to their default values?'
  String get message =>
      'Are you sure you want to reset all shortcuts to their default values?';

  /// en: 'Reset'
  String get confirm => 'Reset';

  /// en: 'Cancel'
  String get cancel => 'Cancel';
}

// Path: settings.providers.section
class TranslationsSettingsProvidersSectionEn {
  TranslationsSettingsProvidersSectionEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Available Services'
  String get services => 'Available Services';

  /// en: 'View available services from configured providers and switch between service types.'
  String get services_description =>
      'View available services from configured providers and switch between service types.';
}

// Path: settings.providers.item
class TranslationsSettingsProvidersItemEn {
  TranslationsSettingsProvidersItemEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'No providers configured. Add one to enable translation services.'
  String get empty =>
      'No providers configured. Add one to enable translation services.';

  /// en: 'Loading providers...'
  String get loading => 'Loading providers...';

  /// en: 'No services available.'
  String get no_services => 'No services available.';
}

// Path: settings.providers.button
class TranslationsSettingsProvidersButtonEn {
  TranslationsSettingsProvidersButtonEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Add a Provider...'
  String get add => 'Add a Provider...';
}

// Path: settings.providers.alert
class TranslationsSettingsProvidersAlertEn {
  TranslationsSettingsProvidersAlertEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Error'
  String get error => 'Error';
}

// Path: settings.providers.intro
class TranslationsSettingsProvidersIntroEn {
  TranslationsSettingsProvidersIntroEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Manage the service providers used by the app.'
  String get body => 'Manage the service providers used by the app.';

  /// en: 'Connected providers may process the text or images you send. Only enable services you trust.'
  String get warning =>
      'Connected providers may process the text or images you send. Only enable services you trust.';
}

// Path: settings.providers.editor
class TranslationsSettingsProvidersEditorEn {
  TranslationsSettingsProvidersEditorEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsSettingsProvidersEditorRowEn row =
      TranslationsSettingsProvidersEditorRowEn.internal(_root);
  late final TranslationsSettingsProvidersEditorPlaceholderEn placeholder =
      TranslationsSettingsProvidersEditorPlaceholderEn.internal(_root);
  late final TranslationsSettingsProvidersEditorTypePickerEn type_picker =
      TranslationsSettingsProvidersEditorTypePickerEn.internal(_root);
  late final TranslationsSettingsProvidersEditorTooltipEn tooltip =
      TranslationsSettingsProvidersEditorTooltipEn.internal(_root);
}

// Path: settings.providers.detail
class TranslationsSettingsProvidersDetailEn {
  TranslationsSettingsProvidersDetailEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final TranslationsSettingsProvidersDetailTooltipEn tooltip =
      TranslationsSettingsProvidersDetailTooltipEn.internal(_root);
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

  /// en: 'OCR'
  String get ocr => 'OCR';
}

// Path: settings.providers.description
class TranslationsSettingsProvidersDescriptionEn {
  TranslationsSettingsProvidersDescriptionEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Provides dictionary lookup and text translation'
  String get all => 'Provides dictionary lookup and text translation';

  /// en: 'Provides dictionary lookup and word definitions'
  String get dictionary => 'Provides dictionary lookup and word definitions';

  /// en: 'Provides text translation between languages'
  String get translation => 'Provides text translation between languages';

  /// en: 'Provides translation services'
  String get fallback => 'Provides translation services';
}

// Path: settings.providers.delete_dialog
class TranslationsSettingsProvidersDeleteDialogEn {
  TranslationsSettingsProvidersDeleteDialogEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Delete "{}"?'
  String get title => 'Delete "{}"?';

  /// en: 'This action cannot be undone.'
  String get message => 'This action cannot be undone.';
}

// Path: settings.layout.empty
class TranslationsSettingsLayoutEmptyEn {
  TranslationsSettingsLayoutEmptyEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Select a Category'
  String get title => 'Select a Category';

  /// en: 'Choose a settings section from the sidebar.'
  String get message => 'Choose a settings section from the sidebar.';
}

// Path: app.tray.context_menu.dev_tools
class TranslationsAppTrayContextMenuDevToolsEn {
  TranslationsAppTrayContextMenuDevToolsEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Dev Tools'
  String get title => 'Dev Tools';

  /// en: 'Open Data Directory'
  String get open_data_directory => 'Open Data Directory';

  /// en: 'Use Native Settings Page'
  String get use_native_settings => 'Use Native Settings Page';
}

// Path: settings.general.editor.row
class TranslationsSettingsGeneralEditorRowEn {
  TranslationsSettingsGeneralEditorRowEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Source Language'
  String get source_language => 'Source Language';

  /// en: 'Target Language'
  String get target_language => 'Target Language';
}

// Path: settings.providers.editor.row
class TranslationsSettingsProvidersEditorRowEn {
  TranslationsSettingsProvidersEditorRowEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Provider ID'
  String get id => 'Provider ID';
}

// Path: settings.providers.editor.placeholder
class TranslationsSettingsProvidersEditorPlaceholderEn {
  TranslationsSettingsProvidersEditorPlaceholderEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'e.g. deepl-main'
  String get id => 'e.g. deepl-main';
}

// Path: settings.providers.editor.type_picker
class TranslationsSettingsProvidersEditorTypePickerEn {
  TranslationsSettingsProvidersEditorTypePickerEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Select the type of provider you would like to add:'
  String get prompt => 'Select the type of provider you would like to add:';
}

// Path: settings.providers.editor.tooltip
class TranslationsSettingsProvidersEditorTooltipEn {
  TranslationsSettingsProvidersEditorTooltipEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Help'
  String get help => 'Help';
}

// Path: settings.providers.detail.tooltip
class TranslationsSettingsProvidersDetailTooltipEn {
  TranslationsSettingsProvidersDetailTooltipEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Edit provider'
  String get edit => 'Edit provider';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
  dynamic _flatMapFunction(String path) {
    return switch (path) {
      'common.ui.button.ok' => 'OK',
      'common.ui.button.cancel' => 'Cancel',
      'common.ui.button.add' => 'Add',
      'common.ui.button.delete' => 'Delete',
      'common.ui.button.edit' => 'Edit',
      'common.ui.button.save' => 'Save',
      'common.ui.button.manage' => 'Manage',
      'common.ui.button.kContinue' => 'Continue',
      'common.ui.feedback.copied' => 'Copied',
      'common.language.ar' => 'Arabic',
      'common.language.bn' => 'Bengali',
      'common.language.de' => 'German',
      'common.language.en' => 'English',
      'common.language.es' => 'Spanish',
      'common.language.fa' => 'Persian',
      'common.language.fr' => 'French',
      'common.language.gu' => 'Gujarati',
      'common.language.ha' => 'Hausa',
      'common.language.hi' => 'Hindi',
      'common.language.id' => 'Indonesian',
      'common.language.it' => 'Italian',
      'common.language.ja' => 'Japanese',
      'common.language.jv' => 'Javanese',
      'common.language.ko' => 'Korean',
      'common.language.ml' => 'Malayalam',
      'common.language.mr' => 'Marathi',
      'common.language.ms' => 'Malay',
      'common.language.nl' => 'Dutch',
      'common.language.pa' => 'Punjabi',
      'common.language.pl' => 'Polish',
      'common.language.pt' => 'Portuguese',
      'common.language.ro' => 'Romanian',
      'common.language.ru' => 'Russian',
      'common.language.sw' => 'Swahili',
      'common.language.ta' => 'Tamil',
      'common.language.te' => 'Telugu',
      'common.language.th' => 'Thai',
      'common.language.tr' => 'Turkish',
      'common.language.uk' => 'Ukrainian',
      'common.language.ur' => 'Urdu',
      'common.language.vi' => 'Vietnamese',
      'common.language.yo' => 'Yoruba',
      'common.language.zh_hans' => 'Chinese (Simplified)',
      'common.language.zh_hant' => 'Chinese (Traditional)',
      'common.theme_mode.light' => 'Light',
      'common.theme_mode.dark' => 'Dark',
      'common.theme_mode.system' => 'System',
      'common.provider.baidu' => 'Baidu',
      'common.provider.caiyun' => 'Caiyun',
      'common.provider.deepl' => 'DeepL',
      'common.provider.google' => 'Google',
      'common.provider.iciba' => 'Iciba',
      'common.provider.sogou' => 'Sogou',
      'common.provider.system' => 'System',
      'common.provider.tencent' => 'Tencent',
      'common.provider.youdao' => 'Youda',
      'common.word_pronunciation.us' => 'US',
      'common.word_pronunciation.uk' => 'UK',
      'app.tray.context_menu.show_window' => 'Show Window',
      'app.tray.context_menu.dev_tools.title' => 'Dev Tools',
      'app.tray.context_menu.dev_tools.open_data_directory' =>
        'Open Data Directory',
      'app.tray.context_menu.dev_tools.use_native_settings' =>
        'Use Native Settings Page',
      'app.tray.context_menu.check_for_updates' => 'Check for Updates',
      'app.tray.context_menu.settings' => 'Settings',
      'app.tray.context_menu.quit' => 'Quit',
      'mini_translator.limited_banner.permission.missing_both' =>
        'Grant Screen Recording and Accessibility permissions to enable all features.',
      'mini_translator.limited_banner.permission.missing_screen_capture' =>
        'Grant Screen Recording permission to enable all features.',
      'mini_translator.limited_banner.permission.missing_accessibility' =>
        'Grant Accessibility permission to enable all features.',
      'mini_translator.limited_banner.instruction.app_settings_prefix' =>
        'Go to ',
      'mini_translator.limited_banner.instruction.follow_guide_prefix' =>
        ', follow the guide, then click ',
      'mini_translator.limited_banner.instruction.suffix' => '.',
      'mini_translator.limited_banner.action.app_settings' => 'App Settings',
      'mini_translator.limited_banner.action.recheck' => 'Recheck',
      'mini_translator.limited_banner.feedback.enabled' =>
        'Screen text extraction is enabled.',
      'mini_translator.limited_banner.feedback.still_missing' =>
        'Required permissions are still missing.\nPlease check your settings and try again.',
      'mini_translator.limited_banner.tooltip.help' => 'View help',
      'mini_translator.input.hint' => 'Enter the word or text here',
      'mini_translator.input.extracting_text' => 'Extracting text...',
      'mini_translator.toolbar.tooltip.extract_text_from_screen_capture' =>
        'Capture screen area and recognize text',
      'mini_translator.toolbar.tooltip.extract_text_from_clipboard' =>
        'Read clipboard content',
      'mini_translator.button.clear' => 'Clear',
      'mini_translator.button.translate' => 'Translate',
      'mini_translator.language.auto_detect' => 'Auto Detect',
      'mini_translator.language.auto_match' => 'Auto Match',
      'mini_translator.language.switch_config' => 'Switch Target',
      'mini_translator.language.more_languages' => 'More languages...',
      'mini_translator.language.manage_common_languages' =>
        'Manage Common Languages...',
      'mini_translator.language.manage_targets' =>
        'Manage Translation Targets...',
      'mini_translator.language.add_target' => 'Add Translation Target...',
      'mini_translator.message.please_enter_word_or_text' =>
        'No text entered or text not extracted',
      'mini_translator.message.capture_screen_area_canceled' =>
        'Capture screen area has been canceled',
      'mini_translator.message.ocr_service_not_configured' =>
        'No default text recognition service configured. Please set one in Settings.',
      'mini_translator.message.ocr_recognition_failed' =>
        'Text recognition failed',
      'settings.version' => 'Version {} BUILD {}',
      'settings.general.title' => 'General',
      'settings.general.section.permissions' => 'Permissions',
      'settings.general.section.ocr' => 'Text Recognition',
      'settings.general.section.directory' => 'Directory',
      'settings.general.section.translation' => 'Translation',
      'settings.general.section.translation_target' => 'Translation Target',
      'settings.general.section.languages' => 'Languages',
      'settings.general.section.input' => 'Input Settings',
      'settings.general.row.launch_at_login' => 'Launch when you log in',
      'settings.general.row.show_in_menu_bar' => 'Show in menu bar',
      'settings.general.row.screen_capture_access' =>
        'Grant screen recording access',
      'settings.general.row.screen_selection_access' =>
        'Grant accessibility access',
      'settings.general.row.default_ocr_service' =>
        'Default text recognition service',
      'settings.general.row.auto_copy_detected_text' =>
        'Auto copy detected text',
      'settings.general.row.default_directory_service' =>
        'Default directory service',
      'settings.general.row.default_translation_service' =>
        'Default translation service',
      'settings.general.row.translation_target_hint' =>
        'Configure language pairs used by the translator.',
      'settings.general.row.common_languages' => 'Common Languages',
      'settings.general.row.common_languages_description' =>
        'Shown at the top of language pickers.',
      'settings.general.row.common_languages_hint' =>
        'Select your common languages:',
      'settings.general.row.common_languages_sort' => 'Sort by Code',
      'settings.general.row.double_click_copy_result' =>
        'Double click to copy translation result',
      'settings.general.row.common_languages_reset' => 'Reset to Defaults',
      'settings.general.row.common_languages_reset_help' =>
        'Reset to the default set of common languages',
      'settings.general.row.common_languages_search' => 'Search languages...',
      'settings.general.row.common_languages_all' => 'All Languages',
      'settings.general.row.submit_with_enter' => 'Submit with Enter',
      'settings.general.row.submit_with_meta_enter_mac' =>
        'Submit with ⌘ + Enter',
      'settings.general.button.add_provider' => 'Add...',
      'settings.general.button.add_target' => 'Add Target...',
      'settings.general.button.manage_targets' =>
        'Manage Translation Targets...',
      'settings.general.button.manage_languages' =>
        'Manage Common Languages...',
      'settings.general.button.grant' => 'Grant',
      'settings.general.option.none' => 'None',
      'settings.general.option.no_services_available' =>
        'No services available',
      'settings.general.option.granted' => 'Granted',
      'settings.general.option.built_in_ocr' => 'Built-in OCR',
      'settings.general.option.tesseract' => 'Tesseract',
      'settings.general.option.youdao_ocr' => 'Youdao OCR',
      'settings.general.editor.add_target_title' => 'Add Translation Target',
      'settings.general.editor.edit_target_title' => 'Edit Translation Target',
      'settings.general.editor.row.source_language' => 'Source Language',
      'settings.general.editor.row.target_language' => 'Target Language',
      'settings.appearance.title' => 'Appearance',
      'settings.appearance.section.app_language' => 'Display Language',
      'settings.appearance.section.theme_mode' => 'Theme Mode',
      'settings.shortcuts.title' => 'Shortcuts',
      'settings.shortcuts.section.text_extraction' => 'Text Extraction',
      'settings.shortcuts.section.input_assist' => 'Input Assist Function',
      'settings.shortcuts.row.toggle_mini_translator' => 'Show/Hide Window',
      'settings.shortcuts.row.extract_text_from_screen_selection' =>
        'Extract text from screen selection',
      'settings.shortcuts.row.extract_text_from_screen_capture' =>
        'Extract text from screen capture',
      'settings.shortcuts.row.extract_text_from_clipboard' =>
        'Extract text from clipboard',
      'settings.shortcuts.row.translate_input' => 'Translate input content',
      'settings.shortcuts.reset_dialog.title' => 'Reset Shortcuts',
      'settings.shortcuts.reset_dialog.message' =>
        'Are you sure you want to reset all shortcuts to their default values?',
      'settings.shortcuts.reset_dialog.confirm' => 'Reset',
      'settings.shortcuts.reset_dialog.cancel' => 'Cancel',
      'settings.advanced.title' => 'Advanced',
      'settings.advanced.api_server' => 'Local API server',
      'settings.advanced.api_server_description' =>
        'Expose the translation API on 127.0.0.1 for local integrations.',
      'settings.advanced.enable' => 'Enable',
      'settings.advanced.port' => 'Port',
      'settings.advanced.running_at' => 'Running at {url}',
      'settings.advanced.disabled' => 'Disabled',
      'settings.providers.title' => 'Providers',
      'settings.providers.section.services' => 'Available Services',
      'settings.providers.section.services_description' =>
        'View available services from configured providers and switch between service types.',
      'settings.providers.item.empty' =>
        'No providers configured. Add one to enable translation services.',
      'settings.providers.item.loading' => 'Loading providers...',
      'settings.providers.item.no_services' => 'No services available.',
      'settings.providers.button.add' => 'Add a Provider...',
      'settings.providers.alert.error' => 'Error',
      'settings.providers.intro.body' =>
        'Manage the service providers used by the app.',
      'settings.providers.intro.warning' =>
        'Connected providers may process the text or images you send. Only enable services you trust.',
      'settings.providers.editor.row.id' => 'Provider ID',
      'settings.providers.editor.placeholder.id' => 'e.g. deepl-main',
      'settings.providers.editor.type_picker.prompt' =>
        'Select the type of provider you would like to add:',
      'settings.providers.editor.tooltip.help' => 'Help',
      'settings.providers.detail.tooltip.edit' => 'Edit provider',
      'settings.providers.capability.translation' => 'Translation',
      'settings.providers.capability.dictionary' => 'Dictionary',
      'settings.providers.capability.ocr' => 'OCR',
      'settings.providers.description.all' =>
        'Provides dictionary lookup and text translation',
      'settings.providers.description.dictionary' =>
        'Provides dictionary lookup and word definitions',
      'settings.providers.description.translation' =>
        'Provides text translation between languages',
      'settings.providers.description.fallback' =>
        'Provides translation services',
      'settings.providers.delete_dialog.title' => 'Delete "{}"?',
      'settings.providers.delete_dialog.message' =>
        'This action cannot be undone.',
      'settings.layout.title' => 'Settings',
      'settings.layout.empty.title' => 'Select a Category',
      'settings.layout.empty.message' =>
        'Choose a settings section from the sidebar.',
      _ => null,
    };
  }
}
