///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsFr extends Translations
    with BaseTranslations<AppLocale, Translations> {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsFr(
      {Map<String, Node>? overrides,
      PluralResolver? cardinalResolver,
      PluralResolver? ordinalResolver,
      TranslationMetadata<AppLocale, Translations>? meta})
      : assert(overrides == null,
            'Set "translation_overrides: true" in order to enable this feature.'),
        $meta = meta ??
            TranslationMetadata(
              locale: AppLocale.fr,
              overrides: overrides ?? {},
              cardinalResolver: cardinalResolver,
              ordinalResolver: ordinalResolver,
            ),
        super(
            cardinalResolver: cardinalResolver,
            ordinalResolver: ordinalResolver) {
    super.$meta.setFlatMapFunction(
        $meta.getTranslation); // copy base translations to super.$meta
    $meta.setFlatMapFunction(_flatMapFunction);
  }

  /// Metadata for the translations of <fr>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  /// Access flat map
  @override
  dynamic operator [](String key) =>
      $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

  late final TranslationsFr _root = this; // ignore: unused_field

  @override
  TranslationsFr $copyWith(
          {TranslationMetadata<AppLocale, Translations>? meta}) =>
      TranslationsFr(meta: meta ?? this.$meta);

  // Translations
  @override
  late final _TranslationsCommonFr common = _TranslationsCommonFr._(_root);
  @override
  late final _TranslationsAppFr app = _TranslationsAppFr._(_root);
  @override
  late final _TranslationsMiniTranslatorFr mini_translator =
      _TranslationsMiniTranslatorFr._(_root);
  @override
  late final _TranslationsSettingsFr settings =
      _TranslationsSettingsFr._(_root);
}

// Path: common
class _TranslationsCommonFr extends TranslationsCommonEn {
  _TranslationsCommonFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsCommonUiFr ui = _TranslationsCommonUiFr._(_root);
  @override
  late final _TranslationsCommonLanguageFr language =
      _TranslationsCommonLanguageFr._(_root);
  @override
  late final _TranslationsCommonThemeModeFr theme_mode =
      _TranslationsCommonThemeModeFr._(_root);
  @override
  late final _TranslationsCommonProviderFr provider =
      _TranslationsCommonProviderFr._(_root);
  @override
  late final _TranslationsCommonWordPronunciationFr word_pronunciation =
      _TranslationsCommonWordPronunciationFr._(_root);
}

// Path: app
class _TranslationsAppFr extends TranslationsAppEn {
  _TranslationsAppFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsAppTrayFr tray = _TranslationsAppTrayFr._(_root);
}

// Path: mini_translator
class _TranslationsMiniTranslatorFr extends TranslationsMiniTranslatorEn {
  _TranslationsMiniTranslatorFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsMiniTranslatorLimitedBannerFr limited_banner =
      _TranslationsMiniTranslatorLimitedBannerFr._(_root);
  @override
  late final _TranslationsMiniTranslatorInputFr input =
      _TranslationsMiniTranslatorInputFr._(_root);
  @override
  late final _TranslationsMiniTranslatorToolbarFr toolbar =
      _TranslationsMiniTranslatorToolbarFr._(_root);
  @override
  late final _TranslationsMiniTranslatorButtonFr button =
      _TranslationsMiniTranslatorButtonFr._(_root);
  @override
  late final _TranslationsMiniTranslatorLanguageFr language =
      _TranslationsMiniTranslatorLanguageFr._(_root);
  @override
  late final _TranslationsMiniTranslatorMessageFr message =
      _TranslationsMiniTranslatorMessageFr._(_root);
}

// Path: settings
class _TranslationsSettingsFr extends TranslationsSettingsEn {
  _TranslationsSettingsFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get version => 'Version {} BUILD {}';
  @override
  late final _TranslationsSettingsGeneralFr general =
      _TranslationsSettingsGeneralFr._(_root);
  @override
  late final _TranslationsSettingsAppearanceFr appearance =
      _TranslationsSettingsAppearanceFr._(_root);
  @override
  late final _TranslationsSettingsShortcutsFr shortcuts =
      _TranslationsSettingsShortcutsFr._(_root);
  @override
  late final _TranslationsSettingsAdvancedFr advanced =
      _TranslationsSettingsAdvancedFr._(_root);
  @override
  late final _TranslationsSettingsProvidersFr providers =
      _TranslationsSettingsProvidersFr._(_root);
  @override
  late final _TranslationsSettingsLayoutFr layout =
      _TranslationsSettingsLayoutFr._(_root);
}

// Path: common.ui
class _TranslationsCommonUiFr extends TranslationsCommonUiEn {
  _TranslationsCommonUiFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsCommonUiButtonFr button =
      _TranslationsCommonUiButtonFr._(_root);
  @override
  late final _TranslationsCommonUiFeedbackFr feedback =
      _TranslationsCommonUiFeedbackFr._(_root);
}

