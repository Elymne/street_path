/// ------------------------------------------------------------
/// Class: PathGateway
/// Layer: Infrastructure
///
/// Description:
///   Interface décrivant l'opération pour récupérer la structure des répertoires de l'appareil sur laquelle l'application tourne.
///   Cette interface me permet de tester plus facilement certaines librairies.
/// ------------------------------------------------------------
abstract class PathGateway {
  Future<String> getBaseDir();
}
