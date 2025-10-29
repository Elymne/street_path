import 'package:poc_street_path/domain/models/content/comment.model.dart';
import 'package:poc_street_path/domain/models/content/content.model.dart';
import 'package:poc_street_path/domain/models/content/reaction.model.dart';

/// ------------------------------------------------------------
/// Class: Flow
/// Layer: Domain/Model
///
/// Description:
///   Représente une sorte d'enveloppe d'un contenu visible uniquement pour l'utilisateur.
///   Elle merge les commentaires et réaction du contenu.
///   Elle lui permet de définir l'importance du contenu et de permettre à la logique métier de déterminer si :
///     - On peut supprimer le contenu au bout d'un moment.
///     - Comment le contenu doit-être transféré via le service de StreetPath.
/// ------------------------------------------------------------
/// Propriétés:
/// - content [Content]: Référence à un contenu.
/// - reaction [List]: Liste des réactions.
/// - comments [List]: Liste des commentaires.
/// ------------------------------------------------------------
class Wrap {
  final Content content;
  final List<Reaction> reactions;
  final List<Comment> comments;

  Wrap({required this.content, required this.reactions, required this.comments});
}
