import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;

bool get kIsAndroid => !kIsWeb && Platform.isAndroid;
bool get kIsIOS => !kIsWeb && Platform.isIOS;
bool get kIsLinux => !kIsWeb && Platform.isLinux;
bool get kIsMacOS => !kIsWeb && Platform.isMacOS;
bool get kIsWindows => !kIsWeb && Platform.isWindows;

T platformSelect<T>(
  T Function() fallback, {
  T Function()? android,
  T Function()? iOS,
  T Function()? linux,
  T Function()? macOS,
  T Function()? windows,
}) {
  if (kIsAndroid && android != null) return android();
  if (kIsIOS && iOS != null) return iOS();
  if (kIsLinux && linux != null) return linux();
  if (kIsMacOS && macOS != null) return macOS();
  if (kIsWindows && windows != null) return windows();
  return fallback();
}
