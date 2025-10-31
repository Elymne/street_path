import 'package:poc_street_path/domain/models/content/reaction.model.dart';

/// ------------------------------------------------------------
/// Interface: ReactionRepository
/// Layer: Domain/Repositories
///
/// Description:
///   Définit les opérations de persistance, de manipulation et de récupération pour les objets [Reaction].
///   Ne dépend d'aucune technologie spécifique.
/// ------------------------------------------------------------
abstract class ReactionRepository {
  /// Permet de savoir si une reaction existe déjà en DB.
  Future<bool> exists(String id);

  /// Permet d'ajouter une nouvelle réaction.
  /// La réaction sera ajouté peut-importe si le contenu existe ou non. C'est au usecase de gérer cela.
  Future<void> insert(Reaction reaction);

  /// Récupère toutes les réactions d'un contenu.
  /// Les réactions doivent-être récupérable à partir de l'id [String] du contneu en question.
  Future<List<Reaction>> findFromContent(String contentId);

  /// Supprimes tous les [Reaction] en fonction de la liste d'ids [String] fournit en paramètres.
  /// returne : [int] Le nombre de wrap supprimés.
  Future<int> deleteMany(List<String> ids);
}
