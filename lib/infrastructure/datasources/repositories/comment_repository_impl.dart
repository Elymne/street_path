import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poc_street_path/domain/gateways/database.gateway.dart';
import 'package:poc_street_path/domain/models/content/comment.model.dart';
import 'package:poc_street_path/domain/repositories/comment.repository.dart';
import 'package:poc_street_path/infrastructure/datasources/entities/contents/comment.entity.dart';
import 'package:poc_street_path/infrastructure/gateways/object_box_impl.gateway.dart';
import 'package:poc_street_path/objectbox.g.dart';

final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  final objectBox = ref.read(objectBoxGatewayProvider);
  return CommentRepositoryImpl(objectBox);
});

class CommentRepositoryImpl implements CommentRepository {
  late final Box<CommentEntity> _boxComment;

  CommentRepositoryImpl(DatabaseGateway objectboxGateway) {
    _boxComment = objectboxGateway.getConnector()!.box<CommentEntity>();
  }

  @override
  Future<bool> exists(String id) async {
    final comment = _boxComment.query(CommentEntity_.id.equals(id)).build().findFirst();
    return comment != null;
  }

  @override
  Future<void> insert(Comment comment) async {
    _boxComment.put(CommentEntity.fromModel(comment));
  }

  @override
  Future<List<Comment>> findFromContent(String contentId) async {
    final idCondition = CommentEntity_.contentId.equals(contentId);
    return _boxComment.query(idCondition).build().find().map((elem) => elem.toModel()).toList();
  }

  @override
  Future<int> deleteMany(List<String> ids) async {
    final comments = _boxComment.query(CommentEntity_.id.oneOf(ids)).build().find();
    return _boxComment.removeMany(comments.map((elem) => elem.obId).toList());
  }
}
