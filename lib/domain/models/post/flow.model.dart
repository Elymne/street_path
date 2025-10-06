import 'package:poc_street_path/core/model.dart';

// todo : La classe va être complètement useless à mon avis.
// Je vais utiliser un index sur l'attribut flowName de la table Post pour filtrer rapidement les Post par nom de flux.
// ! Bref, Chiao toi imo.
class Flow extends Model {
  final String name;

  Flow({required super.id, required super.createdAt, required this.name});
}
