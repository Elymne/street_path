import 'package:poc_street_path/domain/models/post/raw_data.model.dart';

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

  /// Supprime une donnée brute en base de données.
  /// Retourne : [bool] Si l'opération a abouti ou non.
  Future<bool> delete(String id);

  /// Synchronise les données brutes correspondant à des posts.
  /// Supprime les données brutes synchronisés.
  /// Retourne : [int] Nombre d'éléments synchronisés.
  Future<int> syncPosts();
}
