import 'package:poc_street_path/domain/models/contents/comment.model.dart';
import 'package:poc_street_path/domain/models/contents/content.model.dart';
import 'package:poc_street_path/domain/models/contents/reaction.model.dart';
import 'package:poc_street_path/domain/models/contents/wrap.model.dart';

/// ------------------------------------------------------------
/// Interface: WrapRepository
/// Layer: Domain/Repositories
///
/// Description:
///   Définit les opérations de persistance, de manipulation et de récupération pour les objets [Wrap].
///   Ne dépend d'aucune technologie spécifique.
/// ------------------------------------------------------------
abstract class WrapRepository {
  /// Change le mode de transfert d'un [Wrap]
  ///
  /// Return [bool] true si changement, false sinon.
  Future<bool> changeShippingMode(String contentId, ShippingMode shippingMode);

  /// Change le mode de transfert d'un [Wrap].
  ///
  /// Return: [bool] true si changement, false sinon.
  Future<bool> changeStorageMode(String contentId, StorageMode storageMode);

  /// Permet de savoir si un [Wrap] existe dans la DB.
  /// Nécessite l'id [String] du contenu associé au [Wrap]
  ///
  /// Return: [bool]
  Future<bool> exists(String contentId);

  /// Récupère un [Wrap] dans la base de données.
  /// Nécessite l'id [String] du contenu associé au [Wrap]
  ///
  /// Return: [Wrap]
  Future<Wrap?> findUnique(String contentId);

  /// Récupère une partie des [Wrap] stocké en DB.
  /// Utilise un système de pagination des données pour optimiser la RAM de l'app.
  /// Le paramètre chunk [int] correspond à la page courrante.
  /// Le paramètre chunkSize [int] correspond au nombre d'élément à récupérer par chunk.
  ///
  /// En plus des chunks, il est possible de filtrer les données récupérés.
  /// Filtrage par flows, une liste de [String]
  /// Filtrage par date de création, un valeur en tant que milliseconde [int].
  Future<List<Wrap>> findMany(
    int chunk,
    int chunkSize, {
    List<String>? flows,
    int? createWhile,
    StorageMode? storageMode,
    ShippingMode? shippingMode,
  });

  /// Récupère la liste des ids [String] des données qu'on peut supprimer automatiquement.
  /// Une données est considéré supprimable automatiquement en fonction de sa date de création peut-importe la quantité de données stocké en DB.
  /// Si le poid des données dépasse le quota, on doit aussi supprimer les anciennes données jusqu'à ce que le poid soit considéré comme valide.
  /// Le paramètre createdAfter [int] correspond à la date de création max d'un [Wrap] arpès quoi il sera automatiquement supprimé.
  /// Le paramètre maxSize [int] correspond au poid max supporté (en octet) par l'app avant que de la suppression automatique des données ne soit enclanché.
  ///
  /// Return: Liste de [String]
  Future<List<String>> getClearableIds(int createdAfter, int maxSize);

  /// Supprimes tous les [Wrap] en fonction de la liste d'ids [String] fournit en paramètres.
  /// Nécessite une liste de [String] contenant les ids des contenus.
  /// Supprimes aussi les [Content], [Comment] et [Reaction] associé au [Wrap].
  ///
  /// returne : [int] Le nombre de wrap supprimés.
  Future<int> deleteMany(List<String> contentIds);
}
