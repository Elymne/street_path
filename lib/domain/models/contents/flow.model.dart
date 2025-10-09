import 'package:poc_street_path/core/model.dart';

/// ------------------------------------------------------------
/// Class: Flow
/// Layer: Domain/Model
///
/// Description:
///   Représente un nom de flux dans la base de données.
///   On stocke des fluxs pour permettre à l'application de sélectionner les posts de prédilictions.
/// ------------------------------------------------------------
/// Propriétés:
/// - name [String]: Nom du flux (obligatoire, non vide).
/// ------------------------------------------------------------
class Flow extends Model {
  final String name;

  Flow({required super.id, required super.createdAt, required this.name});
}
