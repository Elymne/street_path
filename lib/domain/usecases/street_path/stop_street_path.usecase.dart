import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/gateways/street_path.gateway.dart';

class StopStreetPathParams {}

class StopStreetPath extends Usecase<StopStreetPathParams, void> {
  final StreetPathGateway _streetPathGateway;

  StopStreetPath(this._streetPathGateway);

  @override
  Future<Result<void>> execute(StopStreetPathParams params) async {
    try {
      await _streetPathGateway.stop();
      return Success(null);
    } catch (err, stack) {
      SpLog.instance.e("StopStreetPath: Une exception a été levée.", err, stack: stack);
      return Failure("Une erreur s'est produite lors du démarrage du StreetPath…");
    }
  }
}
