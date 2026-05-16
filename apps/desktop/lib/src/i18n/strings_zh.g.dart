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
class TranslationsZh extends Translations
    with BaseTranslations<AppLocale, Translations> {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsZh(
      {Map<String, Node>? overrides,
      PluralResolver? cardinalResolver,
      PluralResolver? ordinalResolver,
      TranslationMetadata<AppLocale, Translations>? meta})
      : assert(overrides == null,
            'Set "translation_overrides: true" in order to enable this feature.'),
        $meta = meta ??
            TranslationMetadata(
              locale: AppLocale.zh,
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

  /// Metadata for the translations of <zh>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  /// Access flat map
  @override
  dynamic operator [](String key) =>
      $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

  late final TranslationsZh _root = this; // ignore: unused_field

  @override
  TranslationsZh $copyWith(
          {TranslationMetadata<AppLocale, Translations>? meta}) =>
      TranslationsZh(meta: meta ?? this.$meta);

  // Translations
  @override
  late final _TranslationsCommonZh common = _TranslationsCommonZh._(_root);
  @override
  late final _TranslationsProviderZh provider =
      _TranslationsProviderZh._(_root);
  @override
  late final _TranslationsTranslationZh translation =
      _TranslationsTranslationZh._(_root);
  @override
  late final _TranslationsOcrZh ocr = _TranslationsOcrZh._(_root);
  @override
  late final _TranslationsThemeZh theme = _TranslationsThemeZh._(_root);
  @override
  late final _TranslationsTrayZh tray = _TranslationsTrayZh._(_root);
  @override
  late final _TranslationsMiniTranslatorZh mini_translator =
      _TranslationsMiniTranslatorZh._(_root);
  @override
  late final _TranslationsSettingsZh settings =
      _TranslationsSettingsZh._(_root);
  @override
  late final _TranslationsShortcutsZh shortcuts =
      _TranslationsShortcutsZh._(_root);
}

// Path: common
class _TranslationsCommonZh extends TranslationsCommonEn {
  _TranslationsCommonZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsCommonAppZh app = _TranslationsCommonAppZh._(_root);
  @override
  late final _TranslationsCommonButtonZh button =
      _TranslationsCommonButtonZh._(_root);
  @override
  late final _TranslationsCommonFeedbackZh feedback =
      _TranslationsCommonFeedbackZh._(_root);
  @override
  late final _TranslationsCommonPlaceholderZh placeholder =
      _TranslationsCommonPlaceholderZh._(_root);
  @override
  late final _TranslationsCommonLanguageZh language =
      _TranslationsCommonLanguageZh._(_root);
}

// Path: provider
class _TranslationsProviderZh extends TranslationsProviderEn {
  _TranslationsProviderZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

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
class _TranslationsTranslationZh extends TranslationsTranslationEn {
  _TranslationsTranslationZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsTranslationEngineScopeZh engine_scope =
      _TranslationsTranslationEngineScopeZh._(_root);
  @override
  late final _TranslationsTranslationModeZh mode =
      _TranslationsTranslationModeZh._(_root);
  @override
  late final _TranslationsTranslationWordPronunciationZh word_pronunciation =
      _TranslationsTranslationWordPronunciationZh._(_root);
}

// Path: ocr
class _TranslationsOcrZh extends TranslationsOcrEn {
  _TranslationsOcrZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsOcrEngineZh engine =
      _TranslationsOcrEngineZh._(_root);
}

// Path: theme
class _TranslationsThemeZh extends TranslationsThemeEn {
  _TranslationsThemeZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsThemeModeZh mode = _TranslationsThemeModeZh._(_root);
}

// Path: tray
class _TranslationsTrayZh extends TranslationsTrayEn {
  _TranslationsTrayZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsTrayContextMenuZh context_menu =
      _TranslationsTrayContextMenuZh._(_root);
}

// Path: mini_translator
class _TranslationsMiniTranslatorZh extends TranslationsMiniTranslatorEn {
  _TranslationsMiniTranslatorZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsMiniTranslatorUpdateBannerZh update_banner =
      _TranslationsMiniTranslatorUpdateBannerZh._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerZh limited_banner =
      _TranslationsMiniTranslatorLimitedBannerZh._(_root);
  @override
  late final _TranslationsMiniTranslatorInputZh input =
      _TranslationsMiniTranslatorInputZh._(_root);
  @override
  late final _TranslationsMiniTranslatorToolbarZh toolbar =
      _TranslationsMiniTranslatorToolbarZh._(_root);
  @override
  late final _TranslationsMiniTranslatorButtonZh button =
      _TranslationsMiniTranslatorButtonZh._(_root);
  @override
  late final _TranslationsMiniTranslatorMessageZh message =
      _TranslationsMiniTranslatorMessageZh._(_root);
}

// Path: settings
class _TranslationsSettingsZh extends TranslationsSettingsEn {
  _TranslationsSettingsZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get version => '版本 {} BUILD {}';
  @override
  late final _TranslationsSettingsGeneralZh general =
      _TranslationsSettingsGeneralZh._(_root);
  @override
  late final _TranslationsSettingsAppearanceZh appearance =
      _TranslationsSettingsAppearanceZh._(_root);
  @override
  late final _TranslationsSettingsShortcutsZh shortcuts =
      _TranslationsSettingsShortcutsZh._(_root);
  @override
  late final _TranslationsSettingsAdvancedZh advanced =
      _TranslationsSettingsAdvancedZh._(_root);
  @override
  late final _TranslationsSettingsProvidersZh providers =
      _TranslationsSettingsProvidersZh._(_root);
  @override
  late final _TranslationsSettingsLayoutZh layout =
      _TranslationsSettingsLayoutZh._(_root);
  @override
  String get title => '设置';
}

// Path: shortcuts
class _TranslationsShortcutsZh extends TranslationsShortcutsEn {
  _TranslationsShortcutsZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsShortcutsRecordDialogZh record_dialog =
      _TranslationsShortcutsRecordDialogZh._(_root);
}

// Path: common.app
class _TranslationsCommonAppZh extends TranslationsCommonAppEn {
  _TranslationsCommonAppZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get name => '比译';
}

// Path: common.button
class _TranslationsCommonButtonZh extends TranslationsCommonButtonEn {
  _TranslationsCommonButtonZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

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
class _TranslationsCommonFeedbackZh extends TranslationsCommonFeedbackEn {
  _TranslationsCommonFeedbackZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get copied => '已复制';
}

// Path: common.placeholder
class _TranslationsCommonPlaceholderZh extends TranslationsCommonPlaceholderEn {
  _TranslationsCommonPlaceholderZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get choose => '请选择';
}

// Path: common.language
class _TranslationsCommonLanguageZh extends TranslationsCommonLanguageEn {
  _TranslationsCommonLanguageZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get af => '布尔语(南非荷兰语)';
  @override
  String get am => '阿姆哈拉语';
  @override
  String get ar => '阿拉伯语';
  @override
  String get az => '阿塞拜疆语';
  @override
  String get be => '白俄罗斯语';
  @override
  String get bg => '保加利亚语';
  @override
  String get bn => '孟加拉语';
  @override
  String get bs => '波斯尼亚语';
  @override
  String get ca => '加泰罗尼亚语';
  @override
  String get ceb => '宿务语';
  @override
  String get co => '科西嘉语';
  @override
  String get cs => '捷克语';
  @override
  String get cy => '威尔士语';
  @override
  String get da => '丹麦语';
  @override
  String get de => '德语';
  @override
  String get el => '希腊语';
  @override
  String get en => '英语';
  @override
  String get eo => '世界语';
  @override
  String get es => '西班牙语';
  @override
  String get et => '爱沙尼亚语';
  @override
  String get eu => '巴斯克语';
  @override
  String get fa => '波斯语';
  @override
  String get fi => '芬兰语';
  @override
  String get fr => '法语';
  @override
  String get fy => '弗里西语';
  @override
  String get ga => '爱尔兰语';
  @override
  String get gd => '苏格兰盖尔语';
  @override
  String get gl => '加利西亚语';
  @override
  String get gu => '古吉拉特语';
  @override
  String get ha => '豪萨语';
  @override
  String get haw => '夏威夷语';
  @override
  String get he => '希伯来语';
  @override
  String get hi => '印地语';
  @override
  String get hmn => '苗语';
  @override
  String get hr => '克罗地亚语';
  @override
  String get ht => '海地克里奥尔语';
  @override
  String get hu => '匈牙利语';
  @override
  String get hy => '亚美尼亚语';
  @override
  String get id => '印尼语';
  @override
  String get ig => '伊博语';
  @override
  String get kIs => '冰岛语';
  @override
  String get it => '意大利语';
  @override
  String get iw => '希伯来语';
  @override
  String get ja => '日语';
  @override
  String get jw => '印尼爪哇语';
  @override
  String get ka => '格鲁吉亚语';
  @override
  String get kk => '哈萨克语';
  @override
  String get km => '高棉语';
  @override
  String get kn => '卡纳达语';
  @override
  String get ko => '韩语';
  @override
  String get ku => '库尔德语';
  @override
  String get ky => '吉尔吉斯语';
  @override
  String get la => '拉丁语';
  @override
  String get lb => '卢森堡语';
  @override
  String get lo => '老挝语';
  @override
  String get lt => '立陶宛语';
  @override
  String get lv => '拉脱维亚语';
  @override
  String get mg => '马尔加什语';
  @override
  String get mi => '毛利语';
  @override
  String get mk => '马其顿语';
  @override
  String get ml => '马拉雅拉姆语';
  @override
  String get mn => '蒙古语';
  @override
  String get mr => '马拉地语';
  @override
  String get ms => '马来语';
  @override
  String get mt => '马耳他语';
  @override
  String get my => '缅甸语';
  @override
  String get ne => '尼泊尔语';
  @override
  String get nl => '荷兰语';
  @override
  String get no => '挪威语';
  @override
  String get ny => '齐切瓦语';
  @override
  String get or => '奥利亚语';
  @override
  String get pa => '旁遮普语';
  @override
  String get pl => '波兰语';
  @override
  String get ps => '普什图语';
  @override
  String get pt => '葡萄牙语';
  @override
  String get ro => '罗马尼亚语';
  @override
  String get ru => '俄语';
  @override
  String get rw => '卢旺达语';
  @override
  String get sd => '信德语';
  @override
  String get si => '僧伽罗语';
  @override
  String get sk => '斯洛伐克语';
  @override
  String get sl => '斯洛文尼亚语';
  @override
  String get sm => '萨摩亚语';
  @override
  String get sn => '修纳语';
  @override
  String get so => '索马里语';
  @override
  String get sq => '阿尔巴尼亚语';
  @override
  String get sr => '塞尔维亚语';
  @override
  String get st => '塞索托语';
  @override
  String get su => '印尼巽他语';
  @override
  String get sv => '瑞典语';
  @override
  String get sw => '斯瓦希里语';
  @override
  String get ta => '泰米尔语';
  @override
  String get te => '泰卢固语';
  @override
  String get tg => '塔吉克语';
  @override
  String get th => '泰语';
  @override
  String get tk => '土库曼语';
  @override
  String get tl => '菲律宾语';
  @override
  String get tr => '土耳其语';
  @override
  String get tt => '鞑靼语';
  @override
  String get ug => '维吾尔语';
  @override
  String get uk => '乌克兰语';
  @override
  String get ur => '乌尔都语';
  @override
  String get uz => '乌兹别克语';
  @override
  String get vi => '越南语';
  @override
  String get xh => '南非科萨语';
  @override
  String get yi => '意第绪语';
  @override
  String get yo => '约鲁巴语';
  @override
  String get zh => '中文';
  @override
  String get zh_CN => '中文';
  @override
  String get zh_TW => '中文(繁体)';
  @override
  String get zu => '南非祖鲁语';
}

// Path: translation.engine_scope
class _TranslationsTranslationEngineScopeZh
    extends TranslationsTranslationEngineScopeEn {
  _TranslationsTranslationEngineScopeZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get detect_language => '语种识别';
  @override
  String get lookup => '查词';
  @override
  String get translate => '翻译';
}

// Path: translation.mode
class _TranslationsTranslationModeZh extends TranslationsTranslationModeEn {
  _TranslationsTranslationModeZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get auto => '自动';
  @override
  String get manual => '手动';
}

// Path: translation.word_pronunciation
class _TranslationsTranslationWordPronunciationZh
    extends TranslationsTranslationWordPronunciationEn {
  _TranslationsTranslationWordPronunciationZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get us => '美';
  @override
  String get uk => '英';
}

// Path: ocr.engine
class _TranslationsOcrEngineZh extends TranslationsOcrEngineEn {
  _TranslationsOcrEngineZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get built_in => '内置';
  @override
  String get tesseract => 'Tesseract OCR';
  @override
  String get youdao => '有道通用文字识别';
}

// Path: theme.mode
class _TranslationsThemeModeZh extends TranslationsThemeModeEn {
  _TranslationsThemeModeZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get light => '浅色';
  @override
  String get dark => '深色';
  @override
  String get system => '跟随系统';
}

// Path: tray.context_menu
class _TranslationsTrayContextMenuZh extends TranslationsTrayContextMenuEn {
  _TranslationsTrayContextMenuZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get show => '显示';
  @override
  String get quick_start_guide => '快速入门';
  @override
  late final _TranslationsTrayContextMenuDiscussionZh discussion =
      _TranslationsTrayContextMenuDiscussionZh._(_root);
  @override
  String get quit_app => '退出比译';
}

// Path: mini_translator.update_banner
class _TranslationsMiniTranslatorUpdateBannerZh
    extends TranslationsMiniTranslatorUpdateBannerEn {
  _TranslationsMiniTranslatorUpdateBannerZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get found_new_version => '发现新版本：{}';
  @override
  late final _TranslationsMiniTranslatorUpdateBannerButtonZh button =
      _TranslationsMiniTranslatorUpdateBannerButtonZh._(_root);
}

// Path: mini_translator.limited_banner
class _TranslationsMiniTranslatorLimitedBannerZh
    extends TranslationsMiniTranslatorLimitedBannerEn {
  _TranslationsMiniTranslatorLimitedBannerZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsMiniTranslatorLimitedBannerPermissionZh permission =
      _TranslationsMiniTranslatorLimitedBannerPermissionZh._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerInstructionZh instruction =
      _TranslationsMiniTranslatorLimitedBannerInstructionZh._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerActionZh action =
      _TranslationsMiniTranslatorLimitedBannerActionZh._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerFeedbackZh feedback =
      _TranslationsMiniTranslatorLimitedBannerFeedbackZh._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerTooltipZh tooltip =
      _TranslationsMiniTranslatorLimitedBannerTooltipZh._(_root);
}

// Path: mini_translator.input
class _TranslationsMiniTranslatorInputZh
    extends TranslationsMiniTranslatorInputEn {
  _TranslationsMiniTranslatorInputZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get hint => '在此处输入单词或文本';
  @override
  String get extracting_text => '正在提取文字...';
}

// Path: mini_translator.toolbar
class _TranslationsMiniTranslatorToolbarZh
    extends TranslationsMiniTranslatorToolbarEn {
  _TranslationsMiniTranslatorToolbarZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsMiniTranslatorToolbarTooltipZh tooltip =
      _TranslationsMiniTranslatorToolbarTooltipZh._(_root);
}

// Path: mini_translator.button
class _TranslationsMiniTranslatorButtonZh
    extends TranslationsMiniTranslatorButtonEn {
  _TranslationsMiniTranslatorButtonZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get clear => '清空';
  @override
  String get translate => '翻译';
}

// Path: mini_translator.message
class _TranslationsMiniTranslatorMessageZh
    extends TranslationsMiniTranslatorMessageEn {
  _TranslationsMiniTranslatorMessageZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get please_enter_word_or_text => '未输入或未提取到文本';
  @override
  String get capture_screen_area_canceled => '截取屏幕区域已取消';
}

// Path: settings.general
class _TranslationsSettingsGeneralZh extends TranslationsSettingsGeneralEn {
  _TranslationsSettingsGeneralZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get title => '常规';
  @override
  late final _TranslationsSettingsGeneralSectionZh section =
      _TranslationsSettingsGeneralSectionZh._(_root);
  @override
  late final _TranslationsSettingsGeneralRowZh row =
      _TranslationsSettingsGeneralRowZh._(_root);
  @override
  late final _TranslationsSettingsGeneralButtonZh button =
      _TranslationsSettingsGeneralButtonZh._(_root);
  @override
  late final _TranslationsSettingsGeneralOptionZh option =
      _TranslationsSettingsGeneralOptionZh._(_root);
}

// Path: settings.appearance
class _TranslationsSettingsAppearanceZh
    extends TranslationsSettingsAppearanceEn {
  _TranslationsSettingsAppearanceZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get title => '外观';
  @override
  late final _TranslationsSettingsAppearanceSectionZh section =
      _TranslationsSettingsAppearanceSectionZh._(_root);
  @override
  late final _TranslationsSettingsAppearanceOptionZh option =
      _TranslationsSettingsAppearanceOptionZh._(_root);
}

// Path: settings.shortcuts
class _TranslationsSettingsShortcutsZh extends TranslationsSettingsShortcutsEn {
  _TranslationsSettingsShortcutsZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get title => '快捷键';
  @override
  late final _TranslationsSettingsShortcutsSectionZh section =
      _TranslationsSettingsShortcutsSectionZh._(_root);
  @override
  late final _TranslationsSettingsShortcutsRowZh row =
      _TranslationsSettingsShortcutsRowZh._(_root);
}

// Path: settings.advanced
class _TranslationsSettingsAdvancedZh extends TranslationsSettingsAdvancedEn {
  _TranslationsSettingsAdvancedZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get title => '高级';
  @override
  String get empty => '暂无高级设置。';
}

// Path: settings.providers
class _TranslationsSettingsProvidersZh extends TranslationsSettingsProvidersEn {
  _TranslationsSettingsProvidersZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get title => '提供商';
  @override
  late final _TranslationsSettingsProvidersSectionZh section =
      _TranslationsSettingsProvidersSectionZh._(_root);
  @override
  late final _TranslationsSettingsProvidersItemZh item =
      _TranslationsSettingsProvidersItemZh._(_root);
  @override
  late final _TranslationsSettingsProvidersButtonZh button =
      _TranslationsSettingsProvidersButtonZh._(_root);
  @override
  late final _TranslationsSettingsProvidersDialogZh dialog =
      _TranslationsSettingsProvidersDialogZh._(_root);
  @override
  late final _TranslationsSettingsProvidersAlertZh alert =
      _TranslationsSettingsProvidersAlertZh._(_root);
  @override
  late final _TranslationsSettingsProvidersIntroZh intro =
      _TranslationsSettingsProvidersIntroZh._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorZh editor =
      _TranslationsSettingsProvidersEditorZh._(_root);
  @override
  late final _TranslationsSettingsProvidersDetailZh detail =
      _TranslationsSettingsProvidersDetailZh._(_root);
  @override
  late final _TranslationsSettingsProvidersCapabilityZh capability =
      _TranslationsSettingsProvidersCapabilityZh._(_root);
  @override
  late final _TranslationsSettingsProvidersDescriptionZh description =
      _TranslationsSettingsProvidersDescriptionZh._(_root);
}

// Path: settings.layout
class _TranslationsSettingsLayoutZh extends TranslationsSettingsLayoutEn {
  _TranslationsSettingsLayoutZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get title => '设置';
  @override
  late final _TranslationsSettingsLayoutEmptyZh empty =
      _TranslationsSettingsLayoutEmptyZh._(_root);
}

// Path: shortcuts.record_dialog
class _TranslationsShortcutsRecordDialogZh
    extends TranslationsShortcutsRecordDialogEn {
  _TranslationsShortcutsRecordDialogZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get title => '自定义快捷键';
}

// Path: tray.context_menu.discussion
class _TranslationsTrayContextMenuDiscussionZh
    extends TranslationsTrayContextMenuDiscussionEn {
  _TranslationsTrayContextMenuDiscussionZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get title => '加入讨论';
  @override
  String get discord_server => '加入 Discord';
  @override
  String get qq_group => '加入 QQ 群';
}

// Path: mini_translator.update_banner.button
class _TranslationsMiniTranslatorUpdateBannerButtonZh
    extends TranslationsMiniTranslatorUpdateBannerButtonEn {
  _TranslationsMiniTranslatorUpdateBannerButtonZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get update => '立即更新';
}

// Path: mini_translator.limited_banner.permission
class _TranslationsMiniTranslatorLimitedBannerPermissionZh
    extends TranslationsMiniTranslatorLimitedBannerPermissionEn {
  _TranslationsMiniTranslatorLimitedBannerPermissionZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get missing_both => '请授予屏幕录制和辅助功能权限以启用完整功能。';
  @override
  String get missing_screen_capture => '请授予屏幕录制权限以启用完整功能。';
  @override
  String get missing_accessibility => '请授予辅助功能权限以启用完整功能。';
}

// Path: mini_translator.limited_banner.instruction
class _TranslationsMiniTranslatorLimitedBannerInstructionZh
    extends TranslationsMiniTranslatorLimitedBannerInstructionEn {
  _TranslationsMiniTranslatorLimitedBannerInstructionZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get app_settings_prefix => '请前往';
  @override
  String get follow_guide_prefix => '，按指引授权后点击';
  @override
  String get suffix => '。';
}

// Path: mini_translator.limited_banner.action
class _TranslationsMiniTranslatorLimitedBannerActionZh
    extends TranslationsMiniTranslatorLimitedBannerActionEn {
  _TranslationsMiniTranslatorLimitedBannerActionZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get app_settings => '应用设置';
  @override
  String get recheck => '重新检查';
}

// Path: mini_translator.limited_banner.feedback
class _TranslationsMiniTranslatorLimitedBannerFeedbackZh
    extends TranslationsMiniTranslatorLimitedBannerFeedbackEn {
  _TranslationsMiniTranslatorLimitedBannerFeedbackZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get enabled => '屏幕取词功能已启用';
  @override
  String get still_missing => '仍缺少所需权限，\n请检查设置后重试。';
}

// Path: mini_translator.limited_banner.tooltip
class _TranslationsMiniTranslatorLimitedBannerTooltipZh
    extends TranslationsMiniTranslatorLimitedBannerTooltipEn {
  _TranslationsMiniTranslatorLimitedBannerTooltipZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get help => '查看帮助文档';
}

// Path: mini_translator.toolbar.tooltip
class _TranslationsMiniTranslatorToolbarTooltipZh
    extends TranslationsMiniTranslatorToolbarTooltipEn {
  _TranslationsMiniTranslatorToolbarTooltipZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get translation_mode => '当前翻译模式：{}';
  @override
  String get extract_text_from_screen_capture => '截取屏幕区域并识别文字';
  @override
  String get extract_text_from_clipboard => '读取剪切板内容';
}

// Path: settings.general.section
class _TranslationsSettingsGeneralSectionZh
    extends TranslationsSettingsGeneralSectionEn {
  _TranslationsSettingsGeneralSectionZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

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
class _TranslationsSettingsGeneralRowZh
    extends TranslationsSettingsGeneralRowEn {
  _TranslationsSettingsGeneralRowZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

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
class _TranslationsSettingsGeneralButtonZh
    extends TranslationsSettingsGeneralButtonEn {
  _TranslationsSettingsGeneralButtonZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get add_provider => '添加...';
  @override
  String get add_target => '添加目标';
  @override
  String get grant => '授权';
}

// Path: settings.general.option
class _TranslationsSettingsGeneralOptionZh
    extends TranslationsSettingsGeneralOptionEn {
  _TranslationsSettingsGeneralOptionZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

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
class _TranslationsSettingsAppearanceSectionZh
    extends TranslationsSettingsAppearanceSectionEn {
  _TranslationsSettingsAppearanceSectionZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get app_language => '显示语言';
  @override
  String get theme_mode => '主题模式';
}

// Path: settings.appearance.option
class _TranslationsSettingsAppearanceOptionZh
    extends TranslationsSettingsAppearanceOptionEn {
  _TranslationsSettingsAppearanceOptionZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get english => '英文';
  @override
  String get chinese => '中文';
}

// Path: settings.shortcuts.section
class _TranslationsSettingsShortcutsSectionZh
    extends TranslationsSettingsShortcutsSectionEn {
  _TranslationsSettingsShortcutsSectionZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get shortcuts => '快捷键';
  @override
  String get text_extraction => '文字提取';
  @override
  String get input_assist => '输入辅助功能';
}

// Path: settings.shortcuts.row
class _TranslationsSettingsShortcutsRowZh
    extends TranslationsSettingsShortcutsRowEn {
  _TranslationsSettingsShortcutsRowZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

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

// Path: settings.providers.section
class _TranslationsSettingsProvidersSectionZh
    extends TranslationsSettingsProvidersSectionEn {
  _TranslationsSettingsProvidersSectionZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get services => '服务';
}

// Path: settings.providers.item
class _TranslationsSettingsProvidersItemZh
    extends TranslationsSettingsProvidersItemEn {
  _TranslationsSettingsProvidersItemZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get empty => '暂无已配置的提供商。添加一个提供商以启用翻译服务。';
  @override
  String get loading => '正在加载提供商...';
  @override
  String get no_services => '暂无可用服务。';
}

// Path: settings.providers.button
class _TranslationsSettingsProvidersButtonZh
    extends TranslationsSettingsProvidersButtonEn {
  _TranslationsSettingsProvidersButtonZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get add => '添加提供商...';
}

// Path: settings.providers.dialog
class _TranslationsSettingsProvidersDialogZh
    extends TranslationsSettingsProvidersDialogEn {
  _TranslationsSettingsProvidersDialogZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get delete_title => '删除提供商';
  @override
  String get delete_confirm => '删除「{}」？';
  @override
  String get delete_message => '此操作无法撤销。';
}

// Path: settings.providers.alert
class _TranslationsSettingsProvidersAlertZh
    extends TranslationsSettingsProvidersAlertEn {
  _TranslationsSettingsProvidersAlertZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get error => '错误';
}

// Path: settings.providers.intro
class _TranslationsSettingsProvidersIntroZh
    extends TranslationsSettingsProvidersIntroEn {
  _TranslationsSettingsProvidersIntroZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get body => '选择应用使用的翻译和词典提供商。';
  @override
  String get warning => '你添加的提供商可能会处理你发送的文本，请只连接你信任的服务。';
}

// Path: settings.providers.editor
class _TranslationsSettingsProvidersEditorZh
    extends TranslationsSettingsProvidersEditorEn {
  _TranslationsSettingsProvidersEditorZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsSettingsProvidersEditorTitleZh title =
      _TranslationsSettingsProvidersEditorTitleZh._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorRowZh row =
      _TranslationsSettingsProvidersEditorRowZh._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorPlaceholderZh placeholder =
      _TranslationsSettingsProvidersEditorPlaceholderZh._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorTypePickerZh type_picker =
      _TranslationsSettingsProvidersEditorTypePickerZh._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorTooltipZh tooltip =
      _TranslationsSettingsProvidersEditorTooltipZh._(_root);
}

// Path: settings.providers.detail
class _TranslationsSettingsProvidersDetailZh
    extends TranslationsSettingsProvidersDetailEn {
  _TranslationsSettingsProvidersDetailZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsSettingsProvidersDetailTooltipZh tooltip =
      _TranslationsSettingsProvidersDetailTooltipZh._(_root);
}

// Path: settings.providers.capability
class _TranslationsSettingsProvidersCapabilityZh
    extends TranslationsSettingsProvidersCapabilityEn {
  _TranslationsSettingsProvidersCapabilityZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get translation => '翻译';
  @override
  String get dictionary => '词典';
  @override
  String get ocr => 'OCR';
}

// Path: settings.providers.description
class _TranslationsSettingsProvidersDescriptionZh
    extends TranslationsSettingsProvidersDescriptionEn {
  _TranslationsSettingsProvidersDescriptionZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

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
class _TranslationsSettingsLayoutEmptyZh
    extends TranslationsSettingsLayoutEmptyEn {
  _TranslationsSettingsLayoutEmptyZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get title => '选择一个分类';
  @override
  String get message => '从侧边栏选择一个设置分类。';
}

// Path: settings.providers.editor.title
class _TranslationsSettingsProvidersEditorTitleZh
    extends TranslationsSettingsProvidersEditorTitleEn {
  _TranslationsSettingsProvidersEditorTitleZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get add => '添加提供商';
  @override
  String get edit => '编辑提供商';
}

// Path: settings.providers.editor.row
class _TranslationsSettingsProvidersEditorRowZh
    extends TranslationsSettingsProvidersEditorRowEn {
  _TranslationsSettingsProvidersEditorRowZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get id => '提供商 ID';
  @override
  String get type => '提供商类型';
}

// Path: settings.providers.editor.placeholder
class _TranslationsSettingsProvidersEditorPlaceholderZh
    extends TranslationsSettingsProvidersEditorPlaceholderEn {
  _TranslationsSettingsProvidersEditorPlaceholderZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get id => '例如 deepl-main';
}

// Path: settings.providers.editor.type_picker
class _TranslationsSettingsProvidersEditorTypePickerZh
    extends TranslationsSettingsProvidersEditorTypePickerEn {
  _TranslationsSettingsProvidersEditorTypePickerZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get prompt => '请选择要添加的提供商类型：';
}

// Path: settings.providers.editor.tooltip
class _TranslationsSettingsProvidersEditorTooltipZh
    extends TranslationsSettingsProvidersEditorTooltipEn {
  _TranslationsSettingsProvidersEditorTooltipZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get help => '帮助';
}

// Path: settings.providers.detail.tooltip
class _TranslationsSettingsProvidersDetailTooltipZh
    extends TranslationsSettingsProvidersDetailTooltipEn {
  _TranslationsSettingsProvidersDetailTooltipZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get edit => '编辑提供商';
}

/// The flat map containing all translations for locale <zh>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsZh {
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
      'common.language.af' => '布尔语(南非荷兰语)',
      'common.language.am' => '阿姆哈拉语',
      'common.language.ar' => '阿拉伯语',
      'common.language.az' => '阿塞拜疆语',
      'common.language.be' => '白俄罗斯语',
      'common.language.bg' => '保加利亚语',
      'common.language.bn' => '孟加拉语',
      'common.language.bs' => '波斯尼亚语',
      'common.language.ca' => '加泰罗尼亚语',
      'common.language.ceb' => '宿务语',
      'common.language.co' => '科西嘉语',
      'common.language.cs' => '捷克语',
      'common.language.cy' => '威尔士语',
      'common.language.da' => '丹麦语',
      'common.language.de' => '德语',
      'common.language.el' => '希腊语',
      'common.language.en' => '英语',
      'common.language.eo' => '世界语',
      'common.language.es' => '西班牙语',
      'common.language.et' => '爱沙尼亚语',
      'common.language.eu' => '巴斯克语',
      'common.language.fa' => '波斯语',
      'common.language.fi' => '芬兰语',
      'common.language.fr' => '法语',
      'common.language.fy' => '弗里西语',
      'common.language.ga' => '爱尔兰语',
      'common.language.gd' => '苏格兰盖尔语',
      'common.language.gl' => '加利西亚语',
      'common.language.gu' => '古吉拉特语',
      'common.language.ha' => '豪萨语',
      'common.language.haw' => '夏威夷语',
      'common.language.he' => '希伯来语',
      'common.language.hi' => '印地语',
      'common.language.hmn' => '苗语',
      'common.language.hr' => '克罗地亚语',
      'common.language.ht' => '海地克里奥尔语',
      'common.language.hu' => '匈牙利语',
      'common.language.hy' => '亚美尼亚语',
      'common.language.id' => '印尼语',
      'common.language.ig' => '伊博语',
      'common.language.kIs' => '冰岛语',
      'common.language.it' => '意大利语',
      'common.language.iw' => '希伯来语',
      'common.language.ja' => '日语',
      'common.language.jw' => '印尼爪哇语',
      'common.language.ka' => '格鲁吉亚语',
      'common.language.kk' => '哈萨克语',
      'common.language.km' => '高棉语',
      'common.language.kn' => '卡纳达语',
      'common.language.ko' => '韩语',
      'common.language.ku' => '库尔德语',
      'common.language.ky' => '吉尔吉斯语',
      'common.language.la' => '拉丁语',
      'common.language.lb' => '卢森堡语',
      'common.language.lo' => '老挝语',
      'common.language.lt' => '立陶宛语',
      'common.language.lv' => '拉脱维亚语',
      'common.language.mg' => '马尔加什语',
      'common.language.mi' => '毛利语',
      'common.language.mk' => '马其顿语',
      'common.language.ml' => '马拉雅拉姆语',
      'common.language.mn' => '蒙古语',
      'common.language.mr' => '马拉地语',
      'common.language.ms' => '马来语',
      'common.language.mt' => '马耳他语',
      'common.language.my' => '缅甸语',
      'common.language.ne' => '尼泊尔语',
      'common.language.nl' => '荷兰语',
      'common.language.no' => '挪威语',
      'common.language.ny' => '齐切瓦语',
      'common.language.or' => '奥利亚语',
      'common.language.pa' => '旁遮普语',
      'common.language.pl' => '波兰语',
      'common.language.ps' => '普什图语',
      'common.language.pt' => '葡萄牙语',
      'common.language.ro' => '罗马尼亚语',
      'common.language.ru' => '俄语',
      'common.language.rw' => '卢旺达语',
      'common.language.sd' => '信德语',
      'common.language.si' => '僧伽罗语',
      'common.language.sk' => '斯洛伐克语',
      'common.language.sl' => '斯洛文尼亚语',
      'common.language.sm' => '萨摩亚语',
      'common.language.sn' => '修纳语',
      'common.language.so' => '索马里语',
      'common.language.sq' => '阿尔巴尼亚语',
      'common.language.sr' => '塞尔维亚语',
      'common.language.st' => '塞索托语',
      'common.language.su' => '印尼巽他语',
      'common.language.sv' => '瑞典语',
      'common.language.sw' => '斯瓦希里语',
      'common.language.ta' => '泰米尔语',
      'common.language.te' => '泰卢固语',
      'common.language.tg' => '塔吉克语',
      'common.language.th' => '泰语',
      'common.language.tk' => '土库曼语',
      'common.language.tl' => '菲律宾语',
      'common.language.tr' => '土耳其语',
      'common.language.tt' => '鞑靼语',
      'common.language.ug' => '维吾尔语',
      'common.language.uk' => '乌克兰语',
      'common.language.ur' => '乌尔都语',
      'common.language.uz' => '乌兹别克语',
      'common.language.vi' => '越南语',
      'common.language.xh' => '南非科萨语',
      'common.language.yi' => '意第绪语',
      'common.language.yo' => '约鲁巴语',
      'common.language.zh' => '中文',
      'common.language.zh_CN' => '中文',
      'common.language.zh_TW' => '中文(繁体)',
      'common.language.zu' => '南非祖鲁语',
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
      'tray.context_menu.show' => '显示',
      'tray.context_menu.quick_start_guide' => '快速入门',
      'tray.context_menu.discussion.title' => '加入讨论',
      'tray.context_menu.discussion.discord_server' => '加入 Discord',
      'tray.context_menu.discussion.qq_group' => '加入 QQ 群',
      'tray.context_menu.quit_app' => '退出比译',
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
      'settings.appearance.option.english' => '英文',
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
      'settings.advanced.title' => '高级',
      'settings.advanced.empty' => '暂无高级设置。',
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
