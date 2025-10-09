import 'package:objectbox/objectbox.dart';
import 'package:poc_street_path/domain/models/contents/comment.model.dart';

@Entity()
class CommentEntity {
  @Id()
  int obId = 0;

  @Unique()
  String? id;

  int? createdAt;
  String? authorName;
  String? text;

  static CommentEntity fromModel(Comment comment) {
    return CommentEntity()
      ..id = comment.id
      ..createdAt = comment.createdAt
      ..authorName = comment.authorName
      ..text = comment.text;
  }
}
