import 'package:flutter/material.dart';

class ShakleHomeItem extends StatefulWidget {
  final String title;
  final IconData iconData;
  final void Function() onTap;

  const ShakleHomeItem({super.key, required this.title, required this.iconData, required this.onTap});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ShakleHomeItem> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.outline.withAlpha(40), blurRadius: 4, offset: Offset(4, 4))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Stack(
              children: [
                Positioned(
                  right: 0,
                  top: 20,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withAlpha(200), shape: BoxShape.circle),
                  ),
                ),
                Icon(widget.iconData, color: Theme.of(context).colorScheme.onSurface, size: 60),
              ],
            ),
            SizedBox(),
            Text(widget.title, style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}
