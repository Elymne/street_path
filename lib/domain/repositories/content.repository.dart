import 'package:poc_street_path/domain/models/content/content.model.dart';

/// ------------------------------------------------------------
/// Interface: ContentRepository
/// Layer: Domain/Repositories
///
/// Description:
///   Définit les opérations de persistance, de manipulation et de récupération pour les objets [Content].
///   Ne dépend d'aucune technologie spécifique.
/// ------------------------------------------------------------
abstract class ContentRepository {
  /// Permet de savoir si un [Wrap] existe dans la DB.
  /// Nécessite l'id [String] du contenu associé au [Wrap]
  ///
  /// Return: [bool]
  Future<bool> exists(String id);

  /// Ajoute dans la DB un nouveau [Content].
  /// [Content] est un modèle abstrait, ce qui veut dire que l'implémentation doit vérifier ce qu'étend vraiment la valeur content.
  Future<void> upsert(Content content);

  /// Recherche le plus de contenu possible dans la base de données.
  /// Les valeurs retournées [Content] sont abstraites et doivent-être identifiés.
  ///
  /// Le paramètre chunk [int] correspond à la page courrante.
  /// Le paramètre chunkSize [int] correspond au nombre d'élément à récupérer par chunk.
  ///
  /// Retourne : [List] de [Content].
  Future<List<Content>> findMany(
    int chunk,
    int chunkSize, {
    int? createdWhile,
    int? createdAfter,
    List<String>? flows,
    List<StorageMode>? storageModes,
    List<ShippingMode>? shippingModes,
    List<ContentOrderBy>? orderBy,
  });

  /// Récupère un [Wrap] dans la base de données.
  /// Nécessite l'id [String] du contenu associé au [Wrap]
  ///
  /// Return: [Wrap]
  Future<Content?> findUnique(String id);

  /// Supprimes tous les [Content] en fonction de la liste d'ids [String] fournit en paramètres.
  /// returne : [int] Le nombre de wrap supprimés.
  Future<int> deleteMany(List<String> ids);
}

enum ContentOrderBy { newest, oldest }
