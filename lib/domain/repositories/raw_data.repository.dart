import 'package:poc_street_path/domain/models/contents/raw_data.model.dart';

/// ------------------------------------------------------------
/// Interface: RawDataRepository
/// Layer: Domain/Repositories
///
/// Description:
///   Définit les opérations de persistance, de manipulation et de récupération pour les objets [RawData].
///   Ne dépend d'aucune technologie spécifique.
/// ------------------------------------------------------------
abstract class RawDataRepository {
  /// Ajoute une nouvelle donnée brute en base de données.
  /// Retourne : [String] L'id généré par la création d'une data brute.
  Future<String> add(String data);

  /// Synchronise les données brutes correspondant à du contenu abstrait ??? T'es con mec.
  /// Supprime les données brutes synchronisés.
  /// Retourne : [int] Nombre d'éléments synchronisés.
  Future<int> syncData();

  /// Retourne les données partageable via le streetpath sous format JSON.
  Future<String> findShareableData(int dataLimit, int dayLimit);
}
