import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const EdgeInsets _kButtonPadding = EdgeInsets.zero;

const double _kCustomButtonMinHeight = 48;

/// An iOS-style button.
///
/// Takes in a text or an icon that fades out and in on touch. May optionally have a
/// background.
///
/// The [padding] defaults to 16.0 pixels. When using a [CustomButton] within
/// a fixed height parent, like a [CupertinoNavigationBar], a smaller, or even
/// [EdgeInsets.zero], should be used to prevent clipping larger [child]
/// widgets.
///
/// {@tool dartpad}
/// This sample shows produces an enabled and disabled [CustomButton] and
/// [CustomButton.filled].
///
/// ** See code in examples/api/lib/cupertino/button/cupertino_button.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * <https://developer.apple.com/ios/human-interface-guidelines/controls/buttons/>
class CustomButton extends StatefulWidget {
  /// Creates an iOS-style button.
  const CustomButton({
    Key? key,
    this.processing = false,
    required this.child,
    this.padding,
    this.color,
    this.disabledColor = CupertinoColors.quaternarySystemFill,
    this.minSize = _kCustomButtonMinHeight,
    this.pressedOpacity = 0.4,
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.alignment = Alignment.center,
    required this.onPressed,
  })  : assert(pressedOpacity == null ||
            (pressedOpacity >= 0.0 && pressedOpacity <= 1.0)),
        _filled = false,
        _outlined = false,
        super(key: key);

  /// Creates an iOS-style button with a filled background.
  ///
  /// The background color is derived from the [CupertinoTheme]'s `primaryColor`.
  ///
  /// To specify a custom background color, use the [color] argument of the
  /// default constructor.
  const CustomButton.filled({
    Key? key,
    this.processing = false,
    required this.child,
    this.padding,
    this.disabledColor = CupertinoColors.quaternarySystemFill,
    this.minSize = _kCustomButtonMinHeight,
    this.pressedOpacity = 0.4,
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.alignment = Alignment.center,
    required this.onPressed,
  })  : assert(pressedOpacity == null ||
            (pressedOpacity >= 0.0 && pressedOpacity <= 1.0)),
        color = null,
        _filled = true,
        _outlined = false,
        super(key: key);

  const CustomButton.outlined({
    Key? key,
    this.processing = false,
    required this.child,
    this.padding,
    this.disabledColor = const Color(0x3D1A2B48),
    this.minSize = kMinInteractiveDimensionCupertino,
    this.pressedOpacity = 0.4,
    this.color,
    this.borderRadius = const BorderRadius.all(Radius.circular(6.0)),
    this.alignment = Alignment.center,
    required this.onPressed,
  })  : assert(pressedOpacity == null ||
            (pressedOpacity >= 0.0 && pressedOpacity <= 1.0)),
        _filled = false,
        _outlined = true,
        super(key: key);

  final bool processing;

  /// The widget below this widget in the tree.
  ///
  /// Typically a [Text] widget.
  final Widget child;

  /// The amount of space to surround the child inside the bounds of the button.
  ///
  /// Defaults to 16.0 pixels.
  final EdgeInsetsGeometry? padding;

  /// The color of the button's background.
  ///
  /// Defaults to null which produces a button with no background or border.
  ///
  /// Defaults to the [CupertinoTheme]'s `primaryColor` when the
  /// [CustomButton.filled] constructor is used.
  final Color? color;

  /// The color of the button's background when the button is disabled.
  ///
  /// Ignored if the [CustomButton] doesn't also have a [color].
  ///
  /// Defaults to [CupertinoColors.quaternarySystemFill] when [color] is
  /// specified. Must not be null.
  final Color disabledColor;

  /// The callback that is called when the button is tapped or otherwise activated.
  ///
  /// If this is set to null, the button will be disabled.
  final VoidCallback? onPressed;

  /// Minimum size of the button.
  ///
  /// Defaults to _kCustomButtonMinHeight which the iOS Human
  /// Interface Guidelines recommends as the minimum tappable area.
  final double? minSize;

  /// The opacity that the button will fade to when it is pressed.
  /// The button will have an opacity of 1.0 when it is not pressed.
  ///
  /// This defaults to 0.4. If null, opacity will not change on pressed if using
  /// your own custom effects is desired.
  final double? pressedOpacity;

  /// The radius of the button's corners when it has a background color.
  ///
  /// Defaults to round corners of 8 logical pixels.
  final BorderRadius? borderRadius;

