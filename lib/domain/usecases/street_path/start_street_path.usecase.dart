import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/gateways/street_path.gateway.dart';

class StartStreetPathParams {
  final String notificationText;
  final String notificationTitle;
  StartStreetPathParams({required this.notificationText, required this.notificationTitle});
}

class StartStreetPath extends Usecase<StartStreetPathParams, void> {
  final StreetPathGateway _streetPathGateway;

  StartStreetPath(this._streetPathGateway);

  @override
  Future<Result<void>> execute(StartStreetPathParams params) async {
    try {
      if (await _streetPathGateway.getStatus() == StreetPathStatus.active) {
        SpLog.instance.w("StartStreetPath: Quelque chose a tenté de démarrer le service StreetPath alors qu'il tournait déjà.");
        return Failure("Le StreetPath tourne déjà");
      }
      await _streetPathGateway.start(params.notificationText, params.notificationTitle);
      return Success(null);
    } catch (err, stack) {
      SpLog.instance.e("StartStreetPath: Une exception a été levée.", err, stack: stack);
      return Failure("Une erreur s'est produite lors du démarrage du StreetPath…");
    }
  }
}
