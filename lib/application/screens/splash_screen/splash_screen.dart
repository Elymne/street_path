import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poc_street_path/application/notifiers/init_app_notifier.dart';
import 'package:poc_street_path/application/widgets/shakles/shakle_text.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<SplashScreen> with TickerProviderStateMixin {
  late final initAppNotifier = ref.read(initAppNotifier.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initAppNotifier.syncData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShakleText('PTDR', style: Theme.of(context).textTheme.displayLarge),
            ShakleText('Bon ????', style: Theme.of(context).textTheme.displayLarge),
          ],
        ),
      ),
    );
  }
}
