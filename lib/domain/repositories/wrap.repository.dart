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
  /// Créer un [Wrap] autour d'un identifiant de contenu.
  /// Le [Wrap] ne peut pas être créé si un wrap est déjà lié à un contenu.
  ///
  /// Retourne un [bool] en fonction du résultat.
  Future<bool> create(String contentId, StorageMode storageMode, ShippingMode shippingMode);

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

  /// Supprimes tous les [Wrap] en fonction de la liste d'ids [String] fournit en paramètres.
  /// Nécessite une liste de [String] contenant les ids des contenus.
  /// Supprimes aussi les [Content], [Comment] et [Reaction] associé au [Wrap].
  ///
  /// returne : [int] Le nombre de wrap supprimés.
  Future<int> deleteMany(List<String> contentIds);

  /// Récupère une liste d'id de [Wrap] qui sont plus vieux que la date limite fournit en paramètre.
  /// Cette fonction est utilise pour supprimer automatiquement les vieilles données stockés sur l'app.
  /// Le paramètre createdAfter [int] correspond à la date de création max d'un [Wrap].
  ///
  /// Retourne une liste d'ids [String]
  Future<List<String>> getIdsByDateLimit(int createdAfter);

  /// Récupère les ids les plus vieux.
  /// Ne prend pas en compte les données que l'utilisateur souhaite garder, cf [StorageMode].
  ///
  /// Le paramètre [int] number correspond au nombre d'éléments que vous souhaitez récupérer.
  /// Cette fonction sert à supprimer de manière séquencé les vieilles data lorsque l'application prend trop place.
  ///
  /// Retourne une liste d'ids [String]
  Future<List<String>> getOldestIds(int number);
}
