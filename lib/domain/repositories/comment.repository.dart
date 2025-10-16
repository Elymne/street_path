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
  Future<List<Comment>> findFromContent(String id);
}
