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
  /// Change le mode de transfert d'un contenu à l'aide de son Wrap.
  /// Si aucun changement ne subsiste sans erreur, on retourne false.
  Future<bool> changeShippingMode(String contentId, ShippingMode shippingMode);

  /// Change le mode de transfert d'un contenu à l'aide de son Wrap.
  /// Si aucun changement ne subsiste sans erreur, on retourne false.
  Future<bool> changeStorageMode(String contentId, StorageMode storageMode);

  /// Récupere une enveloppe contenu dans la base de données.
  /// Retourne : [Wrap] Le contenu Wrapé.
  Future<Wrap?> findOneFromContent(String contentId);
}
