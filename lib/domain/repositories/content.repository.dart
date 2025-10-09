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
  /// Ajoute un nouveau contenu dans la base de données.
  /// Retourne : [String] L'id généré par la création d'un post.
  Future<String> add(Content content);

  /// Récupére la liste des contenus qui seront à envoyer en priorité via le système de gamepass.
  /// Retourne : Liste [Content] La liste des posts.
  Future<List<Content>> findShareables();
}
