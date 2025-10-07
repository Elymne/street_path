import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/gateways/street_path.gateway.dart';

class InitStreetPathParams {}

class InitStreetPath extends Usecase<InitStreetPathParams, void> {
  final StreetPathGateway _streetPathGateway;

  InitStreetPath(this._streetPathGateway);

  @override
  Future<Result<void>> execute(InitStreetPathParams? params) async {
    try {
      if (await _streetPathGateway.getStatus() != StreetPathStatus.none) {
        SpLog.instance.w("InitStreetPath: Tentative d'initialiser le service déjà en route.");
        return Failure("Le service StreetPath est déjà en marche.");
      }
      await _streetPathGateway.init();
      return Success(null);
    } catch (err, stack) {
      SpLog.instance.e("InitStreetPath: Une exception a été levée.", err, stack: stack);
      return Failure("Une erreur s'est produite lors du démarrage du StreetPath…");
    }
  }
}
