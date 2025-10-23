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
  /// Les valeurs retournées [Content] sont abstraites et doivent-être identifiés.
  ///
  /// limit [int] le nombre max d'éléments à récupérer.
  /// minTime [int] le temps de création minimum des contenus.
  /// maxTime [int] le temps de création maximum des contenus.
  /// flows [List] de [String] permet de filtrer par àFlows.
  /// Retourne : [List] de [Content].
  Future<List<Content>> findMany({int? limit, int? minTime, int? maxTime, List<String>? flows});
}
