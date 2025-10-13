import 'package:poc_street_path/domain/models/contents/comment.model.dart';

abstract class CommentRepository {
  Future<List<Comment>> findFromContent(String id);
}
