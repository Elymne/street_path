import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/gateways/street_path.gateway.dart';
import 'package:poc_street_path/infrastructure/gateways/street_path_impl.gateway.dart';

class CheckStreetPathPermissions extends UsecaseNoParams<bool> {
  final StreetPathGateway _streetPathGateway;

  CheckStreetPathPermissions(this._streetPathGateway);

  @override
  Future<Result<bool>> execute() async {
    try {
      return Success(await _streetPathGateway.checkPermissions());
    } catch (err, stack) {
      SpLog().e('GetStreetPathStatus: Une exception a été levée.', err, stack: stack);
      return Failure(FailureCode.serviceFailure);
    }
  }
}

final checkStreetPathPermissionsProvider = Provider<CheckStreetPathPermissions>((ref) {
  final streetPathGateway = ref.read(streetPathGatewayProvider);
  return CheckStreetPathPermissions(streetPathGateway);
});
