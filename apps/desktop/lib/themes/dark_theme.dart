import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _kDefaultTextColor = Colors.white;

const _kPrimaryColor = Color(0xff416ff4);
const _kSecondaryColor = Color(0xff008D94);
const _kCanvasColor = Color(0xff282828);
const _kScaffoldBackgroundColor = Color(0xff1d1d1d);

const _kDefaultTextStyle = TextStyle(
  color: _kDefaultTextColor,
  fontFamily: 'MiSans',
);

final darkThemeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: _kPrimaryColor,
    primary: _kPrimaryColor,
    secondary: _kSecondaryColor,
  ),
  primaryColor: _kPrimaryColor,
  canvasColor: _kCanvasColor,
  scaffoldBackgroundColor: _kScaffoldBackgroundColor,
  dialogBackgroundColor: _kCanvasColor,
  fontFamily: 'MiSans',
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
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
    systemOverlayStyle: SystemUiOverlayStyle.light,
    color: _kCanvasColor,
    elevation: 0,
    iconTheme: const IconThemeData(
      color: Colors.white,
      opacity: 1,
      size: 24,
    ),
    actionsIconTheme: const IconThemeData(
      color: Colors.white,
      opacity: 1,
      size: 24,
    ),
    titleTextStyle: _kDefaultTextStyle.copyWith(
      fontSize: 15,
    ),
  ),
  cupertinoOverrideTheme: CupertinoThemeData(
    primaryColor: _kPrimaryColor,
    barBackgroundColor: _kCanvasColor,
    textTheme: CupertinoTextThemeData(
      textStyle: _kDefaultTextStyle.copyWith(),
    ),
  ),
);
