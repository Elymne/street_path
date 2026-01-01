import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/domain/usecases/street_path/can_run_street_path.useacse.dart';
import 'package:poc_street_path/domain/usecases/street_path/check_street_path_permissions.usecase.dart';
import 'package:poc_street_path/domain/usecases/street_path/start_street_path.usecase.dart';

/// Le notifier principal pour gérer le service de streetpath de manière globale.
/// J'aimerais beaucoup que les erreurs issus du foreground passe par ici pour que n'importe quelle vue qui utilise ce notifier soit notifié.
/// todo : faire un truc clean.
class StreetPathNotifier extends AsyncNotifier<StreetPathStatus> {
  late final _canRunStreetPath = ref.read(canRunStreetPathProvider);
  late final _checkStreetPathPermissions = ref.read(checkStreetPathPermissionsProvider);
  late final _startStreetPath = ref.read(stratStreetPathProvider);

  @override
  StreetPathStatus build() => StreetPathStatus.notRunning;

  Future<void> canRunStreetPath() async {
    final canRunResult = await _canRunStreetPath.execute();
    if (canRunResult is Failure) {
      state = AsyncData(StreetPathStatus.crashed);
      return;
    }

    final canRun = (canRunResult as Success<bool>).data;
    if (!canRun) {
      state = AsyncData(StreetPathStatus.cantRun);
    }
  }
}

enum StreetPathStatus { notRunning, crashed, cantRun, permissionsNotValidated, running }

final initAppNotifier = AsyncNotifierProvider.autoDispose<StreetPathNotifier, StreetPathStatus>(StreetPathNotifier.new);
