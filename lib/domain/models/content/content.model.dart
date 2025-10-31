import 'package:poc_street_path/core/data_model.dart';

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

  /// Fonction abstraite à implémenter.
  /// Elle doit être utilisé lors des transferts de données entre appareils.
  /// Elle permet d'être facilement transformé en contenu JSON.
  Map<String, Object> toRaw();
}

enum ShippingMode {
  /// Données non priorisé par défaut lors des échanges. C'est en général cet état que l'on va retrouver lorsque des données sont transférés.
  normal(0),

  /// Priorité moyenne. Cas d'usage lorsqu'un utilisateur trouve un contenu intéressant de partager en priorité.
  important(1),

  /// Priorité maximum sur les transferts puisque c'est du contenu utilisateur.
  /// Un contenu sera automatiquement mit en mode "bloqué" au bout d'un certain temps pour éviter qu'un même contenu soit transféré.
  creator(2),

  /// Contenu bloqué par l'utilisateur. Dans le cas où l'utilisateur n'est pas sûr de si il veut que son contenu soit transférable imédiatement ou non.
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
  /// Sera supprimé au bout d'une certaine durée ou si il y a trop de données sur l'app.
  normal(0),

  /// Toujours sauvegardé, jamais supprimé sauf par action de l'utilisateur.
  /// Concerne en général les contenus créés par l'utilisateur ou des contenus que l'utilisateur aurait choisi de sauvegarder pour des raisons personnelles.
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
