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
class TranslationsEs extends Translations
    with BaseTranslations<AppLocale, Translations> {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsEs(
      {Map<String, Node>? overrides,
      PluralResolver? cardinalResolver,
      PluralResolver? ordinalResolver,
      TranslationMetadata<AppLocale, Translations>? meta})
      : assert(overrides == null,
            'Set "translation_overrides: true" in order to enable this feature.'),
        $meta = meta ??
            TranslationMetadata(
              locale: AppLocale.es,
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

  /// Metadata for the translations of <es>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  /// Access flat map
  @override
  dynamic operator [](String key) =>
      $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

  late final TranslationsEs _root = this; // ignore: unused_field

  @override
  TranslationsEs $copyWith(
          {TranslationMetadata<AppLocale, Translations>? meta}) =>
      TranslationsEs(meta: meta ?? this.$meta);

  // Translations
  @override
  late final _TranslationsCommonEs common = _TranslationsCommonEs._(_root);
  @override
  late final _TranslationsAppEs app = _TranslationsAppEs._(_root);
  @override
  late final _TranslationsMiniTranslatorEs mini_translator =
      _TranslationsMiniTranslatorEs._(_root);
  @override
  late final _TranslationsSettingsEs settings =
      _TranslationsSettingsEs._(_root);
}

// Path: common
class _TranslationsCommonEs extends TranslationsCommonEn {
  _TranslationsCommonEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsCommonUiEs ui = _TranslationsCommonUiEs._(_root);
  @override
  late final _TranslationsCommonLanguageEs language =
      _TranslationsCommonLanguageEs._(_root);
  @override
  late final _TranslationsCommonThemeModeEs theme_mode =
      _TranslationsCommonThemeModeEs._(_root);
  @override
  late final _TranslationsCommonProviderEs provider =
      _TranslationsCommonProviderEs._(_root);
  @override
  late final _TranslationsCommonWordPronunciationEs word_pronunciation =
      _TranslationsCommonWordPronunciationEs._(_root);
}

// Path: app
class _TranslationsAppEs extends TranslationsAppEn {
  _TranslationsAppEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsAppTrayEs tray = _TranslationsAppTrayEs._(_root);
}

// Path: mini_translator
class _TranslationsMiniTranslatorEs extends TranslationsMiniTranslatorEn {
  _TranslationsMiniTranslatorEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsMiniTranslatorLimitedBannerEs limited_banner =
      _TranslationsMiniTranslatorLimitedBannerEs._(_root);
  @override
  late final _TranslationsMiniTranslatorInputEs input =
      _TranslationsMiniTranslatorInputEs._(_root);
  @override
  late final _TranslationsMiniTranslatorToolbarEs toolbar =
      _TranslationsMiniTranslatorToolbarEs._(_root);
  @override
  late final _TranslationsMiniTranslatorButtonEs button =
      _TranslationsMiniTranslatorButtonEs._(_root);
  @override
  late final _TranslationsMiniTranslatorLanguageEs language =
      _TranslationsMiniTranslatorLanguageEs._(_root);
  @override
  late final _TranslationsMiniTranslatorMessageEs message =
      _TranslationsMiniTranslatorMessageEs._(_root);
}

// Path: settings
class _TranslationsSettingsEs extends TranslationsSettingsEn {
  _TranslationsSettingsEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get version => 'v{} (Build {})';
  @override
  late final _TranslationsSettingsGeneralEs general =
      _TranslationsSettingsGeneralEs._(_root);
  @override
  late final _TranslationsSettingsAppearanceEs appearance =
      _TranslationsSettingsAppearanceEs._(_root);
  @override
  late final _TranslationsSettingsShortcutsEs shortcuts =
      _TranslationsSettingsShortcutsEs._(_root);
  @override
  late final _TranslationsSettingsAdvancedEs advanced =
      _TranslationsSettingsAdvancedEs._(_root);
  @override
  late final _TranslationsSettingsServicesEs services =
      _TranslationsSettingsServicesEs._(_root);
  @override
  late final _TranslationsSettingsProvidersEs providers =
      _TranslationsSettingsProvidersEs._(_root);
  @override
  late final _TranslationsSettingsLayoutEs layout =
      _TranslationsSettingsLayoutEs._(_root);
  @override
  late final _TranslationsSettingsAboutEs about =
      _TranslationsSettingsAboutEs._(_root);
}

// Path: common.ui
class _TranslationsCommonUiEs extends TranslationsCommonUiEn {
  _TranslationsCommonUiEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsCommonUiButtonEs button =
      _TranslationsCommonUiButtonEs._(_root);
  @override
  late final _TranslationsCommonUiFeedbackEs feedback =
      _TranslationsCommonUiFeedbackEs._(_root);
}

// Path: common.language
class _TranslationsCommonLanguageEs extends TranslationsCommonLanguageEn {
  _TranslationsCommonLanguageEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get ar => 'Árabe';
  @override
  String get bn => 'Bengalí';
  @override
  String get de => 'Alemán';
  @override
  String get en => 'Inglés';
  @override
  String get es => 'Español';
  @override
  String get fa => 'Persa';
  @override
  String get fr => 'Francés';
  @override
  String get gu => 'Guyaratí';
  @override
  String get ha => 'Hausa';
  @override
  String get hi => 'Hindi';
  @override
  String get id => 'Indonesio';
  @override
  String get it => 'Italiano';
  @override
  String get ja => 'Japonés';
  @override
  String get jv => 'Javanés';
  @override
  String get ko => 'Coreano';
  @override
  String get ml => 'Malayalam';
  @override
  String get mr => 'Maratí';
  @override
  String get ms => 'Malayo';
  @override
  String get nl => 'Neerlandés';
  @override
  String get pa => 'Panyabí';
  @override
  String get pl => 'Polaco';
  @override
  String get pt => 'Portugués';
  @override
  String get ro => 'Rumano';
  @override
  String get ru => 'Ruso';
  @override
  String get sw => 'Suajili';
  @override
  String get ta => 'Tamil';
  @override
  String get te => 'Telugú';
  @override
  String get th => 'Tailandés';
  @override
  String get tr => 'Turco';
  @override
  String get uk => 'Ucraniano';
  @override
  String get ur => 'Urdu';
  @override
  String get vi => 'Vietnamita';
  @override
  String get yo => 'Yoruba';
  @override
  String get zh_hans => 'Chino simplificado';
  @override
  String get zh_hant => 'Chino tradicional';
}

// Path: common.theme_mode
class _TranslationsCommonThemeModeEs extends TranslationsCommonThemeModeEn {
  _TranslationsCommonThemeModeEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get light => 'Claro';
  @override
  String get dark => 'Oscuro';
  @override
  String get system => 'Sistema';
}

// Path: common.provider
class _TranslationsCommonProviderEs extends TranslationsCommonProviderEn {
  _TranslationsCommonProviderEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get anthropic => 'Anthropic';
  @override
  String get baidu => 'Baidu';
  @override
  String get caiyun => 'Caiyun';
  @override
  String get deepl => 'DeepL';
  @override
  String get google => 'Google';
  @override
  String get ollama => 'Ollama';
  @override
  String get openai => 'OpenAI';
  @override
  String get sogou => 'Sogou';
  @override
  String get xai => 'xAI';
  @override
  String get system => 'Sistema';
  @override
  String get tencent => 'Tencent';
  @override
  String get youdao => 'Youdao';
}

// Path: common.word_pronunciation
class _TranslationsCommonWordPronunciationEs
    extends TranslationsCommonWordPronunciationEn {
  _TranslationsCommonWordPronunciationEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get us => 'EE. UU.';
  @override
  String get uk => 'RU';
}

// Path: app.tray
class _TranslationsAppTrayEs extends TranslationsAppTrayEn {
  _TranslationsAppTrayEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsAppTrayContextMenuEs context_menu =
      _TranslationsAppTrayContextMenuEs._(_root);
}

// Path: mini_translator.limited_banner
class _TranslationsMiniTranslatorLimitedBannerEs
    extends TranslationsMiniTranslatorLimitedBannerEn {
  _TranslationsMiniTranslatorLimitedBannerEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsMiniTranslatorLimitedBannerPermissionEs permission =
      _TranslationsMiniTranslatorLimitedBannerPermissionEs._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerInstructionEs instruction =
      _TranslationsMiniTranslatorLimitedBannerInstructionEs._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerActionEs action =
      _TranslationsMiniTranslatorLimitedBannerActionEs._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerFeedbackEs feedback =
      _TranslationsMiniTranslatorLimitedBannerFeedbackEs._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerTooltipEs tooltip =
      _TranslationsMiniTranslatorLimitedBannerTooltipEs._(_root);
}

// Path: mini_translator.input
class _TranslationsMiniTranslatorInputEs
    extends TranslationsMiniTranslatorInputEn {
  _TranslationsMiniTranslatorInputEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get hint => 'Escribe la palabra o texto aquí';
  @override
  String get extracting_text => 'Extrayendo texto...';
}

// Path: mini_translator.toolbar
class _TranslationsMiniTranslatorToolbarEs
    extends TranslationsMiniTranslatorToolbarEn {
  _TranslationsMiniTranslatorToolbarEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsMiniTranslatorToolbarTooltipEs tooltip =
      _TranslationsMiniTranslatorToolbarTooltipEs._(_root);
}

// Path: mini_translator.button
class _TranslationsMiniTranslatorButtonEs
    extends TranslationsMiniTranslatorButtonEn {
  _TranslationsMiniTranslatorButtonEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get clear => 'Limpiar';
  @override
  String get translate => 'Traducir';
}

// Path: mini_translator.language
class _TranslationsMiniTranslatorLanguageEs
    extends TranslationsMiniTranslatorLanguageEn {
  _TranslationsMiniTranslatorLanguageEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get auto_detect => 'Detección automática';
  @override
  String get auto_match => 'Coincidencia auto';
  @override
  String get switch_config => 'Cambiar destino';
  @override
  String get more_languages => 'Más idiomas...';
  @override
  String get manage_common_languages => 'Administrar idiomas comunes...';
  @override
  String get manage_targets => 'Administrar destinos de traducción...';
  @override
  String get add_target => 'Agregar destino de traducción...';
}

// Path: mini_translator.message
class _TranslationsMiniTranslatorMessageEs
    extends TranslationsMiniTranslatorMessageEn {
  _TranslationsMiniTranslatorMessageEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get please_enter_word_or_text =>
      'No se ingresó texto o no se pudo extraer';
  @override
  String get capture_screen_area_canceled =>
      'La captura de área de pantalla ha sido cancelada';
  @override
  String get ocr_service_not_configured =>
      'No hay un servicio de reconocimiento de texto predeterminado configurado. Configúrelo en Ajustes.';
  @override
  String get ocr_recognition_failed => 'El reconocimiento de texto falló';
}

// Path: settings.general
class _TranslationsSettingsGeneralEs extends TranslationsSettingsGeneralEn {
  _TranslationsSettingsGeneralEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'General';
  @override
  late final _TranslationsSettingsGeneralSectionEs section =
      _TranslationsSettingsGeneralSectionEs._(_root);
  @override
  late final _TranslationsSettingsGeneralRowEs row =
      _TranslationsSettingsGeneralRowEs._(_root);
  @override
  late final _TranslationsSettingsGeneralButtonEs button =
      _TranslationsSettingsGeneralButtonEs._(_root);
  @override
  late final _TranslationsSettingsGeneralOptionEs option =
      _TranslationsSettingsGeneralOptionEs._(_root);
  @override
  late final _TranslationsSettingsGeneralEditorEs editor =
      _TranslationsSettingsGeneralEditorEs._(_root);
}

// Path: settings.appearance
class _TranslationsSettingsAppearanceEs
    extends TranslationsSettingsAppearanceEn {
  _TranslationsSettingsAppearanceEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Apariencia';
  @override
  late final _TranslationsSettingsAppearanceSectionEs section =
      _TranslationsSettingsAppearanceSectionEs._(_root);
}

// Path: settings.shortcuts
class _TranslationsSettingsShortcutsEs extends TranslationsSettingsShortcutsEn {
  _TranslationsSettingsShortcutsEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Atajos';
  @override
  late final _TranslationsSettingsShortcutsSectionEs section =
      _TranslationsSettingsShortcutsSectionEs._(_root);
  @override
  late final _TranslationsSettingsShortcutsRowEs row =
      _TranslationsSettingsShortcutsRowEs._(_root);
  @override
  late final _TranslationsSettingsShortcutsResetDialogEs reset_dialog =
      _TranslationsSettingsShortcutsResetDialogEs._(_root);
}

// Path: settings.advanced
class _TranslationsSettingsAdvancedEs extends TranslationsSettingsAdvancedEn {
  _TranslationsSettingsAdvancedEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Avanzado';
  @override
  String get api_server => 'Servidor de API local';
  @override
  String get api_server_description =>
      'Exponer la API de traducción en 127.0.0.1 para integraciones locales.';
  @override
  String get enable => 'Habilitar';
  @override
  String get port => 'Puerto';
  @override
  String get running_at => 'Ejecutándose en {url}';
  @override
  String get disabled => 'Deshabilitado';
}

// Path: settings.services
class _TranslationsSettingsServicesEs extends TranslationsSettingsServicesEn {
  _TranslationsSettingsServicesEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Servicios';
  @override
  late final _TranslationsSettingsServicesButtonEs button =
      _TranslationsSettingsServicesButtonEs._(_root);
  @override
  late final _TranslationsSettingsServicesSectionEs section =
      _TranslationsSettingsServicesSectionEs._(_root);
  @override
  late final _TranslationsSettingsServicesEditorEs editor =
      _TranslationsSettingsServicesEditorEs._(_root);
}

// Path: settings.providers
class _TranslationsSettingsProvidersEs extends TranslationsSettingsProvidersEn {
  _TranslationsSettingsProvidersEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Proveedores';
  @override
  late final _TranslationsSettingsProvidersSectionEs section =
      _TranslationsSettingsProvidersSectionEs._(_root);
  @override
  late final _TranslationsSettingsProvidersItemEs item =
      _TranslationsSettingsProvidersItemEs._(_root);
  @override
  late final _TranslationsSettingsProvidersButtonEs button =
      _TranslationsSettingsProvidersButtonEs._(_root);
  @override
  late final _TranslationsSettingsProvidersAlertEs alert =
      _TranslationsSettingsProvidersAlertEs._(_root);
  @override
  late final _TranslationsSettingsProvidersIntroEs intro =
      _TranslationsSettingsProvidersIntroEs._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorEs editor =
      _TranslationsSettingsProvidersEditorEs._(_root);
  @override
  late final _TranslationsSettingsProvidersDetailEs detail =
      _TranslationsSettingsProvidersDetailEs._(_root);
  @override
  late final _TranslationsSettingsProvidersCapabilityEs capability =
      _TranslationsSettingsProvidersCapabilityEs._(_root);
  @override
  late final _TranslationsSettingsProvidersDescriptionEs description =
      _TranslationsSettingsProvidersDescriptionEs._(_root);
  @override
  late final _TranslationsSettingsProvidersDeleteDialogEs delete_dialog =
      _TranslationsSettingsProvidersDeleteDialogEs._(_root);
}

// Path: settings.layout
class _TranslationsSettingsLayoutEs extends TranslationsSettingsLayoutEn {
  _TranslationsSettingsLayoutEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Configuración';
  @override
  late final _TranslationsSettingsLayoutEmptyEs empty =
      _TranslationsSettingsLayoutEmptyEs._(_root);
}

// Path: settings.about
class _TranslationsSettingsAboutEs extends TranslationsSettingsAboutEn {
  _TranslationsSettingsAboutEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Acerca de';
  @override
  String get copy_version_info => 'Copiar información de versión';
  @override
  String get up_to_date => 'Está actualizado.';
  @override
  String get check_again => 'Verificar de nuevo';
  @override
  String get links => 'Enlaces';
  @override
  String get website => 'Sitio web';
  @override
  String get github => 'GitHub';
  @override
  String get report_issue => 'Informar de un problema';
  @override
  String get license => 'Licencia';
  @override
  String get open_changelog => 'Abrir registro de cambios';
}

// Path: common.ui.button
class _TranslationsCommonUiButtonEs extends TranslationsCommonUiButtonEn {
  _TranslationsCommonUiButtonEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get ok => 'OK';
  @override
  String get cancel => 'Cancelar';
  @override
  String get add => 'Agregar';
  @override
  String get delete => 'Eliminar';
  @override
  String get edit => 'Editar';
  @override
  String get save => 'Guardar';
  @override
  String get manage => 'Administrar';
  @override
  String get kContinue => 'Continuar';
}

// Path: common.ui.feedback
class _TranslationsCommonUiFeedbackEs extends TranslationsCommonUiFeedbackEn {
  _TranslationsCommonUiFeedbackEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get copied => 'Copiado';
}

// Path: app.tray.context_menu
class _TranslationsAppTrayContextMenuEs
    extends TranslationsAppTrayContextMenuEn {
  _TranslationsAppTrayContextMenuEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get show_window => 'Mostrar ventana';
  @override
  late final _TranslationsAppTrayContextMenuDevToolsEs dev_tools =
      _TranslationsAppTrayContextMenuDevToolsEs._(_root);
  @override
  String get check_for_updates => 'Buscar actualizaciones';
  @override
  String get settings => 'Configuración';
  @override
  String get quit => 'Salir';
}

// Path: mini_translator.limited_banner.permission
class _TranslationsMiniTranslatorLimitedBannerPermissionEs
    extends TranslationsMiniTranslatorLimitedBannerPermissionEn {
  _TranslationsMiniTranslatorLimitedBannerPermissionEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get missing_both =>
      'Concede los permisos de Grabación de pantalla y Accesibilidad para habilitar todas las funciones.';
  @override
  String get missing_screen_capture =>
      'Concede el permiso de Grabación de pantalla para habilitar todas las funciones.';
  @override
  String get missing_accessibility =>
      'Concede el permiso de Accesibilidad para habilitar todas las funciones.';
}

// Path: mini_translator.limited_banner.instruction
class _TranslationsMiniTranslatorLimitedBannerInstructionEs
    extends TranslationsMiniTranslatorLimitedBannerInstructionEn {
  _TranslationsMiniTranslatorLimitedBannerInstructionEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get app_settings_prefix => 'Ve a ';
  @override
  String get follow_guide_prefix => ', sigue la guía y luego haz clic en ';
  @override
  String get suffix => '.';
}

// Path: mini_translator.limited_banner.action
class _TranslationsMiniTranslatorLimitedBannerActionEs
    extends TranslationsMiniTranslatorLimitedBannerActionEn {
  _TranslationsMiniTranslatorLimitedBannerActionEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get app_settings => 'Configuración de la app';
  @override
  String get recheck => 'Verificar de nuevo';
}

// Path: mini_translator.limited_banner.feedback
class _TranslationsMiniTranslatorLimitedBannerFeedbackEs
    extends TranslationsMiniTranslatorLimitedBannerFeedbackEn {
  _TranslationsMiniTranslatorLimitedBannerFeedbackEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get enabled => 'La extracción de texto de pantalla está habilitada.';
  @override
  String get still_missing =>
      'Los permisos necesarios aún faltan.\nRevisa tu configuración e inténtalo de nuevo.';
}

// Path: mini_translator.limited_banner.tooltip
class _TranslationsMiniTranslatorLimitedBannerTooltipEs
    extends TranslationsMiniTranslatorLimitedBannerTooltipEn {
  _TranslationsMiniTranslatorLimitedBannerTooltipEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get help => 'Ver ayuda';
}

// Path: mini_translator.toolbar.tooltip
class _TranslationsMiniTranslatorToolbarTooltipEs
    extends TranslationsMiniTranslatorToolbarTooltipEn {
  _TranslationsMiniTranslatorToolbarTooltipEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get extract_text_from_screen_capture =>
      'Capturar área de la pantalla y reconocer texto';
  @override
  String get extract_text_from_clipboard => 'Leer contenido del portapapeles';
}

// Path: settings.general.section
class _TranslationsSettingsGeneralSectionEs
    extends TranslationsSettingsGeneralSectionEn {
  _TranslationsSettingsGeneralSectionEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get permissions => 'Permisos';
  @override
  String get ocr => 'Reconocimiento de texto';
  @override
  String get directory => 'Directorio';
  @override
  String get translation => 'Traducción';
  @override
  String get translation_target => 'Idioma de destino';
  @override
  String get languages => 'Idiomas';
  @override
  String get input => 'Configuración de entrada';
}

// Path: settings.general.row
class _TranslationsSettingsGeneralRowEs
    extends TranslationsSettingsGeneralRowEn {
  _TranslationsSettingsGeneralRowEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get launch_at_login => 'Iniciar al iniciar sesión';
  @override
  String get show_in_menu_bar => 'Mostrar en la barra de menú';
  @override
  String get screen_capture_access =>
      'Conceder acceso de grabación de pantalla';
  @override
  String get screen_selection_access => 'Conceder acceso de accesibilidad';
  @override
  String get default_ocr_service =>
      'Servicio de reconocimiento de texto predeterminado';
  @override
  String get auto_copy_detected_text =>
      'Copiar texto detectado automáticamente';
  @override
  String get default_directory_service =>
      'Servicio de diccionario predeterminado';
  @override
  String get default_translation_service =>
      'Servicio de traducción predeterminado';
  @override
  String get translation_target_hint =>
      'Configura los pares de idiomas usados por el traductor.';
  @override
  String get common_languages => 'Idiomas comunes';
  @override
  String get common_languages_description =>
      'Los idiomas comunes aparecen al principio de los selectores de idioma.';
  @override
  String get common_languages_hint => 'Selecciona tus idiomas comunes:';
  @override
  String get common_languages_sort => 'Ordenar por código';
  @override
  String get common_languages_reset => 'Restablecer valores predeterminados';
  @override
  String get common_languages_reset_help =>
      'Restablecer el conjunto predeterminado de idiomas comunes';
  @override
  String get common_languages_search => 'Buscar idiomas...';
  @override
  String get common_languages_all => 'Todos los idiomas';
  @override
  String get double_click_copy_result =>
      'Doble clic para copiar el resultado de la traducción';
  @override
  String get submit_with_enter => 'Enviar con Enter';
  @override
  String get submit_with_meta_enter_mac => 'Enviar con ⌘ + Enter';
}

// Path: settings.general.button
class _TranslationsSettingsGeneralButtonEs
    extends TranslationsSettingsGeneralButtonEn {
  _TranslationsSettingsGeneralButtonEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get add_provider => 'Agregar...';
  @override
  String get add_target => 'Agregar destino...';
  @override
  String get manage_targets => 'Gestionar destinos de traducción...';
  @override
  String get manage_languages => 'Administrar idiomas comunes...';
  @override
  String get grant => 'Conceder';
}

// Path: settings.general.option
class _TranslationsSettingsGeneralOptionEs
    extends TranslationsSettingsGeneralOptionEn {
  _TranslationsSettingsGeneralOptionEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get none => 'Ninguno';
  @override
  String get no_services_available => 'No hay servicios disponibles';
  @override
  String get granted => 'Concedido';
  @override
  String get built_in_ocr => 'OCR integrado';
  @override
  String get tesseract => 'Tesseract';
  @override
  String get youdao_ocr => 'Youdao OCR';
}

// Path: settings.general.editor
class _TranslationsSettingsGeneralEditorEs
    extends TranslationsSettingsGeneralEditorEn {
  _TranslationsSettingsGeneralEditorEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get add_target_title => 'Agregar destino de traducción';
  @override
  String get edit_target_title => 'Editar destino de traducción';
  @override
  late final _TranslationsSettingsGeneralEditorRowEs row =
      _TranslationsSettingsGeneralEditorRowEs._(_root);
}

// Path: settings.appearance.section
class _TranslationsSettingsAppearanceSectionEs
    extends TranslationsSettingsAppearanceSectionEn {
  _TranslationsSettingsAppearanceSectionEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get app_language => 'Idioma de la interfaz';
  @override
  String get theme_mode => 'Modo de tema';
}

// Path: settings.shortcuts.section
class _TranslationsSettingsShortcutsSectionEs
    extends TranslationsSettingsShortcutsSectionEn {
  _TranslationsSettingsShortcutsSectionEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get text_extraction => 'Extracción de texto';
  @override
  String get input_assist => 'Función de asistencia de entrada';
}

// Path: settings.shortcuts.row
class _TranslationsSettingsShortcutsRowEs
    extends TranslationsSettingsShortcutsRowEn {
  _TranslationsSettingsShortcutsRowEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get toggle_mini_translator => 'Mostrar/Ocultar ventana';
  @override
  String get extract_text_from_screen_selection =>
      'Extraer texto de la selección de pantalla';
  @override
  String get extract_text_from_screen_capture =>
      'Extraer texto de la captura de pantalla';
  @override
  String get extract_text_from_clipboard => 'Extraer texto del portapapeles';
  @override
  String get translate_input => 'Traducir contenido de entrada';
}

// Path: settings.shortcuts.reset_dialog
class _TranslationsSettingsShortcutsResetDialogEs
    extends TranslationsSettingsShortcutsResetDialogEn {
  _TranslationsSettingsShortcutsResetDialogEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Restablecer atajos';
  @override
  String get message =>
      '¿Estás seguro de que deseas restablecer todos los atajos a sus valores predeterminados?';
  @override
  String get confirm => 'Restablecer';
  @override
  String get cancel => 'Cancelar';
}

// Path: settings.services.button
class _TranslationsSettingsServicesButtonEs
    extends TranslationsSettingsServicesButtonEn {
  _TranslationsSettingsServicesButtonEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get add_service => 'Agregar Servicio...';
}

// Path: settings.services.section
class _TranslationsSettingsServicesSectionEs
    extends TranslationsSettingsServicesSectionEn {
  _TranslationsSettingsServicesSectionEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get available_services => 'Servicios Disponibles';
}

// Path: settings.services.editor
class _TranslationsSettingsServicesEditorEs
    extends TranslationsSettingsServicesEditorEn {
  _TranslationsSettingsServicesEditorEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get coming_soon => '🚧 Próximamente';
  @override
  String get coming_soon_description =>
      'La configuración del servicio aún no está disponible. Puede administrar los proveedores de servicios desde la pestaña de proveedores.';
}

// Path: settings.providers.section
class _TranslationsSettingsProvidersSectionEs
    extends TranslationsSettingsProvidersSectionEn {
  _TranslationsSettingsProvidersSectionEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get services => 'Servicios disponibles';
  @override
  String get services_description =>
      'Consulta los servicios disponibles de los proveedores configurados y cambia entre tipos de servicio.';
}

// Path: settings.providers.item
class _TranslationsSettingsProvidersItemEs
    extends TranslationsSettingsProvidersItemEn {
  _TranslationsSettingsProvidersItemEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get empty =>
      'No hay proveedores configurados. Agrega uno para habilitar los servicios de traducción.';
  @override
  String get loading => 'Cargando proveedores...';
  @override
  String get no_services => 'No hay servicios disponibles.';
}

// Path: settings.providers.button
class _TranslationsSettingsProvidersButtonEs
    extends TranslationsSettingsProvidersButtonEn {
  _TranslationsSettingsProvidersButtonEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get add => 'Agregar un proveedor...';
}

// Path: settings.providers.alert
class _TranslationsSettingsProvidersAlertEs
    extends TranslationsSettingsProvidersAlertEn {
  _TranslationsSettingsProvidersAlertEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get error => 'Error';
}

// Path: settings.providers.intro
class _TranslationsSettingsProvidersIntroEs
    extends TranslationsSettingsProvidersIntroEn {
  _TranslationsSettingsProvidersIntroEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get body => 'Gestiona los proveedores de servicios que usa la app.';
  @override
  String get warning =>
      'Los proveedores conectados pueden procesar el texto o las imágenes que envías. Activa solo servicios en los que confíes.';
}

// Path: settings.providers.editor
class _TranslationsSettingsProvidersEditorEs
    extends TranslationsSettingsProvidersEditorEn {
  _TranslationsSettingsProvidersEditorEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsSettingsProvidersEditorRowEs row =
      _TranslationsSettingsProvidersEditorRowEs._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorPlaceholderEs placeholder =
      _TranslationsSettingsProvidersEditorPlaceholderEs._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorTypePickerEs type_picker =
      _TranslationsSettingsProvidersEditorTypePickerEs._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorTooltipEs tooltip =
      _TranslationsSettingsProvidersEditorTooltipEs._(_root);
}

// Path: settings.providers.detail
class _TranslationsSettingsProvidersDetailEs
    extends TranslationsSettingsProvidersDetailEn {
  _TranslationsSettingsProvidersDetailEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsSettingsProvidersDetailTooltipEs tooltip =
      _TranslationsSettingsProvidersDetailTooltipEs._(_root);
  @override
  late final _TranslationsSettingsProvidersDetailSectionEs section =
      _TranslationsSettingsProvidersDetailSectionEs._(_root);
  @override
  late final _TranslationsSettingsProvidersDetailModelsEs models =
      _TranslationsSettingsProvidersDetailModelsEs._(_root);
}

// Path: settings.providers.capability
class _TranslationsSettingsProvidersCapabilityEs
    extends TranslationsSettingsProvidersCapabilityEn {
  _TranslationsSettingsProvidersCapabilityEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get translation => 'Traducción';
  @override
  String get dictionary => 'Diccionario';
  @override
  String get ocr => 'OCR';
}

// Path: settings.providers.description
class _TranslationsSettingsProvidersDescriptionEs
    extends TranslationsSettingsProvidersDescriptionEn {
  _TranslationsSettingsProvidersDescriptionEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get all => 'Proporciona búsqueda en diccionario y traducción de texto';
  @override
  String get dictionary =>
      'Proporciona búsqueda en diccionario y definiciones de palabras';
  @override
  String get translation => 'Proporciona traducción de texto entre idiomas';
  @override
  String get fallback => 'Proporciona servicios de traducción';
}

// Path: settings.providers.delete_dialog
class _TranslationsSettingsProvidersDeleteDialogEs
    extends TranslationsSettingsProvidersDeleteDialogEn {
  _TranslationsSettingsProvidersDeleteDialogEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get title => '¿Eliminar "{}"?';
  @override
  String get message => 'Esta acción no se puede deshacer.';
}

// Path: settings.layout.empty
class _TranslationsSettingsLayoutEmptyEs
    extends TranslationsSettingsLayoutEmptyEn {
  _TranslationsSettingsLayoutEmptyEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Selecciona una categoría';
  @override
  String get message =>
      'Elige una sección de configuración de la barra lateral.';
}

// Path: app.tray.context_menu.dev_tools
class _TranslationsAppTrayContextMenuDevToolsEs
    extends TranslationsAppTrayContextMenuDevToolsEn {
  _TranslationsAppTrayContextMenuDevToolsEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Herramientas de desarrollo';
  @override
  String get open_data_directory => 'Abrir directorio de datos';
  @override
  String get use_native_settings => 'Usar página de configuración nativa';
}

// Path: settings.general.editor.row
class _TranslationsSettingsGeneralEditorRowEs
    extends TranslationsSettingsGeneralEditorRowEn {
  _TranslationsSettingsGeneralEditorRowEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get source_language => 'Idioma de origen';
  @override
  String get target_language => 'Idioma de destino';
}

// Path: settings.providers.editor.row
class _TranslationsSettingsProvidersEditorRowEs
    extends TranslationsSettingsProvidersEditorRowEn {
  _TranslationsSettingsProvidersEditorRowEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get id => 'ID del proveedor';
}

// Path: settings.providers.editor.placeholder
class _TranslationsSettingsProvidersEditorPlaceholderEs
    extends TranslationsSettingsProvidersEditorPlaceholderEn {
  _TranslationsSettingsProvidersEditorPlaceholderEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get id => 'ej. deepl-main';
}

// Path: settings.providers.editor.type_picker
class _TranslationsSettingsProvidersEditorTypePickerEs
    extends TranslationsSettingsProvidersEditorTypePickerEn {
  _TranslationsSettingsProvidersEditorTypePickerEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get prompt => 'Selecciona el tipo de proveedor que deseas agregar:';
  @override
  String get section_llm => 'LLM';
  @override
  String get section_traditional => 'Tradicional';
}

// Path: settings.providers.editor.tooltip
class _TranslationsSettingsProvidersEditorTooltipEs
    extends TranslationsSettingsProvidersEditorTooltipEn {
  _TranslationsSettingsProvidersEditorTooltipEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get help => 'Ayuda';
}

// Path: settings.providers.detail.tooltip
class _TranslationsSettingsProvidersDetailTooltipEs
    extends TranslationsSettingsProvidersDetailTooltipEn {
  _TranslationsSettingsProvidersDetailTooltipEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get edit => 'Editar proveedor';
}

// Path: settings.providers.detail.section
class _TranslationsSettingsProvidersDetailSectionEs
    extends TranslationsSettingsProvidersDetailSectionEn {
  _TranslationsSettingsProvidersDetailSectionEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get configuration => 'Configuración';
  @override
  String get models => 'Modelos';
}

// Path: settings.providers.detail.models
class _TranslationsSettingsProvidersDetailModelsEs
    extends TranslationsSettingsProvidersDetailModelsEn {
  _TranslationsSettingsProvidersDetailModelsEs._(TranslationsEs root)
      : this._root = root,
        super.internal(root);

  final TranslationsEs _root; // ignore: unused_field

  // Translations
  @override
  String get loading => 'Cargando modelos...';
  @override
  String get empty => 'No se encontraron modelos.';
  @override
  String get retry => 'Reintentar';
  @override
  String get default_badge => 'Predeterminado';
  @override
  String get fetch_error =>
      'No se pudieron obtener los modelos de la API del proveedor.';
}

/// The flat map containing all translations for locale <es>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEs {
  dynamic _flatMapFunction(String path) {
    return switch (path) {
      'common.ui.button.ok' => 'OK',
      'common.ui.button.cancel' => 'Cancelar',
      'common.ui.button.add' => 'Agregar',
      'common.ui.button.delete' => 'Eliminar',
      'common.ui.button.edit' => 'Editar',
      'common.ui.button.save' => 'Guardar',
      'common.ui.button.manage' => 'Administrar',
      'common.ui.button.kContinue' => 'Continuar',
      'common.ui.feedback.copied' => 'Copiado',
      'common.language.ar' => 'Árabe',
      'common.language.bn' => 'Bengalí',
      'common.language.de' => 'Alemán',
      'common.language.en' => 'Inglés',
      'common.language.es' => 'Español',
      'common.language.fa' => 'Persa',
      'common.language.fr' => 'Francés',
      'common.language.gu' => 'Guyaratí',
      'common.language.ha' => 'Hausa',
      'common.language.hi' => 'Hindi',
      'common.language.id' => 'Indonesio',
      'common.language.it' => 'Italiano',
      'common.language.ja' => 'Japonés',
      'common.language.jv' => 'Javanés',
      'common.language.ko' => 'Coreano',
      'common.language.ml' => 'Malayalam',
      'common.language.mr' => 'Maratí',
      'common.language.ms' => 'Malayo',
      'common.language.nl' => 'Neerlandés',
      'common.language.pa' => 'Panyabí',
      'common.language.pl' => 'Polaco',
      'common.language.pt' => 'Portugués',
      'common.language.ro' => 'Rumano',
      'common.language.ru' => 'Ruso',
      'common.language.sw' => 'Suajili',
      'common.language.ta' => 'Tamil',
      'common.language.te' => 'Telugú',
      'common.language.th' => 'Tailandés',
      'common.language.tr' => 'Turco',
      'common.language.uk' => 'Ucraniano',
      'common.language.ur' => 'Urdu',
      'common.language.vi' => 'Vietnamita',
      'common.language.yo' => 'Yoruba',
      'common.language.zh_hans' => 'Chino simplificado',
      'common.language.zh_hant' => 'Chino tradicional',
      'common.theme_mode.light' => 'Claro',
      'common.theme_mode.dark' => 'Oscuro',
      'common.theme_mode.system' => 'Sistema',
      'common.provider.anthropic' => 'Anthropic',
      'common.provider.baidu' => 'Baidu',
      'common.provider.caiyun' => 'Caiyun',
      'common.provider.deepl' => 'DeepL',
      'common.provider.google' => 'Google',
      'common.provider.ollama' => 'Ollama',
      'common.provider.openai' => 'OpenAI',
      'common.provider.sogou' => 'Sogou',
      'common.provider.xai' => 'xAI',
      'common.provider.system' => 'Sistema',
      'common.provider.tencent' => 'Tencent',
      'common.provider.youdao' => 'Youdao',
      'common.word_pronunciation.us' => 'EE. UU.',
      'common.word_pronunciation.uk' => 'RU',
      'app.tray.context_menu.show_window' => 'Mostrar ventana',
      'app.tray.context_menu.dev_tools.title' => 'Herramientas de desarrollo',
      'app.tray.context_menu.dev_tools.open_data_directory' =>
        'Abrir directorio de datos',
      'app.tray.context_menu.dev_tools.use_native_settings' =>
        'Usar página de configuración nativa',
      'app.tray.context_menu.check_for_updates' => 'Buscar actualizaciones',
      'app.tray.context_menu.settings' => 'Configuración',
      'app.tray.context_menu.quit' => 'Salir',
      'mini_translator.limited_banner.permission.missing_both' =>
        'Concede los permisos de Grabación de pantalla y Accesibilidad para habilitar todas las funciones.',
      'mini_translator.limited_banner.permission.missing_screen_capture' =>
        'Concede el permiso de Grabación de pantalla para habilitar todas las funciones.',
      'mini_translator.limited_banner.permission.missing_accessibility' =>
        'Concede el permiso de Accesibilidad para habilitar todas las funciones.',
      'mini_translator.limited_banner.instruction.app_settings_prefix' =>
        'Ve a ',
      'mini_translator.limited_banner.instruction.follow_guide_prefix' =>
        ', sigue la guía y luego haz clic en ',
      'mini_translator.limited_banner.instruction.suffix' => '.',
      'mini_translator.limited_banner.action.app_settings' =>
        'Configuración de la app',
      'mini_translator.limited_banner.action.recheck' => 'Verificar de nuevo',
      'mini_translator.limited_banner.feedback.enabled' =>
        'La extracción de texto de pantalla está habilitada.',
      'mini_translator.limited_banner.feedback.still_missing' =>
        'Los permisos necesarios aún faltan.\nRevisa tu configuración e inténtalo de nuevo.',
      'mini_translator.limited_banner.tooltip.help' => 'Ver ayuda',
      'mini_translator.input.hint' => 'Escribe la palabra o texto aquí',
      'mini_translator.input.extracting_text' => 'Extrayendo texto...',
      'mini_translator.toolbar.tooltip.extract_text_from_screen_capture' =>
        'Capturar área de la pantalla y reconocer texto',
      'mini_translator.toolbar.tooltip.extract_text_from_clipboard' =>
        'Leer contenido del portapapeles',
      'mini_translator.button.clear' => 'Limpiar',
      'mini_translator.button.translate' => 'Traducir',
      'mini_translator.language.auto_detect' => 'Detección automática',
      'mini_translator.language.auto_match' => 'Coincidencia auto',
      'mini_translator.language.switch_config' => 'Cambiar destino',
      'mini_translator.language.more_languages' => 'Más idiomas...',
      'mini_translator.language.manage_common_languages' =>
        'Administrar idiomas comunes...',
      'mini_translator.language.manage_targets' =>
        'Administrar destinos de traducción...',
      'mini_translator.language.add_target' =>
        'Agregar destino de traducción...',
      'mini_translator.message.please_enter_word_or_text' =>
        'No se ingresó texto o no se pudo extraer',
      'mini_translator.message.capture_screen_area_canceled' =>
        'La captura de área de pantalla ha sido cancelada',
      'mini_translator.message.ocr_service_not_configured' =>
        'No hay un servicio de reconocimiento de texto predeterminado configurado. Configúrelo en Ajustes.',
      'mini_translator.message.ocr_recognition_failed' =>
        'El reconocimiento de texto falló',
      'settings.version' => 'v{} (Build {})',
      'settings.general.title' => 'General',
      'settings.general.section.permissions' => 'Permisos',
      'settings.general.section.ocr' => 'Reconocimiento de texto',
      'settings.general.section.directory' => 'Directorio',
      'settings.general.section.translation' => 'Traducción',
      'settings.general.section.translation_target' => 'Idioma de destino',
      'settings.general.section.languages' => 'Idiomas',
      'settings.general.section.input' => 'Configuración de entrada',
      'settings.general.row.launch_at_login' => 'Iniciar al iniciar sesión',
      'settings.general.row.show_in_menu_bar' => 'Mostrar en la barra de menú',
      'settings.general.row.screen_capture_access' =>
        'Conceder acceso de grabación de pantalla',
      'settings.general.row.screen_selection_access' =>
        'Conceder acceso de accesibilidad',
      'settings.general.row.default_ocr_service' =>
        'Servicio de reconocimiento de texto predeterminado',
      'settings.general.row.auto_copy_detected_text' =>
        'Copiar texto detectado automáticamente',
      'settings.general.row.default_directory_service' =>
        'Servicio de diccionario predeterminado',
      'settings.general.row.default_translation_service' =>
        'Servicio de traducción predeterminado',
      'settings.general.row.translation_target_hint' =>
        'Configura los pares de idiomas usados por el traductor.',
      'settings.general.row.common_languages' => 'Idiomas comunes',
      'settings.general.row.common_languages_description' =>
        'Los idiomas comunes aparecen al principio de los selectores de idioma.',
      'settings.general.row.common_languages_hint' =>
        'Selecciona tus idiomas comunes:',
      'settings.general.row.common_languages_sort' => 'Ordenar por código',
      'settings.general.row.common_languages_reset' =>
        'Restablecer valores predeterminados',
      'settings.general.row.common_languages_reset_help' =>
        'Restablecer el conjunto predeterminado de idiomas comunes',
      'settings.general.row.common_languages_search' => 'Buscar idiomas...',
      'settings.general.row.common_languages_all' => 'Todos los idiomas',
      'settings.general.row.double_click_copy_result' =>
        'Doble clic para copiar el resultado de la traducción',
      'settings.general.row.submit_with_enter' => 'Enviar con Enter',
      'settings.general.row.submit_with_meta_enter_mac' =>
        'Enviar con ⌘ + Enter',
      'settings.general.button.add_provider' => 'Agregar...',
      'settings.general.button.add_target' => 'Agregar destino...',
      'settings.general.button.manage_targets' =>
        'Gestionar destinos de traducción...',
      'settings.general.button.manage_languages' =>
        'Administrar idiomas comunes...',
      'settings.general.button.grant' => 'Conceder',
      'settings.general.option.none' => 'Ninguno',
      'settings.general.option.no_services_available' =>
        'No hay servicios disponibles',
      'settings.general.option.granted' => 'Concedido',
      'settings.general.option.built_in_ocr' => 'OCR integrado',
      'settings.general.option.tesseract' => 'Tesseract',
      'settings.general.option.youdao_ocr' => 'Youdao OCR',
      'settings.general.editor.add_target_title' =>
        'Agregar destino de traducción',
      'settings.general.editor.edit_target_title' =>
        'Editar destino de traducción',
      'settings.general.editor.row.source_language' => 'Idioma de origen',
      'settings.general.editor.row.target_language' => 'Idioma de destino',
      'settings.appearance.title' => 'Apariencia',
      'settings.appearance.section.app_language' => 'Idioma de la interfaz',
      'settings.appearance.section.theme_mode' => 'Modo de tema',
      'settings.shortcuts.title' => 'Atajos',
      'settings.shortcuts.section.text_extraction' => 'Extracción de texto',
      'settings.shortcuts.section.input_assist' =>
        'Función de asistencia de entrada',
      'settings.shortcuts.row.toggle_mini_translator' =>
        'Mostrar/Ocultar ventana',
      'settings.shortcuts.row.extract_text_from_screen_selection' =>
        'Extraer texto de la selección de pantalla',
      'settings.shortcuts.row.extract_text_from_screen_capture' =>
        'Extraer texto de la captura de pantalla',
      'settings.shortcuts.row.extract_text_from_clipboard' =>
        'Extraer texto del portapapeles',
      'settings.shortcuts.row.translate_input' =>
        'Traducir contenido de entrada',
      'settings.shortcuts.reset_dialog.title' => 'Restablecer atajos',
      'settings.shortcuts.reset_dialog.message' =>
        '¿Estás seguro de que deseas restablecer todos los atajos a sus valores predeterminados?',
      'settings.shortcuts.reset_dialog.confirm' => 'Restablecer',
      'settings.shortcuts.reset_dialog.cancel' => 'Cancelar',
      'settings.advanced.title' => 'Avanzado',
      'settings.advanced.api_server' => 'Servidor de API local',
      'settings.advanced.api_server_description' =>
        'Exponer la API de traducción en 127.0.0.1 para integraciones locales.',
      'settings.advanced.enable' => 'Habilitar',
      'settings.advanced.port' => 'Puerto',
      'settings.advanced.running_at' => 'Ejecutándose en {url}',
      'settings.advanced.disabled' => 'Deshabilitado',
      'settings.services.title' => 'Servicios',
      'settings.services.button.add_service' => 'Agregar Servicio...',
      'settings.services.section.available_services' => 'Servicios Disponibles',
      'settings.services.editor.coming_soon' => '🚧 Próximamente',
      'settings.services.editor.coming_soon_description' =>
        'La configuración del servicio aún no está disponible. Puede administrar los proveedores de servicios desde la pestaña de proveedores.',
      'settings.providers.title' => 'Proveedores',
      'settings.providers.section.services' => 'Servicios disponibles',
      'settings.providers.section.services_description' =>
        'Consulta los servicios disponibles de los proveedores configurados y cambia entre tipos de servicio.',
      'settings.providers.item.empty' =>
        'No hay proveedores configurados. Agrega uno para habilitar los servicios de traducción.',
      'settings.providers.item.loading' => 'Cargando proveedores...',
      'settings.providers.item.no_services' => 'No hay servicios disponibles.',
      'settings.providers.button.add' => 'Agregar un proveedor...',
      'settings.providers.alert.error' => 'Error',
      'settings.providers.intro.body' =>
        'Gestiona los proveedores de servicios que usa la app.',
      'settings.providers.intro.warning' =>
        'Los proveedores conectados pueden procesar el texto o las imágenes que envías. Activa solo servicios en los que confíes.',
      'settings.providers.editor.row.id' => 'ID del proveedor',
      'settings.providers.editor.placeholder.id' => 'ej. deepl-main',
      'settings.providers.editor.type_picker.prompt' =>
        'Selecciona el tipo de proveedor que deseas agregar:',
      'settings.providers.editor.type_picker.section_llm' => 'LLM',
      'settings.providers.editor.type_picker.section_traditional' =>
        'Tradicional',
      'settings.providers.editor.tooltip.help' => 'Ayuda',
      'settings.providers.detail.tooltip.edit' => 'Editar proveedor',
      'settings.providers.detail.section.configuration' => 'Configuración',
      'settings.providers.detail.section.models' => 'Modelos',
      'settings.providers.detail.models.loading' => 'Cargando modelos...',
      'settings.providers.detail.models.empty' => 'No se encontraron modelos.',
      'settings.providers.detail.models.retry' => 'Reintentar',
      'settings.providers.detail.models.default_badge' => 'Predeterminado',
      'settings.providers.detail.models.fetch_error' =>
        'No se pudieron obtener los modelos de la API del proveedor.',
      'settings.providers.capability.translation' => 'Traducción',
      'settings.providers.capability.dictionary' => 'Diccionario',
      'settings.providers.capability.ocr' => 'OCR',
      'settings.providers.description.all' =>
        'Proporciona búsqueda en diccionario y traducción de texto',
      'settings.providers.description.dictionary' =>
        'Proporciona búsqueda en diccionario y definiciones de palabras',
      'settings.providers.description.translation' =>
        'Proporciona traducción de texto entre idiomas',
      'settings.providers.description.fallback' =>
        'Proporciona servicios de traducción',
      'settings.providers.delete_dialog.title' => '¿Eliminar "{}"?',
      'settings.providers.delete_dialog.message' =>
        'Esta acción no se puede deshacer.',
      'settings.layout.title' => 'Configuración',
      'settings.layout.empty.title' => 'Selecciona una categoría',
      'settings.layout.empty.message' =>
        'Elige una sección de configuración de la barra lateral.',
      'settings.about.title' => 'Acerca de',
      'settings.about.copy_version_info' => 'Copiar información de versión',
      'settings.about.up_to_date' => 'Está actualizado.',
      'settings.about.check_again' => 'Verificar de nuevo',
      'settings.about.links' => 'Enlaces',
      'settings.about.website' => 'Sitio web',
      'settings.about.github' => 'GitHub',
      'settings.about.report_issue' => 'Informar de un problema',
      'settings.about.license' => 'Licencia',
      'settings.about.open_changelog' => 'Abrir registro de cambios',
      _ => null,
    };
  }
}