// Path: common.language
class _TranslationsCommonLanguageFr extends TranslationsCommonLanguageEn {
  _TranslationsCommonLanguageFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get ar => 'Arabe';
  @override
  String get bn => 'Bengali';
  @override
  String get de => 'Allemand';
  @override
  String get en => 'Anglais';
  @override
  String get es => 'Espagnol';
  @override
  String get fa => 'Persan';
  @override
  String get fr => 'Français';
  @override
  String get gu => 'Gujarati';
  @override
  String get ha => 'Haoussa';
  @override
  String get hi => 'Hindi';
  @override
  String get id => 'Indonésien';
  @override
  String get it => 'Italien';
  @override
  String get ja => 'Japonais';
  @override
  String get jv => 'Javanais';
  @override
  String get ko => 'Coréen';
  @override
  String get ml => 'Malayalam';
  @override
  String get mr => 'Marathi';
  @override
  String get ms => 'Malais';
  @override
  String get nl => 'Néerlandais';
  @override
  String get pa => 'Pendjabi';
  @override
  String get pl => 'Polonais';
  @override
  String get pt => 'Portugais';
  @override
  String get ro => 'Roumain';
  @override
  String get ru => 'Russe';
  @override
  String get sw => 'Swahili';
  @override
  String get ta => 'Tamoul';
  @override
  String get te => 'Télougou';
  @override
  String get th => 'Thaï';
  @override
  String get tr => 'Turc';
  @override
  String get uk => 'Ukrainien';
  @override
  String get ur => 'Ourdou';
  @override
  String get vi => 'Vietnamien';
  @override
  String get yo => 'Yoruba';
  @override
  String get zh_hans => 'Chinois simplifié';
  @override
  String get zh_hant => 'Chinois traditionnel';
}

// Path: common.theme_mode
class _TranslationsCommonThemeModeFr extends TranslationsCommonThemeModeEn {
  _TranslationsCommonThemeModeFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get light => 'Clair';
  @override
  String get dark => 'Sombre';
  @override
  String get system => 'Système';
}

// Path: common.provider
class _TranslationsCommonProviderFr extends TranslationsCommonProviderEn {
  _TranslationsCommonProviderFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get baidu => 'Baidu';
  @override
  String get caiyun => 'Caiyun';
  @override
  String get deepl => 'DeepL';
  @override
  String get google => 'Google';
  @override
  String get iciba => 'Iciba';
  @override
  String get sogou => 'Sogou';
  @override
  String get system => 'Système';
  @override
  String get tencent => 'Tencent';
  @override
  String get youdao => 'Youdao';
}

// Path: common.word_pronunciation
class _TranslationsCommonWordPronunciationFr
    extends TranslationsCommonWordPronunciationEn {
  _TranslationsCommonWordPronunciationFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get us => 'ÉU';
  @override
  String get uk => 'RU';
}

// Path: app.tray
class _TranslationsAppTrayFr extends TranslationsAppTrayEn {
  _TranslationsAppTrayFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsAppTrayContextMenuFr context_menu =
      _TranslationsAppTrayContextMenuFr._(_root);
}

// Path: mini_translator.limited_banner
class _TranslationsMiniTranslatorLimitedBannerFr
    extends TranslationsMiniTranslatorLimitedBannerEn {
  _TranslationsMiniTranslatorLimitedBannerFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsMiniTranslatorLimitedBannerPermissionFr permission =
      _TranslationsMiniTranslatorLimitedBannerPermissionFr._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerInstructionFr instruction =
      _TranslationsMiniTranslatorLimitedBannerInstructionFr._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerActionFr action =
      _TranslationsMiniTranslatorLimitedBannerActionFr._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerFeedbackFr feedback =
      _TranslationsMiniTranslatorLimitedBannerFeedbackFr._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerTooltipFr tooltip =
      _TranslationsMiniTranslatorLimitedBannerTooltipFr._(_root);
}

// Path: mini_translator.input
class _TranslationsMiniTranslatorInputFr
    extends TranslationsMiniTranslatorInputEn {
  _TranslationsMiniTranslatorInputFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get hint => 'Saisissez le mot ou le texte ici';
  @override
  String get extracting_text => 'Extraction du texte...';
}

// Path: mini_translator.toolbar
class _TranslationsMiniTranslatorToolbarFr
    extends TranslationsMiniTranslatorToolbarEn {
  _TranslationsMiniTranslatorToolbarFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsMiniTranslatorToolbarTooltipFr tooltip =
      _TranslationsMiniTranslatorToolbarTooltipFr._(_root);
}

// Path: mini_translator.button
class _TranslationsMiniTranslatorButtonFr
    extends TranslationsMiniTranslatorButtonEn {
  _TranslationsMiniTranslatorButtonFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get clear => 'Effacer';
  @override
  String get translate => 'Traduire';
}

// Path: mini_translator.language
class _TranslationsMiniTranslatorLanguageFr
    extends TranslationsMiniTranslatorLanguageEn {
  _TranslationsMiniTranslatorLanguageFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get auto_detect => 'Détection automatique';
  @override
  String get auto_match => 'Correspondance auto';
  @override
  String get switch_config => 'Changer de cible';
  @override
  String get more_languages => 'Plus de langues...';
  @override
  String get manage_common_languages => 'Gérer les langues courantes...';
  @override
  String get manage_targets => 'Gérer les cibles de traduction...';
  @override
  String get add_target => 'Ajouter une cible de traduction...';
}

// Path: mini_translator.message
class _TranslationsMiniTranslatorMessageFr
    extends TranslationsMiniTranslatorMessageEn {
  _TranslationsMiniTranslatorMessageFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get please_enter_word_or_text =>
      'Aucun texte saisi ou texte non extrait';
  @override
  String get capture_screen_area_canceled =>
      'La capture de la zone d\'écran a été annulée';
}

