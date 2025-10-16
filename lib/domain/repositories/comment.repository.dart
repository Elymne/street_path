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
  /// Récupère tous les commentaires d'un contenu.
  /// Les commentaires doivent-être récupérable à partir de l'id [String] du contneu en question.
  Future<List<Comment>> findFromContent(String contentId);

  /// Permet d'ajouter un commentaire.
  /// Le commentaire sera ajouté peut-importe si le contenu existe ou non. C'est au usecase de gérer cela.
  Future<String> add(String contentId, String authorName, String text);
}
