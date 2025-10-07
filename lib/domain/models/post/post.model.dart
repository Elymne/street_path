import 'package:poc_street_path/core/model.dart';
import 'package:poc_street_path/domain/models/post/reaction.model.dart';
import 'package:poc_street_path/domain/models/post/subpost.model.dart';

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
/// - userId [String]: Référence à l'id du créateur du post. L'application est anonyme, le userID est simplement un nom choisie par l'utilisateur.
/// - flowName [String]: Nom du flux représentant le post.
/// - bounces [int]: Le nombre de fois que le post a été échangé avant d'être reçu par un utilisateur.
/// - reactions [List]: La liste des réactions au post par différents utilisateurs.
/// - subposts [List]: La liste des commentaires du post par différents utilisateurs.
/// ------------------------------------------------------------
class Post extends Model {
  final String userId;
  final String flowName;
  final int bounces;
  final List<Reaction> reactions;
  final List<Subpost> subposts;

  Post({
    required super.id,
    required super.createdAt,
    required this.userId,
    required this.bounces,
    required this.flowName,
    required this.reactions,
    required this.subposts,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      createdAt: json['createdAt'] as int,
      userId: json['userId'] as String,
      bounces: json['bounces'] as int,
      flowName: json['flowName'] as String,
      reactions: (json['reactions'] as List<dynamic>).map((e) => Reaction.fromJson(e as Map<String, dynamic>)).toList(),
      subposts: (json['subposts'] as List<dynamic>).map((e) => Subpost.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'userId': userId,
      'bounces': bounces,
      'flowName': flowName,
      'reactions': reactions.map((e) => e.toJson()).toList(),
      'subposts': subposts.map((e) => e.toJson()).toList(),
    };
  }

  static bool isValidJson(Map<String, dynamic> json) {
    return json.containsKey('id') &&
        json.containsKey('createdAt') &&
        json.containsKey('userId') &&
        json.containsKey('bounces') &&
        json.containsKey('flowName') &&
        json.containsKey('reactions') &&
        json.containsKey('subposts') &&
        json['id'] is String &&
        json['createdAt'] is int &&
        json['userId'] is String &&
        json['bounces'] is int &&
        json['flowName'] is String &&
        json['reactions'] is List &&
        (json['reactions'] as List).every((e) => e is Map<String, dynamic> && Reaction.isValidJson(e)) &&
        json['subposts'] is List &&
        (json['subposts'] as List).every((e) => e is Map<String, dynamic> && Subpost.isValidJson(e));
  }
}
