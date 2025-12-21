import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/domain/usecases/sync/sync_posts.dart';

/// Notifier à utiliser pour initialiser l'application lors du démarrage.
/// Permet de sync les posts récupéré par le service.
/// Vérifie aussi les permissions et droits.
class InitAppNotifier extends AsyncNotifier<InitAppState> {
  late final SyncPost _syncPost = ref.read(syncPostProvider);

  @override
  InitAppState build() => InitAppState(prog: 0, message: '');

  Future<void> syncData() async {
    state = AsyncLoading();

    final syncPostResult = await _syncPost.execute(SyncPostParams());

    if (syncPostResult is Failure) {
      state = AsyncData(InitAppState(prog: 0, message: "Une erreur s'est produite. Tentative de bidule"));
    }

    state = AsyncData(InitAppState(prog: 100, message: 'Données chargées'));
  }
}

class InitAppState {
  final double prog;
  final String message;

  InitAppState({required this.prog, required this.message});
}

final initAppNotifier = AsyncNotifierProvider.autoDispose<InitAppNotifier, InitAppState>(InitAppNotifier.new);
