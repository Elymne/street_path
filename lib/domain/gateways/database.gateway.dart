/// Interface décrivant les opérations disponibles pour gérer une base de données.
/// Toutes classes implémentant cette interface doit-être ensuite utilisé par la partie domaine du projet.
///
/// T correspond à la classe qui permettra d'effectuer des actions sur la base de données.
/// Elle peut provenir d'une lib ou de vous.
abstract class DatabaseGateway<T> {
  /// Se connecte à une base de données.
  /// La configuration doit-être géré par l'implémentation.
  /// Pour accéder aux fonctionnalités de la base de données, il faudra utiliser la fonction getConnector()
  Future<void> connect();

  /// Ferme la connexion à la base de données.
  Future<void> disconnect();

  /// récupère l'instance permettant d'effectuer des actions sur la base de données.
  /// Peut retourner `null` si il n'y a pas de connexion avec la base de données.
  T? getConnector();
}
