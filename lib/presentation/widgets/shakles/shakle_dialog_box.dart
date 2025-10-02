import 'package:flutter/material.dart';
import 'package:poc_street_path/presentation/widgets/shakles/abstract_shakle_state.dart';
import 'package:poc_street_path/presentation/widgets/shakles/shakle_outlined_button.dart';

class ShakleDialogBox extends StatefulWidget {
  final String? title;
  final Widget? content;

  final String? firstButtonText;
  final void Function()? onFirstButton;

  final String? secondButtonText;
  final void Function()? onSecondButton;

  const ShakleDialogBox({
    super.key,
    this.title,
    this.content,
    this.firstButtonText,
    this.onFirstButton,
    this.secondButtonText,
    this.onSecondButton,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends AbstractShakleState<ShakleDialogBox> {
  final GlobalKey _foregroundKey = GlobalKey();
  Size? _widgetSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _foregroundKey.currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox;
        setState(() => _widgetSize = box.size);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: getAnimSkeleton(
        fixed: Column(
          key: _foregroundKey,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            if (widget.title != null) Text(widget.title!, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            if (widget.content != null) widget.content!,
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.firstButtonText != null)
                  ShakleOutlinedButton(
                    widget.firstButtonText!,
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      if (widget.onFirstButton != null) widget.onFirstButton!();
                    },
                  ),
                if (widget.firstButtonText != null && widget.secondButtonText != null) const SizedBox(width: 20),
                if (widget.secondButtonText != null)
                  ShakleOutlinedButton(
                    widget.secondButtonText!,
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      if (widget.onSecondButton != null) widget.onSecondButton!();
                    },
                  ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),

        /// *
        background: SizedBox(),

        /// *
        foreground: Container(
          height: _widgetSize?.height ?? 0,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Theme.of(context).colorScheme.outline, width: 1),
          ),
        ),
      ),
    );
  }
}
