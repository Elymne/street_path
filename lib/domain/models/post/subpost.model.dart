import 'package:poc_street_path/core/model.dart';

class Subpost extends Model {
  final String userId;
  final String comment;

  Subpost({required super.id, required super.createdAt, required this.userId, required this.comment});
}
