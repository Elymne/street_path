import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/gateways/street_path.gateway.dart';
import 'package:poc_street_path/infrastructure/gateways/street_path_impl.gateway.dart';

class CanRunStreetPath extends UsecaseNoParams<bool> {
  final StreetPathGateway _streetPathGateway;

  CanRunStreetPath(this._streetPathGateway);

  @override
  Future<Result<bool>> execute() async {
    try {
      return Success(await _streetPathGateway.canRun());
    } catch (err, stack) {
      SpLog().e('GetStreetPathStatus: Une exception a été levée.', err, stack: stack);
      return Failure(FailureCode.serviceFailure);
    }
  }
}

final canRunStreetPathProvider = Provider<CanRunStreetPath>((ref) {
  final streetPathGateway = ref.read(streetPathGatewayProvider);
  return CanRunStreetPath(streetPathGateway);
});
