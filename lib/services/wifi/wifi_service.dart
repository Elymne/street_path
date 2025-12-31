/// ------------------------------------------------------------
/// Class: WifiService
/// Layer: Service
///
/// Description:
///   Un service de connexion P2P pour gérer les transferts de données.
///   C'est le coeur de notre système StreetPath.
/// ------------------------------------------------------------
class WifiService {
  String? _streetPathId;

  Future<void> start() async {
    if (_streetPathId != null) {
      return;
    }

    ///
  }
}
