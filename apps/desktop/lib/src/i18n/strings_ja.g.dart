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
class TranslationsJa extends Translations
    with BaseTranslations<AppLocale, Translations> {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsJa(
      {Map<String, Node>? overrides,
      PluralResolver? cardinalResolver,
      PluralResolver? ordinalResolver,
      TranslationMetadata<AppLocale, Translations>? meta})
      : assert(overrides == null,
            'Set "translation_overrides: true" in order to enable this feature.'),
        $meta = meta ??
            TranslationMetadata(
              locale: AppLocale.ja,
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

  /// Metadata for the translations of <ja>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  /// Access flat map
  @override
  dynamic operator [](String key) =>
      $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

  late final TranslationsJa _root = this; // ignore: unused_field

  @override
  TranslationsJa $copyWith(
          {TranslationMetadata<AppLocale, Translations>? meta}) =>
      TranslationsJa(meta: meta ?? this.$meta);

  // Translations
  @override
  late final _TranslationsCommonJa common = _TranslationsCommonJa._(_root);
  @override
  late final _TranslationsAppJa app = _TranslationsAppJa._(_root);
  @override
  late final _TranslationsMiniTranslatorJa mini_translator =
      _TranslationsMiniTranslatorJa._(_root);
  @override
  late final _TranslationsSettingsJa settings =
      _TranslationsSettingsJa._(_root);
}

// Path: common
class _TranslationsCommonJa extends TranslationsCommonEn {
  _TranslationsCommonJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsCommonUiJa ui = _TranslationsCommonUiJa._(_root);
  @override
  late final _TranslationsCommonLanguageJa language =
      _TranslationsCommonLanguageJa._(_root);
  @override
  late final _TranslationsCommonThemeModeJa theme_mode =
      _TranslationsCommonThemeModeJa._(_root);
  @override
  late final _TranslationsCommonProviderJa provider =
      _TranslationsCommonProviderJa._(_root);
  @override
  late final _TranslationsCommonWordPronunciationJa word_pronunciation =
      _TranslationsCommonWordPronunciationJa._(_root);
}

// Path: app
class _TranslationsAppJa extends TranslationsAppEn {
  _TranslationsAppJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsAppTrayJa tray = _TranslationsAppTrayJa._(_root);
}

// Path: mini_translator
class _TranslationsMiniTranslatorJa extends TranslationsMiniTranslatorEn {
  _TranslationsMiniTranslatorJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsMiniTranslatorLimitedBannerJa limited_banner =
      _TranslationsMiniTranslatorLimitedBannerJa._(_root);
  @override
  late final _TranslationsMiniTranslatorInputJa input =
      _TranslationsMiniTranslatorInputJa._(_root);
  @override
  late final _TranslationsMiniTranslatorToolbarJa toolbar =
      _TranslationsMiniTranslatorToolbarJa._(_root);
  @override
  late final _TranslationsMiniTranslatorButtonJa button =
      _TranslationsMiniTranslatorButtonJa._(_root);
  @override
  late final _TranslationsMiniTranslatorLanguageJa language =
      _TranslationsMiniTranslatorLanguageJa._(_root);
  @override
  late final _TranslationsMiniTranslatorMessageJa message =
      _TranslationsMiniTranslatorMessageJa._(_root);
}

// Path: settings
class _TranslationsSettingsJa extends TranslationsSettingsEn {
  _TranslationsSettingsJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get version => 'バージョン {} BUILD {}';
  @override
  late final _TranslationsSettingsGeneralJa general =
      _TranslationsSettingsGeneralJa._(_root);
  @override
  late final _TranslationsSettingsAppearanceJa appearance =
      _TranslationsSettingsAppearanceJa._(_root);
  @override
  late final _TranslationsSettingsShortcutsJa shortcuts =
      _TranslationsSettingsShortcutsJa._(_root);
  @override
  late final _TranslationsSettingsAdvancedJa advanced =
      _TranslationsSettingsAdvancedJa._(_root);
  @override
  late final _TranslationsSettingsProvidersJa providers =
      _TranslationsSettingsProvidersJa._(_root);
  @override
  late final _TranslationsSettingsLayoutJa layout =
      _TranslationsSettingsLayoutJa._(_root);
}

// Path: common.ui
class _TranslationsCommonUiJa extends TranslationsCommonUiEn {
  _TranslationsCommonUiJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsCommonUiButtonJa button =
      _TranslationsCommonUiButtonJa._(_root);
  @override
  late final _TranslationsCommonUiFeedbackJa feedback =
      _TranslationsCommonUiFeedbackJa._(_root);
}

// Path: common.language
class _TranslationsCommonLanguageJa extends TranslationsCommonLanguageEn {
  _TranslationsCommonLanguageJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get ar => 'アラビア語';
  @override
  String get bn => 'ベンガル語';
  @override
  String get de => 'ドイツ語';
  @override
  String get en => '英語';
  @override
  String get es => 'スペイン語';
  @override
  String get fa => 'ペルシア語';
  @override
  String get fr => 'フランス語';
  @override
  String get gu => 'グジャラート語';
  @override
  String get ha => 'ハウサ語';
  @override
  String get hi => 'ヒンディー語';
  @override
  String get id => 'インドネシア語';
  @override
  String get it => 'イタリア語';
  @override
  String get ja => '日本語';
  @override
  String get jv => 'ジャワ語';
  @override
  String get ko => '韓国語';
  @override
  String get ml => 'マラヤーラム語';
  @override
  String get mr => 'マラーティー語';
  @override
  String get ms => 'マレー語';
  @override
  String get nl => 'オランダ語';
  @override
  String get pa => 'パンジャブ語';
  @override
  String get pl => 'ポーランド語';
  @override
  String get pt => 'ポルトガル語';
  @override
  String get ro => 'ルーマニア語';
  @override
  String get ru => 'ロシア語';
  @override
  String get sw => 'スワヒリ語';
  @override
  String get ta => 'タミル語';
  @override
  String get te => 'テルグ語';
  @override
  String get th => 'タイ語';
  @override
  String get tr => 'トルコ語';
  @override
  String get uk => 'ウクライナ語';
  @override
  String get ur => 'ウルドゥー語';
  @override
  String get vi => 'ベトナム語';
  @override
  String get yo => 'ヨルバ語';
  @override
  String get zh_hans => '簡体字中国語';
  @override
  String get zh_hant => '繁体字中国語';
}

// Path: common.theme_mode
class _TranslationsCommonThemeModeJa extends TranslationsCommonThemeModeEn {
  _TranslationsCommonThemeModeJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get light => 'ライト';
  @override
  String get dark => 'ダーク';
  @override
  String get system => 'システム';
}

// Path: common.provider
class _TranslationsCommonProviderJa extends TranslationsCommonProviderEn {
  _TranslationsCommonProviderJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

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
  String get system => 'システム';
  @override
  String get tencent => 'Tencent';
  @override
  String get youdao => 'Youda';
}

// Path: common.word_pronunciation
class _TranslationsCommonWordPronunciationJa
    extends TranslationsCommonWordPronunciationEn {
  _TranslationsCommonWordPronunciationJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get us => '米国';
  @override
  String get uk => '英国';
}

// Path: app.tray
class _TranslationsAppTrayJa extends TranslationsAppTrayEn {
  _TranslationsAppTrayJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsAppTrayContextMenuJa context_menu =
      _TranslationsAppTrayContextMenuJa._(_root);
}

// Path: mini_translator.limited_banner
class _TranslationsMiniTranslatorLimitedBannerJa
    extends TranslationsMiniTranslatorLimitedBannerEn {
  _TranslationsMiniTranslatorLimitedBannerJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsMiniTranslatorLimitedBannerPermissionJa permission =
      _TranslationsMiniTranslatorLimitedBannerPermissionJa._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerInstructionJa instruction =
      _TranslationsMiniTranslatorLimitedBannerInstructionJa._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerActionJa action =
      _TranslationsMiniTranslatorLimitedBannerActionJa._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerFeedbackJa feedback =
      _TranslationsMiniTranslatorLimitedBannerFeedbackJa._(_root);
  @override
  late final _TranslationsMiniTranslatorLimitedBannerTooltipJa tooltip =
      _TranslationsMiniTranslatorLimitedBannerTooltipJa._(_root);
}

// Path: mini_translator.input
class _TranslationsMiniTranslatorInputJa
    extends TranslationsMiniTranslatorInputEn {
  _TranslationsMiniTranslatorInputJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get hint => 'ここに単語またはテキストを入力';
  @override
  String get extracting_text => 'テキストを抽出中...';
}

// Path: mini_translator.toolbar
class _TranslationsMiniTranslatorToolbarJa
    extends TranslationsMiniTranslatorToolbarEn {
  _TranslationsMiniTranslatorToolbarJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsMiniTranslatorToolbarTooltipJa tooltip =
      _TranslationsMiniTranslatorToolbarTooltipJa._(_root);
}

// Path: mini_translator.button
class _TranslationsMiniTranslatorButtonJa
    extends TranslationsMiniTranslatorButtonEn {
  _TranslationsMiniTranslatorButtonJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get clear => 'クリア';
  @override
  String get translate => '翻訳';
}

// Path: mini_translator.language
class _TranslationsMiniTranslatorLanguageJa
    extends TranslationsMiniTranslatorLanguageEn {
  _TranslationsMiniTranslatorLanguageJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get auto_detect => '自動検出';
  @override
  String get auto_match => '自動一致';
  @override
  String get switch_config => 'ターゲット切替';
  @override
  String get more_languages => 'その他の言語...';
  @override
  String get manage_common_languages => 'よく使う言語を管理...';
  @override
  String get manage_targets => '翻訳ターゲットを管理...';
  @override
  String get add_target => '翻訳ターゲットを追加...';
}

// Path: mini_translator.message
class _TranslationsMiniTranslatorMessageJa
    extends TranslationsMiniTranslatorMessageEn {
  _TranslationsMiniTranslatorMessageJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get please_enter_word_or_text => 'テキストが入力されていないか、テキストが抽出されていません';
  @override
  String get capture_screen_area_canceled => '画面領域のキャプチャがキャンセルされました';
}

// Path: settings.general
class _TranslationsSettingsGeneralJa extends TranslationsSettingsGeneralEn {
  _TranslationsSettingsGeneralJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => '一般';
  @override
  late final _TranslationsSettingsGeneralSectionJa section =
      _TranslationsSettingsGeneralSectionJa._(_root);
  @override
  late final _TranslationsSettingsGeneralRowJa row =
      _TranslationsSettingsGeneralRowJa._(_root);
  @override
  late final _TranslationsSettingsGeneralButtonJa button =
      _TranslationsSettingsGeneralButtonJa._(_root);
  @override
  late final _TranslationsSettingsGeneralOptionJa option =
      _TranslationsSettingsGeneralOptionJa._(_root);
  @override
  late final _TranslationsSettingsGeneralEditorJa editor =
      _TranslationsSettingsGeneralEditorJa._(_root);
}

// Path: settings.appearance
class _TranslationsSettingsAppearanceJa
    extends TranslationsSettingsAppearanceEn {
  _TranslationsSettingsAppearanceJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => '外観';
  @override
  late final _TranslationsSettingsAppearanceSectionJa section =
      _TranslationsSettingsAppearanceSectionJa._(_root);
}

// Path: settings.shortcuts
class _TranslationsSettingsShortcutsJa extends TranslationsSettingsShortcutsEn {
  _TranslationsSettingsShortcutsJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'ショートカット';
  @override
  late final _TranslationsSettingsShortcutsSectionJa section =
      _TranslationsSettingsShortcutsSectionJa._(_root);
  @override
  late final _TranslationsSettingsShortcutsRowJa row =
      _TranslationsSettingsShortcutsRowJa._(_root);
  @override
  late final _TranslationsSettingsShortcutsResetDialogJa reset_dialog =
      _TranslationsSettingsShortcutsResetDialogJa._(_root);
}

// Path: settings.advanced
class _TranslationsSettingsAdvancedJa extends TranslationsSettingsAdvancedEn {
  _TranslationsSettingsAdvancedJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => '詳細設定';
  @override
  String get api_server => 'ローカルAPIサーバー';
  @override
  String get api_server_description =>
      'ローカルインテグレーションのために127.0.0.1で翻訳APIを公開します。';
  @override
  String get enable => '有効';
  @override
  String get port => 'ポート';
  @override
  String get running_at => '{url} で実行中';
  @override
  String get disabled => '無効';
}

// Path: settings.providers
class _TranslationsSettingsProvidersJa extends TranslationsSettingsProvidersEn {
  _TranslationsSettingsProvidersJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'プロバイダー';
  @override
  late final _TranslationsSettingsProvidersSectionJa section =
      _TranslationsSettingsProvidersSectionJa._(_root);
  @override
  late final _TranslationsSettingsProvidersItemJa item =
      _TranslationsSettingsProvidersItemJa._(_root);
  @override
  late final _TranslationsSettingsProvidersButtonJa button =
      _TranslationsSettingsProvidersButtonJa._(_root);
  @override
  late final _TranslationsSettingsProvidersAlertJa alert =
      _TranslationsSettingsProvidersAlertJa._(_root);
  @override
  late final _TranslationsSettingsProvidersIntroJa intro =
      _TranslationsSettingsProvidersIntroJa._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorJa editor =
      _TranslationsSettingsProvidersEditorJa._(_root);
  @override
  late final _TranslationsSettingsProvidersDetailJa detail =
      _TranslationsSettingsProvidersDetailJa._(_root);
  @override
  late final _TranslationsSettingsProvidersCapabilityJa capability =
      _TranslationsSettingsProvidersCapabilityJa._(_root);
  @override
  late final _TranslationsSettingsProvidersDescriptionJa description =
      _TranslationsSettingsProvidersDescriptionJa._(_root);
  @override
  late final _TranslationsSettingsProvidersDeleteDialogJa delete_dialog =
      _TranslationsSettingsProvidersDeleteDialogJa._(_root);
}

// Path: settings.layout
class _TranslationsSettingsLayoutJa extends TranslationsSettingsLayoutEn {
  _TranslationsSettingsLayoutJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => '設定';
  @override
  late final _TranslationsSettingsLayoutEmptyJa empty =
      _TranslationsSettingsLayoutEmptyJa._(_root);
}

// Path: common.ui.button
class _TranslationsCommonUiButtonJa extends TranslationsCommonUiButtonEn {
  _TranslationsCommonUiButtonJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get ok => 'OK';
  @override
  String get cancel => 'キャンセル';
  @override
  String get add => '追加';
  @override
  String get delete => '削除';
  @override
  String get edit => '編集';
  @override
  String get save => '保存';
  @override
  String get manage => '管理';
  @override
  String get kContinue => '続行';
}

// Path: common.ui.feedback
class _TranslationsCommonUiFeedbackJa extends TranslationsCommonUiFeedbackEn {
  _TranslationsCommonUiFeedbackJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get copied => 'コピーしました';
}

// Path: app.tray.context_menu
class _TranslationsAppTrayContextMenuJa
    extends TranslationsAppTrayContextMenuEn {
  _TranslationsAppTrayContextMenuJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get show_window => 'ウィンドウを表示';
  @override
  late final _TranslationsAppTrayContextMenuDevToolsJa dev_tools =
      _TranslationsAppTrayContextMenuDevToolsJa._(_root);
  @override
  String get check_for_updates => 'アップデートを確認';
  @override
  String get settings => '設定';
  @override
  String get quit => '終了';
}

// Path: mini_translator.limited_banner.permission
class _TranslationsMiniTranslatorLimitedBannerPermissionJa
    extends TranslationsMiniTranslatorLimitedBannerPermissionEn {
  _TranslationsMiniTranslatorLimitedBannerPermissionJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get missing_both => 'すべての機能を有効にするには、画面収録とアクセシビリティの許可を付与してください。';
  @override
  String get missing_screen_capture => 'すべての機能を有効にするには、画面収録の許可を付与してください。';
  @override
  String get missing_accessibility => 'すべての機能を有効にするには、アクセシビリティの許可を付与してください。';
}

// Path: mini_translator.limited_banner.instruction
class _TranslationsMiniTranslatorLimitedBannerInstructionJa
    extends TranslationsMiniTranslatorLimitedBannerInstructionEn {
  _TranslationsMiniTranslatorLimitedBannerInstructionJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get app_settings_prefix => 'アプリ設定に移動';
  @override
  String get follow_guide_prefix => 'し、ガイドに従って';
  @override
  String get suffix => 'をクリックしてください。';
}

// Path: mini_translator.limited_banner.action
class _TranslationsMiniTranslatorLimitedBannerActionJa
    extends TranslationsMiniTranslatorLimitedBannerActionEn {
  _TranslationsMiniTranslatorLimitedBannerActionJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get app_settings => 'アプリ設定';
  @override
  String get recheck => '再確認';
}

// Path: mini_translator.limited_banner.feedback
class _TranslationsMiniTranslatorLimitedBannerFeedbackJa
    extends TranslationsMiniTranslatorLimitedBannerFeedbackEn {
  _TranslationsMiniTranslatorLimitedBannerFeedbackJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get enabled => '画面テキスト抽出が有効です。';
  @override
  String get still_missing => '必要な権限がまだ不足しています。\n設定を確認して、もう一度お試しください。';
}

// Path: mini_translator.limited_banner.tooltip
class _TranslationsMiniTranslatorLimitedBannerTooltipJa
    extends TranslationsMiniTranslatorLimitedBannerTooltipEn {
  _TranslationsMiniTranslatorLimitedBannerTooltipJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get help => 'ヘルプを表示';
}

// Path: mini_translator.toolbar.tooltip
class _TranslationsMiniTranslatorToolbarTooltipJa
    extends TranslationsMiniTranslatorToolbarTooltipEn {
  _TranslationsMiniTranslatorToolbarTooltipJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get extract_text_from_screen_capture => '画面領域をキャプチャしてテキストを認識';
  @override
  String get extract_text_from_clipboard => 'クリップボードの内容を読み取る';
}

// Path: settings.general.section
class _TranslationsSettingsGeneralSectionJa
    extends TranslationsSettingsGeneralSectionEn {
  _TranslationsSettingsGeneralSectionJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get permissions => '権限';
  @override
  String get ocr => 'テキスト認識';
  @override
  String get directory => '辞書';
  @override
  String get translation => '翻訳';
  @override
  String get translation_target => '翻訳先';
  @override
  String get languages => '言語';
  @override
  String get input => '入力設定';
}

// Path: settings.general.row
class _TranslationsSettingsGeneralRowJa
    extends TranslationsSettingsGeneralRowEn {
  _TranslationsSettingsGeneralRowJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get launch_at_startup => 'ログイン時に起動';
  @override
  String get show_in_menu_bar => 'メニューバーに表示';
  @override
  String get screen_capture_access => '画面収録へのアクセスを許可';
  @override
  String get screen_selection_access => 'アクセシビリティへのアクセスを許可';
  @override
  String get default_ocr_service => 'デフォルトのテキスト認識サービス';
  @override
  String get auto_copy_detected_text => '検出したテキストを自動コピー';
  @override
  String get default_directory_service => 'デフォルトの辞書サービス';
  @override
  String get default_translation_service => 'デフォルトの翻訳サービス';
  @override
  String get common_languages => 'よく使う言語';
  @override
  String get common_languages_hint => '言語セレクターの上部に表示する言語を選択してください。';
  @override
  String get common_languages_reset => 'デフォルトにリセット';
  @override
  String get common_languages_reset_help => 'デフォルトのよく使う言語セットにリセット';
  @override
  String get double_click_copy_result => 'ダブルクリックで翻訳結果をコピー';
  @override
  String get submit_with_enter => 'Enterで送信';
  @override
  String get submit_with_meta_enter_mac => '⌘ + Enterで送信';
}

// Path: settings.general.button
class _TranslationsSettingsGeneralButtonJa
    extends TranslationsSettingsGeneralButtonEn {
  _TranslationsSettingsGeneralButtonJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get add_provider => '追加...';
  @override
  String get add_target => '対象を追加';
  @override
  String get manage_targets => '翻訳ターゲットを管理...';
  @override
  String get grant => '許可';
}

// Path: settings.general.option
class _TranslationsSettingsGeneralOptionJa
    extends TranslationsSettingsGeneralOptionEn {
  _TranslationsSettingsGeneralOptionJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get none => 'なし';
  @override
  String get no_services_available => '利用可能なサービスがありません';
  @override
  String get granted => '許可済み';
  @override
  String get built_in_ocr => '内蔵OCR';
  @override
  String get tesseract => 'Tesseract';
  @override
  String get youdao_ocr => 'Youdao OCR';
}

// Path: settings.general.editor
class _TranslationsSettingsGeneralEditorJa
    extends TranslationsSettingsGeneralEditorEn {
  _TranslationsSettingsGeneralEditorJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsSettingsGeneralEditorRowJa row =
      _TranslationsSettingsGeneralEditorRowJa._(_root);
}

// Path: settings.appearance.section
class _TranslationsSettingsAppearanceSectionJa
    extends TranslationsSettingsAppearanceSectionEn {
  _TranslationsSettingsAppearanceSectionJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get app_language => '表示言語';
  @override
  String get theme_mode => 'テーマモード';
}

// Path: settings.shortcuts.section
class _TranslationsSettingsShortcutsSectionJa
    extends TranslationsSettingsShortcutsSectionEn {
  _TranslationsSettingsShortcutsSectionJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get text_extraction => 'テキスト抽出';
  @override
  String get input_assist => '入力補助機能';
}

// Path: settings.shortcuts.row
class _TranslationsSettingsShortcutsRowJa
    extends TranslationsSettingsShortcutsRowEn {
  _TranslationsSettingsShortcutsRowJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get toggle_mini_translator => 'ウィンドウの表示/非表示';
  @override
  String get extract_text_from_screen_selection => '画面選択からテキストを抽出';
  @override
  String get extract_text_from_screen_capture => '画面キャプチャからテキストを抽出';
  @override
  String get extract_text_from_clipboard => 'クリップボードからテキストを抽出';
  @override
  String get translate_input => '入力内容を翻訳';
}

// Path: settings.shortcuts.reset_dialog
class _TranslationsSettingsShortcutsResetDialogJa
    extends TranslationsSettingsShortcutsResetDialogEn {
  _TranslationsSettingsShortcutsResetDialogJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'ショートカットをリセット';
  @override
  String get message => 'すべてのショートカットをデフォルト値にリセットしますか？';
  @override
  String get confirm => 'リセット';
  @override
  String get cancel => 'キャンセル';
}

// Path: settings.providers.section
class _TranslationsSettingsProvidersSectionJa
    extends TranslationsSettingsProvidersSectionEn {
  _TranslationsSettingsProvidersSectionJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get services => '利用可能なサービス';
  @override
  String get services_description => '設定済みプロバイダーで利用できるサービスを確認し、種類ごとに切り替えます。';
}

// Path: settings.providers.item
class _TranslationsSettingsProvidersItemJa
    extends TranslationsSettingsProvidersItemEn {
  _TranslationsSettingsProvidersItemJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get empty => 'プロバイダーが設定されていません。追加して翻訳サービスを有効にしてください。';
  @override
  String get loading => 'プロバイダーを読み込み中...';
  @override
  String get no_services => '利用可能なサービスがありません。';
}

// Path: settings.providers.button
class _TranslationsSettingsProvidersButtonJa
    extends TranslationsSettingsProvidersButtonEn {
  _TranslationsSettingsProvidersButtonJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get add => 'プロバイダーを追加...';
}

// Path: settings.providers.alert
class _TranslationsSettingsProvidersAlertJa
    extends TranslationsSettingsProvidersAlertEn {
  _TranslationsSettingsProvidersAlertJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get error => 'エラー';
}

// Path: settings.providers.intro
class _TranslationsSettingsProvidersIntroJa
    extends TranslationsSettingsProvidersIntroEn {
  _TranslationsSettingsProvidersIntroJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get body => 'アプリで使用するサービスプロバイダーを管理します。';
  @override
  String get warning =>
      '接続したプロバイダーは送信したテキストや画像を処理する場合があります。信頼できるサービスのみ有効にしてください。';
}

// Path: settings.providers.editor
class _TranslationsSettingsProvidersEditorJa
    extends TranslationsSettingsProvidersEditorEn {
  _TranslationsSettingsProvidersEditorJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsSettingsProvidersEditorRowJa row =
      _TranslationsSettingsProvidersEditorRowJa._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorPlaceholderJa placeholder =
      _TranslationsSettingsProvidersEditorPlaceholderJa._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorTypePickerJa type_picker =
      _TranslationsSettingsProvidersEditorTypePickerJa._(_root);
  @override
  late final _TranslationsSettingsProvidersEditorTooltipJa tooltip =
      _TranslationsSettingsProvidersEditorTooltipJa._(_root);
}

// Path: settings.providers.detail
class _TranslationsSettingsProvidersDetailJa
    extends TranslationsSettingsProvidersDetailEn {
  _TranslationsSettingsProvidersDetailJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  late final _TranslationsSettingsProvidersDetailTooltipJa tooltip =
      _TranslationsSettingsProvidersDetailTooltipJa._(_root);
}

// Path: settings.providers.capability
class _TranslationsSettingsProvidersCapabilityJa
    extends TranslationsSettingsProvidersCapabilityEn {
  _TranslationsSettingsProvidersCapabilityJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get translation => '翻訳';
  @override
  String get dictionary => '辞書';
  @override
  String get ocr => 'OCR';
}

// Path: settings.providers.description
class _TranslationsSettingsProvidersDescriptionJa
    extends TranslationsSettingsProvidersDescriptionEn {
  _TranslationsSettingsProvidersDescriptionJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get all => '辞書検索とテキスト翻訳を提供';
  @override
  String get dictionary => '辞書検索と単語定義を提供';
  @override
  String get translation => '言語間のテキスト翻訳を提供';
  @override
  String get fallback => '翻訳サービスを提供';
}

// Path: settings.providers.delete_dialog
class _TranslationsSettingsProvidersDeleteDialogJa
    extends TranslationsSettingsProvidersDeleteDialogEn {
  _TranslationsSettingsProvidersDeleteDialogJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => '"{}" を削除しますか？';
  @override
  String get message => 'この操作は元に戻せません。';
}

// Path: settings.layout.empty
class _TranslationsSettingsLayoutEmptyJa
    extends TranslationsSettingsLayoutEmptyEn {
  _TranslationsSettingsLayoutEmptyJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'カテゴリを選択';
  @override
  String get message => 'サイドバーから設定セクションを選択してください。';
}

// Path: app.tray.context_menu.dev_tools
class _TranslationsAppTrayContextMenuDevToolsJa
    extends TranslationsAppTrayContextMenuDevToolsEn {
  _TranslationsAppTrayContextMenuDevToolsJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => '開発ツール';
  @override
  String get open_data_directory => 'データディレクトリを開く';
  @override
  String get use_native_settings => 'ネイティブ設定ページを使用';
}

// Path: settings.general.editor.row
class _TranslationsSettingsGeneralEditorRowJa
    extends TranslationsSettingsGeneralEditorRowEn {
  _TranslationsSettingsGeneralEditorRowJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get source_language => 'ソース言語';
  @override
  String get target_language => 'ターゲット言語';
}

// Path: settings.providers.editor.row
class _TranslationsSettingsProvidersEditorRowJa
    extends TranslationsSettingsProvidersEditorRowEn {
  _TranslationsSettingsProvidersEditorRowJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get id => 'プロバイダーID';
}

// Path: settings.providers.editor.placeholder
class _TranslationsSettingsProvidersEditorPlaceholderJa
    extends TranslationsSettingsProvidersEditorPlaceholderEn {
  _TranslationsSettingsProvidersEditorPlaceholderJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get id => '例: deepl-main';
}

// Path: settings.providers.editor.type_picker
class _TranslationsSettingsProvidersEditorTypePickerJa
    extends TranslationsSettingsProvidersEditorTypePickerEn {
  _TranslationsSettingsProvidersEditorTypePickerJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get prompt => '追加するプロバイダーの種類を選択してください：';
}

// Path: settings.providers.editor.tooltip
class _TranslationsSettingsProvidersEditorTooltipJa
    extends TranslationsSettingsProvidersEditorTooltipEn {
  _TranslationsSettingsProvidersEditorTooltipJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get help => 'ヘルプ';
}

// Path: settings.providers.detail.tooltip
class _TranslationsSettingsProvidersDetailTooltipJa
    extends TranslationsSettingsProvidersDetailTooltipEn {
  _TranslationsSettingsProvidersDetailTooltipJa._(TranslationsJa root)
      : this._root = root,
        super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get edit => 'プロバイダーを編集';
}

/// The flat map containing all translations for locale <ja>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsJa {
  dynamic _flatMapFunction(String path) {
    return switch (path) {
      'common.ui.button.ok' => 'OK',
      'common.ui.button.cancel' => 'キャンセル',
      'common.ui.button.add' => '追加',
      'common.ui.button.delete' => '削除',
      'common.ui.button.edit' => '編集',
      'common.ui.button.save' => '保存',
      'common.ui.button.manage' => '管理',
      'common.ui.button.kContinue' => '続行',
      'common.ui.feedback.copied' => 'コピーしました',
      'common.language.ar' => 'アラビア語',
      'common.language.bn' => 'ベンガル語',
      'common.language.de' => 'ドイツ語',
      'common.language.en' => '英語',
      'common.language.es' => 'スペイン語',
      'common.language.fa' => 'ペルシア語',
      'common.language.fr' => 'フランス語',
      'common.language.gu' => 'グジャラート語',
      'common.language.ha' => 'ハウサ語',
      'common.language.hi' => 'ヒンディー語',
      'common.language.id' => 'インドネシア語',
      'common.language.it' => 'イタリア語',
      'common.language.ja' => '日本語',
      'common.language.jv' => 'ジャワ語',
      'common.language.ko' => '韓国語',
      'common.language.ml' => 'マラヤーラム語',
      'common.language.mr' => 'マラーティー語',
      'common.language.ms' => 'マレー語',
      'common.language.nl' => 'オランダ語',
      'common.language.pa' => 'パンジャブ語',
      'common.language.pl' => 'ポーランド語',
      'common.language.pt' => 'ポルトガル語',
      'common.language.ro' => 'ルーマニア語',
      'common.language.ru' => 'ロシア語',
      'common.language.sw' => 'スワヒリ語',
      'common.language.ta' => 'タミル語',
      'common.language.te' => 'テルグ語',
      'common.language.th' => 'タイ語',
      'common.language.tr' => 'トルコ語',
      'common.language.uk' => 'ウクライナ語',
      'common.language.ur' => 'ウルドゥー語',
      'common.language.vi' => 'ベトナム語',
      'common.language.yo' => 'ヨルバ語',
      'common.language.zh_hans' => '簡体字中国語',
      'common.language.zh_hant' => '繁体字中国語',
      'common.theme_mode.light' => 'ライト',
      'common.theme_mode.dark' => 'ダーク',
      'common.theme_mode.system' => 'システム',
      'common.provider.baidu' => 'Baidu',
      'common.provider.caiyun' => 'Caiyun',
      'common.provider.deepl' => 'DeepL',
      'common.provider.google' => 'Google',
      'common.provider.iciba' => 'Iciba',
      'common.provider.sogou' => 'Sogou',
      'common.provider.system' => 'システム',
      'common.provider.tencent' => 'Tencent',
      'common.provider.youdao' => 'Youda',
      'common.word_pronunciation.us' => '米国',
      'common.word_pronunciation.uk' => '英国',
      'app.tray.context_menu.show_window' => 'ウィンドウを表示',
      'app.tray.context_menu.dev_tools.title' => '開発ツール',
      'app.tray.context_menu.dev_tools.open_data_directory' => 'データディレクトリを開く',
      'app.tray.context_menu.dev_tools.use_native_settings' => 'ネイティブ設定ページを使用',
      'app.tray.context_menu.check_for_updates' => 'アップデートを確認',
      'app.tray.context_menu.settings' => '設定',
      'app.tray.context_menu.quit' => '終了',
      'mini_translator.limited_banner.permission.missing_both' =>
        'すべての機能を有効にするには、画面収録とアクセシビリティの許可を付与してください。',
      'mini_translator.limited_banner.permission.missing_screen_capture' =>
        'すべての機能を有効にするには、画面収録の許可を付与してください。',
      'mini_translator.limited_banner.permission.missing_accessibility' =>
        'すべての機能を有効にするには、アクセシビリティの許可を付与してください。',
      'mini_translator.limited_banner.instruction.app_settings_prefix' =>
        'アプリ設定に移動',
      'mini_translator.limited_banner.instruction.follow_guide_prefix' =>
        'し、ガイドに従って',
      'mini_translator.limited_banner.instruction.suffix' => 'をクリックしてください。',
      'mini_translator.limited_banner.action.app_settings' => 'アプリ設定',
      'mini_translator.limited_banner.action.recheck' => '再確認',
      'mini_translator.limited_banner.feedback.enabled' => '画面テキスト抽出が有効です。',
      'mini_translator.limited_banner.feedback.still_missing' =>
        '必要な権限がまだ不足しています。\n設定を確認して、もう一度お試しください。',
      'mini_translator.limited_banner.tooltip.help' => 'ヘルプを表示',
      'mini_translator.input.hint' => 'ここに単語またはテキストを入力',
      'mini_translator.input.extracting_text' => 'テキストを抽出中...',
      'mini_translator.toolbar.tooltip.extract_text_from_screen_capture' =>
        '画面領域をキャプチャしてテキストを認識',
      'mini_translator.toolbar.tooltip.extract_text_from_clipboard' =>
        'クリップボードの内容を読み取る',
      'mini_translator.button.clear' => 'クリア',
      'mini_translator.button.translate' => '翻訳',
      'mini_translator.language.auto_detect' => '自動検出',
      'mini_translator.language.auto_match' => '自動一致',
      'mini_translator.language.switch_config' => 'ターゲット切替',
      'mini_translator.language.more_languages' => 'その他の言語...',
      'mini_translator.language.manage_common_languages' => 'よく使う言語を管理...',
      'mini_translator.language.manage_targets' => '翻訳ターゲットを管理...',
      'mini_translator.language.add_target' => '翻訳ターゲットを追加...',
      'mini_translator.message.please_enter_word_or_text' =>
        'テキストが入力されていないか、テキストが抽出されていません',
      'mini_translator.message.capture_screen_area_canceled' =>
        '画面領域のキャプチャがキャンセルされました',
      'settings.version' => 'バージョン {} BUILD {}',
      'settings.general.title' => '一般',
      'settings.general.section.permissions' => '権限',
      'settings.general.section.ocr' => 'テキスト認識',
      'settings.general.section.directory' => '辞書',
      'settings.general.section.translation' => '翻訳',
      'settings.general.section.translation_target' => '翻訳先',
      'settings.general.section.languages' => '言語',
      'settings.general.section.input' => '入力設定',
      'settings.general.row.launch_at_startup' => 'ログイン時に起動',
      'settings.general.row.show_in_menu_bar' => 'メニューバーに表示',
      'settings.general.row.screen_capture_access' => '画面収録へのアクセスを許可',
      'settings.general.row.screen_selection_access' => 'アクセシビリティへのアクセスを許可',
      'settings.general.row.default_ocr_service' => 'デフォルトのテキスト認識サービス',
      'settings.general.row.auto_copy_detected_text' => '検出したテキストを自動コピー',
      'settings.general.row.default_directory_service' => 'デフォルトの辞書サービス',
      'settings.general.row.default_translation_service' => 'デフォルトの翻訳サービス',
      'settings.general.row.common_languages' => 'よく使う言語',
      'settings.general.row.common_languages_hint' =>
        '言語セレクターの上部に表示する言語を選択してください。',
      'settings.general.row.common_languages_reset' => 'デフォルトにリセット',
      'settings.general.row.common_languages_reset_help' =>
        'デフォルトのよく使う言語セットにリセット',
      'settings.general.row.double_click_copy_result' => 'ダブルクリックで翻訳結果をコピー',
      'settings.general.row.submit_with_enter' => 'Enterで送信',
      'settings.general.row.submit_with_meta_enter_mac' => '⌘ + Enterで送信',
      'settings.general.button.add_provider' => '追加...',
      'settings.general.button.add_target' => '対象を追加',
      'settings.general.button.manage_targets' => '翻訳ターゲットを管理...',
      'settings.general.button.grant' => '許可',
      'settings.general.option.none' => 'なし',
      'settings.general.option.no_services_available' => '利用可能なサービスがありません',
      'settings.general.option.granted' => '許可済み',
      'settings.general.option.built_in_ocr' => '内蔵OCR',
      'settings.general.option.tesseract' => 'Tesseract',
      'settings.general.option.youdao_ocr' => 'Youdao OCR',
      'settings.general.editor.row.source_language' => 'ソース言語',
      'settings.general.editor.row.target_language' => 'ターゲット言語',
      'settings.appearance.title' => '外観',
      'settings.appearance.section.app_language' => '表示言語',
      'settings.appearance.section.theme_mode' => 'テーマモード',
      'settings.shortcuts.title' => 'ショートカット',
      'settings.shortcuts.section.text_extraction' => 'テキスト抽出',
      'settings.shortcuts.section.input_assist' => '入力補助機能',
      'settings.shortcuts.row.toggle_mini_translator' => 'ウィンドウの表示/非表示',
      'settings.shortcuts.row.extract_text_from_screen_selection' =>
        '画面選択からテキストを抽出',
      'settings.shortcuts.row.extract_text_from_screen_capture' =>
        '画面キャプチャからテキストを抽出',
      'settings.shortcuts.row.extract_text_from_clipboard' =>
        'クリップボードからテキストを抽出',
      'settings.shortcuts.row.translate_input' => '入力内容を翻訳',
      'settings.shortcuts.reset_dialog.title' => 'ショートカットをリセット',
      'settings.shortcuts.reset_dialog.message' =>
        'すべてのショートカットをデフォルト値にリセットしますか？',
      'settings.shortcuts.reset_dialog.confirm' => 'リセット',
      'settings.shortcuts.reset_dialog.cancel' => 'キャンセル',
      'settings.advanced.title' => '詳細設定',
      'settings.advanced.api_server' => 'ローカルAPIサーバー',
      'settings.advanced.api_server_description' =>
        'ローカルインテグレーションのために127.0.0.1で翻訳APIを公開します。',
      'settings.advanced.enable' => '有効',
      'settings.advanced.port' => 'ポート',
      'settings.advanced.running_at' => '{url} で実行中',
      'settings.advanced.disabled' => '無効',
      'settings.providers.title' => 'プロバイダー',
      'settings.providers.section.services' => '利用可能なサービス',
      'settings.providers.section.services_description' =>
        '設定済みプロバイダーで利用できるサービスを確認し、種類ごとに切り替えます。',
      'settings.providers.item.empty' =>
        'プロバイダーが設定されていません。追加して翻訳サービスを有効にしてください。',
      'settings.providers.item.loading' => 'プロバイダーを読み込み中...',
      'settings.providers.item.no_services' => '利用可能なサービスがありません。',
      'settings.providers.button.add' => 'プロバイダーを追加...',
      'settings.providers.alert.error' => 'エラー',
      'settings.providers.intro.body' => 'アプリで使用するサービスプロバイダーを管理します。',
      'settings.providers.intro.warning' =>
        '接続したプロバイダーは送信したテキストや画像を処理する場合があります。信頼できるサービスのみ有効にしてください。',
      'settings.providers.editor.row.id' => 'プロバイダーID',
      'settings.providers.editor.placeholder.id' => '例: deepl-main',
      'settings.providers.editor.type_picker.prompt' =>
        '追加するプロバイダーの種類を選択してください：',
      'settings.providers.editor.tooltip.help' => 'ヘルプ',
      'settings.providers.detail.tooltip.edit' => 'プロバイダーを編集',
      'settings.providers.capability.translation' => '翻訳',
      'settings.providers.capability.dictionary' => '辞書',
      'settings.providers.capability.ocr' => 'OCR',
      'settings.providers.description.all' => '辞書検索とテキスト翻訳を提供',
      'settings.providers.description.dictionary' => '辞書検索と単語定義を提供',
      'settings.providers.description.translation' => '言語間のテキスト翻訳を提供',
      'settings.providers.description.fallback' => '翻訳サービスを提供',
      'settings.providers.delete_dialog.title' => '"{}" を削除しますか？',
      'settings.providers.delete_dialog.message' => 'この操作は元に戻せません。',
      'settings.layout.title' => '設定',
      'settings.layout.empty.title' => 'カテゴリを選択',
      'settings.layout.empty.message' => 'サイドバーから設定セクションを選択してください。',
      _ => null,
    };
  }
}
