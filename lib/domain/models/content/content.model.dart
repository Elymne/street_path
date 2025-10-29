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
abstract class Content extends DataModel {
  final int receivedAt;
  final String authorName;
  final String flowName;
  final int bounces;
  final String title;

  final StorageMode storageMode;
  final ShippingMode shippingMode;

  Content({
    required super.id,
    required super.createdAt,
    required this.receivedAt,
    required this.authorName,
    required this.bounces,
    required this.flowName,
    required this.title,
    required this.storageMode,
    required this.shippingMode,
  });
}

enum ShippingMode {
  normal(0),
  important(1),
  creator(2),
  blocked(3);

  final int value;
  const ShippingMode(this.value);

  static ShippingMode fromValue(int value) {
    return ShippingMode.values.firstWhere(
      (type) => type.value == value,
      orElse: () => throw ArgumentError('Valeur inconnue pour ReactionType: $value'),
    );
  }
}

enum StorageMode {
  normal(0),
  save(1);

  final int value;
  const StorageMode(this.value);

  static StorageMode fromValue(int value) {
    return StorageMode.values.firstWhere(
      (type) => type.value == value,
      orElse: () => throw ArgumentError('Valeur inconnue pour ReactionType: $value'),
    );
  }
}
