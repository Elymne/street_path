import 'package:flutter/material.dart';

class SquaresBackground extends StatefulWidget {
  const SquaresBackground({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SquaresBackground> {
  late final color = Theme.of(context).colorScheme.primary;

  @override
  Widget build(BuildContext context) {
    /// * Using Layout Builder because I need to know the widget size.
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            /// * Left Sticks.
            Positioned(
              /// * First Left square.
              top: constraints.maxHeight * 0.4,
              left: 20,
              child: _SquareElement(
                color: color,
                shadowColor: color,
                size: 60,
                blurRadius: 8,
                enterAnimationDuration: Duration(milliseconds: 100),
              ),
            ),
            Positioned(
              /// * Second Left square.
              top: constraints.maxHeight * 0.1,
              left: 60,
              child: _SquareElement(
                color: color,
                shadowColor: color,
                size: 40,
                blurRadius: 4,
                enterAnimationDuration: Duration(milliseconds: 400),
              ),
            ),
            Positioned(
              /// * Third Left square.
              top: constraints.maxHeight * 0.3,
              left: 140,
              child: _SquareElement(
                color: color,
                shadowColor: color,
                size: 20,
                blurRadius: 3,
                enterAnimationDuration: Duration(milliseconds: 200),
              ),
            ),

            /// * Right Sticks.
            Positioned(
              /// * First Right square.
              bottom: constraints.maxHeight * 0.2,
              right: 20,
              child: _SquareElement(
                color: color,
                shadowColor: color,
                size: 40,
                blurRadius: 4,
                enterAnimationDuration: Duration(milliseconds: 500),
              ),
            ),
            Positioned(
              /// * Second Right square.
              bottom: constraints.maxHeight * 0.4,
              right: 100,
              child: _SquareElement(
                color: color,
                shadowColor: color,
                size: 60,
                blurRadius: 8,
                enterAnimationDuration: Duration(milliseconds: 100),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SquareElement extends StatefulWidget {
  final double size;
  final Color color;
  final Color shadowColor;
  final double blurRadius;

  final Duration enterAnimationDuration;

  const _SquareElement({
    required this.size,
    required this.color,
    required this.shadowColor,
    required this.blurRadius,
    required this.enterAnimationDuration,
  });

  @override
  State<StatefulWidget> createState() => _SquareState();
}

class _SquareState extends State<_SquareElement> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: widget.enterAnimationDuration);
    _slideAnimation = Tween<double>(begin: 100, end: 0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _animationController.addListener(() {
      setState(() {});
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _fadeAnimation.value,
      child: Transform.translate(
        offset: Offset(0, _slideAnimation.value),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            /// * Styling my Bubble.
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.all(Radius.circular(100)),
            boxShadow: [
              /// * First Shadow.
              BoxShadow(color: widget.shadowColor, blurRadius: widget.blurRadius, offset: Offset(0.0, 0.0)),
            ],
          ),
        ),
      ),
    );
  }
}