// Path: settings.general
class _TranslationsSettingsGeneralFr extends TranslationsSettingsGeneralEn {
  _TranslationsSettingsGeneralFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Général';
  @override
  late final _TranslationsSettingsGeneralSectionFr section =
      _TranslationsSettingsGeneralSectionFr._(_root);
  @override
  late final _TranslationsSettingsGeneralRowFr row =
      _TranslationsSettingsGeneralRowFr._(_root);
  @override
  late final _TranslationsSettingsGeneralButtonFr button =
      _TranslationsSettingsGeneralButtonFr._(_root);
  @override
  late final _TranslationsSettingsGeneralOptionFr option =
      _TranslationsSettingsGeneralOptionFr._(_root);
  @override
  late final _TranslationsSettingsGeneralEditorFr editor =
      _TranslationsSettingsGeneralEditorFr._(_root);
}

// Path: settings.appearance
class _TranslationsSettingsAppearanceFr
    extends TranslationsSettingsAppearanceEn {
  _TranslationsSettingsAppearanceFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Apparence';
  @override
  late final _TranslationsSettingsAppearanceSectionFr section =
      _TranslationsSettingsAppearanceSectionFr._(_root);
}

// Path: settings.shortcuts
class _TranslationsSettingsShortcutsFr extends TranslationsSettingsShortcutsEn {
  _TranslationsSettingsShortcutsFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Raccourcis';
  @override
  late final _TranslationsSettingsShortcutsSectionFr section =
      _TranslationsSettingsShortcutsSectionFr._(_root);
  @override
  late final _TranslationsSettingsShortcutsRowFr row =
      _TranslationsSettingsShortcutsRowFr._(_root);
  @override
  late final _TranslationsSettingsShortcutsResetDialogFr reset_dialog =
      _TranslationsSettingsShortcutsResetDialogFr._(_root);
}

// Path: settings.advanced
class _TranslationsSettingsAdvancedFr extends TranslationsSettingsAdvancedEn {
  _TranslationsSettingsAdvancedFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Avancé';
  @override
  String get api_server => 'Serveur API local';
  @override
  String get api_server_description =>
      'Expose l\'API de traduction sur 127.0.0.1 pour les intégrations locales.';
  @override
  String get enable => 'Activer';
  @override
  String get port => 'Port';
  @override
  String get running_at => 'En cours d\'exécution à {url}';
  @override
  String get disabled => 'Désactivé';
}

// Path: settings.providers
class _TranslationsSettingsProvidersFr extends TranslationsSettingsProvidersEn {
  _TranslationsSettingsProvidersFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Fournisseurs';
  @override
  late final _TranslationsSettingsProvidersSectionFr section =
      _TranslationsSettingsProvidersSectionFr._(_root);
  @override
  late final _TranslationsSettingsProvidersItemFr item =
      _TranslationsSettingsProvidersItemFr._(_root);
  @override
  late final _TranslationsSettingsProvidersButtonFr button =
      _TranslationsSettingsProvidersButtonFr._(_root);
  @override
  late final _TranslationsSettingsProvidersAlertFr alert =
      _TranslationsSettingsProvidersAlertFr._(_root);
  @override
  late final _TranslationsSettingsProvidersIntroFr intro =
      _TranslationsSettingsProvidersIntroFr._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorFr editor =
      _TranslationsSettingsProvidersEditorFr._(_root);
  @override
  late final _TranslationsSettingsProvidersDetailFr detail =
      _TranslationsSettingsProvidersDetailFr._(_root);
  @override
  late final _TranslationsSettingsProvidersCapabilityFr capability =
      _TranslationsSettingsProvidersCapabilityFr._(_root);
  @override
  late final _TranslationsSettingsProvidersDescriptionFr description =
      _TranslationsSettingsProvidersDescriptionFr._(_root);
  @override
  late final _TranslationsSettingsProvidersDeleteDialogFr delete_dialog =
      _TranslationsSettingsProvidersDeleteDialogFr._(_root);
}

// Path: settings.layout
class _TranslationsSettingsLayoutFr extends TranslationsSettingsLayoutEn {
  _TranslationsSettingsLayoutFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Paramètres';
  @override
  late final _TranslationsSettingsLayoutEmptyFr empty =
      _TranslationsSettingsLayoutEmptyFr._(_root);
}

// Path: common.ui.button
class _TranslationsCommonUiButtonFr extends TranslationsCommonUiButtonEn {
  _TranslationsCommonUiButtonFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get ok => 'OK';
  @override
  String get cancel => 'Annuler';
  @override
  String get add => 'Ajouter';
  @override
  String get delete => 'Supprimer';
  @override
  String get edit => 'Modifier';
  @override
  String get save => 'Enregistrer';
  @override
  String get manage => 'Gérer';
  @override
  String get kContinue => 'Continuer';
}

// Path: common.ui.feedback
class _TranslationsCommonUiFeedbackFr extends TranslationsCommonUiFeedbackEn {
  _TranslationsCommonUiFeedbackFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get copied => 'Copié';
}

// Path: app.tray.context_menu
class _TranslationsAppTrayContextMenuFr
    extends TranslationsAppTrayContextMenuEn {
  _TranslationsAppTrayContextMenuFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get show_window => 'Afficher la fenêtre';
  @override
  late final _TranslationsAppTrayContextMenuDevToolsFr dev_tools =
      _TranslationsAppTrayContextMenuDevToolsFr._(_root);
  @override
  String get check_for_updates => 'Vérifier les mises à jour';
  @override
  String get settings => 'Paramètres';
  @override
  String get quit => 'Quitter';
}

