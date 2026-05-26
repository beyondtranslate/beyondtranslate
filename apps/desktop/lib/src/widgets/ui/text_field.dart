import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../utils/platform_util.dart';
import 'native_text_field.dart';

const EdgeInsets _kDefaultPadding = EdgeInsets.symmetric(
  horizontal: 12,
  vertical: 8,
);
const Color _kDefaultCursorColor = Color(0xFF007AFF);
const Color _kDefaultBackgroundCursorColor = Color(0x33000000);

/// A lightweight app text field with Cupertino-style defaults.
///
/// The widget intentionally exposes the common input parameters used across the
/// app while keeping the visual defaults opinionated: no Material/Cupertino
/// text field dependency, compact padding, and a lightweight placeholder layer.
class TextField extends StatefulWidget {
  const TextField({
    super.key,
    this.controller,
    this.focusNode,
    this.placeholder,
    this.placeholderStyle,
    this.style,
    this.padding = _kDefaultPadding,
    this.maxLines = 1,
    this.minLines,
    this.enabled,
    this.autofocus = false,
    this.readOnly = false,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.selectionHeightStyle = BoxHeightStyle.tight,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? placeholder;
  final TextStyle? placeholderStyle;
  final TextStyle? style;
  final EdgeInsetsGeometry padding;
  final int? maxLines;
  final int? minLines;
  final bool? enabled;
  final bool autofocus;
  final bool readOnly;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final BoxHeightStyle selectionHeightStyle;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final GestureTapCallback? onTap;

  @override
  State<TextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<TextField> {
  TextEditingController? _controller;
  FocusNode? _focusNode;

  TextEditingController get _effectiveController =>
      widget.controller ?? _controller!;

  FocusNode get _effectiveFocusNode => widget.focusNode ?? _focusNode!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController();
    }
    if (widget.focusNode == null) {
      _focusNode = FocusNode();
    }
    _effectiveController.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(TextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      if (oldWidget.controller == null) {
        _controller?.removeListener(_handleControllerChanged);
        _controller?.dispose();
        _controller = null;
      }
      if (widget.controller == null) {
        _controller = TextEditingController.fromValue(
          oldWidget.controller?.value,
        );
      }
      _effectiveController.addListener(_handleControllerChanged);
    }

    if (widget.focusNode != oldWidget.focusNode) {
      if (oldWidget.focusNode == null) {
        _focusNode?.dispose();
        _focusNode = null;
      }
      if (widget.focusNode == null) {
        _focusNode = FocusNode();
      }
    }
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_handleControllerChanged);
    _controller?.dispose();
    _focusNode?.dispose();
    super.dispose();
  }

  void _handleControllerChanged() {
    setState(() {});
  }

  void _handleTap() {
    _effectiveFocusNode.requestFocus();
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsMacOS) {
      return NativeTextField(
        controller: _effectiveController,
        focusNode: _effectiveFocusNode,
        placeholder: widget.placeholder,
        placeholderStyle: widget.placeholderStyle,
        style: widget.style,
        padding: widget.padding,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        enabled: widget.enabled,
        autofocus: widget.autofocus,
        readOnly: widget.readOnly,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        textCapitalization: widget.textCapitalization,
        selectionHeightStyle: widget.selectionHeightStyle,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        onTap: widget.onTap,
      );
    }

    final TextStyle textStyle =
        widget.style ?? DefaultTextStyle.of(context).style;
    final Color textColor = textStyle.color ?? const Color(0xFF000000);
    final bool enabled = widget.enabled ?? true;
    final bool showPlaceholder = widget.placeholder != null &&
        !widget.obscureText &&
        _effectiveController.text.isEmpty;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: enabled ? _handleTap : null,
      child: Padding(
        padding: widget.padding,
        child: Stack(
          alignment: AlignmentDirectional.topStart,
          children: [
            if (showPlaceholder)
              IgnorePointer(
                child: Text(
                  widget.placeholder!,
                  style: widget.placeholderStyle ??
                      textStyle.copyWith(
                        color: textColor.withValues(alpha: 0.5),
                      ),
                ),
              ),
            EditableText(
              controller: _effectiveController,
              focusNode: _effectiveFocusNode,
              readOnly: widget.readOnly || !enabled,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              textCapitalization: widget.textCapitalization,
              selectionHeightStyle: widget.selectionHeightStyle,
              style: textStyle,
              cursorColor: _kDefaultCursorColor,
              backgroundCursorColor: _kDefaultBackgroundCursorColor,
              selectionColor: _kDefaultCursorColor.withValues(alpha: 0.2),
              maxLines: widget.obscureText ? 1 : widget.maxLines,
              minLines: widget.minLines,
              autofocus: widget.autofocus,
              enableInteractiveSelection: enabled,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
            ),
          ],
        ),
      ),
    );
  }
}
