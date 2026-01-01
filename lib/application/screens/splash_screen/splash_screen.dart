import 'package:poc_street_path/domain/usecases/street_path/can_run_street_path.useacse.dart';
import 'package:poc_street_path/domain/usecases/street_path/check_street_path_permissions.usecase.dart';
import 'package:poc_street_path/domain/usecases/street_path/start_street_path.usecase.dart';
import 'package:poc_street_path/application/notifiers/sync_content_notifier.dart';
import 'package:poc_street_path/application/widgets/shakles/shakle_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<SplashScreen> with TickerProviderStateMixin {
  final List<String> randomEmote = ['(๑꒪▿꒪)*', '(≧∇≦*)', '(*´꒳`*)', '٩(ˊᗜˋ*)و'];

  late final _canRunStreetPath = ref.read(canRunStreetPathProvider);
  late final _checkStreetPathPermissions = ref.read(checkStreetPathPermissionsProvider);
  late final _startStreetPath = ref.read(stratStreetPathProvider);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // ref.read(initAppNotifier.notifier).syncData();
      await _startStreetPath.execute(
        StartStreetPathParams(notificationText: 'Ca démarre wallah', notificationTitle: 'Bah ? Oui ?'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(initAppNotifier).whenData((value) {
      if (value == SyncContentState.failure) {
        // todo : Une erreur s'est produite lors du chargement des données niveau app.
        // Proposer de retry ou bloquer l'app.
        return;
      }
      // todo : access to HomePage.
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ShakleText(
            'BedBug \n${randomEmote[Random().nextInt(randomEmote.length)]}',
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
      ),
    );
  }
}
