import 'package:flutter/material.dart';

class ShakleTextfield extends StatefulWidget {
  final String label;
  final IconData? icon;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final String? value;

  const ShakleTextfield(this.label, {super.key, this.icon, this.onChanged, this.onSubmitted, this.value});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ShakleTextfield> with TickerProviderStateMixin {
  final FocusNode _focus = FocusNode();
  late final AnimationController _backgroundAnimCtrl;
  late final Animation<double> _backgroundAnim;
  final Duration _backgroundAnimTic = Duration(milliseconds: 1_600);
  late final AnimationController _foregroundAnimCtrl;
  late final Animation<double> _foregroundAnim;
  final Duration _foregroundAnimTic = Duration(milliseconds: 1_000);
  final TextEditingController _ctrl = TextEditingController();
  bool isFocus = false;

  @override
  void initState() {
    super.initState();
    _ctrl.text = widget.value ?? "";
    _backgroundAnimCtrl = AnimationController(vsync: this, duration: _backgroundAnimTic);
    _backgroundAnim = Tween<double>(begin: -1.0, end: 1.0).animate(_backgroundAnimCtrl);
    _foregroundAnimCtrl = AnimationController(vsync: this, duration: _foregroundAnimTic);
    _foregroundAnim = Tween<double>(begin: -0.5, end: 0.5).animate(_foregroundAnimCtrl);
    _focus.addListener(_onFocusUpdate);
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusUpdate);
    _backgroundAnimCtrl.dispose();
    _foregroundAnimCtrl.dispose();
    _ctrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: isFocus,
          child: AnimatedBuilder(
            animation: _backgroundAnimCtrl,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_backgroundAnim.value, _backgroundAnim.value / 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(widget.icon, color: Colors.transparent),
                        SizedBox(width: 20),
                        Text(
                          _ctrl.text.isEmpty ? widget.label : " ",
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(height: 2, width: double.infinity, color: Theme.of(context).colorScheme.primary),
                  ],
                ),
              );
            },
          ),
        ),
        AnimatedBuilder(
          animation: _foregroundAnim,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_foregroundAnim.value, _foregroundAnim.value / 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(widget.icon, color: Theme.of(context).colorScheme.primary),
                      SizedBox(width: 20),
                      Text(
                        _ctrl.text.isEmpty ? widget.label : "",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(height: 2, width: double.infinity, color: Theme.of(context).colorScheme.outline),
                ],
              ),
            );
          },
        ),
        Transform.translate(
          offset: Offset(40, 0),
          child: TextField(
            controller: _ctrl,
            focusNode: _focus,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            style: Theme.of(context).textTheme.labelLarge,
            decoration: null,
          ),
        ),
      ],
    );
  }

  /// This function make the autocomplete appear when used.
  /// Can also be used when autocomplete data has been updated.
  /// The values used will depend of the current autocompleteValues and text set in the TextField.

  /// Called each time the input text is activated, focused.
  void _onFocusUpdate() {
    setState(() => isFocus = _focus.hasFocus);
    if (isFocus) {
      _backgroundAnimCtrl.repeat(reverse: true);
      _foregroundAnimCtrl.repeat(reverse: true);
      return;
    }

    _backgroundAnimCtrl.reverse();
    _foregroundAnimCtrl.reverse();
  }
}
