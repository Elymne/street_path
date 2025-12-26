import 'package:poc_street_path/application/notifiers/sync_content_notifier.dart';
import 'package:poc_street_path/application/widgets/shakles/shakle_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<SplashScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(initAppNotifier.notifier).syncData();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(initAppNotifier).whenData((value) {
      if (value == false) return;
      // todo : access to HomePage.
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ShakleText('BedBug', style: Theme.of(context).textTheme.displayLarge)],
        ),
      ),
    );
  }
}
