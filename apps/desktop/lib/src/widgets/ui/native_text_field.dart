import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

const String _kViewType = 'beyondtranslate/native_text_field';
const String _kChannelPrefix = 'beyondtranslate/native_text_field';

class NativeTextField extends StatefulWidget {
  const NativeTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.placeholder,
    this.placeholderStyle,
    this.style,
    this.padding = EdgeInsets.zero,
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

  final TextEditingController controller;
  final FocusNode focusNode;
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
  State<NativeTextField> createState() => _NativeTextFieldState();
}

class _NativeTextFieldState extends State<NativeTextField> {
  MethodChannel? _channel;
  bool _updatingFromNative = false;
  double? _nativeContentHeight;

  bool get _enabled => widget.enabled ?? true;

  bool get _editable => _enabled && !widget.readOnly;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleControllerChanged);
    widget.focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(NativeTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_handleControllerChanged);
      widget.controller.addListener(_handleControllerChanged);
      _setNativeText(widget.controller.text);
    }
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode.removeListener(_handleFocusChanged);
      widget.focusNode.addListener(_handleFocusChanged);
    }
    if (_editable != ((oldWidget.enabled ?? true) && !oldWidget.readOnly)) {
      _channel?.invokeMethod<void>('setEditableState', <String, Object?>{
        'enabled': _enabled,
        'readOnly': widget.readOnly,
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
    widget.focusNode.removeListener(_handleFocusChanged);
    _channel?.setMethodCallHandler(null);
    super.dispose();
  }

  void _handleControllerChanged() {
    if (_updatingFromNative) return;
    _setNativeText(widget.controller.text);
    setState(() {});
  }

  void _handleFocusChanged() {
    if (widget.focusNode.hasFocus) {
      _channel?.invokeMethod<void>('focus');
    } else {
      _channel?.invokeMethod<void>('blur');
    }
  }

  Future<void> _setNativeText(String text) async {
    await _channel?.invokeMethod<void>('setText', text);
  }

  void _handlePlatformViewCreated(int id) {
    final channel = MethodChannel('$_kChannelPrefix/$id');
    _channel = channel;
    channel.setMethodCallHandler(_handleNativeMethodCall);
    _setNativeText(widget.controller.text);
    if (widget.autofocus || widget.focusNode.hasFocus) {
      channel.invokeMethod<void>('focus');
    }
  }

  Future<void> _handleNativeMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'changed':
        final text = call.arguments as String? ?? '';
        if (widget.controller.text != text) {
          _updatingFromNative = true;
          widget.controller.value = widget.controller.value.copyWith(
            text: text,
            selection: TextSelection.collapsed(offset: text.length),
            composing: TextRange.empty,
          );
          _updatingFromNative = false;
        }
        setState(() {});
        widget.onChanged?.call(text);
        return;
      case 'submitted':
        widget.onSubmitted?.call(call.arguments as String? ?? '');
        return;
      case 'focused':
        if (!widget.focusNode.hasFocus) {
          widget.focusNode.requestFocus();
        }
        return;
      case 'blurred':
        if (widget.focusNode.hasFocus) {
          widget.focusNode.unfocus();
        }
        return;
      case 'tapped':
        widget.onTap?.call();
        return;
      case 'contentHeightChanged':
        final height = (call.arguments as num?)?.toDouble();
        if (height != null && height != _nativeContentHeight) {
          setState(() {
            _nativeContentHeight = height;
          });
        }
        return;
      default:
        throw MissingPluginException();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = widget.style ?? DefaultTextStyle.of(context).style;
    final placeholderStyle = widget.placeholderStyle ??
        textStyle.copyWith(
          color: (textStyle.color ?? const Color(0xFF000000))
              .withValues(alpha: 0.5),
        );
    final padding = widget.padding.resolve(Directionality.maybeOf(context));
    final height = _heightForNativeContent(
      textStyle: textStyle,
      padding: padding,
    );

    if (defaultTargetPlatform != TargetPlatform.macOS) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: height,
      width: double.infinity,
      child: AppKitView(
        viewType: _kViewType,
        creationParams: <String, Object?>{
          'text': widget.controller.text,
          'placeholder': widget.placeholder,
          'padding': _encodePadding(padding),
          'style': _encodeTextStyle(textStyle),
          'placeholderStyle': _encodeTextStyle(placeholderStyle),
          'enabled': _enabled,
          'readOnly': widget.readOnly,
          'obscureText': widget.obscureText,
          'maxLines': widget.maxLines,
          'minLines': widget.minLines,
          'submitOnEnter': widget.textInputAction == TextInputAction.done,
          'autofocus': widget.autofocus,
        },
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _handlePlatformViewCreated,
      ),
    );
  }

  double _heightForNativeContent({
    required TextStyle textStyle,
    required EdgeInsets padding,
  }) {
    final lineHeight = _lineHeight(textStyle);
    final minLines = widget.obscureText ? 1 : math.max(1, widget.minLines ?? 1);
    final maxLines = widget.obscureText ? 1 : widget.maxLines;
    final minHeight = padding.vertical + lineHeight * minLines;
    final maxHeight = maxLines == null
        ? double.infinity
        : padding.vertical + lineHeight * math.max(minLines, maxLines);
    final nativeHeight = _nativeContentHeight == null
        ? minHeight
        : padding.vertical + _nativeContentHeight!;
    return _clampHeight(
      nativeHeight,
      minHeight,
      maxHeight,
    );
  }

  double _clampHeight(double height, double minHeight, double maxHeight) {
    return math.min(math.max(height, minHeight), maxHeight);
  }

  double _lineHeight(TextStyle style) {
    final fontSize = style.fontSize ?? 14;
    return fontSize * (style.height ?? 1.2);
  }

  Map<String, double> _encodePadding(EdgeInsets padding) {
    return <String, double>{
      'left': padding.left,
      'top': padding.top,
      'right': padding.right,
      'bottom': padding.bottom,
    };
  }

  Map<String, Object?> _encodeTextStyle(TextStyle style) {
    return <String, Object?>{
      'fontSize': style.fontSize,
      'fontFamily': style.fontFamily,
      'height': style.height,
      'color': style.color?.toARGB32(),
    };
  }
}
