import 'package:poc_street_path/domain/models/post/post.model.dart';

/// ------------------------------------------------------------
/// Interface: PostRepository
/// Layer: Domain/Repositories
///
/// Description:
///   Définit les opérations de persistance, de manipulation et de récupération pour les objets [Post].
///   Ne dépend d'aucune technologie spécifique.
/// ------------------------------------------------------------
abstract class PostRepository {
  /// Ajoute un nouveau post dans la base de données.
  /// Retourne : [String] L'id généré par la création d'un post.
  Future<String> add(Post post);

  /// Récupére la liste des posts qui seront à envoyer en priorité via le système de gamepass.
  /// Retourne : Liste [Post] La liste des posts.
  Future<List<Post>> findShareables();
}
