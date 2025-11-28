import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/domain/usecases/sync/sync_posts.dart';

/// AsyncNotifier à utiliser pour sync les données brutes transférés récupéré par l'utilisateur.
class InitAppNotifier extends AsyncNotifier<String> {
  late final SyncPost _syncPost = ref.read(syncPostProvider);

  @override
  String build() => '';

  Future<void> syncData() async {
    state = AsyncLoading();

    final syncPostResult = await _syncPost.execute(SyncPostParams());

    if (syncPostResult is Failure) {
      state = AsyncData("Une erreur s'est produite. Tentative de bidule");
    }

    state = AsyncData('Données chargées');
  }
}

final initAppNotifier = AsyncNotifierProvider.autoDispose<InitAppNotifier, String>(InitAppNotifier.new);
