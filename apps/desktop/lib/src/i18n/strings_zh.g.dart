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
  String get app_name => '比译';
  @override
  String get ok => '确定';
  @override
  String get cancel => '取消';
  @override
  String get add => '添加';
  @override
  String get delete => '删除';
  @override
  String get copied => '已复制';
  @override
  String get please_choose => '请选择';
  @override
  late final _TranslationsLanguageZh language =
      _TranslationsLanguageZh._(_root);
  @override
  late final _TranslationsEngineZh engine = _TranslationsEngineZh._(_root);
  @override
  late final _TranslationsEngineScopeZh engine_scope =
      _TranslationsEngineScopeZh._(_root);
  @override
  late final _TranslationsOcrEngineZh ocr_engine =
      _TranslationsOcrEngineZh._(_root);
  @override
  late final _TranslationsTranslationModeZh translation_mode =
      _TranslationsTranslationModeZh._(_root);
  @override
  late final _TranslationsThemeModeZh theme_mode =
      _TranslationsThemeModeZh._(_root);
  @override
  late final _TranslationsWordPronunciationZh word_pronunciation =
      _TranslationsWordPronunciationZh._(_root);
  @override
  late final _TranslationsTrayContextMenuZh tray_context_menu =
      _TranslationsTrayContextMenuZh._(_root);
  @override
  late final _TranslationsMiniTranslatorZh mini_translator =
      _TranslationsMiniTranslatorZh._(_root);
  @override
  late final _TranslationsPageLanguageChooserZh page_language_chooser =
      _TranslationsPageLanguageChooserZh._(_root);
  @override
  late final _TranslationsPageOcrEngineChooserZh page_ocr_engine_chooser =
      _TranslationsPageOcrEngineChooserZh._(_root);
  @override
  late final _TranslationsPageOcrEngineCreateOrEditZh
      page_ocr_engine_create_or_edit =
      _TranslationsPageOcrEngineCreateOrEditZh._(_root);
  @override
  late final _TranslationsPageOcrEngineTypeChooserZh
      page_ocr_engine_type_chooser =
      _TranslationsPageOcrEngineTypeChooserZh._(_root);
  @override
  late final _TranslationsPageOcrEnginesManageZh page_ocr_engines_manage =
      _TranslationsPageOcrEnginesManageZh._(_root);
  @override
  late final _TranslationsPageSettingAppLanguageZh page_setting_app_language =
      _TranslationsPageSettingAppLanguageZh._(_root);
  @override
  late final _TranslationsPageSettingExtractTextZh page_setting_extract_text =
      _TranslationsPageSettingExtractTextZh._(_root);
  @override
  late final _TranslationsPageSettingInterfaceZh page_setting_interface =
      _TranslationsPageSettingInterfaceZh._(_root);
  @override
  late final _TranslationsPageSettingShortcutsZh page_setting_shortcuts =
      _TranslationsPageSettingShortcutsZh._(_root);
  @override
  late final _TranslationsPageSettingThemeModeZh page_setting_theme_mode =
      _TranslationsPageSettingThemeModeZh._(_root);
  @override
  late final _TranslationsPageSettingTranslateZh page_setting_translate =
      _TranslationsPageSettingTranslateZh._(_root);
  @override
  late final _TranslationsPageSettingsZh page_settings =
      _TranslationsPageSettingsZh._(_root);
  @override
  late final _TranslationsPageTranslationEngineChooserZh
      page_translation_engine_chooser =
      _TranslationsPageTranslationEngineChooserZh._(_root);
  @override
  late final _TranslationsPageTranslationEngineCreateOrEditZh
      page_translation_engine_create_or_edit =
      _TranslationsPageTranslationEngineCreateOrEditZh._(_root);
  @override
  late final _TranslationsPageTranslationEngineTypeChooserZh
      page_translation_engine_type_chooser =
      _TranslationsPageTranslationEngineTypeChooserZh._(_root);
  @override
  late final _TranslationsPageTranslationEnginesManageZh
      page_translation_engines_manage =
      _TranslationsPageTranslationEnginesManageZh._(_root);
  @override
  late final _TranslationsPageTranslationTargetNewZh
      page_translation_target_new =
      _TranslationsPageTranslationTargetNewZh._(_root);
  @override
  late final _TranslationsPageYourPlanSelectorZh page_your_plan_selector =
      _TranslationsPageYourPlanSelectorZh._(_root);
  @override
  late final _TranslationsWidgetRecordShortcutDialogZh
      widget_record_shortcut_dialog =
      _TranslationsWidgetRecordShortcutDialogZh._(_root);
}

