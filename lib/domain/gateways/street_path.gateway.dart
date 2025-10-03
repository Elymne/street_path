abstract class StreetPathGateway {
  /// Démarre le service de scan et transfert automatique de data entre plusieurs appareils.
  /// A utiliser si vous devez démarrer ou redémarrer le service.
  /// Si le service est déjà actif, ne fais rien.
  Future start();

  /// Met le service en pause.
  /// Pour le relancer, il faut simplement lancer la fonction start().
  Future stop();

  /// Ferme complètement le service.
  Future cancel();

  /// Récupère l'état à un instant T du service.
  /// todo : la data de retour.
  Future<int> getStatus();
}
