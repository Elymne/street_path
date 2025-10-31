import 'package:poc_street_path/domain/models/content/comment.model.dart';

/// ------------------------------------------------------------
/// Interface: CommentRepository
/// Layer: Domain/Repositories
///
/// Description:
///   Définit les opérations de persistance, de manipulation et de récupération pour les objets [Comment].
///   Ne dépend d'aucune technologie spécifique.
/// ------------------------------------------------------------
abstract class CommentRepository {
  /// Permet de savoir si un commentaire existe déjà en DB.
  Future<bool> exists(String id);

  /// Permet d'ajouter un [Comment] en base de données.
  /// Le commentaire sera ajouté peut-importe si le contenu existe ou non. C'est au usecase de gérer cela.
  Future<void> insert(Comment comment);

  /// Récupère tous les commentaires d'un contenu.
  /// Les commentaires doivent-être récupérable à partir de l'id [String] du contneu en question.
  Future<List<Comment>> findFromContent(String contentId);

  /// Supprimes tous les [Comment] en fonction de la liste d'ids [String] fournit en paramètres.
  /// returne : [int] Le nombre de wrap supprimés.
  Future<int> deleteMany(List<String> ids);
}
