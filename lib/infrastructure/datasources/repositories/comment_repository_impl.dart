import 'package:poc_street_path/domain/models/contents/comment.model.dart';
import 'package:poc_street_path/domain/repositories/comment.repository.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/comment.entity.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/objectbox.g.dart';

class CommentRepositoryImpl implements CommentRepository {
  late final Box<CommentEntity> _boxComment;

  CommentRepositoryImpl(ObjectBoxGateway objectboxGateway) {
    _boxComment = objectboxGateway.getConnector()!.box<CommentEntity>();
  }

  @override
  Future<void> upsert(Comment comment) async {
    _boxComment.put(CommentEntity.fromModel(comment));
  }

  @override
  Future<List<Comment>> findFromContent(String contentId) async {
    final idCondition = CommentEntity_.contentId.equals(contentId);
    return _boxComment.query(idCondition).build().find().map((elem) => elem.toModel()).toList();
  }
}