  /// The alignment of the button's [child].
  ///
  /// Typically buttons are sized to be just big enough to contain the child and its
  /// [padding]. If the button's size is constrained to a fixed size, for example by
  /// enclosing it with a [SizedBox], this property defines how the child is aligned
  /// within the available space.
  ///
  /// Always defaults to [Alignment.center].
  final AlignmentGeometry alignment;

  final bool _filled;
  final bool _outlined;

  /// Whether the button is enabled or disabled. Buttons are disabled by default. To
  /// enable a button, set its [onPressed] property to a non-null value.
  bool get enabled => onPressed != null;

  @override
  State<CustomButton> createState() => _CustomButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(FlagProperty('enabled', value: enabled, ifFalse: 'disabled'));
  }
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  // Eyeballed values. Feel free to tweak.
  static const Duration kFadeOutDuration = Duration(milliseconds: 120);
  static const Duration kFadeInDuration = Duration(milliseconds: 180);
  final Tween<double> _opacityTween = Tween<double>(begin: 1.0);

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      value: 0.0,
      vsync: this,
    );
    _opacityAnimation = _animationController
        .drive(CurveTween(curve: Curves.decelerate))
        .drive(_opacityTween);
    _setTween();
  }

  @override
  void didUpdateWidget(CustomButton old) {
    super.didUpdateWidget(old);
    _setTween();
  }

  void _setTween() {
    _opacityTween.end = widget.pressedOpacity ?? 1.0;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool _buttonHeldDown = false;

  void _handleTapDown(TapDownDetails event) {
    if (!_buttonHeldDown) {
      _buttonHeldDown = true;
      _animate();
    }
  }

  void _handleTapUp(TapUpDetails event) {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _handleTapCancel() {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _animate() {
    if (_animationController.isAnimating) return;
    final bool wasHeldDown = _buttonHeldDown;
    final TickerFuture ticker = _buttonHeldDown
        ? _animationController.animateTo(1.0,
            duration: kFadeOutDuration, curve: Curves.easeInOutCubicEmphasized)
        : _animationController.animateTo(0.0,
            duration: kFadeInDuration, curve: Curves.easeOutCubic);
    ticker.then<void>((void value) {
      if (mounted && wasHeldDown != _buttonHeldDown) _animate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.enabled;
    final CupertinoThemeData themeData = CupertinoTheme.of(context);
    final Color primaryColor = themeData.primaryColor;
    Color? backgroundColor = widget.color == null
        ? (widget._filled ? primaryColor : null)
        : CupertinoDynamicColor.maybeResolve(widget.color, context);

    Color foregroundColor = backgroundColor != null
        ? themeData.primaryContrastingColor
        : enabled
            ? primaryColor
            : CupertinoDynamicColor.resolve(
                CupertinoColors.placeholderText, context);

    if (widget._outlined && widget.color != null) {
      backgroundColor = null;
      foregroundColor = widget.color ?? primaryColor;
    }

    final TextStyle textStyle = themeData.textTheme.textStyle.copyWith(
      color: foregroundColor,
      fontWeight: FontWeight.w500,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: enabled ? _handleTapDown : null,
      onTapUp: enabled ? _handleTapUp : null,
      onTapCancel: enabled ? _handleTapCancel : null,
      onTap: widget.onPressed,
      child: Semantics(
        button: true,
        child: ConstrainedBox(
          constraints: widget.minSize == null
              ? const BoxConstraints()
              : BoxConstraints(
                  minWidth: widget.minSize!,
                  minHeight: widget.minSize!,
                ),
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: widget._outlined
                    ? Border.fromBorderSide(
                        BorderSide(color: widget.color ?? primaryColor),
                      )
                    : null,
                borderRadius: widget.borderRadius,
                color: backgroundColor != null && !enabled
                    ? CupertinoDynamicColor.resolve(
                        widget.disabledColor, context)
                    : backgroundColor,
              ),
              child: Padding(
                padding: widget.padding ?? _kButtonPadding,
                child: Align(
                  alignment: widget.alignment,
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: DefaultTextStyle(
                    style: textStyle,
                    child: IconTheme(
                      data: IconThemeData(color: foregroundColor),
                      child: widget.processing == true
                          ? SpinKitThreeBounce(
                              color: foregroundColor, size: 14.0)
                          : widget.child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
