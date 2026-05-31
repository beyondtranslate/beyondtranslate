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
class TranslationsZhHant extends Translations
    with BaseTranslations<AppLocale, Translations> {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsZhHant(
      {Map<String, Node>? overrides,
      PluralResolver? cardinalResolver,
      PluralResolver? ordinalResolver,
      TranslationMetadata<AppLocale, Translations>? meta})
      : assert(overrides == null,
            'Set "translation_overrides: true" in order to enable this feature.'),
        $meta = meta ??
            TranslationMetadata(
              locale: AppLocale.zhHant,
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

  /// Metadata for the translations of <zh-Hant>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  /// Access flat map
  @override
  dynamic operator [](String key) =>
      $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

  late final TranslationsZhHant _root = this; // ignore: unused_field

  @override
  TranslationsZhHant $copyWith(
          {TranslationMetadata<AppLocale, Translations>? meta}) =>
      TranslationsZhHant(meta: meta ?? this.$meta);

  // Translations
  @override
  late final _TranslationsCommonZhHant common =
      _TranslationsCommonZhHant._(_root);
  @override
  late final _TranslationsAppZhHant app = _TranslationsAppZhHant._(_root);
  @override
  late final _TranslationsMiniTranslatorZhHant mini_translator =
      _TranslationsMiniTranslatorZhHant._(_root);
  @override
  late final _TranslationsSettingsZhHant settings =
      _TranslationsSettingsZhHant._(_root);
}

// Path: common
class _TranslationsCommonZhHant extends TranslationsCommonEn {
  _TranslationsCommonZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsCommonUiZhHant ui =
      _TranslationsCommonUiZhHant._(_root);
  @override
  late final _TranslationsCommonLanguageZhHant language =
      _TranslationsCommonLanguageZhHant._(_root);
  @override
  late final _TranslationsCommonThemeModeZhHant theme_mode =
      _TranslationsCommonThemeModeZhHant._(_root);
  @override
  late final _TranslationsCommonProviderZhHant provider =
      _TranslationsCommonProviderZhHant._(_root);
  @override
  late final _TranslationsCommonWordPronunciationZhHant word_pronunciation =
      _TranslationsCommonWordPronunciationZhHant._(_root);
}

// Path: app
class _TranslationsAppZhHant extends TranslationsAppEn {
  _TranslationsAppZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsAppTrayZhHant tray =
      _TranslationsAppTrayZhHant._(_root);
}

// Path: mini_translator
class _TranslationsMiniTranslatorZhHant extends TranslationsMiniTranslatorEn {
  _TranslationsMiniTranslatorZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsMiniTranslatorLimitedBannerZhHant limited_banner =
      _TranslationsMiniTranslatorLimitedBannerZhHant._(_root);
  @override
  late final _TranslationsMiniTranslatorInputZhHant input =
      _TranslationsMiniTranslatorInputZhHant._(_root);
  @override
  late final _TranslationsMiniTranslatorToolbarZhHant toolbar =
      _TranslationsMiniTranslatorToolbarZhHant._(_root);
  @override
  late final _TranslationsMiniTranslatorButtonZhHant button =
      _TranslationsMiniTranslatorButtonZhHant._(_root);
  @override
  late final _TranslationsMiniTranslatorLanguageZhHant language =
      _TranslationsMiniTranslatorLanguageZhHant._(_root);
  @override
  late final _TranslationsMiniTranslatorMessageZhHant message =
      _TranslationsMiniTranslatorMessageZhHant._(_root);
}

// Path: settings
class _TranslationsSettingsZhHant extends TranslationsSettingsEn {
  _TranslationsSettingsZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get version => 'v{} (Build {})';
  @override
  late final _TranslationsSettingsGeneralZhHant general =
      _TranslationsSettingsGeneralZhHant._(_root);
  @override
  late final _TranslationsSettingsAppearanceZhHant appearance =
      _TranslationsSettingsAppearanceZhHant._(_root);
  @override
  late final _TranslationsSettingsShortcutsZhHant shortcuts =
      _TranslationsSettingsShortcutsZhHant._(_root);
  @override
  late final _TranslationsSettingsAdvancedZhHant advanced =
      _TranslationsSettingsAdvancedZhHant._(_root);
  @override
  late final _TranslationsSettingsServicesZhHant services =
      _TranslationsSettingsServicesZhHant._(_root);
  @override
  late final _TranslationsSettingsProvidersZhHant providers =
      _TranslationsSettingsProvidersZhHant._(_root);
  @override
  late final _TranslationsSettingsLayoutZhHant layout =
      _TranslationsSettingsLayoutZhHant._(_root);
  @override
  late final _TranslationsSettingsAboutZhHant about =
      _TranslationsSettingsAboutZhHant._(_root);
}

// Path: common.ui
class _TranslationsCommonUiZhHant extends TranslationsCommonUiEn {
  _TranslationsCommonUiZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsCommonUiButtonZhHant button =
      _TranslationsCommonUiButtonZhHant._(_root);
  @override
  late final _TranslationsCommonUiFeedbackZhHant feedback =
      _TranslationsCommonUiFeedbackZhHant._(_root);
}

// Path: common.language
class _TranslationsCommonLanguageZhHant extends TranslationsCommonLanguageEn {
  _TranslationsCommonLanguageZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get ar => '阿拉伯語';
  @override
  String get bn => '孟加拉語';
  @override
  String get de => '德語';
  @override
  String get en => '英語';
  @override
  String get es => '西班牙語';
  @override
  String get fa => '波斯語';
  @override
  String get fr => '法語';
  @override
  String get gu => '古吉拉特語';
  @override
  String get ha => '豪薩語';
  @override
  String get hi => '印地語';
  @override
  String get id => '印尼語';
  @override
  String get it => '義大利語';
  @override
  String get ja => '日語';
  @override
  String get jv => '爪哇語';
  @override
  String get ko => '韓語';
  @override
  String get ml => '馬拉雅拉姆語';
  @override
  String get mr => '馬拉地語';
  @override
  String get ms => '馬來語';
  @override
  String get nl => '荷蘭語';
  @override
  String get pa => '旁遮普語';
  @override
  String get pl => '波蘭語';
  @override
  String get pt => '葡萄牙語';
  @override
  String get ro => '羅馬尼亞語';
  @override
  String get ru => '俄語';
  @override
  String get sw => '斯瓦希里語';
  @override
  String get ta => '泰米爾語';
  @override
  String get te => '泰盧固語';
  @override
  String get th => '泰語';
  @override
  String get tr => '土耳其語';
  @override
  String get uk => '烏克蘭語';
  @override
  String get ur => '烏爾都語';
  @override
  String get vi => '越南語';
  @override
  String get yo => '約魯巴語';
  @override
  String get zh_hans => '中文（簡體）';
  @override
  String get zh_hant => '中文（繁體）';
}

// Path: common.theme_mode
class _TranslationsCommonThemeModeZhHant extends TranslationsCommonThemeModeEn {
  _TranslationsCommonThemeModeZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get light => '淺色';
  @override
  String get dark => '深色';
  @override
  String get system => '跟隨系統';
}

// Path: common.provider
class _TranslationsCommonProviderZhHant extends TranslationsCommonProviderEn {
  _TranslationsCommonProviderZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get anthropic => 'Anthropic';
  @override
  String get baidu => '百度';
  @override
  String get caiyun => '彩雲小譯';
  @override
  String get deepl => 'DeepL';
  @override
  String get google => '谷歌';
  @override
  String get iciba => '愛詞霸';
  @override
  String get ollama => 'Ollama';
  @override
  String get openai => 'OpenAI';
  @override
  String get sogou => '搜狗';
  @override
  String get system => '系統';
  @override
  String get tencent => '騰訊';
  @override
  String get youdao => '有道';
}

// Path: common.word_pronunciation
class _TranslationsCommonWordPronunciationZhHant
    extends TranslationsCommonWordPronunciationEn {
  _TranslationsCommonWordPronunciationZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get us => '美';
  @override
  String get uk => '英';
}

// Path: app.tray
class _TranslationsAppTrayZhHant extends TranslationsAppTrayEn {
  _TranslationsAppTrayZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsAppTrayContextMenuZhHant context_menu =
      _TranslationsAppTrayContextMenuZhHant._(_root);
}

// Path: mini_translator.limited_banner
class _TranslationsMiniTranslatorLimitedBannerZhHant
    extends TranslationsMiniTranslatorLimitedBannerEn {
  _TranslationsMiniTranslatorLimitedBannerZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsMiniTranslatorLimitedBannerPermissionZhHant
      permission =
      _TranslationsMiniTranslatorLimitedBannerPermissionZhHant._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerInstructionZhHant
      instruction =
      _TranslationsMiniTranslatorLimitedBannerInstructionZhHant._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerActionZhHant action =
      _TranslationsMiniTranslatorLimitedBannerActionZhHant._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerFeedbackZhHant feedback =
      _TranslationsMiniTranslatorLimitedBannerFeedbackZhHant._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerTooltipZhHant tooltip =
      _TranslationsMiniTranslatorLimitedBannerTooltipZhHant._(_root);
}

// Path: mini_translator.input
class _TranslationsMiniTranslatorInputZhHant
    extends TranslationsMiniTranslatorInputEn {
  _TranslationsMiniTranslatorInputZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get hint => '在此輸入單字或文字';
  @override
  String get extracting_text => '正在辨識文字…';
}

// Path: mini_translator.toolbar
class _TranslationsMiniTranslatorToolbarZhHant
    extends TranslationsMiniTranslatorToolbarEn {
  _TranslationsMiniTranslatorToolbarZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsMiniTranslatorToolbarTooltipZhHant tooltip =
      _TranslationsMiniTranslatorToolbarTooltipZhHant._(_root);
}

// Path: mini_translator.button
class _TranslationsMiniTranslatorButtonZhHant
    extends TranslationsMiniTranslatorButtonEn {
  _TranslationsMiniTranslatorButtonZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get clear => '清除';
  @override
  String get translate => '翻譯';
}

// Path: mini_translator.language
class _TranslationsMiniTranslatorLanguageZhHant
    extends TranslationsMiniTranslatorLanguageEn {
  _TranslationsMiniTranslatorLanguageZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get auto_detect => '自動偵測';
  @override
  String get auto_match => '自動匹配';
  @override
  String get switch_config => '切換目標';
  @override
  String get more_languages => '更多語言...';
  @override
  String get manage_common_languages => '管理常用語言...';
  @override
  String get manage_targets => '管理翻譯目標...';
  @override
  String get add_target => '添加翻譯目標...';
}

// Path: mini_translator.message
class _TranslationsMiniTranslatorMessageZhHant
    extends TranslationsMiniTranslatorMessageEn {
  _TranslationsMiniTranslatorMessageZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get please_enter_word_or_text => '未輸入或未擷取到文字';
  @override
  String get capture_screen_area_canceled => '螢幕區域擷取已取消';
  @override
  String get ocr_service_not_configured => '未配置預設文字辨識服務，請在設定中配置。';
  @override
  String get ocr_recognition_failed => '文字辨識失敗';
}

// Path: settings.general
class _TranslationsSettingsGeneralZhHant extends TranslationsSettingsGeneralEn {
  _TranslationsSettingsGeneralZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get title => '一般';
  @override
  late final _TranslationsSettingsGeneralSectionZhHant section =
      _TranslationsSettingsGeneralSectionZhHant._(_root);
  @override
  late final _TranslationsSettingsGeneralRowZhHant row =
      _TranslationsSettingsGeneralRowZhHant._(_root);
  @override
  late final _TranslationsSettingsGeneralButtonZhHant button =
      _TranslationsSettingsGeneralButtonZhHant._(_root);
  @override
  late final _TranslationsSettingsGeneralOptionZhHant option =
      _TranslationsSettingsGeneralOptionZhHant._(_root);
  @override
  late final _TranslationsSettingsGeneralEditorZhHant editor =
      _TranslationsSettingsGeneralEditorZhHant._(_root);
}

// Path: settings.appearance
class _TranslationsSettingsAppearanceZhHant
    extends TranslationsSettingsAppearanceEn {
  _TranslationsSettingsAppearanceZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get title => '外觀';
  @override
  late final _TranslationsSettingsAppearanceSectionZhHant section =
      _TranslationsSettingsAppearanceSectionZhHant._(_root);
}

// Path: settings.shortcuts
class _TranslationsSettingsShortcutsZhHant
    extends TranslationsSettingsShortcutsEn {
  _TranslationsSettingsShortcutsZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get title => '快捷鍵';
  @override
  late final _TranslationsSettingsShortcutsSectionZhHant section =
      _TranslationsSettingsShortcutsSectionZhHant._(_root);
  @override
  late final _TranslationsSettingsShortcutsRowZhHant row =
      _TranslationsSettingsShortcutsRowZhHant._(_root);
  @override
  late final _TranslationsSettingsShortcutsResetDialogZhHant reset_dialog =
      _TranslationsSettingsShortcutsResetDialogZhHant._(_root);
}

// Path: settings.advanced
class _TranslationsSettingsAdvancedZhHant
    extends TranslationsSettingsAdvancedEn {
  _TranslationsSettingsAdvancedZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get title => '進階';
  @override
  String get api_server => '本機 API 服務';
  @override
  String get api_server_description => '在 127.0.0.1 上開放翻譯 API，供本機整合使用。';
  @override
  String get enable => '啟用';
  @override
  String get port => '埠號';
  @override
  String get running_at => '執行於 {url}';
  @override
  String get disabled => '已關閉';
}

// Path: settings.services
class _TranslationsSettingsServicesZhHant
    extends TranslationsSettingsServicesEn {
  _TranslationsSettingsServicesZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get title => '服務';
  @override
  late final _TranslationsSettingsServicesButtonZhHant button =
      _TranslationsSettingsServicesButtonZhHant._(_root);
  @override
  late final _TranslationsSettingsServicesSectionZhHant section =
      _TranslationsSettingsServicesSectionZhHant._(_root);
  @override
  late final _TranslationsSettingsServicesEditorZhHant editor =
      _TranslationsSettingsServicesEditorZhHant._(_root);
}

// Path: settings.providers
class _TranslationsSettingsProvidersZhHant
    extends TranslationsSettingsProvidersEn {
  _TranslationsSettingsProvidersZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get title => '提供者';
  @override
  late final _TranslationsSettingsProvidersSectionZhHant section =
      _TranslationsSettingsProvidersSectionZhHant._(_root);
  @override
  late final _TranslationsSettingsProvidersItemZhHant item =
      _TranslationsSettingsProvidersItemZhHant._(_root);
  @override
  late final _TranslationsSettingsProvidersButtonZhHant button =
      _TranslationsSettingsProvidersButtonZhHant._(_root);
  @override
  late final _TranslationsSettingsProvidersAlertZhHant alert =
      _TranslationsSettingsProvidersAlertZhHant._(_root);
  @override
  late final _TranslationsSettingsProvidersIntroZhHant intro =
      _TranslationsSettingsProvidersIntroZhHant._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorZhHant editor =
      _TranslationsSettingsProvidersEditorZhHant._(_root);
  @override
  late final _TranslationsSettingsProvidersDetailZhHant detail =
      _TranslationsSettingsProvidersDetailZhHant._(_root);
  @override
  late final _TranslationsSettingsProvidersCapabilityZhHant capability =
      _TranslationsSettingsProvidersCapabilityZhHant._(_root);
  @override
  late final _TranslationsSettingsProvidersDescriptionZhHant description =
      _TranslationsSettingsProvidersDescriptionZhHant._(_root);
  @override
  late final _TranslationsSettingsProvidersDeleteDialogZhHant delete_dialog =
      _TranslationsSettingsProvidersDeleteDialogZhHant._(_root);
}

// Path: settings.layout
class _TranslationsSettingsLayoutZhHant extends TranslationsSettingsLayoutEn {
  _TranslationsSettingsLayoutZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get title => '設定';
  @override
  late final _TranslationsSettingsLayoutEmptyZhHant empty =
      _TranslationsSettingsLayoutEmptyZhHant._(_root);
}

// Path: settings.about
class _TranslationsSettingsAboutZhHant extends TranslationsSettingsAboutEn {
  _TranslationsSettingsAboutZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get title => '關於';
  @override
  String get copy_version_info => '複製版本資訊';
  @override
  String get up_to_date => '已是最新版本。';
  @override
  String get check_again => '重新檢查';
  @override
  String get links => '連結';
  @override
  String get website => '網站';
  @override
  String get github => 'GitHub';
  @override
  String get report_issue => '回報問題';
  @override
  String get license => '授權條款';
  @override
  String get open_changelog => '查看更新日誌';
}

// Path: common.ui.button
class _TranslationsCommonUiButtonZhHant extends TranslationsCommonUiButtonEn {
  _TranslationsCommonUiButtonZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get ok => '確定';
  @override
  String get cancel => '取消';
  @override
  String get add => '新增';
  @override
  String get delete => '刪除';
  @override
  String get edit => '編輯';
  @override
  String get save => '儲存';
  @override
  String get manage => '管理';
  @override
  String get kContinue => '繼續';
}

// Path: common.ui.feedback
class _TranslationsCommonUiFeedbackZhHant
    extends TranslationsCommonUiFeedbackEn {
  _TranslationsCommonUiFeedbackZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get copied => '已複製';
}

// Path: app.tray.context_menu
class _TranslationsAppTrayContextMenuZhHant
    extends TranslationsAppTrayContextMenuEn {
  _TranslationsAppTrayContextMenuZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get show_window => '顯示視窗';
  @override
  late final _TranslationsAppTrayContextMenuDevToolsZhHant dev_tools =
      _TranslationsAppTrayContextMenuDevToolsZhHant._(_root);
  @override
  String get check_for_updates => '檢查更新';
  @override
  String get settings => '設定';
  @override
  String get quit => '結束';
}

// Path: mini_translator.limited_banner.permission
class _TranslationsMiniTranslatorLimitedBannerPermissionZhHant
    extends TranslationsMiniTranslatorLimitedBannerPermissionEn {
  _TranslationsMiniTranslatorLimitedBannerPermissionZhHant._(
      TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get missing_both => '請授予螢幕錄製和輔助功能權限以啟用完整功能。';
  @override
  String get missing_screen_capture => '請授予螢幕錄製權限以啟用完整功能。';
  @override
  String get missing_accessibility => '請授予輔助功能權限以啟用完整功能。';
}

// Path: mini_translator.limited_banner.instruction
class _TranslationsMiniTranslatorLimitedBannerInstructionZhHant
    extends TranslationsMiniTranslatorLimitedBannerInstructionEn {
  _TranslationsMiniTranslatorLimitedBannerInstructionZhHant._(
      TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get app_settings_prefix => '請前往';
  @override
  String get follow_guide_prefix => '，依指引授權後點選';
  @override
  String get suffix => '。';
}

// Path: mini_translator.limited_banner.action
class _TranslationsMiniTranslatorLimitedBannerActionZhHant
    extends TranslationsMiniTranslatorLimitedBannerActionEn {
  _TranslationsMiniTranslatorLimitedBannerActionZhHant._(
      TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get app_settings => '應用程式設定';
  @override
  String get recheck => '重新檢查';
}

// Path: mini_translator.limited_banner.feedback
class _TranslationsMiniTranslatorLimitedBannerFeedbackZhHant
    extends TranslationsMiniTranslatorLimitedBannerFeedbackEn {
  _TranslationsMiniTranslatorLimitedBannerFeedbackZhHant._(
      TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get enabled => '螢幕取詞功能已啟用。';
  @override
  String get still_missing => '仍缺少所需權限。\n請檢查您的設定後再試。';
}

// Path: mini_translator.limited_banner.tooltip
class _TranslationsMiniTranslatorLimitedBannerTooltipZhHant
    extends TranslationsMiniTranslatorLimitedBannerTooltipEn {
  _TranslationsMiniTranslatorLimitedBannerTooltipZhHant._(
      TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get help => '檢視說明';
}

// Path: mini_translator.toolbar.tooltip
class _TranslationsMiniTranslatorToolbarTooltipZhHant
    extends TranslationsMiniTranslatorToolbarTooltipEn {
  _TranslationsMiniTranslatorToolbarTooltipZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get extract_text_from_screen_capture => '擷取螢幕區域並辨識文字';
  @override
  String get extract_text_from_clipboard => '讀取剪貼簿內容';
}

// Path: settings.general.section
class _TranslationsSettingsGeneralSectionZhHant
    extends TranslationsSettingsGeneralSectionEn {
  _TranslationsSettingsGeneralSectionZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get permissions => '權限';
  @override
  String get ocr => '文字辨識';
  @override
  String get directory => '辭典';
  @override
  String get translation => '翻譯';
  @override
  String get translation_target => '翻譯目標';
  @override
  String get languages => '語言';
  @override
  String get input => '輸入設定';
}

// Path: settings.general.row
class _TranslationsSettingsGeneralRowZhHant
    extends TranslationsSettingsGeneralRowEn {
  _TranslationsSettingsGeneralRowZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get launch_at_login => '登入時啟動';
  @override
  String get show_in_menu_bar => '在選單列中顯示';
  @override
  String get screen_capture_access => '授予螢幕錄製權限';
  @override
  String get screen_selection_access => '授予輔助功能權限';
  @override
  String get default_ocr_service => '預設文字辨識服務';
  @override
  String get auto_copy_detected_text => '自動複製偵測到的文字';
  @override
  String get default_directory_service => '預設辭典服務';
  @override
  String get default_translation_service => '預設翻譯服務';
  @override
  String get translation_target_hint => '設定翻譯器使用的語言目標。';
  @override
  String get common_languages => '常用語言';
  @override
  String get common_languages_description => '顯示在語言選擇列表頂部。';
  @override
  String get common_languages_hint => '選擇你常用的語言：';
  @override
  String get common_languages_sort => '按代碼排序';
  @override
  String get common_languages_reset => '恢復預設';
  @override
  String get common_languages_reset_help => '恢復為預設的常用語言集合';
  @override
  String get common_languages_search => '搜索語言...';
  @override
  String get common_languages_all => '所有語言';
  @override
  String get double_click_copy_result => '雙擊複製翻譯結果';
  @override
  String get submit_with_enter => '按 Enter 提交';
  @override
  String get submit_with_meta_enter_mac => '按 ⌘ + Enter 提交';
}

// Path: settings.general.button
class _TranslationsSettingsGeneralButtonZhHant
    extends TranslationsSettingsGeneralButtonEn {
  _TranslationsSettingsGeneralButtonZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get add_provider => '新增…';
  @override
  String get add_target => '新增目標...';
  @override
  String get manage_targets => '管理翻譯目標...';
  @override
  String get manage_languages => '管理常用語言...';
  @override
  String get grant => '授權';
}

// Path: settings.general.option
class _TranslationsSettingsGeneralOptionZhHant
    extends TranslationsSettingsGeneralOptionEn {
  _TranslationsSettingsGeneralOptionZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get none => '無';
  @override
  String get no_services_available => '暫無可用服務';
  @override
  String get granted => '已授權';
  @override
  String get built_in_ocr => '內建 OCR';
  @override
  String get tesseract => 'Tesseract';
  @override
  String get youdao_ocr => '有道 OCR';
}

// Path: settings.general.editor
class _TranslationsSettingsGeneralEditorZhHant
    extends TranslationsSettingsGeneralEditorEn {
  _TranslationsSettingsGeneralEditorZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get add_target_title => '添加翻譯目標：';
  @override
  String get edit_target_title => '修改翻譯目標：';
  @override
  late final _TranslationsSettingsGeneralEditorRowZhHant row =
      _TranslationsSettingsGeneralEditorRowZhHant._(_root);
}

// Path: settings.appearance.section
class _TranslationsSettingsAppearanceSectionZhHant
    extends TranslationsSettingsAppearanceSectionEn {
  _TranslationsSettingsAppearanceSectionZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get app_language => '顯示語言';
  @override
  String get theme_mode => '主題模式';
}

// Path: settings.shortcuts.section
class _TranslationsSettingsShortcutsSectionZhHant
    extends TranslationsSettingsShortcutsSectionEn {
  _TranslationsSettingsShortcutsSectionZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get text_extraction => '文字擷取';
  @override
  String get input_assist => '輸入輔助功能';
}

// Path: settings.shortcuts.row
class _TranslationsSettingsShortcutsRowZhHant
    extends TranslationsSettingsShortcutsRowEn {
  _TranslationsSettingsShortcutsRowZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get toggle_mini_translator => '顯示/隱藏視窗';
  @override
  String get extract_text_from_screen_selection => '從螢幕選取範圍擷取文字';
  @override
  String get extract_text_from_screen_capture => '從螢幕截圖擷取文字';
  @override
  String get extract_text_from_clipboard => '從剪貼簿擷取文字';
  @override
  String get translate_input => '翻譯輸入內容';
}

// Path: settings.shortcuts.reset_dialog
class _TranslationsSettingsShortcutsResetDialogZhHant
    extends TranslationsSettingsShortcutsResetDialogEn {
  _TranslationsSettingsShortcutsResetDialogZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get title => '重設快捷鍵';
  @override
  String get message => '確定要重設所有快捷鍵為預設值嗎？';
  @override
  String get confirm => '重設';
  @override
  String get cancel => '取消';
}

// Path: settings.services.button
class _TranslationsSettingsServicesButtonZhHant
    extends TranslationsSettingsServicesButtonEn {
  _TranslationsSettingsServicesButtonZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get add_service => '新增服務...';
}

// Path: settings.services.section
class _TranslationsSettingsServicesSectionZhHant
    extends TranslationsSettingsServicesSectionEn {
  _TranslationsSettingsServicesSectionZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get available_services => '可用服務';
}

// Path: settings.services.editor
class _TranslationsSettingsServicesEditorZhHant
    extends TranslationsSettingsServicesEditorEn {
  _TranslationsSettingsServicesEditorZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get coming_soon => '🚧 即將推出';
  @override
  String get coming_soon_description => '服務配置尚不可用。您可以在提供者標籤頁中管理服務提供者。';
}

// Path: settings.providers.section
class _TranslationsSettingsProvidersSectionZhHant
    extends TranslationsSettingsProvidersSectionEn {
  _TranslationsSettingsProvidersSectionZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get services => '可用服務';
  @override
  String get services_description => '查看已設定提供商的可用服務，並依服務類型切換。';
}

// Path: settings.providers.item
class _TranslationsSettingsProvidersItemZhHant
    extends TranslationsSettingsProvidersItemEn {
  _TranslationsSettingsProvidersItemZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get empty => '尚未設定任何提供者。新增一個提供者以啟用翻譯服務。';
  @override
  String get loading => '正在載入提供者…';
  @override
  String get no_services => '暫無可用服務。';
}

// Path: settings.providers.button
class _TranslationsSettingsProvidersButtonZhHant
    extends TranslationsSettingsProvidersButtonEn {
  _TranslationsSettingsProvidersButtonZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get add => '新增提供者…';
}

// Path: settings.providers.alert
class _TranslationsSettingsProvidersAlertZhHant
    extends TranslationsSettingsProvidersAlertEn {
  _TranslationsSettingsProvidersAlertZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get error => '錯誤';
}

// Path: settings.providers.intro
class _TranslationsSettingsProvidersIntroZhHant
    extends TranslationsSettingsProvidersIntroEn {
  _TranslationsSettingsProvidersIntroZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get body => '管理應用程式使用的服務提供商。';
  @override
  String get warning => '已連線的提供商可能會處理您傳送的文字或圖片，請僅啟用您信任的服務。';
}

// Path: settings.providers.editor
class _TranslationsSettingsProvidersEditorZhHant
    extends TranslationsSettingsProvidersEditorEn {
  _TranslationsSettingsProvidersEditorZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsSettingsProvidersEditorRowZhHant row =
      _TranslationsSettingsProvidersEditorRowZhHant._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorPlaceholderZhHant placeholder =
      _TranslationsSettingsProvidersEditorPlaceholderZhHant._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorTypePickerZhHant type_picker =
      _TranslationsSettingsProvidersEditorTypePickerZhHant._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorTooltipZhHant tooltip =
      _TranslationsSettingsProvidersEditorTooltipZhHant._(_root);
}

// Path: settings.providers.detail
class _TranslationsSettingsProvidersDetailZhHant
    extends TranslationsSettingsProvidersDetailEn {
  _TranslationsSettingsProvidersDetailZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsSettingsProvidersDetailTooltipZhHant tooltip =
      _TranslationsSettingsProvidersDetailTooltipZhHant._(_root);
  @override
  late final _TranslationsSettingsProvidersDetailSectionZhHant section =
      _TranslationsSettingsProvidersDetailSectionZhHant._(_root);
  @override
  late final _TranslationsSettingsProvidersDetailModelsZhHant models =
      _TranslationsSettingsProvidersDetailModelsZhHant._(_root);
}

// Path: settings.providers.capability
class _TranslationsSettingsProvidersCapabilityZhHant
    extends TranslationsSettingsProvidersCapabilityEn {
  _TranslationsSettingsProvidersCapabilityZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get translation => '翻譯';
  @override
  String get dictionary => '辭典';
  @override
  String get ocr => 'OCR';
}

// Path: settings.providers.description
class _TranslationsSettingsProvidersDescriptionZhHant
    extends TranslationsSettingsProvidersDescriptionEn {
  _TranslationsSettingsProvidersDescriptionZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get all => '提供辭典查詢和文字翻譯';
  @override
  String get translation => '提供語言間文字翻譯';
  @override
  String get dictionary => '提供辭典查詢和單字釋義';
  @override
  String get fallback => '提供翻譯服務';
}

// Path: settings.providers.delete_dialog
class _TranslationsSettingsProvidersDeleteDialogZhHant
    extends TranslationsSettingsProvidersDeleteDialogEn {
  _TranslationsSettingsProvidersDeleteDialogZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get title => '刪除「{}」？';
  @override
  String get message => '此操作無法復原。';
}

// Path: settings.layout.empty
class _TranslationsSettingsLayoutEmptyZhHant
    extends TranslationsSettingsLayoutEmptyEn {
  _TranslationsSettingsLayoutEmptyZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get title => '選擇一個分類';
  @override
  String get message => '從側邊欄選擇一個設定分類。';
}

// Path: app.tray.context_menu.dev_tools
class _TranslationsAppTrayContextMenuDevToolsZhHant
    extends TranslationsAppTrayContextMenuDevToolsEn {
  _TranslationsAppTrayContextMenuDevToolsZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get title => '開發工具';
  @override
  String get open_data_directory => '開啟資料目錄';
  @override
  String get use_native_settings => '使用原生設定頁面';
}

// Path: settings.general.editor.row
class _TranslationsSettingsGeneralEditorRowZhHant
    extends TranslationsSettingsGeneralEditorRowEn {
  _TranslationsSettingsGeneralEditorRowZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get source_language => '源語言';
  @override
  String get target_language => '目標語言';
}

// Path: settings.providers.editor.row
class _TranslationsSettingsProvidersEditorRowZhHant
    extends TranslationsSettingsProvidersEditorRowEn {
  _TranslationsSettingsProvidersEditorRowZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get id => '提供者 ID';
}

// Path: settings.providers.editor.placeholder
class _TranslationsSettingsProvidersEditorPlaceholderZhHant
    extends TranslationsSettingsProvidersEditorPlaceholderEn {
  _TranslationsSettingsProvidersEditorPlaceholderZhHant._(
      TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get id => '例如 deepl-main';
}

// Path: settings.providers.editor.type_picker
class _TranslationsSettingsProvidersEditorTypePickerZhHant
    extends TranslationsSettingsProvidersEditorTypePickerEn {
  _TranslationsSettingsProvidersEditorTypePickerZhHant._(
      TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get prompt => '請選擇要新增的提供者類型：';
  @override
  String get section_llm => 'LLM';
  @override
  String get section_traditional => '傳統';
}

// Path: settings.providers.editor.tooltip
class _TranslationsSettingsProvidersEditorTooltipZhHant
    extends TranslationsSettingsProvidersEditorTooltipEn {
  _TranslationsSettingsProvidersEditorTooltipZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get help => '說明';
}

// Path: settings.providers.detail.tooltip
class _TranslationsSettingsProvidersDetailTooltipZhHant
    extends TranslationsSettingsProvidersDetailTooltipEn {
  _TranslationsSettingsProvidersDetailTooltipZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get edit => '編輯提供者';
}

// Path: settings.providers.detail.section
class _TranslationsSettingsProvidersDetailSectionZhHant
    extends TranslationsSettingsProvidersDetailSectionEn {
  _TranslationsSettingsProvidersDetailSectionZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get configuration => '配置';
  @override
  String get models => '模型';
}

// Path: settings.providers.detail.models
class _TranslationsSettingsProvidersDetailModelsZhHant
    extends TranslationsSettingsProvidersDetailModelsEn {
  _TranslationsSettingsProvidersDetailModelsZhHant._(TranslationsZhHant root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHant _root; // ignore: unused_field

  // Translations
  @override
  String get loading => '正在載入模型...';
  @override
  String get empty => '找不到模型。';
  @override
  String get retry => '重試';
  @override
  String get add => '新增模型…';
  @override
  String get add_title => '新增模型';
  @override
  String get add_placeholder => '例如：gpt-4o';
  @override
  String get default_badge => '預設';
  @override
  String get fetch_error => '無法從提供者 API 取得模型。';
}

/// The flat map containing all translations for locale <zh-Hant>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsZhHant {
  dynamic _flatMapFunction(String path) {
    return switch (path) {
      'common.ui.button.ok' => '確定',
      'common.ui.button.cancel' => '取消',
      'common.ui.button.add' => '新增',
      'common.ui.button.delete' => '刪除',
      'common.ui.button.edit' => '編輯',
      'common.ui.button.save' => '儲存',
      'common.ui.button.manage' => '管理',
      'common.ui.button.kContinue' => '繼續',
      'common.ui.feedback.copied' => '已複製',
      'common.language.ar' => '阿拉伯語',
      'common.language.bn' => '孟加拉語',
      'common.language.de' => '德語',
      'common.language.en' => '英語',
      'common.language.es' => '西班牙語',
      'common.language.fa' => '波斯語',
      'common.language.fr' => '法語',
      'common.language.gu' => '古吉拉特語',
      'common.language.ha' => '豪薩語',
      'common.language.hi' => '印地語',
      'common.language.id' => '印尼語',
      'common.language.it' => '義大利語',
      'common.language.ja' => '日語',
      'common.language.jv' => '爪哇語',
      'common.language.ko' => '韓語',
      'common.language.ml' => '馬拉雅拉姆語',
      'common.language.mr' => '馬拉地語',
      'common.language.ms' => '馬來語',
      'common.language.nl' => '荷蘭語',
      'common.language.pa' => '旁遮普語',
      'common.language.pl' => '波蘭語',
      'common.language.pt' => '葡萄牙語',
      'common.language.ro' => '羅馬尼亞語',
      'common.language.ru' => '俄語',
      'common.language.sw' => '斯瓦希里語',
      'common.language.ta' => '泰米爾語',
      'common.language.te' => '泰盧固語',
      'common.language.th' => '泰語',
      'common.language.tr' => '土耳其語',
      'common.language.uk' => '烏克蘭語',
      'common.language.ur' => '烏爾都語',
      'common.language.vi' => '越南語',
      'common.language.yo' => '約魯巴語',
      'common.language.zh_hans' => '中文（簡體）',
      'common.language.zh_hant' => '中文（繁體）',
      'common.theme_mode.light' => '淺色',
      'common.theme_mode.dark' => '深色',
      'common.theme_mode.system' => '跟隨系統',
      'common.provider.anthropic' => 'Anthropic',
      'common.provider.baidu' => '百度',
      'common.provider.caiyun' => '彩雲小譯',
      'common.provider.deepl' => 'DeepL',
      'common.provider.google' => '谷歌',
      'common.provider.iciba' => '愛詞霸',
      'common.provider.ollama' => 'Ollama',
      'common.provider.openai' => 'OpenAI',
      'common.provider.sogou' => '搜狗',
      'common.provider.system' => '系統',
      'common.provider.tencent' => '騰訊',
      'common.provider.youdao' => '有道',
      'common.word_pronunciation.us' => '美',
      'common.word_pronunciation.uk' => '英',
      'app.tray.context_menu.show_window' => '顯示視窗',
      'app.tray.context_menu.dev_tools.title' => '開發工具',
      'app.tray.context_menu.dev_tools.open_data_directory' => '開啟資料目錄',
      'app.tray.context_menu.dev_tools.use_native_settings' => '使用原生設定頁面',
      'app.tray.context_menu.check_for_updates' => '檢查更新',
      'app.tray.context_menu.settings' => '設定',
      'app.tray.context_menu.quit' => '結束',
      'mini_translator.limited_banner.permission.missing_both' =>
        '請授予螢幕錄製和輔助功能權限以啟用完整功能。',
      'mini_translator.limited_banner.permission.missing_screen_capture' =>
        '請授予螢幕錄製權限以啟用完整功能。',
      'mini_translator.limited_banner.permission.missing_accessibility' =>
        '請授予輔助功能權限以啟用完整功能。',
      'mini_translator.limited_banner.instruction.app_settings_prefix' => '請前往',
      'mini_translator.limited_banner.instruction.follow_guide_prefix' =>
        '，依指引授權後點選',
      'mini_translator.limited_banner.instruction.suffix' => '。',
      'mini_translator.limited_banner.action.app_settings' => '應用程式設定',
      'mini_translator.limited_banner.action.recheck' => '重新檢查',
      'mini_translator.limited_banner.feedback.enabled' => '螢幕取詞功能已啟用。',
      'mini_translator.limited_banner.feedback.still_missing' =>
        '仍缺少所需權限。\n請檢查您的設定後再試。',
      'mini_translator.limited_banner.tooltip.help' => '檢視說明',
      'mini_translator.input.hint' => '在此輸入單字或文字',
      'mini_translator.input.extracting_text' => '正在辨識文字…',
      'mini_translator.toolbar.tooltip.extract_text_from_screen_capture' =>
        '擷取螢幕區域並辨識文字',
      'mini_translator.toolbar.tooltip.extract_text_from_clipboard' =>
        '讀取剪貼簿內容',
      'mini_translator.button.clear' => '清除',
      'mini_translator.button.translate' => '翻譯',
      'mini_translator.language.auto_detect' => '自動偵測',
      'mini_translator.language.auto_match' => '自動匹配',
      'mini_translator.language.switch_config' => '切換目標',
      'mini_translator.language.more_languages' => '更多語言...',
      'mini_translator.language.manage_common_languages' => '管理常用語言...',
      'mini_translator.language.manage_targets' => '管理翻譯目標...',
      'mini_translator.language.add_target' => '添加翻譯目標...',
      'mini_translator.message.please_enter_word_or_text' => '未輸入或未擷取到文字',
      'mini_translator.message.capture_screen_area_canceled' => '螢幕區域擷取已取消',
      'mini_translator.message.ocr_service_not_configured' =>
        '未配置預設文字辨識服務，請在設定中配置。',
      'mini_translator.message.ocr_recognition_failed' => '文字辨識失敗',
      'settings.version' => 'v{} (Build {})',
      'settings.general.title' => '一般',
      'settings.general.section.permissions' => '權限',
      'settings.general.section.ocr' => '文字辨識',
      'settings.general.section.directory' => '辭典',
      'settings.general.section.translation' => '翻譯',
      'settings.general.section.translation_target' => '翻譯目標',
      'settings.general.section.languages' => '語言',
      'settings.general.section.input' => '輸入設定',
      'settings.general.row.launch_at_login' => '登入時啟動',
      'settings.general.row.show_in_menu_bar' => '在選單列中顯示',
      'settings.general.row.screen_capture_access' => '授予螢幕錄製權限',
      'settings.general.row.screen_selection_access' => '授予輔助功能權限',
      'settings.general.row.default_ocr_service' => '預設文字辨識服務',
      'settings.general.row.auto_copy_detected_text' => '自動複製偵測到的文字',
      'settings.general.row.default_directory_service' => '預設辭典服務',
      'settings.general.row.default_translation_service' => '預設翻譯服務',
      'settings.general.row.translation_target_hint' => '設定翻譯器使用的語言目標。',
      'settings.general.row.common_languages' => '常用語言',
      'settings.general.row.common_languages_description' => '顯示在語言選擇列表頂部。',
      'settings.general.row.common_languages_hint' => '選擇你常用的語言：',
      'settings.general.row.common_languages_sort' => '按代碼排序',
      'settings.general.row.common_languages_reset' => '恢復預設',
      'settings.general.row.common_languages_reset_help' => '恢復為預設的常用語言集合',
      'settings.general.row.common_languages_search' => '搜索語言...',
      'settings.general.row.common_languages_all' => '所有語言',
      'settings.general.row.double_click_copy_result' => '雙擊複製翻譯結果',
      'settings.general.row.submit_with_enter' => '按 Enter 提交',
      'settings.general.row.submit_with_meta_enter_mac' => '按 ⌘ + Enter 提交',
      'settings.general.button.add_provider' => '新增…',
      'settings.general.button.add_target' => '新增目標...',
      'settings.general.button.manage_targets' => '管理翻譯目標...',
      'settings.general.button.manage_languages' => '管理常用語言...',
      'settings.general.button.grant' => '授權',
      'settings.general.option.none' => '無',
      'settings.general.option.no_services_available' => '暫無可用服務',
      'settings.general.option.granted' => '已授權',
      'settings.general.option.built_in_ocr' => '內建 OCR',
      'settings.general.option.tesseract' => 'Tesseract',
      'settings.general.option.youdao_ocr' => '有道 OCR',
      'settings.general.editor.add_target_title' => '添加翻譯目標：',
      'settings.general.editor.edit_target_title' => '修改翻譯目標：',
      'settings.general.editor.row.source_language' => '源語言',
      'settings.general.editor.row.target_language' => '目標語言',
      'settings.appearance.title' => '外觀',
      'settings.appearance.section.app_language' => '顯示語言',
      'settings.appearance.section.theme_mode' => '主題模式',
      'settings.shortcuts.title' => '快捷鍵',
      'settings.shortcuts.section.text_extraction' => '文字擷取',
      'settings.shortcuts.section.input_assist' => '輸入輔助功能',
      'settings.shortcuts.row.toggle_mini_translator' => '顯示/隱藏視窗',
      'settings.shortcuts.row.extract_text_from_screen_selection' =>
        '從螢幕選取範圍擷取文字',
      'settings.shortcuts.row.extract_text_from_screen_capture' => '從螢幕截圖擷取文字',
      'settings.shortcuts.row.extract_text_from_clipboard' => '從剪貼簿擷取文字',
      'settings.shortcuts.row.translate_input' => '翻譯輸入內容',
      'settings.shortcuts.reset_dialog.title' => '重設快捷鍵',
      'settings.shortcuts.reset_dialog.message' => '確定要重設所有快捷鍵為預設值嗎？',
      'settings.shortcuts.reset_dialog.confirm' => '重設',
      'settings.shortcuts.reset_dialog.cancel' => '取消',
      'settings.advanced.title' => '進階',
      'settings.advanced.api_server' => '本機 API 服務',
      'settings.advanced.api_server_description' =>
        '在 127.0.0.1 上開放翻譯 API，供本機整合使用。',
      'settings.advanced.enable' => '啟用',
      'settings.advanced.port' => '埠號',
      'settings.advanced.running_at' => '執行於 {url}',
      'settings.advanced.disabled' => '已關閉',
      'settings.services.title' => '服務',
      'settings.services.button.add_service' => '新增服務...',
      'settings.services.section.available_services' => '可用服務',
      'settings.services.editor.coming_soon' => '🚧 即將推出',
      'settings.services.editor.coming_soon_description' =>
        '服務配置尚不可用。您可以在提供者標籤頁中管理服務提供者。',
      'settings.providers.title' => '提供者',
      'settings.providers.section.services' => '可用服務',
      'settings.providers.section.services_description' =>
        '查看已設定提供商的可用服務，並依服務類型切換。',
      'settings.providers.item.empty' => '尚未設定任何提供者。新增一個提供者以啟用翻譯服務。',
      'settings.providers.item.loading' => '正在載入提供者…',
      'settings.providers.item.no_services' => '暫無可用服務。',
      'settings.providers.button.add' => '新增提供者…',
      'settings.providers.alert.error' => '錯誤',
      'settings.providers.intro.body' => '管理應用程式使用的服務提供商。',
      'settings.providers.intro.warning' => '已連線的提供商可能會處理您傳送的文字或圖片，請僅啟用您信任的服務。',
      'settings.providers.editor.row.id' => '提供者 ID',
      'settings.providers.editor.placeholder.id' => '例如 deepl-main',
      'settings.providers.editor.type_picker.prompt' => '請選擇要新增的提供者類型：',
      'settings.providers.editor.type_picker.section_llm' => 'LLM',
      'settings.providers.editor.type_picker.section_traditional' => '傳統',
      'settings.providers.editor.tooltip.help' => '說明',
      'settings.providers.detail.tooltip.edit' => '編輯提供者',
      'settings.providers.detail.section.configuration' => '配置',
      'settings.providers.detail.section.models' => '模型',
      'settings.providers.detail.models.loading' => '正在載入模型...',
      'settings.providers.detail.models.empty' => '找不到模型。',
      'settings.providers.detail.models.retry' => '重試',
      'settings.providers.detail.models.add' => '新增模型…',
      'settings.providers.detail.models.add_title' => '新增模型',
      'settings.providers.detail.models.add_placeholder' => '例如：gpt-4o',
      'settings.providers.detail.models.default_badge' => '預設',
      'settings.providers.detail.models.fetch_error' => '無法從提供者 API 取得模型。',
      'settings.providers.capability.translation' => '翻譯',
      'settings.providers.capability.dictionary' => '辭典',
      'settings.providers.capability.ocr' => 'OCR',
      'settings.providers.description.all' => '提供辭典查詢和文字翻譯',
      'settings.providers.description.translation' => '提供語言間文字翻譯',
      'settings.providers.description.dictionary' => '提供辭典查詢和單字釋義',
      'settings.providers.description.fallback' => '提供翻譯服務',
      'settings.providers.delete_dialog.title' => '刪除「{}」？',
      'settings.providers.delete_dialog.message' => '此操作無法復原。',
      'settings.layout.title' => '設定',
      'settings.layout.empty.title' => '選擇一個分類',
      'settings.layout.empty.message' => '從側邊欄選擇一個設定分類。',
      'settings.about.title' => '關於',
      'settings.about.copy_version_info' => '複製版本資訊',
      'settings.about.up_to_date' => '已是最新版本。',
      'settings.about.check_again' => '重新檢查',
      'settings.about.links' => '連結',
      'settings.about.website' => '網站',
      'settings.about.github' => 'GitHub',
      'settings.about.report_issue' => '回報問題',
      'settings.about.license' => '授權條款',
      'settings.about.open_changelog' => '查看更新日誌',
      _ => null,
    };
  }
}
