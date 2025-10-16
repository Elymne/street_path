import 'package:poc_street_path/domain/models/contents/comment.model.dart';
import 'package:poc_street_path/domain/repositories/comment.repository.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/comment.entity.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/objectbox.g.dart';
import 'package:uuid/uuid.dart';

class CommentRepositoryImpl implements CommentRepository {
  late final Box<CommentEntity> _boxComment;

  CommentRepositoryImpl(ObjectBoxGateway objectboxGateway) {
    _boxComment = objectboxGateway.getConnector()!.box<CommentEntity>();
  }

  @override
  Future<String> add(String contentId, String authorName, String text) async {
    final id = Uuid().v4();
    _boxComment.put(
      CommentEntity(
        // * linebreaker.
        id: id,
        contentId: contentId,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        authorName: authorName,
        text: text,
      ),
    );
    return id;
  }

  @override
  Future<List<Comment>> findFromContent(String contentId) async {
    final condition = CommentEntity_.contentId.equals(contentId);
    return _boxComment.query(condition).build().find().map((elem) => elem.toModel()).toList();
  }
}
