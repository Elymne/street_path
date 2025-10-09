import 'package:poc_street_path/core/model.dart';

/// ------------------------------------------------------------
/// Class: Flow
/// Layer: Domain/Model
///
/// Description:
///   Représente un post dans la base de données.
///   C'est la données de base de l'application.
///   Celle que les utilisateurs vont s'échanger passivement via le service de StreetPath.
/// ------------------------------------------------------------
/// Propriétés:
/// - authorName [String]: Référence à l'id du créateur du post. L'application est anonyme, le authorName est simplement un nom choisie par l'utilisateur.
/// - flowName [String]: Nom du flux représentant le post.
/// - bounces [int]: Le nombre de fois que le post a été échangé avant d'être reçu par un utilisateur.
/// - reactions [List]: La liste des réactions au post par différents utilisateurs.
/// - subposts [List]: La liste des commentaires du post par différents utilisateurs.
/// ------------------------------------------------------------
abstract class Content extends Model {
  final String authorName;
  final String flowName;
  final int bounces;
  final String title;

  Content({
    required super.id,
    required super.createdAt,
    required this.authorName,
    required this.bounces,
    required this.flowName,
    required this.title,
  });
}
