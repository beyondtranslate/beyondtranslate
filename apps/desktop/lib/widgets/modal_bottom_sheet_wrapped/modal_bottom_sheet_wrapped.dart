import 'package:biyi_app/includes.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class ModalBottomSheetWrapped extends StatefulWidget {
  const ModalBottomSheetWrapped({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  State<ModalBottomSheetWrapped> createState() =>
      _ModalBottomSheetWrappedState();
}

class _ModalBottomSheetWrappedState extends State<ModalBottomSheetWrapped> {
  Configuration get _configuration => localDb.configuration;

  @override
  void initState() {
    localDb.preferences.addListener(_handleChanged);
    super.initState();
  }

  @override
  void dispose() {
    localDb.preferences.removeListener(_handleChanged);
    super.dispose();
  }

  void _handleChanged() {
    if (mounted) setState(() {});
  }

  Widget _build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightThemeData,
      darkTheme: darkThemeData,
      themeMode: _configuration.themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: widget.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      child: _build(context),
    );
  }
}

Future<T?> showModalBottomSheetPage<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) async {
  if (kIsLinux || kIsMacOS || kIsWindows) {
    await Future.delayed(const Duration(milliseconds: 120));
    Size size = await windowManager.getSize();
    await windowManager.setSize(Size(size.width, 680.0));
  }

  return showModalBottomSheet<T>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(10),
      ),
    ),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    isScrollControlled: true,
    builder: (ctx) {
      return ModalBottomSheetWrapped(
        child: builder(ctx),
      );
    },
  );
}
