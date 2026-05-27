import 'dart:async';
import 'package:flutter/material.dart';

/// A text widget that reveals its content character by character
/// with a typewriter-style animation.
class TypewriterText extends StatefulWidget {
  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.speed = const Duration(milliseconds: 30),
    this.showCursor = true,
    this.cursorColor,
    this.onComplete,
  });

  /// The full text to reveal.
  final String text;

  /// Text style for the revealed text.
  final TextStyle? style;

  /// Delay between each character reveal.
  final Duration speed;

  /// Whether to show a blinking cursor at the end.
  final bool showCursor;

  /// Color of the blinking cursor.
  final Color? cursorColor;

  /// Called when all text has been revealed.
  final VoidCallback? onComplete;

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _cursorController;
  Timer? _timer;
  int _index = 0;

  /// Characters that trigger a longer pause when revealed.
  static const _punctuationChars = '.!?;；。！？';

  @override
  void initState() {
    super.initState();
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 530),
    )..repeat(reverse: true);
    _scheduleNext();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cursorController.dispose();
    super.dispose();
  }

  bool _isPunctuation(String char) => _punctuationChars.contains(char);

  void _scheduleNext() {
    _timer?.cancel();
    if (_index >= widget.text.length) return;

    final currentChar = widget.text[_index];
    final delay = _isPunctuation(currentChar) ? widget.speed * 8 : widget.speed;
    _timer = Timer(delay, _onTick);
  }

  void _onTick() {
    if (!mounted) return;
    setState(() => _index++);

    if (_index >= widget.text.length) {
      widget.onComplete?.call();
      return;
    }
    _scheduleNext();
  }

  @override
  Widget build(BuildContext context) {
    final revealed = widget.text.substring(0, _index);
    final isAnimating = _index < widget.text.length;
    final showCursor = isAnimating || widget.showCursor;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: revealed, style: widget.style),
          if (showCursor)
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: FadeTransition(
                opacity: _cursorController,
                child: Text(
                  '|',
                  style: widget.style?.copyWith(
                    color: widget.cursorColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
