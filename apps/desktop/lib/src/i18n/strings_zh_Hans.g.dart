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
class TranslationsZhHans extends Translations
    with BaseTranslations<AppLocale, Translations> {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsZhHans(
      {Map<String, Node>? overrides,
      PluralResolver? cardinalResolver,
      PluralResolver? ordinalResolver,
      TranslationMetadata<AppLocale, Translations>? meta})
      : assert(overrides == null,
            'Set "translation_overrides: true" in order to enable this feature.'),
        $meta = meta ??
            TranslationMetadata(
              locale: AppLocale.zhHans,
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

  /// Metadata for the translations of <zh-Hans>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  /// Access flat map
  @override
  dynamic operator [](String key) =>
      $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

  late final TranslationsZhHans _root = this; // ignore: unused_field

  @override
  TranslationsZhHans $copyWith(
          {TranslationMetadata<AppLocale, Translations>? meta}) =>
      TranslationsZhHans(meta: meta ?? this.$meta);

  // Translations
  @override
  late final _TranslationsCommonZhHans common =
      _TranslationsCommonZhHans._(_root);
  @override
  late final _TranslationsProviderZhHans provider =
      _TranslationsProviderZhHans._(_root);
  @override
  late final _TranslationsTranslationZhHans translation =
      _TranslationsTranslationZhHans._(_root);
  @override
  late final _TranslationsOcrZhHans ocr = _TranslationsOcrZhHans._(_root);
  @override
  late final _TranslationsThemeZhHans theme = _TranslationsThemeZhHans._(_root);
  @override
  late final _TranslationsTrayZhHans tray = _TranslationsTrayZhHans._(_root);
  @override
  late final _TranslationsMiniTranslatorZhHans mini_translator =
      _TranslationsMiniTranslatorZhHans._(_root);
  @override
  late final _TranslationsSettingsZhHans settings =
      _TranslationsSettingsZhHans._(_root);
  @override
  late final _TranslationsShortcutsZhHans shortcuts =
      _TranslationsShortcutsZhHans._(_root);
}

// Path: common
class _TranslationsCommonZhHans extends TranslationsCommonEn {
  _TranslationsCommonZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsCommonAppZhHans app =
      _TranslationsCommonAppZhHans._(_root);
  @override
  late final _TranslationsCommonButtonZhHans button =
      _TranslationsCommonButtonZhHans._(_root);
  @override
  late final _TranslationsCommonFeedbackZhHans feedback =
      _TranslationsCommonFeedbackZhHans._(_root);
  @override
  late final _TranslationsCommonPlaceholderZhHans placeholder =
      _TranslationsCommonPlaceholderZhHans._(_root);
  @override
  late final _TranslationsCommonLanguageZhHans language =
      _TranslationsCommonLanguageZhHans._(_root);
}

// Path: provider
class _TranslationsProviderZhHans extends TranslationsProviderEn {
  _TranslationsProviderZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get baidu => '百度';
  @override
  String get caiyun => '彩云小译';
  @override
  String get deepl => 'DeepL';
  @override
  String get google => '谷歌';
  @override
  String get iciba => '爱词霸';
  @override
  String get sogou => '搜狗';
  @override
  String get system => '系统';
  @override
  String get tencent => '腾讯';
  @override
  String get youdao => '有道';
}

// Path: translation
class _TranslationsTranslationZhHans extends TranslationsTranslationEn {
  _TranslationsTranslationZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsTranslationEngineScopeZhHans engine_scope =
      _TranslationsTranslationEngineScopeZhHans._(_root);
  @override
  late final _TranslationsTranslationModeZhHans mode =
      _TranslationsTranslationModeZhHans._(_root);
  @override
  late final _TranslationsTranslationWordPronunciationZhHans
      word_pronunciation =
      _TranslationsTranslationWordPronunciationZhHans._(_root);
}

// Path: ocr
class _TranslationsOcrZhHans extends TranslationsOcrEn {
  _TranslationsOcrZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsOcrEngineZhHans engine =
      _TranslationsOcrEngineZhHans._(_root);
}

// Path: theme
class _TranslationsThemeZhHans extends TranslationsThemeEn {
  _TranslationsThemeZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsThemeModeZhHans mode =
      _TranslationsThemeModeZhHans._(_root);
}

// Path: tray
class _TranslationsTrayZhHans extends TranslationsTrayEn {
  _TranslationsTrayZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsTrayContextMenuZhHans context_menu =
      _TranslationsTrayContextMenuZhHans._(_root);
}

// Path: mini_translator
class _TranslationsMiniTranslatorZhHans extends TranslationsMiniTranslatorEn {
  _TranslationsMiniTranslatorZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsMiniTranslatorUpdateBannerZhHans update_banner =
      _TranslationsMiniTranslatorUpdateBannerZhHans._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerZhHans limited_banner =
      _TranslationsMiniTranslatorLimitedBannerZhHans._(_root);
  @override
  late final _TranslationsMiniTranslatorInputZhHans input =
      _TranslationsMiniTranslatorInputZhHans._(_root);
  @override
  late final _TranslationsMiniTranslatorToolbarZhHans toolbar =
      _TranslationsMiniTranslatorToolbarZhHans._(_root);
  @override
  late final _TranslationsMiniTranslatorButtonZhHans button =
      _TranslationsMiniTranslatorButtonZhHans._(_root);
  @override
  late final _TranslationsMiniTranslatorMessageZhHans message =
      _TranslationsMiniTranslatorMessageZhHans._(_root);
}

// Path: settings
class _TranslationsSettingsZhHans extends TranslationsSettingsEn {
  _TranslationsSettingsZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get version => '版本 {} BUILD {}';
  @override
  late final _TranslationsSettingsGeneralZhHans general =
      _TranslationsSettingsGeneralZhHans._(_root);
  @override
  late final _TranslationsSettingsAppearanceZhHans appearance =
      _TranslationsSettingsAppearanceZhHans._(_root);
  @override
  late final _TranslationsSettingsShortcutsZhHans shortcuts =
      _TranslationsSettingsShortcutsZhHans._(_root);
  @override
  late final _TranslationsSettingsAdvancedZhHans advanced =
      _TranslationsSettingsAdvancedZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersZhHans providers =
      _TranslationsSettingsProvidersZhHans._(_root);
  @override
  late final _TranslationsSettingsLayoutZhHans layout =
      _TranslationsSettingsLayoutZhHans._(_root);
  @override
  String get title => '设置';
}

// Path: shortcuts
class _TranslationsShortcutsZhHans extends TranslationsShortcutsEn {
  _TranslationsShortcutsZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsShortcutsRecordDialogZhHans record_dialog =
      _TranslationsShortcutsRecordDialogZhHans._(_root);
}

// Path: common.app
class _TranslationsCommonAppZhHans extends TranslationsCommonAppEn {
  _TranslationsCommonAppZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get name => '比译';
}

// Path: common.button
class _TranslationsCommonButtonZhHans extends TranslationsCommonButtonEn {
  _TranslationsCommonButtonZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get ok => '确定';
  @override
  String get cancel => '取消';
  @override
  String get add => '添加';
  @override
  String get delete => '删除';
  @override
  String get edit => '编辑';
  @override
  String get save => '保存';
  @override
  String get manage => '管理';
  @override
  String get kContinue => '继续';
}

// Path: common.feedback
class _TranslationsCommonFeedbackZhHans extends TranslationsCommonFeedbackEn {
  _TranslationsCommonFeedbackZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get copied => '已复制';
}

// Path: common.placeholder
class _TranslationsCommonPlaceholderZhHans
    extends TranslationsCommonPlaceholderEn {
  _TranslationsCommonPlaceholderZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get choose => '请选择';
}

// Path: common.language
class _TranslationsCommonLanguageZhHans extends TranslationsCommonLanguageEn {
  _TranslationsCommonLanguageZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get ar => '阿拉伯语';
  @override
  String get bn => '孟加拉语';
  @override
  String get de => '德语';
  @override
  String get en => '英语';
  @override
  String get es => '西班牙语';
  @override
  String get fa => '波斯语';
  @override
  String get fr => '法语';
  @override
  String get gu => '古吉拉特语';
  @override
  String get ha => '豪萨语';
  @override
  String get hi => '印地语';
  @override
  String get id => '印尼语';
  @override
  String get it => '意大利语';
  @override
  String get ja => '日语';
  @override
  String get jv => '印尼爪哇语';
  @override
  String get ko => '韩语';
  @override
  String get ml => '马拉雅拉姆语';
  @override
  String get mr => '马拉地语';
  @override
  String get ms => '马来语';
  @override
  String get nl => '荷兰语';
  @override
  String get pa => '旁遮普语';
  @override
  String get pl => '波兰语';
  @override
  String get pt => '葡萄牙语';
  @override
  String get ro => '罗马尼亚语';
  @override
  String get ru => '俄语';
  @override
  String get sw => '斯瓦希里语';
  @override
  String get ta => '泰米尔语';
  @override
  String get te => '泰卢固语';
  @override
  String get th => '泰语';
  @override
  String get tr => '土耳其语';
  @override
  String get uk => '乌克兰语';
  @override
  String get ur => '乌尔都语';
  @override
  String get vi => '越南语';
  @override
  String get yo => '约鲁巴语';
  @override
  String get zh_Hans => '中文（简体）';
  @override
  String get zh_Hant => '中文（繁体）';
}

// Path: translation.engine_scope
class _TranslationsTranslationEngineScopeZhHans
    extends TranslationsTranslationEngineScopeEn {
  _TranslationsTranslationEngineScopeZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get detect_language => '语种识别';
  @override
  String get lookup => '查词';
  @override
  String get translate => '翻译';
}

// Path: translation.mode
class _TranslationsTranslationModeZhHans extends TranslationsTranslationModeEn {
  _TranslationsTranslationModeZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get auto => '自动';
  @override
  String get manual => '手动';
}

// Path: translation.word_pronunciation
class _TranslationsTranslationWordPronunciationZhHans
    extends TranslationsTranslationWordPronunciationEn {
  _TranslationsTranslationWordPronunciationZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get us => '美';
  @override
  String get uk => '英';
}

// Path: ocr.engine
class _TranslationsOcrEngineZhHans extends TranslationsOcrEngineEn {
  _TranslationsOcrEngineZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get built_in => '内置';
  @override
  String get tesseract => 'Tesseract OCR';
  @override
  String get youdao => '有道通用文字识别';
}

// Path: theme.mode
class _TranslationsThemeModeZhHans extends TranslationsThemeModeEn {
  _TranslationsThemeModeZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get light => '浅色';
  @override
  String get dark => '深色';
  @override
  String get system => '跟随系统';
}

// Path: tray.context_menu
class _TranslationsTrayContextMenuZhHans extends TranslationsTrayContextMenuEn {
  _TranslationsTrayContextMenuZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get show_window => '显示窗口';
  @override
  late final _TranslationsTrayContextMenuDevToolsZhHans dev_tools =
      _TranslationsTrayContextMenuDevToolsZhHans._(_root);
  @override
  String get check_for_updates => '检查更新';
  @override
  String get settings => '设置';
  @override
  String get quit => '退出';
}

// Path: mini_translator.update_banner
class _TranslationsMiniTranslatorUpdateBannerZhHans
    extends TranslationsMiniTranslatorUpdateBannerEn {
  _TranslationsMiniTranslatorUpdateBannerZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get found_new_version => '发现新版本：{}';
  @override
  late final _TranslationsMiniTranslatorUpdateBannerButtonZhHans button =
      _TranslationsMiniTranslatorUpdateBannerButtonZhHans._(_root);
}

// Path: mini_translator.limited_banner
class _TranslationsMiniTranslatorLimitedBannerZhHans
    extends TranslationsMiniTranslatorLimitedBannerEn {
  _TranslationsMiniTranslatorLimitedBannerZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsMiniTranslatorLimitedBannerPermissionZhHans
      permission =
      _TranslationsMiniTranslatorLimitedBannerPermissionZhHans._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerInstructionZhHans
      instruction =
      _TranslationsMiniTranslatorLimitedBannerInstructionZhHans._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerActionZhHans action =
      _TranslationsMiniTranslatorLimitedBannerActionZhHans._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerFeedbackZhHans feedback =
      _TranslationsMiniTranslatorLimitedBannerFeedbackZhHans._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerTooltipZhHans tooltip =
      _TranslationsMiniTranslatorLimitedBannerTooltipZhHans._(_root);
}

// Path: mini_translator.input
class _TranslationsMiniTranslatorInputZhHans
    extends TranslationsMiniTranslatorInputEn {
  _TranslationsMiniTranslatorInputZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get hint => '在此处输入单词或文本';
  @override
  String get extracting_text => '正在提取文字...';
}

// Path: mini_translator.toolbar
class _TranslationsMiniTranslatorToolbarZhHans
    extends TranslationsMiniTranslatorToolbarEn {
  _TranslationsMiniTranslatorToolbarZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsMiniTranslatorToolbarTooltipZhHans tooltip =
      _TranslationsMiniTranslatorToolbarTooltipZhHans._(_root);
}

// Path: mini_translator.button
class _TranslationsMiniTranslatorButtonZhHans
    extends TranslationsMiniTranslatorButtonEn {
  _TranslationsMiniTranslatorButtonZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get clear => '清空';
  @override
  String get translate => '翻译';
}

// Path: mini_translator.message
class _TranslationsMiniTranslatorMessageZhHans
    extends TranslationsMiniTranslatorMessageEn {
  _TranslationsMiniTranslatorMessageZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get please_enter_word_or_text => '未输入或未提取到文本';
  @override
  String get capture_screen_area_canceled => '截取屏幕区域已取消';
}

// Path: settings.general
class _TranslationsSettingsGeneralZhHans extends TranslationsSettingsGeneralEn {
  _TranslationsSettingsGeneralZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get title => '常规';
  @override
  late final _TranslationsSettingsGeneralSectionZhHans section =
      _TranslationsSettingsGeneralSectionZhHans._(_root);
  @override
  late final _TranslationsSettingsGeneralRowZhHans row =
      _TranslationsSettingsGeneralRowZhHans._(_root);
  @override
  late final _TranslationsSettingsGeneralButtonZhHans button =
      _TranslationsSettingsGeneralButtonZhHans._(_root);
  @override
  late final _TranslationsSettingsGeneralOptionZhHans option =
      _TranslationsSettingsGeneralOptionZhHans._(_root);
}

// Path: settings.appearance
class _TranslationsSettingsAppearanceZhHans
    extends TranslationsSettingsAppearanceEn {
  _TranslationsSettingsAppearanceZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get title => '外观';
  @override
  late final _TranslationsSettingsAppearanceSectionZhHans section =
      _TranslationsSettingsAppearanceSectionZhHans._(_root);
  @override
  late final _TranslationsSettingsAppearanceOptionZhHans option =
      _TranslationsSettingsAppearanceOptionZhHans._(_root);
}

// Path: settings.shortcuts
class _TranslationsSettingsShortcutsZhHans
    extends TranslationsSettingsShortcutsEn {
  _TranslationsSettingsShortcutsZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get title => '快捷键';
  @override
  late final _TranslationsSettingsShortcutsSectionZhHans section =
      _TranslationsSettingsShortcutsSectionZhHans._(_root);
  @override
  late final _TranslationsSettingsShortcutsRowZhHans row =
      _TranslationsSettingsShortcutsRowZhHans._(_root);
  @override
  late final _TranslationsSettingsShortcutsDialogZhHans dialog =
      _TranslationsSettingsShortcutsDialogZhHans._(_root);
}

// Path: settings.advanced
class _TranslationsSettingsAdvancedZhHans
    extends TranslationsSettingsAdvancedEn {
  _TranslationsSettingsAdvancedZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get title => '高级';
  @override
  String get api_server => '本地 API 服务';
  @override
  String get api_server_description => '在 127.0.0.1 上开放翻译 API，供本机集成使用。';
  @override
  String get enable => '启用';
  @override
  String get address => '地址';
  @override
  String get host => '主机';
  @override
  String get port => '端口';
  @override
  String get running_at => '运行于 {url}';
  @override
  String get disabled => '已关闭';
}

// Path: settings.providers
class _TranslationsSettingsProvidersZhHans
    extends TranslationsSettingsProvidersEn {
  _TranslationsSettingsProvidersZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get title => '提供商';
  @override
  late final _TranslationsSettingsProvidersSectionZhHans section =
      _TranslationsSettingsProvidersSectionZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersItemZhHans item =
      _TranslationsSettingsProvidersItemZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersButtonZhHans button =
      _TranslationsSettingsProvidersButtonZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersDialogZhHans dialog =
      _TranslationsSettingsProvidersDialogZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersAlertZhHans alert =
      _TranslationsSettingsProvidersAlertZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersIntroZhHans intro =
      _TranslationsSettingsProvidersIntroZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorZhHans editor =
      _TranslationsSettingsProvidersEditorZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersDetailZhHans detail =
      _TranslationsSettingsProvidersDetailZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersCapabilityZhHans capability =
      _TranslationsSettingsProvidersCapabilityZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersDescriptionZhHans description =
      _TranslationsSettingsProvidersDescriptionZhHans._(_root);
}

// Path: settings.layout
class _TranslationsSettingsLayoutZhHans extends TranslationsSettingsLayoutEn {
  _TranslationsSettingsLayoutZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get title => '设置';
  @override
  late final _TranslationsSettingsLayoutEmptyZhHans empty =
      _TranslationsSettingsLayoutEmptyZhHans._(_root);
}

// Path: shortcuts.record_dialog
class _TranslationsShortcutsRecordDialogZhHans
    extends TranslationsShortcutsRecordDialogEn {
  _TranslationsShortcutsRecordDialogZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get title => '自定义快捷键';
}

// Path: tray.context_menu.dev_tools
class _TranslationsTrayContextMenuDevToolsZhHans
    extends TranslationsTrayContextMenuDevToolsEn {
  _TranslationsTrayContextMenuDevToolsZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get title => '开发工具';
  @override
  String get open_data_directory => '打开数据目录';
  @override
  String get use_native_settings => '使用原生设置页面';
}

// Path: mini_translator.update_banner.button
class _TranslationsMiniTranslatorUpdateBannerButtonZhHans
    extends TranslationsMiniTranslatorUpdateBannerButtonEn {
  _TranslationsMiniTranslatorUpdateBannerButtonZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get update => '立即更新';
}

// Path: mini_translator.limited_banner.permission
class _TranslationsMiniTranslatorLimitedBannerPermissionZhHans
    extends TranslationsMiniTranslatorLimitedBannerPermissionEn {
  _TranslationsMiniTranslatorLimitedBannerPermissionZhHans._(
      TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get missing_both => '请授予屏幕录制和辅助功能权限以启用完整功能。';
  @override
  String get missing_screen_capture => '请授予屏幕录制权限以启用完整功能。';
  @override
  String get missing_accessibility => '请授予辅助功能权限以启用完整功能。';
}

// Path: mini_translator.limited_banner.instruction
class _TranslationsMiniTranslatorLimitedBannerInstructionZhHans
    extends TranslationsMiniTranslatorLimitedBannerInstructionEn {
  _TranslationsMiniTranslatorLimitedBannerInstructionZhHans._(
      TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get app_settings_prefix => '请前往';
  @override
  String get follow_guide_prefix => '，按指引授权后点击';
  @override
  String get suffix => '。';
}

// Path: mini_translator.limited_banner.action
class _TranslationsMiniTranslatorLimitedBannerActionZhHans
    extends TranslationsMiniTranslatorLimitedBannerActionEn {
  _TranslationsMiniTranslatorLimitedBannerActionZhHans._(
      TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get app_settings => '应用设置';
  @override
  String get recheck => '重新检查';
}

// Path: mini_translator.limited_banner.feedback
class _TranslationsMiniTranslatorLimitedBannerFeedbackZhHans
    extends TranslationsMiniTranslatorLimitedBannerFeedbackEn {
  _TranslationsMiniTranslatorLimitedBannerFeedbackZhHans._(
      TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get enabled => '屏幕取词功能已启用';
  @override
  String get still_missing => '仍缺少所需权限，\n请检查设置后重试。';
}

// Path: mini_translator.limited_banner.tooltip
class _TranslationsMiniTranslatorLimitedBannerTooltipZhHans
    extends TranslationsMiniTranslatorLimitedBannerTooltipEn {
  _TranslationsMiniTranslatorLimitedBannerTooltipZhHans._(
      TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get help => '查看帮助文档';
}

// Path: mini_translator.toolbar.tooltip
class _TranslationsMiniTranslatorToolbarTooltipZhHans
    extends TranslationsMiniTranslatorToolbarTooltipEn {
  _TranslationsMiniTranslatorToolbarTooltipZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get translation_mode => '当前翻译模式：{}';
  @override
  String get extract_text_from_screen_capture => '截取屏幕区域并识别文字';
  @override
  String get extract_text_from_clipboard => '读取剪切板内容';
}

// Path: settings.general.section
class _TranslationsSettingsGeneralSectionZhHans
    extends TranslationsSettingsGeneralSectionEn {
  _TranslationsSettingsGeneralSectionZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get permissions => '权限';
  @override
  String get ocr => '文字识别';
  @override
  String get directory => '词典';
  @override
  String get translation => '翻译';
  @override
  String get translation_target => '翻译目标';
  @override
  String get input => '输入设置';
}

// Path: settings.general.row
class _TranslationsSettingsGeneralRowZhHans
    extends TranslationsSettingsGeneralRowEn {
  _TranslationsSettingsGeneralRowZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get launch_at_startup => '登录时启动';
  @override
  String get show_in_menu_bar => '在菜单栏中显示';
  @override
  String get screen_capture_access => '授予屏幕录制权限';
  @override
  String get screen_selection_access => '授予辅助功能权限';
  @override
  String get default_ocr_service => '默认文字识别服务';
  @override
  String get auto_copy_detected_text => '自动复制识别文本';
  @override
  String get default_directory_service => '默认词典服务';
  @override
  String get default_translation_service => '默认翻译服务';
  @override
  String get translation_mode => '翻译模式';
  @override
  String get double_click_copy_result => '双击复制翻译结果';
  @override
  String get submit_with_enter => '用 Enter 提交';
  @override
  String get submit_with_meta_enter_mac => '用 ⌘ + Enter 提交';
}

// Path: settings.general.button
class _TranslationsSettingsGeneralButtonZhHans
    extends TranslationsSettingsGeneralButtonEn {
  _TranslationsSettingsGeneralButtonZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get add_provider => '添加...';
  @override
  String get add_target => '添加目标';
  @override
  String get grant => '授权';
}

// Path: settings.general.option
class _TranslationsSettingsGeneralOptionZhHans
    extends TranslationsSettingsGeneralOptionEn {
  _TranslationsSettingsGeneralOptionZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get none => '无';
  @override
  String get no_services_available => '暂无可用服务';
  @override
  String get granted => '已授权';
  @override
  String get built_in_ocr => '内置 OCR';
  @override
  String get tesseract => 'Tesseract';
  @override
  String get youdao_ocr => '有道 OCR';
}

// Path: settings.appearance.section
class _TranslationsSettingsAppearanceSectionZhHans
    extends TranslationsSettingsAppearanceSectionEn {
  _TranslationsSettingsAppearanceSectionZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get app_language => '显示语言';
  @override
  String get theme_mode => '主题模式';
}

// Path: settings.appearance.option
class _TranslationsSettingsAppearanceOptionZhHans
    extends TranslationsSettingsAppearanceOptionEn {
  _TranslationsSettingsAppearanceOptionZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get english => '英语';
  @override
  String get chinese => '中文';
}

// Path: settings.shortcuts.section
class _TranslationsSettingsShortcutsSectionZhHans
    extends TranslationsSettingsShortcutsSectionEn {
  _TranslationsSettingsShortcutsSectionZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get shortcuts => '快捷键';
  @override
  String get text_extraction => '文字提取';
  @override
  String get input_assist => '输入辅助功能';
}

// Path: settings.shortcuts.row
class _TranslationsSettingsShortcutsRowZhHans
    extends TranslationsSettingsShortcutsRowEn {
  _TranslationsSettingsShortcutsRowZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get toggle_mini_translator => '显示/隐藏窗口';
  @override
  String get extract_text_from_screen_selection => '从屏幕选区提取文字';
  @override
  String get extract_text_from_screen_capture => '从屏幕截图提取文字';
  @override
  String get extract_text_from_clipboard => '从剪贴板提取文字';
  @override
  String get translate_input => '翻译输入内容';
}

// Path: settings.shortcuts.dialog
class _TranslationsSettingsShortcutsDialogZhHans
    extends TranslationsSettingsShortcutsDialogEn {
  _TranslationsSettingsShortcutsDialogZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get reset_title => '重置快捷键';
  @override
  String get reset_message => '确定要重置所有快捷键为默认值吗？';
  @override
  String get reset_confirm => '重置';
  @override
  String get reset_cancel => '取消';
}

// Path: settings.providers.section
class _TranslationsSettingsProvidersSectionZhHans
    extends TranslationsSettingsProvidersSectionEn {
  _TranslationsSettingsProvidersSectionZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get services => '服务';
}

// Path: settings.providers.item
class _TranslationsSettingsProvidersItemZhHans
    extends TranslationsSettingsProvidersItemEn {
  _TranslationsSettingsProvidersItemZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get empty => '暂无已配置的提供商。添加一个提供商以启用翻译服务。';
  @override
  String get loading => '正在加载提供商...';
  @override
  String get no_services => '暂无可用服务。';
}

// Path: settings.providers.button
class _TranslationsSettingsProvidersButtonZhHans
    extends TranslationsSettingsProvidersButtonEn {
  _TranslationsSettingsProvidersButtonZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get add => '添加提供商...';
}

// Path: settings.providers.dialog
class _TranslationsSettingsProvidersDialogZhHans
    extends TranslationsSettingsProvidersDialogEn {
  _TranslationsSettingsProvidersDialogZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get delete_title => '删除提供商';
  @override
  String get delete_confirm => '删除「{}」？';
  @override
  String get delete_message => '此操作无法撤销。';
}

// Path: settings.providers.alert
class _TranslationsSettingsProvidersAlertZhHans
    extends TranslationsSettingsProvidersAlertEn {
  _TranslationsSettingsProvidersAlertZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get error => '错误';
}

// Path: settings.providers.intro
class _TranslationsSettingsProvidersIntroZhHans
    extends TranslationsSettingsProvidersIntroEn {
  _TranslationsSettingsProvidersIntroZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get body => '选择应用使用的翻译和词典提供商。';
  @override
  String get warning => '你添加的提供商可能会处理你发送的文本，请只连接你信任的服务。';
}

// Path: settings.providers.editor
class _TranslationsSettingsProvidersEditorZhHans
    extends TranslationsSettingsProvidersEditorEn {
  _TranslationsSettingsProvidersEditorZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsSettingsProvidersEditorTitleZhHans title =
      _TranslationsSettingsProvidersEditorTitleZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorRowZhHans row =
      _TranslationsSettingsProvidersEditorRowZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorPlaceholderZhHans placeholder =
      _TranslationsSettingsProvidersEditorPlaceholderZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorTypePickerZhHans type_picker =
      _TranslationsSettingsProvidersEditorTypePickerZhHans._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorTooltipZhHans tooltip =
      _TranslationsSettingsProvidersEditorTooltipZhHans._(_root);
}

// Path: settings.providers.detail
class _TranslationsSettingsProvidersDetailZhHans
    extends TranslationsSettingsProvidersDetailEn {
  _TranslationsSettingsProvidersDetailZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsSettingsProvidersDetailTooltipZhHans tooltip =
      _TranslationsSettingsProvidersDetailTooltipZhHans._(_root);
}

// Path: settings.providers.capability
class _TranslationsSettingsProvidersCapabilityZhHans
    extends TranslationsSettingsProvidersCapabilityEn {
  _TranslationsSettingsProvidersCapabilityZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get translation => '翻译';
  @override
  String get dictionary => '词典';
  @override
  String get ocr => 'OCR';
}

// Path: settings.providers.description
class _TranslationsSettingsProvidersDescriptionZhHans
    extends TranslationsSettingsProvidersDescriptionEn {
  _TranslationsSettingsProvidersDescriptionZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get all => '提供词典查询和文本翻译';
  @override
  String get translation => '提供语言间文本翻译';
  @override
  String get dictionary => '提供词典查询和单词释义';
  @override
  String get fallback => '提供翻译服务';
}

// Path: settings.layout.empty
class _TranslationsSettingsLayoutEmptyZhHans
    extends TranslationsSettingsLayoutEmptyEn {
  _TranslationsSettingsLayoutEmptyZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get title => '选择一个分类';
  @override
  String get message => '从侧边栏选择一个设置分类。';
}

// Path: settings.providers.editor.title
class _TranslationsSettingsProvidersEditorTitleZhHans
    extends TranslationsSettingsProvidersEditorTitleEn {
  _TranslationsSettingsProvidersEditorTitleZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get add => '添加提供商';
  @override
  String get edit => '编辑提供商';
}

// Path: settings.providers.editor.row
class _TranslationsSettingsProvidersEditorRowZhHans
    extends TranslationsSettingsProvidersEditorRowEn {
  _TranslationsSettingsProvidersEditorRowZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get id => '提供商 ID';
  @override
  String get type => '提供商类型';
}

// Path: settings.providers.editor.placeholder
class _TranslationsSettingsProvidersEditorPlaceholderZhHans
    extends TranslationsSettingsProvidersEditorPlaceholderEn {
  _TranslationsSettingsProvidersEditorPlaceholderZhHans._(
      TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get id => '例如 deepl-main';
}

// Path: settings.providers.editor.type_picker
class _TranslationsSettingsProvidersEditorTypePickerZhHans
    extends TranslationsSettingsProvidersEditorTypePickerEn {
  _TranslationsSettingsProvidersEditorTypePickerZhHans._(
      TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get prompt => '请选择要添加的提供商类型：';
}

// Path: settings.providers.editor.tooltip
class _TranslationsSettingsProvidersEditorTooltipZhHans
    extends TranslationsSettingsProvidersEditorTooltipEn {
  _TranslationsSettingsProvidersEditorTooltipZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get help => '帮助';
}

// Path: settings.providers.detail.tooltip
class _TranslationsSettingsProvidersDetailTooltipZhHans
    extends TranslationsSettingsProvidersDetailTooltipEn {
  _TranslationsSettingsProvidersDetailTooltipZhHans._(TranslationsZhHans root)
      : this._root = root,
        super.internal(root);

  final TranslationsZhHans _root; // ignore: unused_field

  // Translations
  @override
  String get edit => '编辑提供商';
}

/// The flat map containing all translations for locale <zh-Hans>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsZhHans {
  dynamic _flatMapFunction(String path) {
    return switch (path) {
      'common.app.name' => '比译',
      'common.button.ok' => '确定',
      'common.button.cancel' => '取消',
      'common.button.add' => '添加',
      'common.button.delete' => '删除',
      'common.button.edit' => '编辑',
      'common.button.save' => '保存',
      'common.button.manage' => '管理',
      'common.button.kContinue' => '继续',
      'common.feedback.copied' => '已复制',
      'common.placeholder.choose' => '请选择',
      'common.language.ar' => '阿拉伯语',
      'common.language.bn' => '孟加拉语',
      'common.language.de' => '德语',
      'common.language.en' => '英语',
      'common.language.es' => '西班牙语',
      'common.language.fa' => '波斯语',
      'common.language.fr' => '法语',
      'common.language.gu' => '古吉拉特语',
      'common.language.ha' => '豪萨语',
      'common.language.hi' => '印地语',
      'common.language.id' => '印尼语',
      'common.language.it' => '意大利语',
      'common.language.ja' => '日语',
      'common.language.jv' => '印尼爪哇语',
      'common.language.ko' => '韩语',
      'common.language.ml' => '马拉雅拉姆语',
      'common.language.mr' => '马拉地语',
      'common.language.ms' => '马来语',
      'common.language.nl' => '荷兰语',
      'common.language.pa' => '旁遮普语',
      'common.language.pl' => '波兰语',
      'common.language.pt' => '葡萄牙语',
      'common.language.ro' => '罗马尼亚语',
      'common.language.ru' => '俄语',
      'common.language.sw' => '斯瓦希里语',
      'common.language.ta' => '泰米尔语',
      'common.language.te' => '泰卢固语',
      'common.language.th' => '泰语',
      'common.language.tr' => '土耳其语',
      'common.language.uk' => '乌克兰语',
      'common.language.ur' => '乌尔都语',
      'common.language.vi' => '越南语',
      'common.language.yo' => '约鲁巴语',
      'common.language.zh_Hans' => '中文（简体）',
      'common.language.zh_Hant' => '中文（繁体）',
      'provider.baidu' => '百度',
      'provider.caiyun' => '彩云小译',
      'provider.deepl' => 'DeepL',
      'provider.google' => '谷歌',
      'provider.iciba' => '爱词霸',
      'provider.sogou' => '搜狗',
      'provider.system' => '系统',
      'provider.tencent' => '腾讯',
      'provider.youdao' => '有道',
      'translation.engine_scope.detect_language' => '语种识别',
      'translation.engine_scope.lookup' => '查词',
      'translation.engine_scope.translate' => '翻译',
      'translation.mode.auto' => '自动',
      'translation.mode.manual' => '手动',
      'translation.word_pronunciation.us' => '美',
      'translation.word_pronunciation.uk' => '英',
      'ocr.engine.built_in' => '内置',
      'ocr.engine.tesseract' => 'Tesseract OCR',
      'ocr.engine.youdao' => '有道通用文字识别',
      'theme.mode.light' => '浅色',
      'theme.mode.dark' => '深色',
      'theme.mode.system' => '跟随系统',
      'tray.context_menu.show_window' => '显示窗口',
      'tray.context_menu.dev_tools.title' => '开发工具',
      'tray.context_menu.dev_tools.open_data_directory' => '打开数据目录',
      'tray.context_menu.dev_tools.use_native_settings' => '使用原生设置页面',
      'tray.context_menu.check_for_updates' => '检查更新',
      'tray.context_menu.settings' => '设置',
      'tray.context_menu.quit' => '退出',
      'mini_translator.update_banner.found_new_version' => '发现新版本：{}',
      'mini_translator.update_banner.button.update' => '立即更新',
      'mini_translator.limited_banner.permission.missing_both' =>
        '请授予屏幕录制和辅助功能权限以启用完整功能。',
      'mini_translator.limited_banner.permission.missing_screen_capture' =>
        '请授予屏幕录制权限以启用完整功能。',
      'mini_translator.limited_banner.permission.missing_accessibility' =>
        '请授予辅助功能权限以启用完整功能。',
      'mini_translator.limited_banner.instruction.app_settings_prefix' => '请前往',
      'mini_translator.limited_banner.instruction.follow_guide_prefix' =>
        '，按指引授权后点击',
      'mini_translator.limited_banner.instruction.suffix' => '。',
      'mini_translator.limited_banner.action.app_settings' => '应用设置',
      'mini_translator.limited_banner.action.recheck' => '重新检查',
      'mini_translator.limited_banner.feedback.enabled' => '屏幕取词功能已启用',
      'mini_translator.limited_banner.feedback.still_missing' =>
        '仍缺少所需权限，\n请检查设置后重试。',
      'mini_translator.limited_banner.tooltip.help' => '查看帮助文档',
      'mini_translator.input.hint' => '在此处输入单词或文本',
      'mini_translator.input.extracting_text' => '正在提取文字...',
      'mini_translator.toolbar.tooltip.translation_mode' => '当前翻译模式：{}',
      'mini_translator.toolbar.tooltip.extract_text_from_screen_capture' =>
        '截取屏幕区域并识别文字',
      'mini_translator.toolbar.tooltip.extract_text_from_clipboard' =>
        '读取剪切板内容',
      'mini_translator.button.clear' => '清空',
      'mini_translator.button.translate' => '翻译',
      'mini_translator.message.please_enter_word_or_text' => '未输入或未提取到文本',
      'mini_translator.message.capture_screen_area_canceled' => '截取屏幕区域已取消',
      'settings.version' => '版本 {} BUILD {}',
      'settings.general.title' => '常规',
      'settings.general.section.permissions' => '权限',
      'settings.general.section.ocr' => '文字识别',
      'settings.general.section.directory' => '词典',
      'settings.general.section.translation' => '翻译',
      'settings.general.section.translation_target' => '翻译目标',
      'settings.general.section.input' => '输入设置',
      'settings.general.row.launch_at_startup' => '登录时启动',
      'settings.general.row.show_in_menu_bar' => '在菜单栏中显示',
      'settings.general.row.screen_capture_access' => '授予屏幕录制权限',
      'settings.general.row.screen_selection_access' => '授予辅助功能权限',
      'settings.general.row.default_ocr_service' => '默认文字识别服务',
      'settings.general.row.auto_copy_detected_text' => '自动复制识别文本',
      'settings.general.row.default_directory_service' => '默认词典服务',
      'settings.general.row.default_translation_service' => '默认翻译服务',
      'settings.general.row.translation_mode' => '翻译模式',
      'settings.general.row.double_click_copy_result' => '双击复制翻译结果',
      'settings.general.row.submit_with_enter' => '用 Enter 提交',
      'settings.general.row.submit_with_meta_enter_mac' => '用 ⌘ + Enter 提交',
      'settings.general.button.add_provider' => '添加...',
      'settings.general.button.add_target' => '添加目标',
      'settings.general.button.grant' => '授权',
      'settings.general.option.none' => '无',
      'settings.general.option.no_services_available' => '暂无可用服务',
      'settings.general.option.granted' => '已授权',
      'settings.general.option.built_in_ocr' => '内置 OCR',
      'settings.general.option.tesseract' => 'Tesseract',
      'settings.general.option.youdao_ocr' => '有道 OCR',
      'settings.appearance.title' => '外观',
      'settings.appearance.section.app_language' => '显示语言',
      'settings.appearance.section.theme_mode' => '主题模式',
      'settings.appearance.option.english' => '英语',
      'settings.appearance.option.chinese' => '中文',
      'settings.shortcuts.title' => '快捷键',
      'settings.shortcuts.section.shortcuts' => '快捷键',
      'settings.shortcuts.section.text_extraction' => '文字提取',
      'settings.shortcuts.section.input_assist' => '输入辅助功能',
      'settings.shortcuts.row.toggle_mini_translator' => '显示/隐藏窗口',
      'settings.shortcuts.row.extract_text_from_screen_selection' =>
        '从屏幕选区提取文字',
      'settings.shortcuts.row.extract_text_from_screen_capture' => '从屏幕截图提取文字',
      'settings.shortcuts.row.extract_text_from_clipboard' => '从剪贴板提取文字',
      'settings.shortcuts.row.translate_input' => '翻译输入内容',
      'settings.shortcuts.dialog.reset_title' => '重置快捷键',
      'settings.shortcuts.dialog.reset_message' => '确定要重置所有快捷键为默认值吗？',
      'settings.shortcuts.dialog.reset_confirm' => '重置',
      'settings.shortcuts.dialog.reset_cancel' => '取消',
      'settings.advanced.title' => '高级',
      'settings.advanced.api_server' => '本地 API 服务',
      'settings.advanced.api_server_description' =>
        '在 127.0.0.1 上开放翻译 API，供本机集成使用。',
      'settings.advanced.enable' => '启用',
      'settings.advanced.address' => '地址',
      'settings.advanced.host' => '主机',
      'settings.advanced.port' => '端口',
      'settings.advanced.running_at' => '运行于 {url}',
      'settings.advanced.disabled' => '已关闭',
      'settings.providers.title' => '提供商',
      'settings.providers.section.services' => '服务',
      'settings.providers.item.empty' => '暂无已配置的提供商。添加一个提供商以启用翻译服务。',
      'settings.providers.item.loading' => '正在加载提供商...',
      'settings.providers.item.no_services' => '暂无可用服务。',
      'settings.providers.button.add' => '添加提供商...',
      'settings.providers.dialog.delete_title' => '删除提供商',
      'settings.providers.dialog.delete_confirm' => '删除「{}」？',
      'settings.providers.dialog.delete_message' => '此操作无法撤销。',
      'settings.providers.alert.error' => '错误',
      'settings.providers.intro.body' => '选择应用使用的翻译和词典提供商。',
      'settings.providers.intro.warning' => '你添加的提供商可能会处理你发送的文本，请只连接你信任的服务。',
      'settings.providers.editor.title.add' => '添加提供商',
      'settings.providers.editor.title.edit' => '编辑提供商',
      'settings.providers.editor.row.id' => '提供商 ID',
      'settings.providers.editor.row.type' => '提供商类型',
      'settings.providers.editor.placeholder.id' => '例如 deepl-main',
      'settings.providers.editor.type_picker.prompt' => '请选择要添加的提供商类型：',
      'settings.providers.editor.tooltip.help' => '帮助',
      'settings.providers.detail.tooltip.edit' => '编辑提供商',
      'settings.providers.capability.translation' => '翻译',
      'settings.providers.capability.dictionary' => '词典',
      'settings.providers.capability.ocr' => 'OCR',
      'settings.providers.description.all' => '提供词典查询和文本翻译',
      'settings.providers.description.translation' => '提供语言间文本翻译',
      'settings.providers.description.dictionary' => '提供词典查询和单词释义',
      'settings.providers.description.fallback' => '提供翻译服务',
      'settings.layout.title' => '设置',
      'settings.layout.empty.title' => '选择一个分类',
      'settings.layout.empty.message' => '从侧边栏选择一个设置分类。',
      'settings.title' => '设置',
      'shortcuts.record_dialog.title' => '自定义快捷键',
      _ => null,
    };
  }
}