// Path: mini_translator.limited_banner.permission
class _TranslationsMiniTranslatorLimitedBannerPermissionFr
    extends TranslationsMiniTranslatorLimitedBannerPermissionEn {
  _TranslationsMiniTranslatorLimitedBannerPermissionFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get missing_both =>
      'Accordez les autorisations d\'enregistrement d\'écran et d\'accessibilité pour activer toutes les fonctionnalités.';
  @override
  String get missing_screen_capture =>
      'Accordez l\'autorisation d\'enregistrement d\'écran pour activer toutes les fonctionnalités.';
  @override
  String get missing_accessibility =>
      'Accordez l\'autorisation d\'accessibilité pour activer toutes les fonctionnalités.';
}

// Path: mini_translator.limited_banner.instruction
class _TranslationsMiniTranslatorLimitedBannerInstructionFr
    extends TranslationsMiniTranslatorLimitedBannerInstructionEn {
  _TranslationsMiniTranslatorLimitedBannerInstructionFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get app_settings_prefix => 'Accédez aux ';
  @override
  String get follow_guide_prefix => ', suivez le guide, puis cliquez sur ';
  @override
  String get suffix => '.';
}

// Path: mini_translator.limited_banner.action
class _TranslationsMiniTranslatorLimitedBannerActionFr
    extends TranslationsMiniTranslatorLimitedBannerActionEn {
  _TranslationsMiniTranslatorLimitedBannerActionFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get app_settings => 'Paramètres de l\'application';
  @override
  String get recheck => 'Re-vérifier';
}

// Path: mini_translator.limited_banner.feedback
class _TranslationsMiniTranslatorLimitedBannerFeedbackFr
    extends TranslationsMiniTranslatorLimitedBannerFeedbackEn {
  _TranslationsMiniTranslatorLimitedBannerFeedbackFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get enabled => 'L\'extraction de texte d\'écran est activée.';
  @override
  String get still_missing =>
      'Les autorisations requises sont toujours manquantes.\nVeuillez vérifier vos paramètres et réessayer.';
}

// Path: mini_translator.limited_banner.tooltip
class _TranslationsMiniTranslatorLimitedBannerTooltipFr
    extends TranslationsMiniTranslatorLimitedBannerTooltipEn {
  _TranslationsMiniTranslatorLimitedBannerTooltipFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get help => 'Voir l\'aide';
}

// Path: mini_translator.toolbar.tooltip
class _TranslationsMiniTranslatorToolbarTooltipFr
    extends TranslationsMiniTranslatorToolbarTooltipEn {
  _TranslationsMiniTranslatorToolbarTooltipFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get extract_text_from_screen_capture =>
      'Capturer une zone de l\'écran et reconnaître le texte';
  @override
  String get extract_text_from_clipboard => 'Lire le contenu du presse-papiers';
}

// Path: settings.general.section
class _TranslationsSettingsGeneralSectionFr
    extends TranslationsSettingsGeneralSectionEn {
  _TranslationsSettingsGeneralSectionFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get permissions => 'Autorisations';
  @override
  String get ocr => 'Reconnaissance de texte';
  @override
  String get directory => 'Répertoire';
  @override
  String get translation => 'Traduction';
  @override
  String get translation_target => 'Cible de traduction';
  @override
  String get languages => 'Langues';
  @override
  String get input => 'Paramètres de saisie';
}

// Path: settings.general.row
class _TranslationsSettingsGeneralRowFr
    extends TranslationsSettingsGeneralRowEn {
  _TranslationsSettingsGeneralRowFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get launch_at_startup => 'Lancer à l\'ouverture de session';
  @override
  String get show_in_menu_bar => 'Afficher dans la barre de menus';
  @override
  String get screen_capture_access =>
      'Accorder l\'accès à l\'enregistrement d\'écran';
  @override
  String get screen_selection_access => 'Accorder l\'accès à l\'accessibilité';
  @override
  String get default_ocr_service =>
      'Service de reconnaissance de texte par défaut';
  @override
  String get auto_copy_detected_text =>
      'Copier automatiquement le texte détecté';
  @override
  String get default_directory_service => 'Service de répertoire par défaut';
  @override
  String get default_translation_service => 'Service de traduction par défaut';
  @override
  String get common_languages => 'Langues courantes';
  @override
  String get common_languages_hint =>
      'Sélectionnez les langues à afficher en haut des sélecteurs de langue.';
  @override
  String get common_languages_reset => 'Réinitialiser';
  @override
  String get common_languages_reset_help =>
      'Rétablir l\'ensemble par défaut des langues courantes';
  @override
  String get double_click_copy_result =>
      'Double-cliquer pour copier le résultat de la traduction';
  @override
  String get submit_with_enter => 'Valider avec Entrée';
  @override
  String get submit_with_meta_enter_mac => 'Valider avec ⌘ + Entrée';
}

// Path: settings.general.button
class _TranslationsSettingsGeneralButtonFr
    extends TranslationsSettingsGeneralButtonEn {
  _TranslationsSettingsGeneralButtonFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get add_provider => 'Ajouter...';
  @override
  String get add_target => 'Ajouter une cible';
  @override
  String get manage_targets => 'Gérer les cibles de traduction...';
  @override
  String get grant => 'Accorder';
}

// Path: settings.general.option
class _TranslationsSettingsGeneralOptionFr
    extends TranslationsSettingsGeneralOptionEn {
  _TranslationsSettingsGeneralOptionFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get none => 'Aucun';
  @override
  String get no_services_available => 'Aucun service disponible';
  @override
  String get granted => 'Accordée';
  @override
  String get built_in_ocr => 'OCR intégré';
  @override
  String get tesseract => 'Tesseract';
  @override
  String get youdao_ocr => 'OCR Youdao';
}

