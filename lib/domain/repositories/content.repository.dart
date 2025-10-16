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
  /// createdWhile [int] permet de filtrer par vieillesse.
  /// flows [List] de [String] permet de filtrer par Flows.
  /// Retourne : [List] de [Content].
  Future<List<Content>> findMany({int? createdWhile, List<String>? flows, int? limit});

  /// Recherche d'un contenu précis.
  /// [Content] est une valeur abstraite, il doit-être identifié pour être utilisé totalement.
  /// Retourne : [Content].
  Future<Content?> findUnique(String id);

  /// Recherche rapidement si un contenu existe.
  /// Retourne : [bool]
  Future<bool> exists(String id);
}
