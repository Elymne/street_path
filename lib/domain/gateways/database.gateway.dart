/// ------------------------------------------------------------
/// Class: DatabaseGateway
/// Layer: Infrastructure
///
/// Description:
///   Interface décrivant les opérations disponibles pour manipuler la base de données interne de l'apoplication.
///   [T] correspond à la classe utilisé pour manipuler les bases de données.
///   [T] peut provenir d'une librarie externe ou interne.
///   Doit permettre la connexion, déconnexion et récupération de différentes informations sur la base de données.
/// ------------------------------------------------------------
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

  /// Récupère la taille actuelle de la base de données en ko.
  Future<int> getCurrentSize();
}
