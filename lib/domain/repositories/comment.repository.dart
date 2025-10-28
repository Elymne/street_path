import 'package:poc_street_path/domain/models/contents/comment.model.dart';

/// ------------------------------------------------------------
/// Interface: CommentRepository
/// Layer: Domain/Repositories
///
/// Description:
///   Définit les opérations de persistance, de manipulation et de récupération pour les objets [Comment].
///   Ne dépend d'aucune technologie spécifique.
/// ------------------------------------------------------------
abstract class CommentRepository {
  /// Permet d'ajouter un [Comment] en base de données.
  /// Le commentaire sera ajouté peut-importe si le contenu existe ou non. C'est au usecase de gérer cela.
  Future<void> upsert(Comment comment);

  /// Récupère tous les commentaires d'un contenu.
  /// Les commentaires doivent-être récupérable à partir de l'id [String] du contneu en question.
  Future<List<Comment>> findFromContent(String contentId);
}
