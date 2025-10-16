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
  /// Ajoute un nouveau contenu dans la base de données.
  /// Retourne : [String] L'id généré par la création d'un post.
  Future<String> add(Wrap wrap);

  /// Récupere une enveloppe contenu dans la base de données.
  /// Retourne : [Wrap] Le contenu Wrapé.
  Future<Wrap?> findOneByContent(String contentId);
}
