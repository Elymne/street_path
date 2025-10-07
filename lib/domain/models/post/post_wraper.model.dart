import 'package:poc_street_path/core/model.dart';
import 'package:poc_street_path/domain/models/post/post.model.dart';

/// ------------------------------------------------------------
/// Class: Flow
/// Layer: Domain/Model
///
/// Description:
///   Représente une sorte d'enveloppe d'un post visible uniquement pour l'utilisateur.
///   Elle lui permet de définir l'importance du post et de permettre à la logique métier de déterminer si :
///     - On peut supprimer le post au bout d'un moment.
///     - Comment le post doit-être transféré via le service de StreetPath.
/// ------------------------------------------------------------
/// Propriétés:
/// - post [Post]: Référence à un post.
/// - storageMode [int]: Code de mode de stockage.
/// - shippingMode [int]: Code de mode de propagation.
/// ------------------------------------------------------------
class PostWraper extends Model {
  final Post post;
  final int storageMode;
  final int shippingMode;

  PostWraper({required super.id, required super.createdAt, required this.post, required this.storageMode, required this.shippingMode});
}
