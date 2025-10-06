/// Interface d'implémentation d'une instance de moteur de base de données.
/// Plusieurs instance peuvent tourner sur l'app (forcément puisqu'on a un runner en background qui doit tourner à côté).
/// T correspond à une classe qui permet d'effectuer des call sur une database. Soit c'est une classe custom, soit elle provient d'une lib.
abstract class DatabaseGateway<T> {
  Future init();

  T getConnector();

  Future close();
}
