import 'dart:math' as math;

import 'package:flutter/material.dart';

enum LoadingIndicatorType {
  threeBounce,
  doubleBounce,
}

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({
    Key? key,
    required this.type,
    this.color,
    this.size = 18,
  }) : super(key: key);

  const LoadingIndicator.threeBounce({
    Key? key,
    this.color,
    this.size = 18,
  })  : type = LoadingIndicatorType.threeBounce,
        super(key: key);

  const LoadingIndicator.doubleBounce({
    Key? key,
    this.color,
    this.size = 18,
  })  : type = LoadingIndicatorType.doubleBounce,
        super(key: key);

  final LoadingIndicatorType type;
  final Color? color;
  final double size;

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).primaryColor;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        switch (widget.type) {
          case LoadingIndicatorType.threeBounce:
            return _ThreeBounceIndicator(
              color: color,
              size: widget.size,
              progress: _controller.value,
            );
          case LoadingIndicatorType.doubleBounce:
            return _DoubleBounceIndicator(
              color: color,
              size: widget.size,
              progress: _controller.value,
            );
        }
      },
    );
  }
}

class _ThreeBounceIndicator extends StatelessWidget {
  const _ThreeBounceIndicator({
    required this.color,
    required this.size,
    required this.progress,
  });

  final Color color;
  final double size;
  final double progress;

  double _dotScale(int index) {
    final offset = (progress - index * 0.16) % 1.0;
    final wave = math.sin(offset * math.pi);
    return 0.45 + (wave.isNegative ? 0 : wave) * 0.55;
  }

  @override
  Widget build(BuildContext context) {
    final dotSize = size / 2.8;
    final spacing = dotSize * 0.5;

    return SizedBox(
      width: dotSize * 3 + spacing * 2,
      height: size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(3, (index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing / 2),
            child: Transform.scale(
              scale: _dotScale(index),
              child: Opacity(
                opacity: 0.35 + _dotScale(index) * 0.65,
                child: Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _DoubleBounceIndicator extends StatelessWidget {
  const _DoubleBounceIndicator({
    required this.color,
    required this.size,
    required this.progress,
  });

  final Color color;
  final double size;
  final double progress;

  double _scale(double offset) {
    final value = ((progress + offset) % 1.0);
    return Curves.easeInOut.transform(value);
  }

  @override
  Widget build(BuildContext context) {
    final firstScale = _scale(0);
    final secondScale = _scale(0.5);

    Widget bubble(double scale, double opacity) {
      return Transform.scale(
        scale: 0.12 + scale * 0.88,
        child: Opacity(
          opacity: opacity,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          bubble(firstScale, 0.25 + (1 - firstScale) * 0.5),
          bubble(secondScale, 0.25 + (1 - secondScale) * 0.5),
        ],
      ),
    );
  }
}
