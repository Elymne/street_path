import 'package:poc_street_path/core/logger/sp_log.dart';
import 'package:poc_street_path/core/result.dart';
import 'package:poc_street_path/core/usecase.dart';
import 'package:poc_street_path/domain/gateways/street_path.gateway.dart';

/// ------------------------------------------------------------
/// Class: StartStreetPath
/// Layer: Application
///
/// Description:
///   Permet de démarrer le service de StreetPath
///
/// Dépendances :
///   [StreetPathGateway]
/// Paramètres:
///   [StartStreetPathParams]
/// Sortie:
///   [Result] Retourne simplement un objet de résultat en fonction de si le processus a marché ou non.
/// ------------------------------------------------------------
/// Étapes métier:
/// 1. Vérifie le service est déjà en marche.
/// 2. Si le service n'est pas en marche, démarre.
/// ------------------------------------------------------------
class StartStreetPath extends Usecase<StartStreetPathParams, void> {
  final StreetPathGateway _streetPathGateway;

  StartStreetPath(this._streetPathGateway);

  @override
  Future<Result<void>> execute(StartStreetPathParams params) async {
    try {
      if (await _streetPathGateway.getStatus() == StreetPathStatus.active) {
        SpLog().w("StartStreetPath: Quelque chose a tenté de démarrer le service StreetPath alors qu'il tournait déjà.");
        return Failure("Le StreetPath tourne déjà");
      }
      await _streetPathGateway.start(params.notificationText, params.notificationTitle);
      return Success(null);
    } catch (err, stack) {
      SpLog().e("StartStreetPath: Une exception a été levée.", err, stack: stack);
      return Failure("Une erreur s'est produite lors du démarrage du StreetPath…");
    }
  }
}

class StartStreetPathParams {
  final String notificationText;
  final String notificationTitle;
  StartStreetPathParams({required this.notificationText, required this.notificationTitle});
}
