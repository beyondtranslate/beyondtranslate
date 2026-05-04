// ignore_for_file: implementation_imports, invalid_use_of_internal_member

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/_window.dart';

import '../../i18n/i18n.dart';
import '../../services/settings_store.dart';
import '../../widgets/ui/themes/dark_theme.dart';
import '../../widgets/ui/themes/light_theme.dart';
import '../../utils/language_util.dart';
import '../../utils/platform_util.dart';
import '../../windowing/window_controllers.dart';
import 'mini_translator.dart';

class MiniTranslatorApp extends StatefulWidget {
  const MiniTranslatorApp({super.key});

  @override
  State<MiniTranslatorApp> createState() => _MiniTranslatorAppState();
}

class _MiniTranslatorAppState extends State<MiniTranslatorApp> {
  @override
  void initState() {
    settingsStore.addListener(_handleChanged);
    super.initState();
  }

  @override
  void dispose() {
    settingsStore.removeListener(_handleChanged);
    super.dispose();
  }

  Future<void> _handleChanged() async {
    final oldLocale = context.locale;
    final newLocale = languageToLocale(settingsStore.appLanguage);
    if (newLocale != oldLocale) {
      await context.setLocale(newLocale);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();

    return RegularWindow(
      controller: miniTranslatorWindowController,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightThemeData,
        darkTheme: darkThemeData,
        themeMode: settingsStore.themeMode,
        builder: (context, child) {
          if (kIsLinux || kIsWindows) {
            child = ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(7),
                topRight: Radius.circular(7),
              ),
              child: child,
            );
          }
          child = botToastBuilder(context, child);
          return child;
        },
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: const MiniTranslatorPage(),
      ),
    );
  }
}
