import 'package:flutter/material.dart';

class PreferenceList extends StatelessWidget {
  const PreferenceList({
    Key? key,
    this.padding,
    required this.children,
  }) : super(key: key);

  final EdgeInsets? padding;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: padding ??
          const EdgeInsets.only(
            top: 12,
            bottom: 12,
          ),
      children: children,
    );
  }
}
