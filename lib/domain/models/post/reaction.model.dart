import 'package:poc_street_path/core/model.dart';

class Reaction extends Model {
  final String userId;
  final bool isLiked;
  final int? flag; // todo : should represent which type of reaction this is, an enum should be used.

  Reaction({required super.id, required super.createdAt, required this.userId, required this.isLiked, required this.flag});
}
