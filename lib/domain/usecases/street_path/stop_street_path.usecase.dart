import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/gateways/street_path.gateway.dart';
import 'package:poc_street_path/infrastructure/gateways/street_path_impl.gateway.dart';

/// ------------------------------------------------------------
/// Class: StopStreetPath
/// Layer: Application
///
/// Description:
///   Permet de stopper le service de StreetPath
///
/// Dépendances :
///   [StreetPathGateway]
/// Paramètres:
///   [StopStreetPathParams]
/// Sortie:
///   [Result] Retourne simplement un objet de résultat en fonction de si le processus a marché ou non.
/// ------------------------------------------------------------
/// Étapes métier:
/// 1. Coupe le StreetPath.
/// ------------------------------------------------------------
class StopStreetPath extends UsecaseNoParams<void> {
  final StreetPathGateway _streetPathGateway;

  StopStreetPath(this._streetPathGateway);

  @override
  Future<Result<void>> execute() async {
    try {
      await _streetPathGateway.stop();
      return Success(null);
    } catch (err, stack) {
      SpLog().e('StopStreetPath: Une exception a été levée.', err, stack: stack);
      return Failure(FailureCode.serviceFailure);
    }
  }
}

final stopStreetPathProvider = Provider<StopStreetPath>((ref) {
  final streetPathGateway = ref.read(streetPathGatewayProvider);
  return StopStreetPath(streetPathGateway);
});
