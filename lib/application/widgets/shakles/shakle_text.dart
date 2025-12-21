import 'package:flutter/material.dart';

class ShakleText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final double force;

  const ShakleText(this.text, {super.key, required this.style, this.force = 1});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ShakleText> with TickerProviderStateMixin {
  /// Background idle animation.
  late final AnimationController _backgroundAnimCtrl;
  late final Animation<double> _backgroundAnim;
  final Duration _backgroundAnimTic = Duration(milliseconds: 1_600);

  /// Frontend idle animation.
  late final AnimationController _foregroundAnimCtrl;
  late final Animation<double> _foregroundAnim;
  final Duration _foregroundAnimTic = Duration(milliseconds: 1_000);

  @override
  void initState() {
    super.initState();

    /// * Set the text shaky animation for background text.
    _backgroundAnimCtrl = AnimationController(vsync: this, duration: _backgroundAnimTic);
    _backgroundAnim = Tween<double>(begin: -3, end: 3).animate(_backgroundAnimCtrl);
    _backgroundAnimCtrl.repeat(reverse: true);

    /// * Set the text shaky animation for frontend text.
    _foregroundAnimCtrl = AnimationController(vsync: this, duration: _foregroundAnimTic);
    _foregroundAnim = Tween<double>(begin: -1, end: 1).animate(_foregroundAnimCtrl);
    _foregroundAnimCtrl.repeat(reverse: true);
  }

  @override
  void dispose() {
    _backgroundAnimCtrl.dispose();
    _foregroundAnimCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _backgroundAnim,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_backgroundAnim.value * widget.force, 0),
              child: Text(widget.text, style: widget.style?.copyWith(color: Theme.of(context).colorScheme.primary)),
            );
          },
        ),
        AnimatedBuilder(
          animation: _foregroundAnim,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_foregroundAnim.value * widget.force, 0),
              child: Text(widget.text, style: widget.style),
            );
          },
        ),
      ],
    );
  }
}
