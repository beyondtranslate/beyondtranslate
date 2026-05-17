import 'package:flutter/material.dart';

import 'ui/preference_list.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
    required this.title,
    required this.children,
    this.actions = const [],
  });

  final String title;
  final List<Widget> children;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 56,
          padding: const EdgeInsetsDirectional.only(start: 28, end: 20),
          alignment: Alignment.center,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ...actions,
            ],
          ),
        ),
        Expanded(
          child: PreferenceList(
            padding: const EdgeInsets.only(top: 0, bottom: 16),
            children: children,
          ),
        ),
      ],
    );
  }
}
