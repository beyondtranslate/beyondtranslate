import 'package:flutter/cupertino.dart';
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
  dividerColor: Colors.grey.withOpacity(0.2),
  dialogBackgroundColor: _kCanvasColor,
  fontFamily: 'MiSans',
  textTheme: TextTheme(
    titleLarge: _kDefaultTextStyle.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: _kDefaultTextStyle.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: _kDefaultTextStyle.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: _kDefaultTextStyle.copyWith(
      fontSize: 16,
    ),
    bodyMedium: _kDefaultTextStyle.copyWith(
      fontSize: 14,
    ),
    bodySmall: _kDefaultTextStyle.copyWith(
      color: _kDefaultTextColor.withOpacity(0.5),
      fontSize: 12,
    ),
  ),
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    color: _kCanvasColor,
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
      fontSize: 15,
    ),
  ),
  cupertinoOverrideTheme: const CupertinoThemeData(
    primaryColor: _kPrimaryColor,
    barBackgroundColor: _kCanvasColor,
  ),
);
