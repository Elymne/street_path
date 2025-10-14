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
  /// [Content] est une valeur abstraite, il faut que l'implémentation gère cela.
  /// Retourne : [String] L'id généré par la création d'un post.
  Future<String> add(Content content);
}
