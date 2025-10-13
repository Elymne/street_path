/// ------------------------------------------------------------
/// Class: StreetPathGateway
/// Layer: Infrastructure
///
/// Description:
///   Interface décrivant les opérations disponibles pour manipuler le service de StreetPath.
///   Un service de StreetPath doit tourner en dehors de l'application.
///   Elle peut utiliser n'importe quelle librairie.
/// ------------------------------------------------------------
abstract class StreetPathGateway {
  /// Démarre le service StreetPath.
  /// La manière dont le service est créé et tourne ne concerne pas la partie domaine.
  Future start(String notificationTitle, String notificationText);

  /// Coupe le service StreetPath.
  /// La manière dont le service est stoppé ne concerne pas la partie domaine.
  Future stop();

  /// Récupère le status courant du StreetPath
  /// Il est soit actif ou inactif.
  Future<StreetPathStatus> getStatus();
}

enum StreetPathStatus { active, inactive }