// Path: settings.general.editor
class _TranslationsSettingsGeneralEditorFr
    extends TranslationsSettingsGeneralEditorEn {
  _TranslationsSettingsGeneralEditorFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsSettingsGeneralEditorRowFr row =
      _TranslationsSettingsGeneralEditorRowFr._(_root);
}

// Path: settings.appearance.section
class _TranslationsSettingsAppearanceSectionFr
    extends TranslationsSettingsAppearanceSectionEn {
  _TranslationsSettingsAppearanceSectionFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get app_language => 'Langue d\'affichage';
  @override
  String get theme_mode => 'Mode du thème';
}

// Path: settings.shortcuts.section
class _TranslationsSettingsShortcutsSectionFr
    extends TranslationsSettingsShortcutsSectionEn {
  _TranslationsSettingsShortcutsSectionFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get text_extraction => 'Extraction de texte';
  @override
  String get input_assist => 'Fonction d\'aide à la saisie';
}

// Path: settings.shortcuts.row
class _TranslationsSettingsShortcutsRowFr
    extends TranslationsSettingsShortcutsRowEn {
  _TranslationsSettingsShortcutsRowFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get toggle_mini_translator => 'Afficher/Masquer la fenêtre';
  @override
  String get extract_text_from_screen_selection =>
      'Extraire le texte d\'une sélection d\'écran';
  @override
  String get extract_text_from_screen_capture =>
      'Extraire le texte d\'une capture d\'écran';
  @override
  String get extract_text_from_clipboard =>
      'Extraire le texte du presse-papiers';
  @override
  String get translate_input => 'Traduire le contenu saisi';
}

// Path: settings.shortcuts.reset_dialog
class _TranslationsSettingsShortcutsResetDialogFr
    extends TranslationsSettingsShortcutsResetDialogEn {
  _TranslationsSettingsShortcutsResetDialogFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Réinitialiser les raccourcis';
  @override
  String get message =>
      'Êtes-vous sûr de vouloir réinitialiser tous les raccourcis à leurs valeurs par défaut ?';
  @override
  String get confirm => 'Réinitialiser';
  @override
  String get cancel => 'Annuler';
}

// Path: settings.providers.section
class _TranslationsSettingsProvidersSectionFr
    extends TranslationsSettingsProvidersSectionEn {
  _TranslationsSettingsProvidersSectionFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get services => 'Services disponibles';
  @override
  String get services_description =>
      'Consultez les services disponibles des fournisseurs configurés et changez de type de service.';
}

// Path: settings.providers.item
class _TranslationsSettingsProvidersItemFr
    extends TranslationsSettingsProvidersItemEn {
  _TranslationsSettingsProvidersItemFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get empty =>
      'Aucun fournisseur configuré. Ajoutez-en un pour activer les services de traduction.';
  @override
  String get loading => 'Chargement des fournisseurs...';
  @override
  String get no_services => 'Aucun service disponible.';
}

// Path: settings.providers.button
class _TranslationsSettingsProvidersButtonFr
    extends TranslationsSettingsProvidersButtonEn {
  _TranslationsSettingsProvidersButtonFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get add => 'Ajouter un fournisseur...';
}

// Path: settings.providers.alert
class _TranslationsSettingsProvidersAlertFr
    extends TranslationsSettingsProvidersAlertEn {
  _TranslationsSettingsProvidersAlertFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get error => 'Erreur';
}

// Path: settings.providers.intro
class _TranslationsSettingsProvidersIntroFr
    extends TranslationsSettingsProvidersIntroEn {
  _TranslationsSettingsProvidersIntroFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get body =>
      'Gérez les fournisseurs de services utilisés par l’application.';
  @override
  String get warning =>
      'Les fournisseurs connectés peuvent traiter le texte ou les images que vous envoyez. Activez uniquement les services de confiance.';
}

// Path: settings.providers.editor
class _TranslationsSettingsProvidersEditorFr
    extends TranslationsSettingsProvidersEditorEn {
  _TranslationsSettingsProvidersEditorFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsSettingsProvidersEditorRowFr row =
      _TranslationsSettingsProvidersEditorRowFr._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorPlaceholderFr placeholder =
      _TranslationsSettingsProvidersEditorPlaceholderFr._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorTypePickerFr type_picker =
      _TranslationsSettingsProvidersEditorTypePickerFr._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorTooltipFr tooltip =
      _TranslationsSettingsProvidersEditorTooltipFr._(_root);
}

// Path: settings.providers.detail
class _TranslationsSettingsProvidersDetailFr
    extends TranslationsSettingsProvidersDetailEn {
  _TranslationsSettingsProvidersDetailFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsSettingsProvidersDetailTooltipFr tooltip =
      _TranslationsSettingsProvidersDetailTooltipFr._(_root);
}

// Path: settings.providers.capability
class _TranslationsSettingsProvidersCapabilityFr
    extends TranslationsSettingsProvidersCapabilityEn {
  _TranslationsSettingsProvidersCapabilityFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get translation => 'Traduction';
  @override
  String get dictionary => 'Dictionnaire';
  @override
  String get ocr => 'OCR';
}

// Path: settings.providers.description
class _TranslationsSettingsProvidersDescriptionFr
    extends TranslationsSettingsProvidersDescriptionEn {
  _TranslationsSettingsProvidersDescriptionFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get all =>
      'Fournit la recherche dans le dictionnaire et la traduction de texte';
  @override
  String get dictionary =>
      'Fournit la recherche dans le dictionnaire et les définitions de mots';
  @override
  String get translation => 'Fournit la traduction de texte entre les langues';
  @override
  String get fallback => 'Fournit des services de traduction';
}

