import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/domain/usecases/sync/sync_posts.dart';

/// Notifier de synchro des contenus brutes stockés via le système de street path.
/// Permet de savoir en direct combien de contenus ont été ajoutés en DB.
/// -1 lorsque une erreur s'est produite.
class StreetPathNotifier extends AsyncNotifier<int> {
  late final SyncContent _syncContent = ref.read(syncContentProvider);

  @override
  int build() => 0;

  Future<void> syncData() async {
    state = AsyncLoading();

    final syncPostResult = await _syncContent.execute(SyncPostParams());
    if (syncPostResult is Failure) {
      state = AsyncData(1);
      return;
    }
    state = AsyncData(1);
  }
}

final initAppNotifier = AsyncNotifierProvider.autoDispose<StreetPathNotifier, int>(StreetPathNotifier.new);
