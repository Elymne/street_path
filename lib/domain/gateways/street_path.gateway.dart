abstract class StreetPathGateway {
  /// Initialisation à faire au lancement de l'application.
  /// String notificationDesc :
  ///  - La description texte de la notif lorsque le service sera démarré et en cours d'utilisation.
  Future init();

  /// Démarre le service de scan et transfert automatique de data entre plusieurs appareils.
  /// A utiliser si vous devez démarrer ou redémarrer le service.
  /// Si le service est déjà actif, ne fais rien.
  Future start(String notificationTitle, String notificationText);

  /// Met le service en pause.
  /// Pour le relancer, il faut simplement lancer la fonction start().
  Future stop();
}
