import 'package:poc_street_path/domain/models/contents/reaction.model.dart';

/// ------------------------------------------------------------
/// Interface: ReactionRepository
/// Layer: Domain/Repositories
///
/// Description:
///   Définit les opérations de persistance, de manipulation et de récupération pour les objets [Reaction].
///   Ne dépend d'aucune technologie spécifique.
/// ------------------------------------------------------------
abstract class ReactionRepository {
  /// Récupère toutes les réactions d'un contenu.
  /// Les réactions doivent-être récupérable à partir de l'id [String] du contneu en question.
  Future<List<Reaction>> findFromContent(String contentId);

  /// Permet d'ajouter une nouvelle réaction.
  /// La réaction sera ajouté peut-importe si le contenu existe ou non. C'est au usecase de gérer cela.
  Future<String> add(String contentId, String authorName, ReactionType flag);

  /// Supprimes toutes les reactions associées aux contenus.
  /// Fournir une [List] de [String] ids de contenus.
  /// returne : [int] Le nombre de reactions supprimées.
  Future<int> deleteByContents(List<String> ids);
}
