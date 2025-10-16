import 'package:poc_street_path/domain/models/contents/content.model.dart';

/// ------------------------------------------------------------
/// Interface: ContentRepository
/// Layer: Domain/Repositories
///
/// Description:
///   Définit les opérations de persistance, de manipulation et de récupération pour les objets [Content].
///   Ne dépend d'aucune technologie spécifique.
/// ------------------------------------------------------------
abstract class ContentRepository {
  /// Recherche le plus de contenu possible dans la base de données.
  /// [Content] est une valeur abstraite, il faut que l'implémentation gère cela.
  /// createdWhile [int] permet de filtrer par vieillesse.
  /// flows [List] de [String] permet de filtrer par Flows.
  /// Retourne : [List] de [Content].
  Future<List<Content>> findMany({int? createdWhile, List<String>? flows});
}
