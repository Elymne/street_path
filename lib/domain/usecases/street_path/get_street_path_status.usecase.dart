import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/gateways/street_path.gateway.dart';

class GetStreetPathStatusParams {}

class GetStreetPathStatus extends Usecase<GetStreetPathStatusParams, StreetPathStatus> {
  final StreetPathGateway _streetPathGateway;

  GetStreetPathStatus(this._streetPathGateway);

  @override
  Future<Result<StreetPathStatus>> execute(GetStreetPathStatusParams? params) async {
    try {
      return Success(await _streetPathGateway.getStatus());
    } catch (err, stack) {
      SpLog.instance.e("GetStreetPathStatus: Une exception a été levée.", err, stack: stack);
      return Failure("Une erreur s'est produite lors de la recherche du StreetPath…");
    }
  }
}
