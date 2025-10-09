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
class Content extends Model {
  final String authorName;
  final String flowName;
  final int bounces;

  Content({required super.id, required super.createdAt, required this.authorName, required this.bounces, required this.flowName});

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['id'] as String,
      createdAt: json['createdAt'] as int,
      authorName: json['authorName'] as String,
      bounces: json['bounces'] as int,
      flowName: json['flowName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'createdAt': createdAt, 'authorName': authorName, 'bounces': bounces, 'flowName': flowName};
  }

  static bool isValidJson(Map<String, dynamic> json) {
    return json.containsKey('id') &&
        json.containsKey('createdAt') &&
        json.containsKey('authorName') &&
        json.containsKey('bounces') &&
        json.containsKey('flowName') &&
        json['id'] is String &&
        json['createdAt'] is int &&
        json['authorName'] is String &&
        json['bounces'] is int &&
        json['flowName'] is String;
  }
}
