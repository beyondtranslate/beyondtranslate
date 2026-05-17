import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _kDefaultTextColor = Color(0xff333333);

const _kPrimaryColor = Color(0xff416ff4);
const _kSecondaryColor = Color(0xff008D94);
const _kCanvasColor = Colors.white;
const _kScaffoldBackgroundColor = Color(0xfff2f3f5);

const _kDefaultTextStyle = TextStyle(
  color: _kDefaultTextColor,
  fontFamily: 'MiSans',
);

final lightThemeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: _kPrimaryColor,
    primary: _kPrimaryColor,
    secondary: _kSecondaryColor,
  ),
  primaryColor: _kPrimaryColor,
  canvasColor: _kCanvasColor,
  scaffoldBackgroundColor: _kScaffoldBackgroundColor,
  dividerColor: Colors.grey.withValues(alpha: 0.2),
  fontFamily: 'MiSans',
  dialogTheme: const DialogThemeData(
    backgroundColor: _kCanvasColor,
  ),
  textTheme: TextTheme(
    titleLarge: _kDefaultTextStyle.copyWith(
      fontSize: 17,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: _kDefaultTextStyle.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: _kDefaultTextStyle.copyWith(
      fontSize: 13,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: _kDefaultTextStyle.copyWith(
      fontSize: 15,
    ),
    bodyMedium: _kDefaultTextStyle.copyWith(
      fontSize: 13,
    ),
    bodySmall: _kDefaultTextStyle.copyWith(
      color: _kDefaultTextColor.withValues(alpha: 0.5),
      fontSize: 11,
    ),
    labelLarge: _kDefaultTextStyle.copyWith(
      fontSize: 13,
    ),
    labelMedium: _kDefaultTextStyle.copyWith(
      fontSize: 12,
    ),
    labelSmall: _kDefaultTextStyle.copyWith(
      fontSize: 10,
    ),
  ),
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    backgroundColor: _kCanvasColor,
    elevation: 0,
    iconTheme: const IconThemeData(
      color: Colors.black,
      opacity: 1,
      size: 24,
    ),
    actionsIconTheme: const IconThemeData(
      color: Colors.black,
      opacity: 1,
      size: 24,
    ),
    titleTextStyle: _kDefaultTextStyle.copyWith(
      fontSize: 13,
      fontWeight: FontWeight.w600,
    ),
  ),
);