// Path: settings.providers.delete_dialog
class _TranslationsSettingsProvidersDeleteDialogFr
    extends TranslationsSettingsProvidersDeleteDialogEn {
  _TranslationsSettingsProvidersDeleteDialogFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Supprimer « {} » ?';
  @override
  String get message => 'Cette action est irréversible.';
}

// Path: settings.layout.empty
class _TranslationsSettingsLayoutEmptyFr
    extends TranslationsSettingsLayoutEmptyEn {
  _TranslationsSettingsLayoutEmptyFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Sélectionnez une catégorie';
  @override
  String get message =>
      'Choisissez une section de paramètres dans la barre latérale.';
}

// Path: app.tray.context_menu.dev_tools
class _TranslationsAppTrayContextMenuDevToolsFr
    extends TranslationsAppTrayContextMenuDevToolsEn {
  _TranslationsAppTrayContextMenuDevToolsFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Outils de développement';
  @override
  String get open_data_directory => 'Ouvrir le répertoire de données';
  @override
  String get use_native_settings => 'Utiliser la page de paramètres native';
}

// Path: settings.general.editor.row
class _TranslationsSettingsGeneralEditorRowFr
    extends TranslationsSettingsGeneralEditorRowEn {
  _TranslationsSettingsGeneralEditorRowFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get source_language => 'Langue source';
  @override
  String get target_language => 'Langue cible';
}

// Path: settings.providers.editor.row
class _TranslationsSettingsProvidersEditorRowFr
    extends TranslationsSettingsProvidersEditorRowEn {
  _TranslationsSettingsProvidersEditorRowFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get id => 'Identifiant du fournisseur';
}

// Path: settings.providers.editor.placeholder
class _TranslationsSettingsProvidersEditorPlaceholderFr
    extends TranslationsSettingsProvidersEditorPlaceholderEn {
  _TranslationsSettingsProvidersEditorPlaceholderFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get id => 'p. ex. deepl-main';
}

// Path: settings.providers.editor.type_picker
class _TranslationsSettingsProvidersEditorTypePickerFr
    extends TranslationsSettingsProvidersEditorTypePickerEn {
  _TranslationsSettingsProvidersEditorTypePickerFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get prompt =>
      'Sélectionnez le type de fournisseur que vous souhaitez ajouter :';
}

// Path: settings.providers.editor.tooltip
class _TranslationsSettingsProvidersEditorTooltipFr
    extends TranslationsSettingsProvidersEditorTooltipEn {
  _TranslationsSettingsProvidersEditorTooltipFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get help => 'Aide';
}

// Path: settings.providers.detail.tooltip
class _TranslationsSettingsProvidersDetailTooltipFr
    extends TranslationsSettingsProvidersDetailTooltipEn {
  _TranslationsSettingsProvidersDetailTooltipFr._(TranslationsFr root)
      : this._root = root,
        super.internal(root);

  final TranslationsFr _root; // ignore: unused_field

  // Translations
  @override
  String get edit => 'Modifier le fournisseur';
}

