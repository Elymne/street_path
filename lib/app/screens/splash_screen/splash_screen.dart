import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poc_street_path/app/screens/home_screen/home_screen.dart';
import 'package:poc_street_path/app/widgets/shakles/shakle_text.dart';
import 'dart:async';

import 'package:poc_street_path/core/l10n/app_localizations.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<SplashScreen> with TickerProviderStateMixin {
  final _splashscreenDur = Duration(milliseconds: 3000);

  @override
  void initState() {
    super.initState();

    Future.delayed(_splashscreenDur, () async {
      if (!mounted) return;
      await Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {},
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShakleText(AppLocalizations.of(context)!.title, style: Theme.of(context).textTheme.displayLarge),
              ShakleText(AppLocalizations.of(context)!.title, style: Theme.of(context).textTheme.displayLarge),
            ],
          ),
        ),
      ),
    );
  }
}
