import 'dart:convert';

import 'package:biyi_app/models/models.dart';
import '../services.dart';
import '../../utilities/utilities.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

class Configuration {
  String get translationMode {
    return _getString(kPrefTranslationMode) ?? kTranslationModeManual;
  }

  set translationMode(String value) {
    _setString(kPrefTranslationMode, value);
  }

  String? get defaultEngineId {
    return _getString(kPrefDefaultEngineId);
  }

  set defaultEngineId(String? value) {
    _setString(kPrefDefaultEngineId, value);
  }

  TranslationEngineConfig? get defaultEngineConfig {
    return localDb.proEngine(defaultEngineId).get() ??
        localDb.privateEngine(defaultEngineId).get();
  }

  String? get defaultTranslateEngineId {
    return _getString(kPrefDefaultTranslateEngineId);
  }

  set defaultTranslateEngineId(String? value) {
    _setString(kPrefDefaultTranslateEngineId, value);
  }

  TranslationEngineConfig? get defaultTranslateEngineConfig {
    return localDb.proEngine(defaultTranslateEngineId).get() ??
        localDb.privateEngine(defaultTranslateEngineId).get();
  }

  bool get doubleClickCopyResult {
    return _getBool(kPrefDoubleClickCopyResult) ?? true;
  }

  set doubleClickCopyResult(bool value) {
    _setBool(kPrefDoubleClickCopyResult, value);
  }

  String? get defaultOcrEngineId {
    return _getString(kPrefDefaultOcrEngineId);
  }

  set defaultOcrEngineId(String? value) {
    _setString(kPrefDefaultOcrEngineId, value);
  }

  bool get autoCopyDetectedText {
    return _getBool(kPrefAutoCopyDetectedText) ?? true;
  }

  set autoCopyDetectedText(bool value) {
    _setBool(kPrefAutoCopyDetectedText, value);
  }

  bool get showTrayIcon {
    return _getBool(kPrefShowTrayIcon) ?? true;
  }

  set showTrayIcon(bool value) {
    _setBool(kPrefShowTrayIcon, value);
  }

  double get maxWindowHeight {
    String? stringValue = _getString(kPrefMaxWindowHeight);
    if (stringValue != null) {
      return double.parse(stringValue);
    }
    return 800;
  }

  set maxWindowHeight(value) {
    _setString(kPrefMaxWindowHeight, value.toString());
  }

  String get appLanguage {
    return _getString(kPrefAppLanguage) ?? kLanguageZH;
  }

  set appLanguage(value) {
    _setString(kPrefAppLanguage, value);
  }

  ThemeMode get themeMode {
    String themeModeString = _getString(kPrefThemeMode) ?? ThemeMode.light.name;
    return kKnownThemeModes[themeModeString]!;
  }

  set themeMode(value) {
    _setString(kPrefThemeMode, value.name);
  }

  String get inputSetting {
    return _getString(kPrefInputSetting) ?? kInputSettingSubmitWithEnter;
  }

  set inputSetting(value) {
    _setString(kPrefInputSetting, value);
  }

  HotKey get shortcutShowOrHide {
    return _getShortcut(kShortcutShowOrHide) ??
        HotKey(
          key: PhysicalKeyboardKey.digit1,
          modifiers: [HotKeyModifier.alt],
          identifier: kShortcutShowOrHide,
        );
  }

  set shortcutShowOrHide(value) {
    _setShortcut(kShortcutShowOrHide, value);
  }

  HotKey get shortcutHide {
    return _getShortcut(kShortcutHide) ??
        HotKey(
          key: PhysicalKeyboardKey.escape,
          modifiers: [],
          identifier: kShortcutHide,
          scope: HotKeyScope.inapp,
        );
  }

  set shortcutHide(value) {
    _setShortcut(kShortcutHide, value);
  }

  HotKey get shortcutExtractFromScreenSelection {
    return _getShortcut(kShortcutExtractFromScreenSelection) ??
        HotKey(
          key: PhysicalKeyboardKey.keyQ,
          modifiers: [HotKeyModifier.alt],
          identifier: kShortcutExtractFromScreenSelection,
        );
  }

  set shortcutExtractFromScreenSelection(value) {
    _setShortcut(kShortcutExtractFromScreenSelection, value);
  }

  HotKey get shortcutExtractFromScreenCapture {
    return _getShortcut(kShortcutExtractFromScreenCapture) ??
        HotKey(
          key: PhysicalKeyboardKey.keyW,
          modifiers: [HotKeyModifier.alt],
          identifier: kShortcutExtractFromScreenCapture,
        );
  }

  set shortcutExtractFromScreenCapture(value) {
    _setShortcut(kShortcutExtractFromScreenCapture, value);
  }

  HotKey get shortcutExtractFromClipboard {
    return _getShortcut(kShortcutExtractFromClipboard) ??
        HotKey(
          key: PhysicalKeyboardKey.keyE,
          modifiers: [HotKeyModifier.alt],
          identifier: kShortcutExtractFromClipboard,
        );
  }

  set shortcutExtractFromClipboard(value) {
    _setShortcut(kShortcutExtractFromClipboard, value);
  }

  HotKey get shortcutTranslateInputContent {
    return _getShortcut(kPrefShortcutTranslateInputContent) ??
        HotKey(
          key: PhysicalKeyboardKey.keyZ,
          modifiers: [HotKeyModifier.alt],
          identifier: kPrefShortcutTranslateInputContent,
        );
  }

  set shortcutTranslateInputContent(value) {
    _setShortcut(kPrefShortcutTranslateInputContent, value);
  }

  HotKey get shortcutInputSettingSubmitWithMetaEnter {
    if (kIsMacOS) {
      return HotKey(
        key: PhysicalKeyboardKey.enter,
        modifiers: [HotKeyModifier.meta],
        scope: HotKeyScope.inapp,
      );
    }
    return HotKey(
      key: PhysicalKeyboardKey.enter,
      modifiers: [HotKeyModifier.control],
      scope: HotKeyScope.inapp,
    );
  }

  void setShortcut(String key, HotKey hotKey) {
    _setShortcut(key, hotKey);
  }

  String? _getString(String key) {
    UserPreference? pref = localDb.preference(key).get();
    return pref?.value;
  }

  void _setString(String key, String? value) {
    if (value == null) {
      localDb.preference(key).delete();
    } else {
      localDb.preference(key).updateOrCreate(value: value);
    }
  }

  bool? _getBool(String key) {
    UserPreference? pref = localDb.preference(key).get();
    return pref?.boolValue;
  }

  void _setBool(String key, bool value) async {
    localDb //
        .preference(key)
        .updateOrCreate(
          type: kPreferenceTypeBool,
          value: '$value',
        );
  }

  void _setShortcut(String key, HotKey hotKey) {
    _setString(
      key,
      json.encode(hotKey.toJson()),
    );
  }

  HotKey? _getShortcut(String key) {
    HotKey? hotKey;
    String? jsonString = _getString(key);
    if (jsonString != null && jsonString.isNotEmpty) {
      hotKey = HotKey.fromJson(json.decode(jsonString));
    }
    return hotKey;
  }
}
