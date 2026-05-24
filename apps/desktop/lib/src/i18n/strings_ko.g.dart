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
class TranslationsKo extends Translations
    with BaseTranslations<AppLocale, Translations> {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsKo(
      {Map<String, Node>? overrides,
      PluralResolver? cardinalResolver,
      PluralResolver? ordinalResolver,
      TranslationMetadata<AppLocale, Translations>? meta})
      : assert(overrides == null,
            'Set "translation_overrides: true" in order to enable this feature.'),
        $meta = meta ??
            TranslationMetadata(
              locale: AppLocale.ko,
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

  /// Metadata for the translations of <ko>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  /// Access flat map
  @override
  dynamic operator [](String key) =>
      $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

  late final TranslationsKo _root = this; // ignore: unused_field

  @override
  TranslationsKo $copyWith(
          {TranslationMetadata<AppLocale, Translations>? meta}) =>
      TranslationsKo(meta: meta ?? this.$meta);

  // Translations
  @override
  late final _TranslationsCommonKo common = _TranslationsCommonKo._(_root);
  @override
  late final _TranslationsAppKo app = _TranslationsAppKo._(_root);
  @override
  late final _TranslationsMiniTranslatorKo mini_translator =
      _TranslationsMiniTranslatorKo._(_root);
  @override
  late final _TranslationsSettingsKo settings =
      _TranslationsSettingsKo._(_root);
}

// Path: common
class _TranslationsCommonKo extends TranslationsCommonEn {
  _TranslationsCommonKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsCommonUiKo ui = _TranslationsCommonUiKo._(_root);
  @override
  late final _TranslationsCommonLanguageKo language =
      _TranslationsCommonLanguageKo._(_root);
  @override
  late final _TranslationsCommonThemeModeKo theme_mode =
      _TranslationsCommonThemeModeKo._(_root);
  @override
  late final _TranslationsCommonProviderKo provider =
      _TranslationsCommonProviderKo._(_root);
  @override
  late final _TranslationsCommonWordPronunciationKo word_pronunciation =
      _TranslationsCommonWordPronunciationKo._(_root);
}

// Path: app
class _TranslationsAppKo extends TranslationsAppEn {
  _TranslationsAppKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsAppTrayKo tray = _TranslationsAppTrayKo._(_root);
}

// Path: mini_translator
class _TranslationsMiniTranslatorKo extends TranslationsMiniTranslatorEn {
  _TranslationsMiniTranslatorKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsMiniTranslatorLimitedBannerKo limited_banner =
      _TranslationsMiniTranslatorLimitedBannerKo._(_root);
  @override
  late final _TranslationsMiniTranslatorInputKo input =
      _TranslationsMiniTranslatorInputKo._(_root);
  @override
  late final _TranslationsMiniTranslatorToolbarKo toolbar =
      _TranslationsMiniTranslatorToolbarKo._(_root);
  @override
  late final _TranslationsMiniTranslatorButtonKo button =
      _TranslationsMiniTranslatorButtonKo._(_root);
  @override
  late final _TranslationsMiniTranslatorLanguageKo language =
      _TranslationsMiniTranslatorLanguageKo._(_root);
  @override
  late final _TranslationsMiniTranslatorMessageKo message =
      _TranslationsMiniTranslatorMessageKo._(_root);
}

// Path: settings
class _TranslationsSettingsKo extends TranslationsSettingsEn {
  _TranslationsSettingsKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get version => '버전 {} 빌드 {}';
  @override
  late final _TranslationsSettingsGeneralKo general =
      _TranslationsSettingsGeneralKo._(_root);
  @override
  late final _TranslationsSettingsAppearanceKo appearance =
      _TranslationsSettingsAppearanceKo._(_root);
  @override
  late final _TranslationsSettingsShortcutsKo shortcuts =
      _TranslationsSettingsShortcutsKo._(_root);
  @override
  late final _TranslationsSettingsAdvancedKo advanced =
      _TranslationsSettingsAdvancedKo._(_root);
  @override
  late final _TranslationsSettingsProvidersKo providers =
      _TranslationsSettingsProvidersKo._(_root);
  @override
  late final _TranslationsSettingsLayoutKo layout =
      _TranslationsSettingsLayoutKo._(_root);
}

// Path: common.ui
class _TranslationsCommonUiKo extends TranslationsCommonUiEn {
  _TranslationsCommonUiKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsCommonUiButtonKo button =
      _TranslationsCommonUiButtonKo._(_root);
  @override
  late final _TranslationsCommonUiFeedbackKo feedback =
      _TranslationsCommonUiFeedbackKo._(_root);
}

// Path: common.language
class _TranslationsCommonLanguageKo extends TranslationsCommonLanguageEn {
  _TranslationsCommonLanguageKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get ar => '아랍어';
  @override
  String get bn => '벵골어';
  @override
  String get de => '독일어';
  @override
  String get en => '영어';
  @override
  String get es => '스페인어';
  @override
  String get fa => '페르시아어';
  @override
  String get fr => '프랑스어';
  @override
  String get gu => '구자라트어';
  @override
  String get ha => '하우사어';
  @override
  String get hi => '힌디어';
  @override
  String get id => '인도네시아어';
  @override
  String get it => '이탈리아어';
  @override
  String get ja => '일본어';
  @override
  String get jv => '자바어';
  @override
  String get ko => '한국어';
  @override
  String get ml => '말라얄람어';
  @override
  String get mr => '마라티어';
  @override
  String get ms => '말레이어';
  @override
  String get nl => '네덜란드어';
  @override
  String get pa => '펀자브어';
  @override
  String get pl => '폴란드어';
  @override
  String get pt => '포르투갈어';
  @override
  String get ro => '루마니아어';
  @override
  String get ru => '러시아어';
  @override
  String get sw => '스와힐리어';
  @override
  String get ta => '타밀어';
  @override
  String get te => '텔루구어';
  @override
  String get th => '태국어';
  @override
  String get tr => '터키어';
  @override
  String get uk => '우크라이나어';
  @override
  String get ur => '우르두어';
  @override
  String get vi => '베트남어';
  @override
  String get yo => '요루바어';
  @override
  String get zh_hans => '중국어(간체)';
  @override
  String get zh_hant => '중국어(번체)';
}

// Path: common.theme_mode
class _TranslationsCommonThemeModeKo extends TranslationsCommonThemeModeEn {
  _TranslationsCommonThemeModeKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get light => '라이트';
  @override
  String get dark => '다크';
  @override
  String get system => '시스템';
}

// Path: common.provider
class _TranslationsCommonProviderKo extends TranslationsCommonProviderEn {
  _TranslationsCommonProviderKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

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
  String get system => '시스템';
  @override
  String get tencent => 'Tencent';
  @override
  String get youdao => 'Youdao';
}

// Path: common.word_pronunciation
class _TranslationsCommonWordPronunciationKo
    extends TranslationsCommonWordPronunciationEn {
  _TranslationsCommonWordPronunciationKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get us => '미국';
  @override
  String get uk => '영국';
}

// Path: app.tray
class _TranslationsAppTrayKo extends TranslationsAppTrayEn {
  _TranslationsAppTrayKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsAppTrayContextMenuKo context_menu =
      _TranslationsAppTrayContextMenuKo._(_root);
}

// Path: mini_translator.limited_banner
class _TranslationsMiniTranslatorLimitedBannerKo
    extends TranslationsMiniTranslatorLimitedBannerEn {
  _TranslationsMiniTranslatorLimitedBannerKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsMiniTranslatorLimitedBannerPermissionKo permission =
      _TranslationsMiniTranslatorLimitedBannerPermissionKo._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerInstructionKo instruction =
      _TranslationsMiniTranslatorLimitedBannerInstructionKo._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerActionKo action =
      _TranslationsMiniTranslatorLimitedBannerActionKo._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerFeedbackKo feedback =
      _TranslationsMiniTranslatorLimitedBannerFeedbackKo._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerTooltipKo tooltip =
      _TranslationsMiniTranslatorLimitedBannerTooltipKo._(_root);
}

// Path: mini_translator.input
class _TranslationsMiniTranslatorInputKo
    extends TranslationsMiniTranslatorInputEn {
  _TranslationsMiniTranslatorInputKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get hint => '단어나 텍스트를 입력하세요';
  @override
  String get extracting_text => '텍스트 추출 중...';
}

// Path: mini_translator.toolbar
class _TranslationsMiniTranslatorToolbarKo
    extends TranslationsMiniTranslatorToolbarEn {
  _TranslationsMiniTranslatorToolbarKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsMiniTranslatorToolbarTooltipKo tooltip =
      _TranslationsMiniTranslatorToolbarTooltipKo._(_root);
}

// Path: mini_translator.button
class _TranslationsMiniTranslatorButtonKo
    extends TranslationsMiniTranslatorButtonEn {
  _TranslationsMiniTranslatorButtonKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get clear => '지우기';
  @override
  String get translate => '번역';
}

// Path: mini_translator.language
class _TranslationsMiniTranslatorLanguageKo
    extends TranslationsMiniTranslatorLanguageEn {
  _TranslationsMiniTranslatorLanguageKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get auto_detect => '자동 감지';
  @override
  String get auto_match => '자동 일치';
  @override
  String get switch_config => '대상 전환';
}

// Path: mini_translator.message
class _TranslationsMiniTranslatorMessageKo
    extends TranslationsMiniTranslatorMessageEn {
  _TranslationsMiniTranslatorMessageKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get please_enter_word_or_text => '입력된 텍스트가 없거나 텍스트를 추출하지 못했습니다';
  @override
  String get capture_screen_area_canceled => '화면 영역 캡처가 취소되었습니다';
}

// Path: settings.general
class _TranslationsSettingsGeneralKo extends TranslationsSettingsGeneralEn {
  _TranslationsSettingsGeneralKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get title => '일반';
  @override
  late final _TranslationsSettingsGeneralSectionKo section =
      _TranslationsSettingsGeneralSectionKo._(_root);
  @override
  late final _TranslationsSettingsGeneralRowKo row =
      _TranslationsSettingsGeneralRowKo._(_root);
  @override
  late final _TranslationsSettingsGeneralButtonKo button =
      _TranslationsSettingsGeneralButtonKo._(_root);
  @override
  late final _TranslationsSettingsGeneralOptionKo option =
      _TranslationsSettingsGeneralOptionKo._(_root);
  @override
  late final _TranslationsSettingsGeneralEditorKo editor =
      _TranslationsSettingsGeneralEditorKo._(_root);
}

// Path: settings.appearance
class _TranslationsSettingsAppearanceKo
    extends TranslationsSettingsAppearanceEn {
  _TranslationsSettingsAppearanceKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get title => '외관';
  @override
  late final _TranslationsSettingsAppearanceSectionKo section =
      _TranslationsSettingsAppearanceSectionKo._(_root);
}

// Path: settings.shortcuts
class _TranslationsSettingsShortcutsKo extends TranslationsSettingsShortcutsEn {
  _TranslationsSettingsShortcutsKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get title => '단축키';
  @override
  late final _TranslationsSettingsShortcutsSectionKo section =
      _TranslationsSettingsShortcutsSectionKo._(_root);
  @override
  late final _TranslationsSettingsShortcutsRowKo row =
      _TranslationsSettingsShortcutsRowKo._(_root);
  @override
  late final _TranslationsSettingsShortcutsResetDialogKo reset_dialog =
      _TranslationsSettingsShortcutsResetDialogKo._(_root);
}

// Path: settings.advanced
class _TranslationsSettingsAdvancedKo extends TranslationsSettingsAdvancedEn {
  _TranslationsSettingsAdvancedKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get title => '고급';
  @override
  String get api_server => '로컬 API 서버';
  @override
  String get api_server_description => '로컬 통합을 위해 127.0.0.1에서 번역 API를 노출합니다.';
  @override
  String get enable => '활성화';
  @override
  String get port => '포트';
  @override
  String get running_at => '{url}에서 실행 중';
  @override
  String get disabled => '비활성화됨';
}

// Path: settings.providers
class _TranslationsSettingsProvidersKo extends TranslationsSettingsProvidersEn {
  _TranslationsSettingsProvidersKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get title => '제공자';
  @override
  late final _TranslationsSettingsProvidersSectionKo section =
      _TranslationsSettingsProvidersSectionKo._(_root);
  @override
  late final _TranslationsSettingsProvidersItemKo item =
      _TranslationsSettingsProvidersItemKo._(_root);
  @override
  late final _TranslationsSettingsProvidersButtonKo button =
      _TranslationsSettingsProvidersButtonKo._(_root);
  @override
  late final _TranslationsSettingsProvidersAlertKo alert =
      _TranslationsSettingsProvidersAlertKo._(_root);
  @override
  late final _TranslationsSettingsProvidersIntroKo intro =
      _TranslationsSettingsProvidersIntroKo._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorKo editor =
      _TranslationsSettingsProvidersEditorKo._(_root);
  @override
  late final _TranslationsSettingsProvidersDetailKo detail =
      _TranslationsSettingsProvidersDetailKo._(_root);
  @override
  late final _TranslationsSettingsProvidersCapabilityKo capability =
      _TranslationsSettingsProvidersCapabilityKo._(_root);
  @override
  late final _TranslationsSettingsProvidersDescriptionKo description =
      _TranslationsSettingsProvidersDescriptionKo._(_root);
  @override
  late final _TranslationsSettingsProvidersDeleteDialogKo delete_dialog =
      _TranslationsSettingsProvidersDeleteDialogKo._(_root);
}

// Path: settings.layout
class _TranslationsSettingsLayoutKo extends TranslationsSettingsLayoutEn {
  _TranslationsSettingsLayoutKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get title => '설정';
  @override
  late final _TranslationsSettingsLayoutEmptyKo empty =
      _TranslationsSettingsLayoutEmptyKo._(_root);
}

// Path: common.ui.button
class _TranslationsCommonUiButtonKo extends TranslationsCommonUiButtonEn {
  _TranslationsCommonUiButtonKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get ok => '확인';
  @override
  String get cancel => '취소';
  @override
  String get add => '추가';
  @override
  String get delete => '삭제';
  @override
  String get edit => '편집';
  @override
  String get save => '저장';
  @override
  String get manage => '관리';
  @override
  String get kContinue => '계속';
}

// Path: common.ui.feedback
class _TranslationsCommonUiFeedbackKo extends TranslationsCommonUiFeedbackEn {
  _TranslationsCommonUiFeedbackKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get copied => '복사됨';
}

// Path: app.tray.context_menu
class _TranslationsAppTrayContextMenuKo
    extends TranslationsAppTrayContextMenuEn {
  _TranslationsAppTrayContextMenuKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get show_window => '창 보기';
  @override
  late final _TranslationsAppTrayContextMenuDevToolsKo dev_tools =
      _TranslationsAppTrayContextMenuDevToolsKo._(_root);
  @override
  String get check_for_updates => '업데이트 확인';
  @override
  String get settings => '설정';
  @override
  String get quit => '종료';
}

// Path: mini_translator.limited_banner.permission
class _TranslationsMiniTranslatorLimitedBannerPermissionKo
    extends TranslationsMiniTranslatorLimitedBannerPermissionEn {
  _TranslationsMiniTranslatorLimitedBannerPermissionKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get missing_both => '모든 기능을 사용하려면 화면 녹화 및 손쉬운 사용 권한을 부여하세요.';
  @override
  String get missing_screen_capture => '모든 기능을 사용하려면 화면 녹화 권한을 부여하세요.';
  @override
  String get missing_accessibility => '모든 기능을 사용하려면 손쉬운 사용 권한을 부여하세요.';
}

// Path: mini_translator.limited_banner.instruction
class _TranslationsMiniTranslatorLimitedBannerInstructionKo
    extends TranslationsMiniTranslatorLimitedBannerInstructionEn {
  _TranslationsMiniTranslatorLimitedBannerInstructionKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get app_settings_prefix => '';
  @override
  String get follow_guide_prefix => '로 이동하여 안내를 따라 ';
  @override
  String get suffix => '을(를) 클릭하세요.';
}

// Path: mini_translator.limited_banner.action
class _TranslationsMiniTranslatorLimitedBannerActionKo
    extends TranslationsMiniTranslatorLimitedBannerActionEn {
  _TranslationsMiniTranslatorLimitedBannerActionKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get app_settings => '앱 설정';
  @override
  String get recheck => '재확인';
}

// Path: mini_translator.limited_banner.feedback
class _TranslationsMiniTranslatorLimitedBannerFeedbackKo
    extends TranslationsMiniTranslatorLimitedBannerFeedbackEn {
  _TranslationsMiniTranslatorLimitedBannerFeedbackKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get enabled => '화면 텍스트 추출이 활성화되었습니다.';
  @override
  String get still_missing => '필요한 권한이 아직 부여되지 않았습니다.\n설정을 확인한 후 다시 시도해 주세요.';
}

// Path: mini_translator.limited_banner.tooltip
class _TranslationsMiniTranslatorLimitedBannerTooltipKo
    extends TranslationsMiniTranslatorLimitedBannerTooltipEn {
  _TranslationsMiniTranslatorLimitedBannerTooltipKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get help => '도움말 보기';
}

// Path: mini_translator.toolbar.tooltip
class _TranslationsMiniTranslatorToolbarTooltipKo
    extends TranslationsMiniTranslatorToolbarTooltipEn {
  _TranslationsMiniTranslatorToolbarTooltipKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get extract_text_from_screen_capture => '화면 영역을 캡처하여 텍스트 인식';
  @override
  String get extract_text_from_clipboard => '클립보드 내용 읽기';
}

// Path: settings.general.section
class _TranslationsSettingsGeneralSectionKo
    extends TranslationsSettingsGeneralSectionEn {
  _TranslationsSettingsGeneralSectionKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get permissions => '권한';
  @override
  String get ocr => '텍스트 인식';
  @override
  String get directory => '사전';
  @override
  String get translation => '번역';
  @override
  String get translation_target => '번역 대상';
  @override
  String get input => '입력 설정';
}

// Path: settings.general.row
class _TranslationsSettingsGeneralRowKo
    extends TranslationsSettingsGeneralRowEn {
  _TranslationsSettingsGeneralRowKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get launch_at_startup => '로그인 시 실행';
  @override
  String get show_in_menu_bar => '메뉴 막대에 표시';
  @override
  String get screen_capture_access => '화면 녹화 접근 권한 부여';
  @override
  String get screen_selection_access => '손쉬운 사용 접근 권한 부여';
  @override
  String get default_ocr_service => '기본 텍스트 인식 서비스';
  @override
  String get auto_copy_detected_text => '감지된 텍스트 자동 복사';
  @override
  String get default_directory_service => '기본 사전 서비스';
  @override
  String get default_translation_service => '기본 번역 서비스';
  @override
  String get double_click_copy_result => '더블 클릭으로 번역 결과 복사';
  @override
  String get submit_with_enter => 'Enter 키로 전송';
  @override
  String get submit_with_meta_enter_mac => '⌘ + Enter 키로 전송';
}

// Path: settings.general.button
class _TranslationsSettingsGeneralButtonKo
    extends TranslationsSettingsGeneralButtonEn {
  _TranslationsSettingsGeneralButtonKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get add_provider => '추가...';
  @override
  String get add_target => '대상 추가';
  @override
  String get manage_targets => '번역 대상 관리...';
  @override
  String get grant => '허용';
}

// Path: settings.general.option
class _TranslationsSettingsGeneralOptionKo
    extends TranslationsSettingsGeneralOptionEn {
  _TranslationsSettingsGeneralOptionKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get none => '없음';
  @override
  String get no_services_available => '사용 가능한 서비스가 없습니다';
  @override
  String get granted => '허용됨';
  @override
  String get built_in_ocr => '내장 OCR';
  @override
  String get tesseract => 'Tesseract';
  @override
  String get youdao_ocr => 'Youdao OCR';
}

// Path: settings.general.editor
class _TranslationsSettingsGeneralEditorKo
    extends TranslationsSettingsGeneralEditorEn {
  _TranslationsSettingsGeneralEditorKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsSettingsGeneralEditorRowKo row =
      _TranslationsSettingsGeneralEditorRowKo._(_root);
}

// Path: settings.appearance.section
class _TranslationsSettingsAppearanceSectionKo
    extends TranslationsSettingsAppearanceSectionEn {
  _TranslationsSettingsAppearanceSectionKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get app_language => '표시 언어';
  @override
  String get theme_mode => '테마 모드';
}

// Path: settings.shortcuts.section
class _TranslationsSettingsShortcutsSectionKo
    extends TranslationsSettingsShortcutsSectionEn {
  _TranslationsSettingsShortcutsSectionKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get text_extraction => '텍스트 추출';
  @override
  String get input_assist => '입력 보조 기능';
}

// Path: settings.shortcuts.row
class _TranslationsSettingsShortcutsRowKo
    extends TranslationsSettingsShortcutsRowEn {
  _TranslationsSettingsShortcutsRowKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get toggle_mini_translator => '창 보이기/숨기기';
  @override
  String get extract_text_from_screen_selection => '화면 선택 영역에서 텍스트 추출';
  @override
  String get extract_text_from_screen_capture => '화면 캡처에서 텍스트 추출';
  @override
  String get extract_text_from_clipboard => '클립보드에서 텍스트 추출';
  @override
  String get translate_input => '입력 내용 번역';
}

// Path: settings.shortcuts.reset_dialog
class _TranslationsSettingsShortcutsResetDialogKo
    extends TranslationsSettingsShortcutsResetDialogEn {
  _TranslationsSettingsShortcutsResetDialogKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get title => '단축키 초기화';
  @override
  String get message => '모든 단축키를 기본값으로 초기화하시겠습니까?';
  @override
  String get confirm => '초기화';
  @override
  String get cancel => '취소';
}

// Path: settings.providers.section
class _TranslationsSettingsProvidersSectionKo
    extends TranslationsSettingsProvidersSectionEn {
  _TranslationsSettingsProvidersSectionKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get services => '사용 가능한 서비스';
  @override
  String get services_description =>
      '구성된 제공업체의 사용 가능한 서비스를 확인하고 서비스 유형별로 전환합니다.';
}

// Path: settings.providers.item
class _TranslationsSettingsProvidersItemKo
    extends TranslationsSettingsProvidersItemEn {
  _TranslationsSettingsProvidersItemKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get empty => '구성된 제공자가 없습니다. 추가하여 번역 서비스를 활성화하세요.';
  @override
  String get loading => '제공자 로딩 중...';
  @override
  String get no_services => '사용 가능한 서비스가 없습니다.';
}

// Path: settings.providers.button
class _TranslationsSettingsProvidersButtonKo
    extends TranslationsSettingsProvidersButtonEn {
  _TranslationsSettingsProvidersButtonKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get add => '제공자 추가...';
}

// Path: settings.providers.alert
class _TranslationsSettingsProvidersAlertKo
    extends TranslationsSettingsProvidersAlertEn {
  _TranslationsSettingsProvidersAlertKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get error => '오류';
}

// Path: settings.providers.intro
class _TranslationsSettingsProvidersIntroKo
    extends TranslationsSettingsProvidersIntroEn {
  _TranslationsSettingsProvidersIntroKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get body => '앱에서 사용하는 서비스 제공업체를 관리합니다.';
  @override
  String get warning =>
      '연결된 제공업체는 사용자가 보낸 텍스트나 이미지를 처리할 수 있습니다. 신뢰할 수 있는 서비스만 활성화하세요.';
}

// Path: settings.providers.editor
class _TranslationsSettingsProvidersEditorKo
    extends TranslationsSettingsProvidersEditorEn {
  _TranslationsSettingsProvidersEditorKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsSettingsProvidersEditorRowKo row =
      _TranslationsSettingsProvidersEditorRowKo._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorPlaceholderKo placeholder =
      _TranslationsSettingsProvidersEditorPlaceholderKo._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorTypePickerKo type_picker =
      _TranslationsSettingsProvidersEditorTypePickerKo._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorTooltipKo tooltip =
      _TranslationsSettingsProvidersEditorTooltipKo._(_root);
}

// Path: settings.providers.detail
class _TranslationsSettingsProvidersDetailKo
    extends TranslationsSettingsProvidersDetailEn {
  _TranslationsSettingsProvidersDetailKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsSettingsProvidersDetailTooltipKo tooltip =
      _TranslationsSettingsProvidersDetailTooltipKo._(_root);
}

// Path: settings.providers.capability
class _TranslationsSettingsProvidersCapabilityKo
    extends TranslationsSettingsProvidersCapabilityEn {
  _TranslationsSettingsProvidersCapabilityKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get translation => '번역';
  @override
  String get dictionary => '사전';
  @override
  String get ocr => 'OCR';
}

// Path: settings.providers.description
class _TranslationsSettingsProvidersDescriptionKo
    extends TranslationsSettingsProvidersDescriptionEn {
  _TranslationsSettingsProvidersDescriptionKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get all => '사전 검색 및 텍스트 번역을 제공합니다';
  @override
  String get dictionary => '사전 검색 및 단어 정의를 제공합니다';
  @override
  String get translation => '언어 간 텍스트 번역을 제공합니다';
  @override
  String get fallback => '번역 서비스를 제공합니다';
}

// Path: settings.providers.delete_dialog
class _TranslationsSettingsProvidersDeleteDialogKo
    extends TranslationsSettingsProvidersDeleteDialogEn {
  _TranslationsSettingsProvidersDeleteDialogKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get title => '"{}"을(를) 삭제하시겠습니까?';
  @override
  String get message => '이 작업은 되돌릴 수 없습니다.';
}

// Path: settings.layout.empty
class _TranslationsSettingsLayoutEmptyKo
    extends TranslationsSettingsLayoutEmptyEn {
  _TranslationsSettingsLayoutEmptyKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get title => '카테고리 선택';
  @override
  String get message => '사이드바에서 설정 섹션을 선택하세요.';
}

// Path: app.tray.context_menu.dev_tools
class _TranslationsAppTrayContextMenuDevToolsKo
    extends TranslationsAppTrayContextMenuDevToolsEn {
  _TranslationsAppTrayContextMenuDevToolsKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get title => '개발자 도구';
  @override
  String get open_data_directory => '데이터 디렉터리 열기';
  @override
  String get use_native_settings => '네이티브 설정 페이지 사용';
}

// Path: settings.general.editor.row
class _TranslationsSettingsGeneralEditorRowKo
    extends TranslationsSettingsGeneralEditorRowEn {
  _TranslationsSettingsGeneralEditorRowKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get source_language => '소스 언어';
  @override
  String get target_language => '대상 언어';
}

// Path: settings.providers.editor.row
class _TranslationsSettingsProvidersEditorRowKo
    extends TranslationsSettingsProvidersEditorRowEn {
  _TranslationsSettingsProvidersEditorRowKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get id => '제공자 ID';
}

// Path: settings.providers.editor.placeholder
class _TranslationsSettingsProvidersEditorPlaceholderKo
    extends TranslationsSettingsProvidersEditorPlaceholderEn {
  _TranslationsSettingsProvidersEditorPlaceholderKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get id => '예: deepl-main';
}

// Path: settings.providers.editor.type_picker
class _TranslationsSettingsProvidersEditorTypePickerKo
    extends TranslationsSettingsProvidersEditorTypePickerEn {
  _TranslationsSettingsProvidersEditorTypePickerKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get prompt => '추가할 제공자 유형을 선택하세요:';
}

// Path: settings.providers.editor.tooltip
class _TranslationsSettingsProvidersEditorTooltipKo
    extends TranslationsSettingsProvidersEditorTooltipEn {
  _TranslationsSettingsProvidersEditorTooltipKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get help => '도움말';
}

// Path: settings.providers.detail.tooltip
class _TranslationsSettingsProvidersDetailTooltipKo
    extends TranslationsSettingsProvidersDetailTooltipEn {
  _TranslationsSettingsProvidersDetailTooltipKo._(TranslationsKo root)
      : this._root = root,
        super.internal(root);

  final TranslationsKo _root; // ignore: unused_field

  // Translations
  @override
  String get edit => '제공자 편집';
}

/// The flat map containing all translations for locale <ko>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsKo {
  dynamic _flatMapFunction(String path) {
    return switch (path) {
      'common.ui.button.ok' => '확인',
      'common.ui.button.cancel' => '취소',
      'common.ui.button.add' => '추가',
      'common.ui.button.delete' => '삭제',
      'common.ui.button.edit' => '편집',
      'common.ui.button.save' => '저장',
      'common.ui.button.manage' => '관리',
      'common.ui.button.kContinue' => '계속',
      'common.ui.feedback.copied' => '복사됨',
      'common.language.ar' => '아랍어',
      'common.language.bn' => '벵골어',
      'common.language.de' => '독일어',
      'common.language.en' => '영어',
      'common.language.es' => '스페인어',
      'common.language.fa' => '페르시아어',
      'common.language.fr' => '프랑스어',
      'common.language.gu' => '구자라트어',
      'common.language.ha' => '하우사어',
      'common.language.hi' => '힌디어',
      'common.language.id' => '인도네시아어',
      'common.language.it' => '이탈리아어',
      'common.language.ja' => '일본어',
      'common.language.jv' => '자바어',
      'common.language.ko' => '한국어',
      'common.language.ml' => '말라얄람어',
      'common.language.mr' => '마라티어',
      'common.language.ms' => '말레이어',
      'common.language.nl' => '네덜란드어',
      'common.language.pa' => '펀자브어',
      'common.language.pl' => '폴란드어',
      'common.language.pt' => '포르투갈어',
      'common.language.ro' => '루마니아어',
      'common.language.ru' => '러시아어',
      'common.language.sw' => '스와힐리어',
      'common.language.ta' => '타밀어',
      'common.language.te' => '텔루구어',
      'common.language.th' => '태국어',
      'common.language.tr' => '터키어',
      'common.language.uk' => '우크라이나어',
      'common.language.ur' => '우르두어',
      'common.language.vi' => '베트남어',
      'common.language.yo' => '요루바어',
      'common.language.zh_hans' => '중국어(간체)',
      'common.language.zh_hant' => '중국어(번체)',
      'common.theme_mode.light' => '라이트',
      'common.theme_mode.dark' => '다크',
      'common.theme_mode.system' => '시스템',
      'common.provider.baidu' => 'Baidu',
      'common.provider.caiyun' => 'Caiyun',
      'common.provider.deepl' => 'DeepL',
      'common.provider.google' => 'Google',
      'common.provider.iciba' => 'Iciba',
      'common.provider.sogou' => 'Sogou',
      'common.provider.system' => '시스템',
      'common.provider.tencent' => 'Tencent',
      'common.provider.youdao' => 'Youdao',
      'common.word_pronunciation.us' => '미국',
      'common.word_pronunciation.uk' => '영국',
      'app.tray.context_menu.show_window' => '창 보기',
      'app.tray.context_menu.dev_tools.title' => '개발자 도구',
      'app.tray.context_menu.dev_tools.open_data_directory' => '데이터 디렉터리 열기',
      'app.tray.context_menu.dev_tools.use_native_settings' => '네이티브 설정 페이지 사용',
      'app.tray.context_menu.check_for_updates' => '업데이트 확인',
      'app.tray.context_menu.settings' => '설정',
      'app.tray.context_menu.quit' => '종료',
      'mini_translator.limited_banner.permission.missing_both' =>
        '모든 기능을 사용하려면 화면 녹화 및 손쉬운 사용 권한을 부여하세요.',
      'mini_translator.limited_banner.permission.missing_screen_capture' =>
        '모든 기능을 사용하려면 화면 녹화 권한을 부여하세요.',
      'mini_translator.limited_banner.permission.missing_accessibility' =>
        '모든 기능을 사용하려면 손쉬운 사용 권한을 부여하세요.',
      'mini_translator.limited_banner.instruction.app_settings_prefix' => '',
      'mini_translator.limited_banner.instruction.follow_guide_prefix' =>
        '로 이동하여 안내를 따라 ',
      'mini_translator.limited_banner.instruction.suffix' => '을(를) 클릭하세요.',
      'mini_translator.limited_banner.action.app_settings' => '앱 설정',
      'mini_translator.limited_banner.action.recheck' => '재확인',
      'mini_translator.limited_banner.feedback.enabled' =>
        '화면 텍스트 추출이 활성화되었습니다.',
      'mini_translator.limited_banner.feedback.still_missing' =>
        '필요한 권한이 아직 부여되지 않았습니다.\n설정을 확인한 후 다시 시도해 주세요.',
      'mini_translator.limited_banner.tooltip.help' => '도움말 보기',
      'mini_translator.input.hint' => '단어나 텍스트를 입력하세요',
      'mini_translator.input.extracting_text' => '텍스트 추출 중...',
      'mini_translator.toolbar.tooltip.extract_text_from_screen_capture' =>
        '화면 영역을 캡처하여 텍스트 인식',
      'mini_translator.toolbar.tooltip.extract_text_from_clipboard' =>
        '클립보드 내용 읽기',
      'mini_translator.button.clear' => '지우기',
      'mini_translator.button.translate' => '번역',
      'mini_translator.language.auto_detect' => '자동 감지',
      'mini_translator.language.auto_match' => '자동 일치',
      'mini_translator.language.switch_config' => '대상 전환',
      'mini_translator.message.please_enter_word_or_text' =>
        '입력된 텍스트가 없거나 텍스트를 추출하지 못했습니다',
      'mini_translator.message.capture_screen_area_canceled' =>
        '화면 영역 캡처가 취소되었습니다',
      'settings.version' => '버전 {} 빌드 {}',
      'settings.general.title' => '일반',
      'settings.general.section.permissions' => '권한',
      'settings.general.section.ocr' => '텍스트 인식',
      'settings.general.section.directory' => '사전',
      'settings.general.section.translation' => '번역',
      'settings.general.section.translation_target' => '번역 대상',
      'settings.general.section.input' => '입력 설정',
      'settings.general.row.launch_at_startup' => '로그인 시 실행',
      'settings.general.row.show_in_menu_bar' => '메뉴 막대에 표시',
      'settings.general.row.screen_capture_access' => '화면 녹화 접근 권한 부여',
      'settings.general.row.screen_selection_access' => '손쉬운 사용 접근 권한 부여',
      'settings.general.row.default_ocr_service' => '기본 텍스트 인식 서비스',
      'settings.general.row.auto_copy_detected_text' => '감지된 텍스트 자동 복사',
      'settings.general.row.default_directory_service' => '기본 사전 서비스',
      'settings.general.row.default_translation_service' => '기본 번역 서비스',
      'settings.general.row.double_click_copy_result' => '더블 클릭으로 번역 결과 복사',
      'settings.general.row.submit_with_enter' => 'Enter 키로 전송',
      'settings.general.row.submit_with_meta_enter_mac' => '⌘ + Enter 키로 전송',
      'settings.general.button.add_provider' => '추가...',
      'settings.general.button.add_target' => '대상 추가',
      'settings.general.button.manage_targets' => '번역 대상 관리...',
      'settings.general.button.grant' => '허용',
      'settings.general.option.none' => '없음',
      'settings.general.option.no_services_available' => '사용 가능한 서비스가 없습니다',
      'settings.general.option.granted' => '허용됨',
      'settings.general.option.built_in_ocr' => '내장 OCR',
      'settings.general.option.tesseract' => 'Tesseract',
      'settings.general.option.youdao_ocr' => 'Youdao OCR',
      'settings.general.editor.row.source_language' => '소스 언어',
      'settings.general.editor.row.target_language' => '대상 언어',
      'settings.appearance.title' => '외관',
      'settings.appearance.section.app_language' => '표시 언어',
      'settings.appearance.section.theme_mode' => '테마 모드',
      'settings.shortcuts.title' => '단축키',
      'settings.shortcuts.section.text_extraction' => '텍스트 추출',
      'settings.shortcuts.section.input_assist' => '입력 보조 기능',
      'settings.shortcuts.row.toggle_mini_translator' => '창 보이기/숨기기',
      'settings.shortcuts.row.extract_text_from_screen_selection' =>
        '화면 선택 영역에서 텍스트 추출',
      'settings.shortcuts.row.extract_text_from_screen_capture' =>
        '화면 캡처에서 텍스트 추출',
      'settings.shortcuts.row.extract_text_from_clipboard' => '클립보드에서 텍스트 추출',
      'settings.shortcuts.row.translate_input' => '입력 내용 번역',
      'settings.shortcuts.reset_dialog.title' => '단축키 초기화',
      'settings.shortcuts.reset_dialog.message' => '모든 단축키를 기본값으로 초기화하시겠습니까?',
      'settings.shortcuts.reset_dialog.confirm' => '초기화',
      'settings.shortcuts.reset_dialog.cancel' => '취소',
      'settings.advanced.title' => '고급',
      'settings.advanced.api_server' => '로컬 API 서버',
      'settings.advanced.api_server_description' =>
        '로컬 통합을 위해 127.0.0.1에서 번역 API를 노출합니다.',
      'settings.advanced.enable' => '활성화',
      'settings.advanced.port' => '포트',
      'settings.advanced.running_at' => '{url}에서 실행 중',
      'settings.advanced.disabled' => '비활성화됨',
      'settings.providers.title' => '제공자',
      'settings.providers.section.services' => '사용 가능한 서비스',
      'settings.providers.section.services_description' =>
        '구성된 제공업체의 사용 가능한 서비스를 확인하고 서비스 유형별로 전환합니다.',
      'settings.providers.item.empty' => '구성된 제공자가 없습니다. 추가하여 번역 서비스를 활성화하세요.',
      'settings.providers.item.loading' => '제공자 로딩 중...',
      'settings.providers.item.no_services' => '사용 가능한 서비스가 없습니다.',
      'settings.providers.button.add' => '제공자 추가...',
      'settings.providers.alert.error' => '오류',
      'settings.providers.intro.body' => '앱에서 사용하는 서비스 제공업체를 관리합니다.',
      'settings.providers.intro.warning' =>
        '연결된 제공업체는 사용자가 보낸 텍스트나 이미지를 처리할 수 있습니다. 신뢰할 수 있는 서비스만 활성화하세요.',
      'settings.providers.editor.row.id' => '제공자 ID',
      'settings.providers.editor.placeholder.id' => '예: deepl-main',
      'settings.providers.editor.type_picker.prompt' => '추가할 제공자 유형을 선택하세요:',
      'settings.providers.editor.tooltip.help' => '도움말',
      'settings.providers.detail.tooltip.edit' => '제공자 편집',
      'settings.providers.capability.translation' => '번역',
      'settings.providers.capability.dictionary' => '사전',
      'settings.providers.capability.ocr' => 'OCR',
      'settings.providers.description.all' => '사전 검색 및 텍스트 번역을 제공합니다',
      'settings.providers.description.dictionary' => '사전 검색 및 단어 정의를 제공합니다',
      'settings.providers.description.translation' => '언어 간 텍스트 번역을 제공합니다',
      'settings.providers.description.fallback' => '번역 서비스를 제공합니다',
      'settings.providers.delete_dialog.title' => '"{}"을(를) 삭제하시겠습니까?',
      'settings.providers.delete_dialog.message' => '이 작업은 되돌릴 수 없습니다.',
      'settings.layout.title' => '설정',
      'settings.layout.empty.title' => '카테고리 선택',
      'settings.layout.empty.message' => '사이드바에서 설정 섹션을 선택하세요.',
      _ => null,
    };
  }
}
