import 'package:chat_application/themes/app_theme.dart';
import 'package:flutter/material.dart';

class Typingindicator extends StatefulWidget {
  const Typingindicator({super.key});

  @override
  State<Typingindicator> createState() => _TypingindicatorState();
}

class _TypingindicatorState extends State<Typingindicator>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;

  static const int _dotCount = 3;
  static const Duration _duration = Duration(milliseconds: 600);
  static const Duration _stagger = Duration(milliseconds: 160);

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      _dotCount,
      (i) => AnimationController(vsync: this, duration: _duration),
    );

    _animations = _controllers
        .map(
          (c) => Tween<double>(begin: 0, end: -7).animate(
            CurvedAnimation(parent: c, curve: Curves.easeInOut),
          ),
        )
        .toList();

    _startAnimation();
  }

  void _startAnimation() async {
    while (mounted) {
      for (int i = 0; i < _dotCount; i++) {
        if (!mounted) return;
        _controllers[i].forward().then((_) {
          if (mounted) _controllers[i].reverse();
        });
        await Future.delayed(_stagger);
      }
      // Wait for the last dot to finish before restarting
      await Future.delayed(
        _duration + (_stagger * (_dotCount - 1)),
      );
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatTheme = Theme.of(context).extension<AppChatTheme>()!;

    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 4, top: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Small "tail" circle to mimic a message bubble tail
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(right: 4, bottom: 2),
            decoration: BoxDecoration(
              color: chatTheme.bubbleReceived,
              shape: BoxShape.circle,
            ),
          ),

          // Main bubble
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: chatTheme.bubbleReceived,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(_dotCount, (i) {
                return AnimatedBuilder(
                  animation: _animations[i],
                  builder: (context, _) {
                    return Transform.translate(
                      offset: Offset(0, _animations[i].value),
                      child: Container(
                        width: 8,
                        height: 8,
                        margin: EdgeInsets.only(right: i < _dotCount - 1 ? 5 : 0),
                        decoration: BoxDecoration(
                          color: chatTheme.bubbleReceivedText.withValues(
                            alpha: 0.55,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
