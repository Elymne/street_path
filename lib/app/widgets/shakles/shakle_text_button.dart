import 'package:flutter/material.dart';

class ShakleTextButton extends StatefulWidget {
  final String label;
  final void Function()? onPressed;

  const ShakleTextButton(this.label, {super.key, this.onPressed});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ShakleTextButton> with TickerProviderStateMixin {
  late final AnimationController _backgroundAnimCtrl;
  late final Animation<double> _backgroundAnim;
  final Duration _backgroundAnimTic = Duration(milliseconds: 1_600);

  late final AnimationController _foregroundAnimCtrl;
  late final Animation<double> _foregroundAnim;
  final Duration _foregroundAnimTic = Duration(milliseconds: 1_000);

  @override
  void initState() {
    super.initState();
    _backgroundAnimCtrl = AnimationController(vsync: this, duration: _backgroundAnimTic);
    _foregroundAnimCtrl = AnimationController(vsync: this, duration: _foregroundAnimTic);
    _backgroundAnim = Tween<double>(begin: -1.2, end: 1.2).animate(_backgroundAnimCtrl);
    _foregroundAnim = Tween<double>(begin: -1, end: 1).animate(_foregroundAnimCtrl);
    if (widget.onPressed != null) _backgroundAnimCtrl.repeat(reverse: true);
    if (widget.onPressed != null) _foregroundAnimCtrl.repeat(reverse: true);
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
        Visibility(
          child: AnimatedBuilder(
            animation: _backgroundAnimCtrl,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_backgroundAnim.value, _backgroundAnim.value * 0.5),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20)),
                  child: Text(
                    widget.label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              );
            },
          ),
        ),
        AnimatedBuilder(
          animation: _foregroundAnim,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_foregroundAnim.value, _foregroundAnim.value * 0.5),
              child: TextButton(
                onPressed: widget.onPressed,
                style: TextButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20)),
                child: Text(
                  widget.label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: widget.onPressed != null ? Theme.of(context).colorScheme.outline : Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
