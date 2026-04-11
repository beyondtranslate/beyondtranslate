import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PreferenceListItem extends StatelessWidget {
  const PreferenceListItem({
    Key? key,
    this.padding,
    this.icon,
    this.title,
    this.summary,
    this.detailText,
    this.accessoryView,
    this.bottomView,
    this.disabled = false,
    this.onTap,
  }) : super(key: key);

  final EdgeInsets? padding;
  final Widget? icon;
  final Widget? title;
  final Widget? summary;
  final Widget? detailText;
  final Widget? accessoryView;
  final Widget? bottomView;
  final bool disabled;
  final VoidCallback? onTap;

  _onTap() {
    onTap?.call();
  }

  Widget buildDetailText(BuildContext context) {
    if (detailText != null) {
      return DefaultTextStyle(
        style: Theme.of(context).textTheme.bodySmall!,
        child: detailText!,
      );
    } else {
      return Container();
    }
  }

  Widget buildAccessoryView(BuildContext context) {
    if (accessoryView != null) {
      return accessoryView!;
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Icon(
          FluentIcons.chevron_right_20_regular,
          size: 18,
          color: Theme.of(context).textTheme.bodySmall!.color,
        ),
      );
    }
  }

  Widget buildBottomView(BuildContext context) {
    return bottomView ?? Container();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Material(
      color: Theme.of(context).canvasColor,
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: disabled ? null : _onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(
                minHeight: 48,
              ),
              padding: padding ?? const EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Row(
                children: [
                  if (icon != null)
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: icon,
                    ),
                  if (title != null || summary != null)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (title != null)
                            DefaultTextStyle(
                              style: textTheme.bodyMedium!,
                              child: title!,
                            ),
                          if (summary != null)
                            DefaultTextStyle(
                              style: textTheme.bodySmall!,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 2,
                                  bottom: 2,
                                ),
                                child: summary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  buildDetailText(context),
                  buildAccessoryView(context),
                ],
              ),
            ),
            buildBottomView(context),
          ],
        ),
      ),
    );
  }
}

class PreferenceListRadioItem<T> extends PreferenceListItem {
  const PreferenceListRadioItem({
    Key? key,
    EdgeInsets? padding,
    Widget? icon,
    Widget? title,
    Widget? summary,
    Widget? detailText,
    Widget? accessoryView,
    VoidCallback? onTap,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  }) : super(
          key: key,
          padding: padding,
          icon: icon,
          title: title,
          summary: summary,
          detailText: detailText,
          accessoryView: accessoryView,
          onTap: onTap,
        );
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;

  @override
  void _onTap() {
    onChanged(value);
    super._onTap();
  }

  @override
  Widget buildAccessoryView(BuildContext context) {
    if (value != null && value == groupValue) {
      return Container(
        margin: EdgeInsets.zero,
        child: Icon(
          FluentIcons.checkmark_circle_20_filled,
          size: 22,
          color: Theme.of(context).primaryColor,
        ),
      );
    }
    return Container();
  }
}

class PreferenceListSwitchItem extends PreferenceListItem {
  const PreferenceListSwitchItem({
    Key? key,
    Widget? icon,
    Widget? title,
    Widget? summary,
    Widget? detailText,
    Widget? accessoryView,
    VoidCallback? onTap,
    required this.value,
    required this.onChanged,
  }) : super(
          key: key,
          icon: icon,
          title: title,
          summary: summary,
          detailText: detailText,
          accessoryView: accessoryView,
          onTap: onTap,
        );
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  void _onTap() {
    if (onTap == null) {
      onChanged(!value);
    }
    super._onTap();
  }

  @override
  Widget buildAccessoryView(BuildContext context) {
    return SizedBox(
      height: 22,
      width: 34,
      child: Transform.scale(
        scale: 0.68,
        child: CupertinoSwitch(
          value: value,
          onChanged: onChanged,
          activeColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

class PreferenceListTextFieldItem extends PreferenceListItem {
  const PreferenceListTextFieldItem({
    Key? key,
    Widget? icon,
    Widget? title,
    Widget? summary,
    Widget? accessoryView,
    VoidCallback? onTap,
    this.controller,
    this.placeholder,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
  }) : super(
          key: key,
          icon: icon,
          title: title,
          summary: summary,
          accessoryView: accessoryView,
          onTap: onTap,
        );
  final TextEditingController? controller;
  final String? placeholder;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;

  @override
  bool get disabled => true;

  @override
  Widget buildDetailText(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: CupertinoTextField(
        controller: controller,
        padding: EdgeInsets.zero,
        decoration: const BoxDecoration(),
        style: textTheme.bodyMedium?.copyWith(
          height: 1.2,
        ),
        placeholder: placeholder,
        placeholderStyle: textTheme.bodyMedium?.copyWith(
          color: textTheme.bodyMedium?.color?.withOpacity(0.5),
          height: 1.2,
        ),
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        onSubmitted: onSubmitted,
      ),
    );
  }
}
