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

  /// Recherche le maximum de contenu ordonné par date de création pour une suppression automatique ultérieur.
  /// Les contenus jugé important ou créé par l'utilisateur ne doivent-pas être supprimées.
  /// Les valeurs retournées [Content] sont abstraites et doivent-être identifiés pour être manipulé.
  ///
  /// limit [int] le nombre max d'éléments à récupérer.
  /// Retourne : [List] de [Content].
  Future<List<Content>> findForSizeDeletion(int limit);

  /// Recherche d'un contenu précis.
  /// [Content] est une valeur abstraite, il doit-être identifié pour être utilisé totalement.
  /// Retourne : [Content].
  Future<Content?> findUnique(String id);

  /// Supprimes des contenus.
  /// Fournir une [List] de [String] ids de contenus.
  /// returne : [int] Le nombre de contenus supprimées.
  Future<int> deleteMany(List<String> ids);

  /// Recherche rapidement si un contenu existe.
  /// Retourne : [bool]
  Future<bool> exists(String id);
}
