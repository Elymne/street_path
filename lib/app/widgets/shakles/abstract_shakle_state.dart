import 'package:flutter/material.dart';

abstract class AbstractShakleState<T extends StatefulWidget> extends State<T> with TickerProviderStateMixin {
  late final AnimationController backgroundAnimCtrl;
  late final AnimationController foregroundAnimCtrl;
  late final Animation<double> backgroundAnim;
  late final Animation<double> foregroundAnim;
  Duration backgroundAnimTic;
  Duration foregroundAnimTic;

  AbstractShakleState({
    this.backgroundAnimTic = const Duration(milliseconds: 1_600),
    this.foregroundAnimTic = const Duration(milliseconds: 1_000),
  });

  @override
  void initState() {
    super.initState();
    backgroundAnimCtrl = AnimationController(vsync: this, duration: backgroundAnimTic);
    foregroundAnimCtrl = AnimationController(vsync: this, duration: foregroundAnimTic);
    backgroundAnim = Tween<double>(begin: -1.2, end: 1.2).animate(backgroundAnimCtrl);
    foregroundAnim = Tween<double>(begin: -1, end: 1).animate(foregroundAnimCtrl);
    backgroundAnimCtrl.repeat(reverse: true);
    foregroundAnimCtrl.repeat(reverse: true);
  }

  @override
  void dispose() {
    backgroundAnimCtrl.dispose();
    foregroundAnimCtrl.dispose();
    super.dispose();
  }

  Widget getAnimSkeleton({Widget? background, Widget? foreground, Widget? fixed}) {
    return Stack(
      children: [
        Visibility(
          visible: background != null,
          child: AnimatedBuilder(
            animation: backgroundAnimCtrl,
            builder: (context, child) {
              return Transform.translate(offset: Offset(backgroundAnim.value, backgroundAnim.value * 0.5), child: background);
            },
          ),
        ),
        Visibility(
          visible: foreground != null,
          child: AnimatedBuilder(
            animation: foregroundAnimCtrl,
            builder: (context, child) {
              return Transform.translate(offset: Offset(foregroundAnim.value, foregroundAnim.value * 0.5), child: foreground);
            },
          ),
        ),
        if (fixed != null) fixed,
      ],
    );
  }
}
