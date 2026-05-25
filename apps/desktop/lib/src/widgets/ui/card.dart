import 'package:flutter/material.dart' hide Card;

class Card extends StatelessWidget {
  const Card({
    super.key,
    required this.child,
    this.margin = const EdgeInsets.symmetric(horizontal: 12),
    this.padding,
    this.constraints,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.clipBehavior = Clip.antiAlias,
  });

  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry? padding;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;
  final BorderRadius borderRadius;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: margin,
      width: width,
      height: height,
      constraints: constraints,
      decoration: BoxDecoration(
        color: theme.canvasColor.withValues(alpha: 0.60),
        borderRadius: borderRadius,
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      clipBehavior: clipBehavior,
      padding: padding,
      child: child,
    );
  }
}
