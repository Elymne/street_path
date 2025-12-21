import 'package:flutter/material.dart';

class ShakleElevatedButton extends StatefulWidget {
  final String label;
  final void Function()? onPressed;

  const ShakleElevatedButton(this.label, {super.key, this.onPressed});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ShakleElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        side: BorderSide(
          color: widget.onPressed != null ? Theme.of(context).colorScheme.outline : Theme.of(context).colorScheme.outlineVariant,
          width: 2,
        ),
        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
      ),
      child: Text(
        widget.label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: widget.onPressed != null ? Theme.of(context).colorScheme.outline : Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
    );
  }
}
