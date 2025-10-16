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
  Future<List<Reaction>> findFromContent(String id);
}
