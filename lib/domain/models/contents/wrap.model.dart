import 'package:poc_street_path/core/model.dart';
import 'package:poc_street_path/domain/models/contents/comment.model.dart';
import 'package:poc_street_path/domain/models/contents/content.model.dart';
import 'package:poc_street_path/domain/models/contents/reaction.model.dart';

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
/// - storageMode [int]: Code de mode de stockage.
/// - shippingMode [int]: Code de mode de propagation.
/// ------------------------------------------------------------
class PostWraper extends Model {
  final Content content;
  final List<Reaction> reaction;
  final List<Comment> comments;

  final int storageMode;
  final int shippingMode;

  PostWraper({
    required super.id,
    required super.createdAt,
    required this.content,
    required this.reaction,
    required this.comments,
    required this.storageMode,
    required this.shippingMode,
  });
}
