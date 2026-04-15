import 'package:flutter/material.dart';

const kPreferenceTypeInt = 'int';
const kPreferenceTypeBool = 'bool';

// 翻译
const kPrefTranslationMode = 'translation_mode';
const kPrefDefaultEngineId = 'default_engine_id';
const kPrefDefaultTranslateEngineId = 'default_translate_engine_id';
const kPrefDoubleClickCopyResult = 'double_click_copy_result';
// 取词
const kPrefDefaultOcrEngineId = 'default_ocr_engine_id';
const kPrefAutoCopyDetectedText = 'auto_copy_detected_text';
// 界面
const kPrefShowTrayIcon = 'show_tray_icon';
const kPrefMaxWindowHeight = 'max_window_height';
// 显示语言
const kPrefAppLanguage = 'app_language';
// 主题模式
const kPrefThemeMode = 'theme_mode';
// 快捷键
const kPrefShortcutShowOrHide = 'shortcut_show_or_hide';
const kPrefShortcutExtractFromScreenCapture =
    'shortcut_extract_text_from_screen_capture';
const kPrefShortcutExtractFromScreenSelection =
    'shortcut_extract_text_from_screen_selection';
const kPrefShortcutTranslateInputContent = 'shortcut_translate_input_content';
// 输入设置
const kPrefInputSetting = 'input_setting';

const kTranslationModeAuto = 'auto';
const kTranslationModeManual = 'manual';

const kInputSettingSubmitWithEnter = 'submit-with-enter';
const kInputSettingSubmitWithMetaEnter = 'submit-with-meta+enter';

const kShortcutShowOrHide = 'shortcut_show_or_hide';
const kShortcutHide = 'shortcut_hide';
const kShortcutExtractFromScreenSelection =
    'shortcut_extract_from_screen_selection';
const kShortcutExtractFromScreenCapture =
    'shortcut_extract_from_screen_capture';
const kShortcutExtractFromClipboard = 'shortcut_extract_from_clipboard';
const kShortcutTranslateInputContent = 'shortcut_translate_input_content';

const Map<String, ThemeMode> kKnownThemeModes = <String, ThemeMode>{
  'light': ThemeMode.light,
  'dark': ThemeMode.dark,
  'system': ThemeMode.system,
};

class UserPreference {
  UserPreference({
    this.key,
    this.type,
    this.value,
  });

  factory UserPreference.fromJson(Map<dynamic, dynamic> json) {
    return UserPreference(
      key: json['key'],
      type: json['type'],
      value: json['value'],
    );
  }

  String? key;
  String? type;
  String? value;

  int? get intValue {
    if (type != kPreferenceTypeInt) return null;
    return int.parse(value!);
  }

  bool? get boolValue {
    if (type != kPreferenceTypeBool) return null;
    return value == 'true';
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'type': type,
      'value': value,
    };
  }
}