/// The flat map containing all translations for locale <fr>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsFr {
  dynamic _flatMapFunction(String path) {
    return switch (path) {
      'common.ui.button.ok' => 'OK',
      'common.ui.button.cancel' => 'Annuler',
      'common.ui.button.add' => 'Ajouter',
      'common.ui.button.delete' => 'Supprimer',
      'common.ui.button.edit' => 'Modifier',
      'common.ui.button.save' => 'Enregistrer',
      'common.ui.button.manage' => 'Gérer',
      'common.ui.button.kContinue' => 'Continuer',
      'common.ui.feedback.copied' => 'Copié',
      'common.language.ar' => 'Arabe',
      'common.language.bn' => 'Bengali',
      'common.language.de' => 'Allemand',
      'common.language.en' => 'Anglais',
      'common.language.es' => 'Espagnol',
      'common.language.fa' => 'Persan',
      'common.language.fr' => 'Français',
      'common.language.gu' => 'Gujarati',
      'common.language.ha' => 'Haoussa',
      'common.language.hi' => 'Hindi',
      'common.language.id' => 'Indonésien',
      'common.language.it' => 'Italien',
      'common.language.ja' => 'Japonais',
      'common.language.jv' => 'Javanais',
      'common.language.ko' => 'Coréen',
      'common.language.ml' => 'Malayalam',
      'common.language.mr' => 'Marathi',
      'common.language.ms' => 'Malais',
      'common.language.nl' => 'Néerlandais',
      'common.language.pa' => 'Pendjabi',
      'common.language.pl' => 'Polonais',
      'common.language.pt' => 'Portugais',
      'common.language.ro' => 'Roumain',
      'common.language.ru' => 'Russe',
      'common.language.sw' => 'Swahili',
      'common.language.ta' => 'Tamoul',
      'common.language.te' => 'Télougou',
      'common.language.th' => 'Thaï',
      'common.language.tr' => 'Turc',
      'common.language.uk' => 'Ukrainien',
      'common.language.ur' => 'Ourdou',
      'common.language.vi' => 'Vietnamien',
      'common.language.yo' => 'Yoruba',
      'common.language.zh_hans' => 'Chinois simplifié',
      'common.language.zh_hant' => 'Chinois traditionnel',
      'common.theme_mode.light' => 'Clair',
      'common.theme_mode.dark' => 'Sombre',
      'common.theme_mode.system' => 'Système',
      'common.provider.baidu' => 'Baidu',
      'common.provider.caiyun' => 'Caiyun',
      'common.provider.deepl' => 'DeepL',
      'common.provider.google' => 'Google',
      'common.provider.iciba' => 'Iciba',
      'common.provider.sogou' => 'Sogou',
      'common.provider.system' => 'Système',
      'common.provider.tencent' => 'Tencent',
      'common.provider.youdao' => 'Youdao',
      'common.word_pronunciation.us' => 'ÉU',
      'common.word_pronunciation.uk' => 'RU',
      'app.tray.context_menu.show_window' => 'Afficher la fenêtre',
      'app.tray.context_menu.dev_tools.title' => 'Outils de développement',
      'app.tray.context_menu.dev_tools.open_data_directory' =>
        'Ouvrir le répertoire de données',
      'app.tray.context_menu.dev_tools.use_native_settings' =>
        'Utiliser la page de paramètres native',
      'app.tray.context_menu.check_for_updates' => 'Vérifier les mises à jour',
      'app.tray.context_menu.settings' => 'Paramètres',
      'app.tray.context_menu.quit' => 'Quitter',
      'mini_translator.limited_banner.permission.missing_both' =>
        'Accordez les autorisations d\'enregistrement d\'écran et d\'accessibilité pour activer toutes les fonctionnalités.',
      'mini_translator.limited_banner.permission.missing_screen_capture' =>
        'Accordez l\'autorisation d\'enregistrement d\'écran pour activer toutes les fonctionnalités.',
      'mini_translator.limited_banner.permission.missing_accessibility' =>
        'Accordez l\'autorisation d\'accessibilité pour activer toutes les fonctionnalités.',
      'mini_translator.limited_banner.instruction.app_settings_prefix' =>
        'Accédez aux ',
      'mini_translator.limited_banner.instruction.follow_guide_prefix' =>
        ', suivez le guide, puis cliquez sur ',
      'mini_translator.limited_banner.instruction.suffix' => '.',
      'mini_translator.limited_banner.action.app_settings' =>
        'Paramètres de l\'application',
      'mini_translator.limited_banner.action.recheck' => 'Re-vérifier',
      'mini_translator.limited_banner.feedback.enabled' =>
        'L\'extraction de texte d\'écran est activée.',
      'mini_translator.limited_banner.feedback.still_missing' =>
        'Les autorisations requises sont toujours manquantes.\nVeuillez vérifier vos paramètres et réessayer.',
      'mini_translator.limited_banner.tooltip.help' => 'Voir l\'aide',
      'mini_translator.input.hint' => 'Saisissez le mot ou le texte ici',
      'mini_translator.input.extracting_text' => 'Extraction du texte...',
      'mini_translator.toolbar.tooltip.extract_text_from_screen_capture' =>
        'Capturer une zone de l\'écran et reconnaître le texte',
      'mini_translator.toolbar.tooltip.extract_text_from_clipboard' =>
        'Lire le contenu du presse-papiers',
      'mini_translator.button.clear' => 'Effacer',
      'mini_translator.button.translate' => 'Traduire',
      'mini_translator.language.auto_detect' => 'Détection automatique',
      'mini_translator.language.auto_match' => 'Correspondance auto',
      'mini_translator.language.switch_config' => 'Changer de cible',
      'mini_translator.language.more_languages' => 'Plus de langues...',
      'mini_translator.language.manage_common_languages' =>
        'Gérer les langues courantes...',
      'mini_translator.language.manage_targets' =>
        'Gérer les cibles de traduction...',
      'mini_translator.language.add_target' =>
        'Ajouter une cible de traduction...',
      'mini_translator.message.please_enter_word_or_text' =>
        'Aucun texte saisi ou texte non extrait',
      'mini_translator.message.capture_screen_area_canceled' =>
        'La capture de la zone d\'écran a été annulée',
      'settings.version' => 'Version {} BUILD {}',
      'settings.general.title' => 'Général',
      'settings.general.section.permissions' => 'Autorisations',
      'settings.general.section.ocr' => 'Reconnaissance de texte',
      'settings.general.section.directory' => 'Répertoire',
      'settings.general.section.translation' => 'Traduction',
      'settings.general.section.translation_target' => 'Cible de traduction',
      'settings.general.section.languages' => 'Langues',
      'settings.general.section.input' => 'Paramètres de saisie',
      'settings.general.row.launch_at_startup' =>
        'Lancer à l\'ouverture de session',
      'settings.general.row.show_in_menu_bar' =>
        'Afficher dans la barre de menus',
      'settings.general.row.screen_capture_access' =>
        'Accorder l\'accès à l\'enregistrement d\'écran',
      'settings.general.row.screen_selection_access' =>
        'Accorder l\'accès à l\'accessibilité',
      'settings.general.row.default_ocr_service' =>
        'Service de reconnaissance de texte par défaut',
      'settings.general.row.auto_copy_detected_text' =>
        'Copier automatiquement le texte détecté',
      'settings.general.row.default_directory_service' =>
        'Service de répertoire par défaut',
      'settings.general.row.default_translation_service' =>
        'Service de traduction par défaut',
      'settings.general.row.common_languages' => 'Langues courantes',
      'settings.general.row.common_languages_hint' =>
        'Sélectionnez les langues à afficher en haut des sélecteurs de langue.',
      'settings.general.row.common_languages_reset' => 'Réinitialiser',
      'settings.general.row.common_languages_reset_help' =>
        'Rétablir l\'ensemble par défaut des langues courantes',
      'settings.general.row.double_click_copy_result' =>
        'Double-cliquer pour copier le résultat de la traduction',
      'settings.general.row.submit_with_enter' => 'Valider avec Entrée',
      'settings.general.row.submit_with_meta_enter_mac' =>
        'Valider avec ⌘ + Entrée',
      'settings.general.button.add_provider' => 'Ajouter...',
      'settings.general.button.add_target' => 'Ajouter une cible',
      'settings.general.button.manage_targets' =>
        'Gérer les cibles de traduction...',
      'settings.general.button.grant' => 'Accorder',
      'settings.general.option.none' => 'Aucun',
      'settings.general.option.no_services_available' =>
        'Aucun service disponible',
      'settings.general.option.granted' => 'Accordée',
      'settings.general.option.built_in_ocr' => 'OCR intégré',
      'settings.general.option.tesseract' => 'Tesseract',
      'settings.general.option.youdao_ocr' => 'OCR Youdao',
      'settings.general.editor.row.source_language' => 'Langue source',
      'settings.general.editor.row.target_language' => 'Langue cible',
      'settings.appearance.title' => 'Apparence',
      'settings.appearance.section.app_language' => 'Langue d\'affichage',
      'settings.appearance.section.theme_mode' => 'Mode du thème',
      'settings.shortcuts.title' => 'Raccourcis',
      'settings.shortcuts.section.text_extraction' => 'Extraction de texte',
      'settings.shortcuts.section.input_assist' =>
        'Fonction d\'aide à la saisie',
      'settings.shortcuts.row.toggle_mini_translator' =>
        'Afficher/Masquer la fenêtre',
      'settings.shortcuts.row.extract_text_from_screen_selection' =>
        'Extraire le texte d\'une sélection d\'écran',
      'settings.shortcuts.row.extract_text_from_screen_capture' =>
        'Extraire le texte d\'une capture d\'écran',
      'settings.shortcuts.row.extract_text_from_clipboard' =>
        'Extraire le texte du presse-papiers',
      'settings.shortcuts.row.translate_input' => 'Traduire le contenu saisi',
      'settings.shortcuts.reset_dialog.title' => 'Réinitialiser les raccourcis',
      'settings.shortcuts.reset_dialog.message' =>
        'Êtes-vous sûr de vouloir réinitialiser tous les raccourcis à leurs valeurs par défaut ?',
      'settings.shortcuts.reset_dialog.confirm' => 'Réinitialiser',
      'settings.shortcuts.reset_dialog.cancel' => 'Annuler',
      'settings.advanced.title' => 'Avancé',
      'settings.advanced.api_server' => 'Serveur API local',
      'settings.advanced.api_server_description' =>
        'Expose l\'API de traduction sur 127.0.0.1 pour les intégrations locales.',
      'settings.advanced.enable' => 'Activer',
      'settings.advanced.port' => 'Port',
      'settings.advanced.running_at' => 'En cours d\'exécution à {url}',
      'settings.advanced.disabled' => 'Désactivé',
      'settings.providers.title' => 'Fournisseurs',
      'settings.providers.section.services' => 'Services disponibles',
      'settings.providers.section.services_description' =>
        'Consultez les services disponibles des fournisseurs configurés et changez de type de service.',
      'settings.providers.item.empty' =>
        'Aucun fournisseur configuré. Ajoutez-en un pour activer les services de traduction.',
      'settings.providers.item.loading' => 'Chargement des fournisseurs...',
      'settings.providers.item.no_services' => 'Aucun service disponible.',
      'settings.providers.button.add' => 'Ajouter un fournisseur...',
      'settings.providers.alert.error' => 'Erreur',
      'settings.providers.intro.body' =>
        'Gérez les fournisseurs de services utilisés par l’application.',
      'settings.providers.intro.warning' =>
        'Les fournisseurs connectés peuvent traiter le texte ou les images que vous envoyez. Activez uniquement les services de confiance.',
      'settings.providers.editor.row.id' => 'Identifiant du fournisseur',
      'settings.providers.editor.placeholder.id' => 'p. ex. deepl-main',
      'settings.providers.editor.type_picker.prompt' =>
        'Sélectionnez le type de fournisseur que vous souhaitez ajouter :',
      'settings.providers.editor.tooltip.help' => 'Aide',
      'settings.providers.detail.tooltip.edit' => 'Modifier le fournisseur',
      'settings.providers.capability.translation' => 'Traduction',
      'settings.providers.capability.dictionary' => 'Dictionnaire',
      'settings.providers.capability.ocr' => 'OCR',
      'settings.providers.description.all' =>
        'Fournit la recherche dans le dictionnaire et la traduction de texte',
      'settings.providers.description.dictionary' =>
        'Fournit la recherche dans le dictionnaire et les définitions de mots',
      'settings.providers.description.translation' =>
        'Fournit la traduction de texte entre les langues',
      'settings.providers.description.fallback' =>
        'Fournit des services de traduction',
      'settings.providers.delete_dialog.title' => 'Supprimer « {} » ?',
      'settings.providers.delete_dialog.message' =>
        'Cette action est irréversible.',
      'settings.layout.title' => 'Paramètres',
      'settings.layout.empty.title' => 'Sélectionnez une catégorie',
      'settings.layout.empty.message' =>
        'Choisissez une section de paramètres dans la barre latérale.',
      _ => null,
    };
  }
}
