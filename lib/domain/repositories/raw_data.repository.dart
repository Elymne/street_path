import 'package:poc_street_path/domain/models/cache/raw_data.model.dart';

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
  Future<void> insert(RawData rawData);

  /// Récupère la totalité des données brutes enregistré en base de données.
  /// Retourne une [List] de [RawData].
  Future<List<RawData>> findAll();

  /// Vide totalement les données.
  Future<void> clear();
}