// Path: language
class _TranslationsLanguageZh extends TranslationsLanguageEn {
  _TranslationsLanguageZh._(TranslationsZh root)
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

// Path: engine
class _TranslationsEngineZh extends TranslationsEngineEn {
  _TranslationsEngineZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get baidu => '百度翻译';
  @override
  String get caiyun => '彩云小译';
  @override
  String get deepl => 'DeepL';
  @override
  String get google => '谷歌翻译';
  @override
  String get ibmwatson => 'IBMWatson';
  @override
  String get iciba => '爱词霸';
  @override
  String get openai => 'OpenAI';
  @override
  String get sogou => '搜狗翻译';
  @override
  String get tencent => '腾讯翻译君';
  @override
  String get youdao => '有道翻译';
}

// Path: engine_scope
class _TranslationsEngineScopeZh extends TranslationsEngineScopeEn {
  _TranslationsEngineScopeZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get detectlanguage => '语种识别';
  @override
  String get lookup => '查词';
  @override
  String get translate => '翻译';
}

// Path: ocr_engine
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

// Path: translation_mode
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

// Path: theme_mode
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

// Path: word_pronunciation
class _TranslationsWordPronunciationZh extends TranslationsWordPronunciationEn {
  _TranslationsWordPronunciationZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get us => '美';
  @override
  String get uk => '英';
}

// Path: tray_context_menu
class _TranslationsTrayContextMenuZh extends TranslationsTrayContextMenuEn {
  _TranslationsTrayContextMenuZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get item_show => '显示';
  @override
  String get item_quick_start_guide => '快速入门';
  @override
  String get item_discussion => '加入讨论';
  @override
  String get item_quit_app => '退出比译';
  @override
  String get item_discussion_subitem_discord_server => '加入 Discord';
  @override
  String get item_discussion_subitem_qq_group => '加入 QQ 群';
}

// Path: mini_translator
class _TranslationsMiniTranslatorZh extends TranslationsMiniTranslatorEn {
  _TranslationsMiniTranslatorZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get newversion_banner_text_found_new_version => '发现新版本：{}';
  @override
  String get newversion_banner_btn_update => '立即更新';
  @override
  String get limited_banner_title => '功能受限，请根据提示进行检查。';
  @override
  String get limited_banner_text_screen_capture => '授予屏幕录制权限';
  @override
  String get limited_banner_text_screen_selection => '授予辅助功能权限';
  @override
  String get limited_banner_btn_allow => '允许';
  @override
  String get limited_banner_btn_go_settings => '前往设置';
  @override
  String get limited_banner_btn_check_again => '重新检查';
  @override
  String get limited_banner_tip_help => '查看帮助文档';
  @override
  String get limited_banner_msg_allow_access_tip =>
      '点击「授权」后如无任何响应，请点击「前往设置」进行手动设置。';
  @override
  String get limited_banner_msg_all_access_allowed => '屏幕取词功能已启用';
  @override
  String get limited_banner_msg_all_access_not_allowed =>
      '未获得所需权限，\n请重新检查并进行设置。';
  @override
  String get input_hint => '在此处输入单词或文本';
  @override
  String get text_extracting_text => '正在提取文字...';
  @override
  String get tip_translation_mode => '当前翻译模式：{}';
  @override
  String get tip_extract_text_from_screen_capture => '截取屏幕区域并识别文字';
  @override
  String get tip_extract_text_from_clipboard => '读取剪切板内容';
  @override
  String get btn_clear => '清空';
  @override
  String get btn_trans => '翻译';
  @override
  String get msg_please_enter_word_or_text => '未输入或未提取到文本';
  @override
  String get msg_capture_screen_area_canceled => '截取屏幕区域已取消';
}

// Path: page_language_chooser
class _TranslationsPageLanguageChooserZh
    extends TranslationsPageLanguageChooserEn {
  _TranslationsPageLanguageChooserZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get title => '选择语言';
  @override
  String get pref_section_title_all => '全部';
}

// Path: page_ocr_engine_chooser
class _TranslationsPageOcrEngineChooserZh
    extends TranslationsPageOcrEngineChooserEn {
  _TranslationsPageOcrEngineChooserZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get title => '文字识别引擎';
  @override
  String get pref_section_title_private => '私有';
  @override
  String get pref_item_title_no_available_engines => '无可用的引擎';
}

// Path: page_ocr_engine_create_or_edit
class _TranslationsPageOcrEngineCreateOrEditZh
    extends TranslationsPageOcrEngineCreateOrEditEn {
  _TranslationsPageOcrEngineCreateOrEditZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get title => '添加文字识别引擎';
  @override
  String get pref_section_title_engine_type => '引擎类型';
  @override
  String get pref_section_title_option => '选项';
}

// Path: page_ocr_engine_type_chooser
class _TranslationsPageOcrEngineTypeChooserZh
    extends TranslationsPageOcrEngineTypeChooserEn {
  _TranslationsPageOcrEngineTypeChooserZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get title => '引擎类型';
}

// Path: page_ocr_engines_manage
class _TranslationsPageOcrEnginesManageZh
    extends TranslationsPageOcrEnginesManageEn {
  _TranslationsPageOcrEnginesManageZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get title => '文字识别引擎';
  @override
  String get pref_section_title_private => '私有';
  @override
  String get pref_section_description_private => '长按项目以重新排序';
}

// Path: page_setting_app_language
class _TranslationsPageSettingAppLanguageZh
    extends TranslationsPageSettingAppLanguageEn {
  _TranslationsPageSettingAppLanguageZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get title => '显示语言';
}

// Path: page_setting_extract_text
class _TranslationsPageSettingExtractTextZh
    extends TranslationsPageSettingExtractTextEn {
  _TranslationsPageSettingExtractTextZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get title => '取词';
  @override
  String get pref_section_title_default_detect_text_engine => '默认文字识别引擎';
  @override
  String get pref_item_auto_copy_detected_text => '自动复制检测到的文本';
}

// Path: page_setting_interface
class _TranslationsPageSettingInterfaceZh
    extends TranslationsPageSettingInterfaceEn {
  _TranslationsPageSettingInterfaceZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get title => '界面';
  @override
  String get pref_section_title_tray_icon => '托盘图标';
  @override
  String get pref_section_title_tray_icon_style => '托盘图标样式';
  @override
  String get pref_section_title_max_window_height => '最大窗口高度（逻辑像素）';
  @override
  String get pref_item_title_show_tray_icon => '显示托盘图标';
}

// Path: page_setting_shortcuts
class _TranslationsPageSettingShortcutsZh
    extends TranslationsPageSettingShortcutsEn {
  _TranslationsPageSettingShortcutsZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get title => '快捷键';
  @override
  String get pref_section_title_extract_text => '屏幕/剪切板取词';
  @override
  String get pref_section_title_input_assist_function => '输入辅助功能';
  @override
  String get pref_item_title_show_or_hide => '显示/隐藏';
  @override
  String get pref_item_title_hide => '隐藏';
  @override
  String get pref_item_title_extract_text_from_selection => '选中文字';
  @override
  String get pref_item_title_extract_text_from_capture => '截取区域';
  @override
  String get pref_item_title_extract_text_from_clipboard => '剪切板';
  @override
  String get pref_item_title_translate_input_content => '翻译当前输入框内容';
}

// Path: page_setting_theme_mode
class _TranslationsPageSettingThemeModeZh
    extends TranslationsPageSettingThemeModeEn {
  _TranslationsPageSettingThemeModeZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get title => '主题模式';
}

// Path: page_setting_translate
class _TranslationsPageSettingTranslateZh
    extends TranslationsPageSettingTranslateEn {
  _TranslationsPageSettingTranslateZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get title => '翻译';
  @override
  String get pref_section_title_default_translate_engine => '默认翻译引擎';
  @override
  String get pref_section_title_translation_mode => '翻译模式';
  @override
  String get pref_section_title_default_detect_language_engine => '默认语种识别引擎';
  @override
  String get pref_section_title_translation_target => '翻译目标';
  @override
  String get pref_item_title_double_click_copy_result => '双击复制翻译结果';
}

// Path: page_settings
class _TranslationsPageSettingsZh extends TranslationsPageSettingsEn {
  _TranslationsPageSettingsZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get title => '设置';
  @override
  String get text_version => '版本 {} BUILD {}';
  @override
  String get pref_section_title_general => '常规';
  @override
  String get pref_section_title_appearance => '外观';
  @override
  String get pref_section_title_shortcuts => '快捷键';
  @override
  String get pref_section_title_input_settings => '输入设置';
  @override
  String get pref_section_title_advanced => '高级';
  @override
  String get pref_section_title_service_integration => '服务接入';
  @override
  String get pref_section_title_others => '其他';
  @override
  String get pref_item_title_your_plan => '当前会员计划';
  @override
  String get pref_item_title_extract_text => '取词';
  @override
  String get pref_item_title_translate => '翻译';
  @override
  String get pref_item_title_interface => '界面';
  @override
  String get pref_item_title_app_language => '显示语言';
  @override
  String get pref_item_title_theme_mode => '主题模式';
  @override
  String get pref_item_title_keyboard_shortcuts => '键盘快捷键';
  @override
  String get pref_item_title_submit_with_enter => '用 Enter 提交';
  @override
  String get pref_item_title_submit_with_meta_enter => '用 Ctrl + Enter 提交';
  @override
  String get pref_item_title_submit_with_meta_enter_mac => '用 ⌘ + Enter 提交';
  @override
  String get pref_item_title_launch_at_startup => '登录时启动';
  @override
  String get pref_item_title_engines => '文本翻译';
  @override
  String get pref_item_title_ocr_engines => '文字识别';
  @override
  String get pref_item_title_about => '关于比译';
  @override
  String get pref_item_title_exit_app => '退出应用';
  @override
  late final _TranslationsPageSettingsExitAppDialogZh exit_app_dialog =
      _TranslationsPageSettingsExitAppDialogZh._(_root);
}

// Path: page_translation_engine_chooser
class _TranslationsPageTranslationEngineChooserZh
    extends TranslationsPageTranslationEngineChooserEn {
  _TranslationsPageTranslationEngineChooserZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get title => '文本翻译引擎';
  @override
  String get pref_section_title_private => '私有';
  @override
  String get pref_item_title_no_available_engines => '无可用的引擎';
}

// Path: page_translation_engine_create_or_edit
class _TranslationsPageTranslationEngineCreateOrEditZh
    extends TranslationsPageTranslationEngineCreateOrEditEn {
  _TranslationsPageTranslationEngineCreateOrEditZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get title => '添加文本翻译引擎';
  @override
  String get pref_section_title_engine_type => '引擎类型';
  @override
  String get pref_section_title_support_interface => '支持接口';
  @override
  String get pref_section_title_option => '选项';
}

// Path: page_translation_engine_type_chooser
class _TranslationsPageTranslationEngineTypeChooserZh
    extends TranslationsPageTranslationEngineTypeChooserEn {
  _TranslationsPageTranslationEngineTypeChooserZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get title => '引擎类型';
}

// Path: page_translation_engines_manage
class _TranslationsPageTranslationEnginesManageZh
    extends TranslationsPageTranslationEnginesManageEn {
  _TranslationsPageTranslationEnginesManageZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get title => '文本翻译引擎';
  @override
  String get pref_section_title_private => '私有';
  @override
  String get pref_section_description_private => '长按项目以重新排序';
}

// Path: page_translation_target_new
class _TranslationsPageTranslationTargetNewZh
    extends TranslationsPageTranslationTargetNewEn {
  _TranslationsPageTranslationTargetNewZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get title => '添加翻译目标';
  @override
  String get title_with_edit => '编辑翻译目标';
  @override
  String get source_language => '源语言';
  @override
  String get target_language => '目标语言';
}

// Path: page_your_plan_selector
class _TranslationsPageYourPlanSelectorZh
    extends TranslationsPageYourPlanSelectorEn {
  _TranslationsPageYourPlanSelectorZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get title => '选择您的会员计划';
  @override
  String get label_free => '免费';
  @override
  String get label_forever => '永久';
  @override
  String get btn_plan_benefits => '会员权益';
  @override
  String get btn_activate => '立即激活';
  @override
  String get activation_code_input_hint => '请输入激活码';
  @override
  String get pref_section_title_plans => '选择适合您的会员方案。';
  @override
  String get pref_section_title_activate_your_plan => '激活您的会员计划';
  @override
  String get pref_section_title_your_plan_expiry_date => '您的计划到期日';
  @override
  String get pref_item_title_get_activation_code => '获取会员计划激活码';
  @override
  String get msg_plan_pro_coming_soon => '即将推出，敬请期待。';
}

// Path: widget_record_shortcut_dialog
class _TranslationsWidgetRecordShortcutDialogZh
    extends TranslationsWidgetRecordShortcutDialogEn {
  _TranslationsWidgetRecordShortcutDialogZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get title => '自定义快捷键';
}

// Path: page_settings.exit_app_dialog
class _TranslationsPageSettingsExitAppDialogZh
    extends TranslationsPageSettingsExitAppDialogEn {
  _TranslationsPageSettingsExitAppDialogZh._(TranslationsZh root)
      : this._root = root,
        super.internal(root);

  final TranslationsZh _root; // ignore: unused_field

  // Translations
  @override
  String get title => '您确定要退出吗？';
}

/// The flat map containing all translations for locale <zh>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsZh {
  dynamic _flatMapFunction(String path) {
    return switch (path) {
      'app_name' => '比译',
      'ok' => '确定',
      'cancel' => '取消',
      'add' => '添加',
      'delete' => '删除',
      'copied' => '已复制',
      'please_choose' => '请选择',
      'language.af' => '布尔语(南非荷兰语)',
      'language.am' => '阿姆哈拉语',
      'language.ar' => '阿拉伯语',
      'language.az' => '阿塞拜疆语',
      'language.be' => '白俄罗斯语',
      'language.bg' => '保加利亚语',
      'language.bn' => '孟加拉语',
      'language.bs' => '波斯尼亚语',
      'language.ca' => '加泰罗尼亚语',
      'language.ceb' => '宿务语',
      'language.co' => '科西嘉语',
      'language.cs' => '捷克语',
      'language.cy' => '威尔士语',
      'language.da' => '丹麦语',
      'language.de' => '德语',
      'language.el' => '希腊语',
      'language.en' => '英语',
      'language.eo' => '世界语',
      'language.es' => '西班牙语',
      'language.et' => '爱沙尼亚语',
      'language.eu' => '巴斯克语',
      'language.fa' => '波斯语',
      'language.fi' => '芬兰语',
      'language.fr' => '法语',
      'language.fy' => '弗里西语',
      'language.ga' => '爱尔兰语',
      'language.gd' => '苏格兰盖尔语',
      'language.gl' => '加利西亚语',
      'language.gu' => '古吉拉特语',
      'language.ha' => '豪萨语',
      'language.haw' => '夏威夷语',
      'language.he' => '希伯来语',
      'language.hi' => '印地语',
      'language.hmn' => '苗语',
      'language.hr' => '克罗地亚语',
      'language.ht' => '海地克里奥尔语',
      'language.hu' => '匈牙利语',
      'language.hy' => '亚美尼亚语',
      'language.id' => '印尼语',
      'language.ig' => '伊博语',
      'language.kIs' => '冰岛语',
      'language.it' => '意大利语',
      'language.iw' => '希伯来语',
      'language.ja' => '日语',
      'language.jw' => '印尼爪哇语',
      'language.ka' => '格鲁吉亚语',
      'language.kk' => '哈萨克语',
      'language.km' => '高棉语',
      'language.kn' => '卡纳达语',
      'language.ko' => '韩语',
      'language.ku' => '库尔德语',
      'language.ky' => '吉尔吉斯语',
      'language.la' => '拉丁语',
      'language.lb' => '卢森堡语',
      'language.lo' => '老挝语',
      'language.lt' => '立陶宛语',
      'language.lv' => '拉脱维亚语',
      'language.mg' => '马尔加什语',
      'language.mi' => '毛利语',
      'language.mk' => '马其顿语',
      'language.ml' => '马拉雅拉姆语',
      'language.mn' => '蒙古语',
      'language.mr' => '马拉地语',
      'language.ms' => '马来语',
      'language.mt' => '马耳他语',
      'language.my' => '缅甸语',
      'language.ne' => '尼泊尔语',
      'language.nl' => '荷兰语',
      'language.no' => '挪威语',
      'language.ny' => '齐切瓦语',
      'language.or' => '奥利亚语',
      'language.pa' => '旁遮普语',
      'language.pl' => '波兰语',
      'language.ps' => '普什图语',
      'language.pt' => '葡萄牙语',
      'language.ro' => '罗马尼亚语',
      'language.ru' => '俄语',
      'language.rw' => '卢旺达语',
      'language.sd' => '信德语',
      'language.si' => '僧伽罗语',
      'language.sk' => '斯洛伐克语',
      'language.sl' => '斯洛文尼亚语',
      'language.sm' => '萨摩亚语',
      'language.sn' => '修纳语',
      'language.so' => '索马里语',
      'language.sq' => '阿尔巴尼亚语',
      'language.sr' => '塞尔维亚语',
      'language.st' => '塞索托语',
      'language.su' => '印尼巽他语',
      'language.sv' => '瑞典语',
      'language.sw' => '斯瓦希里语',
      'language.ta' => '泰米尔语',
      'language.te' => '泰卢固语',
      'language.tg' => '塔吉克语',
      'language.th' => '泰语',
      'language.tk' => '土库曼语',
      'language.tl' => '菲律宾语',
      'language.tr' => '土耳其语',
      'language.tt' => '鞑靼语',
      'language.ug' => '维吾尔语',
      'language.uk' => '乌克兰语',
      'language.ur' => '乌尔都语',
      'language.uz' => '乌兹别克语',
      'language.vi' => '越南语',
      'language.xh' => '南非科萨语',
      'language.yi' => '意第绪语',
      'language.yo' => '约鲁巴语',
      'language.zh' => '中文',
      'language.zh_CN' => '中文',
      'language.zh_TW' => '中文(繁体)',
      'language.zu' => '南非祖鲁语',
      'engine.baidu' => '百度翻译',
      'engine.caiyun' => '彩云小译',
      'engine.deepl' => 'DeepL',
      'engine.google' => '谷歌翻译',
      'engine.ibmwatson' => 'IBMWatson',
      'engine.iciba' => '爱词霸',
      'engine.openai' => 'OpenAI',
      'engine.sogou' => '搜狗翻译',
      'engine.tencent' => '腾讯翻译君',
      'engine.youdao' => '有道翻译',
      'engine_scope.detectlanguage' => '语种识别',
      'engine_scope.lookup' => '查词',
      'engine_scope.translate' => '翻译',
      'ocr_engine.built_in' => '内置',
      'ocr_engine.tesseract' => 'Tesseract OCR',
      'ocr_engine.youdao' => '有道通用文字识别',
      'translation_mode.auto' => '自动',
      'translation_mode.manual' => '手动',
      'theme_mode.light' => '浅色',
      'theme_mode.dark' => '深色',
      'theme_mode.system' => '跟随系统',
      'word_pronunciation.us' => '美',
      'word_pronunciation.uk' => '英',
      'tray_context_menu.item_show' => '显示',
      'tray_context_menu.item_quick_start_guide' => '快速入门',
      'tray_context_menu.item_discussion' => '加入讨论',
      'tray_context_menu.item_quit_app' => '退出比译',
      'tray_context_menu.item_discussion_subitem_discord_server' =>
        '加入 Discord',
      'tray_context_menu.item_discussion_subitem_qq_group' => '加入 QQ 群',
      'mini_translator.newversion_banner_text_found_new_version' => '发现新版本：{}',
      'mini_translator.newversion_banner_btn_update' => '立即更新',
      'mini_translator.limited_banner_title' => '功能受限，请根据提示进行检查。',
      'mini_translator.limited_banner_text_screen_capture' => '授予屏幕录制权限',
      'mini_translator.limited_banner_text_screen_selection' => '授予辅助功能权限',
      'mini_translator.limited_banner_btn_allow' => '允许',
      'mini_translator.limited_banner_btn_go_settings' => '前往设置',
      'mini_translator.limited_banner_btn_check_again' => '重新检查',
      'mini_translator.limited_banner_tip_help' => '查看帮助文档',
      'mini_translator.limited_banner_msg_allow_access_tip' =>
        '点击「授权」后如无任何响应，请点击「前往设置」进行手动设置。',
      'mini_translator.limited_banner_msg_all_access_allowed' => '屏幕取词功能已启用',
      'mini_translator.limited_banner_msg_all_access_not_allowed' =>
        '未获得所需权限，\n请重新检查并进行设置。',
      'mini_translator.input_hint' => '在此处输入单词或文本',
      'mini_translator.text_extracting_text' => '正在提取文字...',
      'mini_translator.tip_translation_mode' => '当前翻译模式：{}',
      'mini_translator.tip_extract_text_from_screen_capture' => '截取屏幕区域并识别文字',
      'mini_translator.tip_extract_text_from_clipboard' => '读取剪切板内容',
      'mini_translator.btn_clear' => '清空',
      'mini_translator.btn_trans' => '翻译',
      'mini_translator.msg_please_enter_word_or_text' => '未输入或未提取到文本',
      'mini_translator.msg_capture_screen_area_canceled' => '截取屏幕区域已取消',
      'page_language_chooser.title' => '选择语言',
      'page_language_chooser.pref_section_title_all' => '全部',
      'page_ocr_engine_chooser.title' => '文字识别引擎',
      'page_ocr_engine_chooser.pref_section_title_private' => '私有',
      'page_ocr_engine_chooser.pref_item_title_no_available_engines' =>
        '无可用的引擎',
      'page_ocr_engine_create_or_edit.title' => '添加文字识别引擎',
      'page_ocr_engine_create_or_edit.pref_section_title_engine_type' => '引擎类型',
      'page_ocr_engine_create_or_edit.pref_section_title_option' => '选项',
      'page_ocr_engine_type_chooser.title' => '引擎类型',
      'page_ocr_engines_manage.title' => '文字识别引擎',
      'page_ocr_engines_manage.pref_section_title_private' => '私有',
      'page_ocr_engines_manage.pref_section_description_private' => '长按项目以重新排序',
      'page_setting_app_language.title' => '显示语言',
      'page_setting_extract_text.title' => '取词',
      'page_setting_extract_text.pref_section_title_default_detect_text_engine' =>
        '默认文字识别引擎',
      'page_setting_extract_text.pref_item_auto_copy_detected_text' =>
        '自动复制检测到的文本',
      'page_setting_interface.title' => '界面',
      'page_setting_interface.pref_section_title_tray_icon' => '托盘图标',
      'page_setting_interface.pref_section_title_tray_icon_style' => '托盘图标样式',
      'page_setting_interface.pref_section_title_max_window_height' =>
        '最大窗口高度（逻辑像素）',
      'page_setting_interface.pref_item_title_show_tray_icon' => '显示托盘图标',
      'page_setting_shortcuts.title' => '快捷键',
      'page_setting_shortcuts.pref_section_title_extract_text' => '屏幕/剪切板取词',
      'page_setting_shortcuts.pref_section_title_input_assist_function' =>
        '输入辅助功能',
      'page_setting_shortcuts.pref_item_title_show_or_hide' => '显示/隐藏',
      'page_setting_shortcuts.pref_item_title_hide' => '隐藏',
      'page_setting_shortcuts.pref_item_title_extract_text_from_selection' =>
        '选中文字',
      'page_setting_shortcuts.pref_item_title_extract_text_from_capture' =>
        '截取区域',
      'page_setting_shortcuts.pref_item_title_extract_text_from_clipboard' =>
        '剪切板',
      'page_setting_shortcuts.pref_item_title_translate_input_content' =>
        '翻译当前输入框内容',
      'page_setting_theme_mode.title' => '主题模式',
      'page_setting_translate.title' => '翻译',
      'page_setting_translate.pref_section_title_default_translate_engine' =>
        '默认翻译引擎',
      'page_setting_translate.pref_section_title_translation_mode' => '翻译模式',
      'page_setting_translate.pref_section_title_default_detect_language_engine' =>
        '默认语种识别引擎',
      'page_setting_translate.pref_section_title_translation_target' => '翻译目标',
      'page_setting_translate.pref_item_title_double_click_copy_result' =>
        '双击复制翻译结果',
      'page_settings.title' => '设置',
      'page_settings.text_version' => '版本 {} BUILD {}',
      'page_settings.pref_section_title_general' => '常规',
      'page_settings.pref_section_title_appearance' => '外观',
      'page_settings.pref_section_title_shortcuts' => '快捷键',
      'page_settings.pref_section_title_input_settings' => '输入设置',
      'page_settings.pref_section_title_advanced' => '高级',
      'page_settings.pref_section_title_service_integration' => '服务接入',
      'page_settings.pref_section_title_others' => '其他',
      'page_settings.pref_item_title_your_plan' => '当前会员计划',
      'page_settings.pref_item_title_extract_text' => '取词',
      'page_settings.pref_item_title_translate' => '翻译',
      'page_settings.pref_item_title_interface' => '界面',
      'page_settings.pref_item_title_app_language' => '显示语言',
      'page_settings.pref_item_title_theme_mode' => '主题模式',
      'page_settings.pref_item_title_keyboard_shortcuts' => '键盘快捷键',
      'page_settings.pref_item_title_submit_with_enter' => '用 Enter 提交',
      'page_settings.pref_item_title_submit_with_meta_enter' =>
        '用 Ctrl + Enter 提交',
      'page_settings.pref_item_title_submit_with_meta_enter_mac' =>
        '用 ⌘ + Enter 提交',
      'page_settings.pref_item_title_launch_at_startup' => '登录时启动',
      'page_settings.pref_item_title_engines' => '文本翻译',
      'page_settings.pref_item_title_ocr_engines' => '文字识别',
      'page_settings.pref_item_title_about' => '关于比译',
      'page_settings.pref_item_title_exit_app' => '退出应用',
      'page_settings.exit_app_dialog.title' => '您确定要退出吗？',
      'page_translation_engine_chooser.title' => '文本翻译引擎',
      'page_translation_engine_chooser.pref_section_title_private' => '私有',
      'page_translation_engine_chooser.pref_item_title_no_available_engines' =>
        '无可用的引擎',
      'page_translation_engine_create_or_edit.title' => '添加文本翻译引擎',
      'page_translation_engine_create_or_edit.pref_section_title_engine_type' =>
        '引擎类型',
      'page_translation_engine_create_or_edit.pref_section_title_support_interface' =>
        '支持接口',
      'page_translation_engine_create_or_edit.pref_section_title_option' =>
        '选项',
      'page_translation_engine_type_chooser.title' => '引擎类型',
      'page_translation_engines_manage.title' => '文本翻译引擎',
      'page_translation_engines_manage.pref_section_title_private' => '私有',
      'page_translation_engines_manage.pref_section_description_private' =>
        '长按项目以重新排序',
      'page_translation_target_new.title' => '添加翻译目标',
      'page_translation_target_new.title_with_edit' => '编辑翻译目标',
      'page_translation_target_new.source_language' => '源语言',
      'page_translation_target_new.target_language' => '目标语言',
      'page_your_plan_selector.title' => '选择您的会员计划',
      'page_your_plan_selector.label_free' => '免费',
      'page_your_plan_selector.label_forever' => '永久',
      'page_your_plan_selector.btn_plan_benefits' => '会员权益',
      'page_your_plan_selector.btn_activate' => '立即激活',
      'page_your_plan_selector.activation_code_input_hint' => '请输入激活码',
      'page_your_plan_selector.pref_section_title_plans' => '选择适合您的会员方案。',
      'page_your_plan_selector.pref_section_title_activate_your_plan' =>
        '激活您的会员计划',
      'page_your_plan_selector.pref_section_title_your_plan_expiry_date' =>
        '您的计划到期日',
      'page_your_plan_selector.pref_item_title_get_activation_code' =>
        '获取会员计划激活码',
      'page_your_plan_selector.msg_plan_pro_coming_soon' => '即将推出，敬请期待。',
      'widget_record_shortcut_dialog.title' => '自定义快捷键',
      _ => null,
    };
  }
}
