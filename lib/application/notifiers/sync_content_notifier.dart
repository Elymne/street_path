import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/domain/usecases/sync/sync_posts.dart';

/// Notifier de synchro des contenus brutes stockés via le système de street path.
/// Permet de savoi r en direct combien de contenus ont été ajoutés en DB.
/// -1 lorsque une erreur s'est produite.
class SyncContentNotifier extends AsyncNotifier<int> {
  late final SyncContent _syncPost = ref.read(syncContentProvider);

  @override
  int build() => 0;

  Future<void> syncData() async {
    state = AsyncLoading();
    final syncPostResult = await _syncPost.execute(SyncPostParams());
    if (syncPostResult is Failure) {
      state = AsyncData(-1);
      return;
    }
    state = AsyncData((syncPostResult as Success).data);
  }
}

final initAppNotifier = AsyncNotifierProvider.autoDispose<SyncContentNotifier, int>(SyncContentNotifier.new);
