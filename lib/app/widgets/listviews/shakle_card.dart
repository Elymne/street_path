import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShakleCard extends ConsumerStatefulWidget {
  final String text;
  final String? subtext;
  final IconData? icon;
  final bool isActive;
  final void Function()? onTap;

  const ShakleCard({super.key, required this.text, this.subtext, this.icon, this.isActive = false, this.onTap});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<ShakleCard> with TickerProviderStateMixin {
  late final AnimationController _backgroundAnimCtrl;
  late final Animation<double> _backgroundAnim;
  final Duration _backgroundAnimTic = Duration(milliseconds: 400);

  late final AnimationController _foregroundAnimCtrl;
  late final Animation<double> _foregroundAnim;
  final Duration _foregroundAnimTic = Duration(milliseconds: 600);

  @override
  void initState() {
    super.initState();
    _backgroundAnimCtrl = AnimationController(vsync: this, duration: _backgroundAnimTic);
    _backgroundAnim = Tween<double>(begin: -1.0, end: 1.0).animate(_backgroundAnimCtrl);
    _foregroundAnimCtrl = AnimationController(vsync: this, duration: _foregroundAnimTic);
    _foregroundAnim = Tween<double>(begin: -0.5, end: 0.5).animate(_foregroundAnimCtrl);
  }

  @override
  void dispose() {
    _backgroundAnimCtrl.dispose();
    _foregroundAnimCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isActive) {
      _backgroundAnimCtrl.repeat(reverse: true);
      _foregroundAnimCtrl.repeat(reverse: true);
    } else {
      _backgroundAnimCtrl.reverse();
      _foregroundAnimCtrl.reverse();
    }

    return Stack(
      children: [
        Visibility(
          visible: widget.isActive,
          child: AnimatedBuilder(
            animation: _backgroundAnim,
            builder: (context, child) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: Transform.translate(
                  offset: Offset(_backgroundAnim.value, _backgroundAnim.value / 2),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                      border: Border.all(color: Theme.of(context).colorScheme.primary),
                    ),
                    child: Row(
                      children: [
                        Icon(widget.icon, color: Theme.of(context).colorScheme.primary),
                        SizedBox(width: 20),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.text,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.primary),
                              ),
                              Visibility(
                                visible: widget.subtext != null,
                                child: Text(
                                  widget.subtext ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.primary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        AnimatedBuilder(
          animation: _foregroundAnim,
          builder: (context, child) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0),
              child: Transform.translate(
                offset: Offset(_foregroundAnim.value, _foregroundAnim.value / 2),
                child: GestureDetector(
                  onTap: () {
                    if (widget.onTap != null) widget.onTap!();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                      border: Border.all(
                        color: widget.isActive ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          widget.icon,
                          color: widget.isActive ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSecondary,
                        ),
                        SizedBox(width: 20),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.text,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              Visibility(
                                visible: widget.subtext != null,
                                child: Text(
                                  widget.subtext ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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


// tileColor: Theme.of(context).colorScheme.surfaceContainer,
// splashColor: Theme.of(context).colorScheme.primary.withAlpha(100),