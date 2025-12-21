import 'package:flutter/material.dart';

class ShakleLoading extends StatefulWidget {
  const ShakleLoading({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ShakleLoading> with TickerProviderStateMixin {
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
    _backgroundAnimCtrl.repeat(reverse: true);
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
          animation: _backgroundAnimCtrl,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_backgroundAnim.value, _backgroundAnim.value * 0.5),
              child: SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                ),
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _foregroundAnimCtrl,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_foregroundAnim.value, _foregroundAnim.value * 0.5),
              child: SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.outline,
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.outline),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
