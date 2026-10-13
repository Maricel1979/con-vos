import 'dart:math';
import 'package:flutter/material.dart';

class FloatingEmojiWidget extends StatefulWidget {
  final String emoji;
  final VoidCallback onAnimationFinished;

  const FloatingEmojiWidget({
    Key? key,
    required this.emoji,
    required this.onAnimationFinished,
  }) : super(key: key);

  @override
  State<FloatingEmojiWidget> createState() => _FloatingEmojiWidgetState();
}

class _FloatingEmojiWidgetState extends State<FloatingEmojiWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _yAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  
  // Desplazamiento horizontal aleatorio para que los emojis no suban en línea recta
  late final double _randomXOffset;

  @override
  void initState() {
    super.initState();
    _randomXOffset = (Random().nextDouble() - 0.5) * 80;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _yAnimation = Tween<double>(begin: 0.0, end: -350.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.6).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.elasticOut),
      ),
    );

    _controller.forward().then((_) {
      widget.onAnimationFinished();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          right: 40 + _randomXOffset,
          bottom: 90 + _yAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Text(
                widget.emoji,
                style: const TextStyle(fontSize: 36),
              ),
            ),
          ),
        );
      },
    );
  }
}